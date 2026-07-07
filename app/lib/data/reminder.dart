/// Saturday-morning reminder (owner pick #1, 2026-07-06): a weekly local
/// notification, Saturdays 08:00, "It's Saturday — open the book."
/// Purely on-device; no network, no exact-alarm permission needed.
library;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

const _kEnabled = 'saturday_reminder';
const _notificationId = 7; // Saturday

final _plugin = FlutterLocalNotificationsPlugin();
var _initialized = false;

Future<void> _init() async {
  if (_initialized) return;
  tzdata.initializeTimeZones();
  try {
    tz.setLocalLocation(
      tz.getLocation((await FlutterTimezone.getLocalTimezone()).identifier),
    );
  } catch (_) {
    // Fall back to the default location; the reminder is not time-critical.
  }
  await _plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );
  _initialized = true;
}

Future<bool> reminderEnabled() async =>
    (await SharedPreferences.getInstance()).getBool(_kEnabled) ?? false;

/// Turns the weekly reminder on/off. Returns false if the phone refused
/// notification permission (Android 13+ asks the user).
Future<bool> setReminder(bool on) async {
  await _init();
  final prefs = await SharedPreferences.getInstance();
  if (!on) {
    await _plugin.cancel(id: _notificationId);
    await prefs.setBool(_kEnabled, false);
    return true;
  }
  final android = _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  final granted = await android?.requestNotificationsPermission() ?? true;
  if (!granted) return false;
  await _schedule();
  await prefs.setBool(_kEnabled, true);
  return true;
}

Future<void> _schedule() async {
  var next = tz.TZDateTime.now(tz.local);
  next = tz.TZDateTime(tz.local, next.year, next.month, next.day, 8);
  while (next.weekday != DateTime.saturday ||
      next.isBefore(tz.TZDateTime.now(tz.local))) {
    next = next.add(const Duration(days: 1));
  }
  await _plugin.zonedSchedule(
    id: _notificationId,
    title: 'It\'s Saturday!',
    body: 'Open QuickBucks and tick who has paid this week.',
    scheduledDate: next,
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        'saturday_reminder',
        'Saturday reminder',
        channelDescription: 'Weekly reminder to record Saturday payments',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
  );
}

/// Called on app start: keeps the schedule alive while wanted and clears
/// it once weekly payments are over.
Future<void> syncReminder({required bool contributionsRunning}) async {
  if (!await reminderEnabled()) return;
  await _init();
  if (contributionsRunning) {
    await _schedule();
  } else {
    await _plugin.cancel(id: _notificationId);
    await (await SharedPreferences.getInstance()).setBool(_kEnabled, false);
  }
}
