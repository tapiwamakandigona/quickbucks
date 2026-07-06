// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $CyclesTable extends Cycles with TableInfo<$CyclesTable, Cycle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _endedOnMeta = const VerificationMeta(
    'endedOn',
  );
  @override
  late final GeneratedColumn<String> endedOn = GeneratedColumn<String>(
    'ended_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weeklyUnitCentsMeta = const VerificationMeta(
    'weeklyUnitCents',
  );
  @override
  late final GeneratedColumn<int> weeklyUnitCents = GeneratedColumn<int>(
    'weekly_unit_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1000),
  );
  static const VerificationMeta _interestPctMeta = const VerificationMeta(
    'interestPct',
  );
  @override
  late final GeneratedColumn<int> interestPct = GeneratedColumn<int>(
    'interest_pct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(20),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    startDate,
    endDate,
    status,
    endedOn,
    weeklyUnitCents,
    interestPct,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cycles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cycle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('ended_on')) {
      context.handle(
        _endedOnMeta,
        endedOn.isAcceptableOrUnknown(data['ended_on']!, _endedOnMeta),
      );
    }
    if (data.containsKey('weekly_unit_cents')) {
      context.handle(
        _weeklyUnitCentsMeta,
        weeklyUnitCents.isAcceptableOrUnknown(
          data['weekly_unit_cents']!,
          _weeklyUnitCentsMeta,
        ),
      );
    }
    if (data.containsKey('interest_pct')) {
      context.handle(
        _interestPctMeta,
        interestPct.isAcceptableOrUnknown(
          data['interest_pct']!,
          _interestPctMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cycle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cycle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      endedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ended_on'],
      ),
      weeklyUnitCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_unit_cents'],
      )!,
      interestPct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interest_pct'],
      )!,
    );
  }

  @override
  $CyclesTable createAlias(String alias) {
    return $CyclesTable(attachedDatabase, alias);
  }
}

class Cycle extends DataClass implements Insertable<Cycle> {
  final String id;
  final String name;
  final String startDate;
  final String? endDate;
  final String status;
  final String? endedOn;
  final int weeklyUnitCents;
  final int interestPct;
  const Cycle({
    required this.id,
    required this.name,
    required this.startDate,
    this.endDate,
    required this.status,
    this.endedOn,
    required this.weeklyUnitCents,
    required this.interestPct,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['start_date'] = Variable<String>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || endedOn != null) {
      map['ended_on'] = Variable<String>(endedOn);
    }
    map['weekly_unit_cents'] = Variable<int>(weeklyUnitCents);
    map['interest_pct'] = Variable<int>(interestPct);
    return map;
  }

  CyclesCompanion toCompanion(bool nullToAbsent) {
    return CyclesCompanion(
      id: Value(id),
      name: Value(name),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      status: Value(status),
      endedOn: endedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(endedOn),
      weeklyUnitCents: Value(weeklyUnitCents),
      interestPct: Value(interestPct),
    );
  }

  factory Cycle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cycle(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      status: serializer.fromJson<String>(json['status']),
      endedOn: serializer.fromJson<String?>(json['endedOn']),
      weeklyUnitCents: serializer.fromJson<int>(json['weeklyUnitCents']),
      interestPct: serializer.fromJson<int>(json['interestPct']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'status': serializer.toJson<String>(status),
      'endedOn': serializer.toJson<String?>(endedOn),
      'weeklyUnitCents': serializer.toJson<int>(weeklyUnitCents),
      'interestPct': serializer.toJson<int>(interestPct),
    };
  }

  Cycle copyWith({
    String? id,
    String? name,
    String? startDate,
    Value<String?> endDate = const Value.absent(),
    String? status,
    Value<String?> endedOn = const Value.absent(),
    int? weeklyUnitCents,
    int? interestPct,
  }) => Cycle(
    id: id ?? this.id,
    name: name ?? this.name,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    status: status ?? this.status,
    endedOn: endedOn.present ? endedOn.value : this.endedOn,
    weeklyUnitCents: weeklyUnitCents ?? this.weeklyUnitCents,
    interestPct: interestPct ?? this.interestPct,
  );
  Cycle copyWithCompanion(CyclesCompanion data) {
    return Cycle(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      status: data.status.present ? data.status.value : this.status,
      endedOn: data.endedOn.present ? data.endedOn.value : this.endedOn,
      weeklyUnitCents: data.weeklyUnitCents.present
          ? data.weeklyUnitCents.value
          : this.weeklyUnitCents,
      interestPct: data.interestPct.present
          ? data.interestPct.value
          : this.interestPct,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cycle(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('endedOn: $endedOn, ')
          ..write('weeklyUnitCents: $weeklyUnitCents, ')
          ..write('interestPct: $interestPct')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    startDate,
    endDate,
    status,
    endedOn,
    weeklyUnitCents,
    interestPct,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cycle &&
          other.id == this.id &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.status == this.status &&
          other.endedOn == this.endedOn &&
          other.weeklyUnitCents == this.weeklyUnitCents &&
          other.interestPct == this.interestPct);
}

class CyclesCompanion extends UpdateCompanion<Cycle> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> startDate;
  final Value<String?> endDate;
  final Value<String> status;
  final Value<String?> endedOn;
  final Value<int> weeklyUnitCents;
  final Value<int> interestPct;
  final Value<int> rowid;
  const CyclesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.status = const Value.absent(),
    this.endedOn = const Value.absent(),
    this.weeklyUnitCents = const Value.absent(),
    this.interestPct = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CyclesCompanion.insert({
    required String id,
    required String name,
    required String startDate,
    this.endDate = const Value.absent(),
    this.status = const Value.absent(),
    this.endedOn = const Value.absent(),
    this.weeklyUnitCents = const Value.absent(),
    this.interestPct = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       startDate = Value(startDate);
  static Insertable<Cycle> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<String>? status,
    Expression<String>? endedOn,
    Expression<int>? weeklyUnitCents,
    Expression<int>? interestPct,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (status != null) 'status': status,
      if (endedOn != null) 'ended_on': endedOn,
      if (weeklyUnitCents != null) 'weekly_unit_cents': weeklyUnitCents,
      if (interestPct != null) 'interest_pct': interestPct,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CyclesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? startDate,
    Value<String?>? endDate,
    Value<String>? status,
    Value<String?>? endedOn,
    Value<int>? weeklyUnitCents,
    Value<int>? interestPct,
    Value<int>? rowid,
  }) {
    return CyclesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      endedOn: endedOn ?? this.endedOn,
      weeklyUnitCents: weeklyUnitCents ?? this.weeklyUnitCents,
      interestPct: interestPct ?? this.interestPct,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (endedOn.present) {
      map['ended_on'] = Variable<String>(endedOn.value);
    }
    if (weeklyUnitCents.present) {
      map['weekly_unit_cents'] = Variable<int>(weeklyUnitCents.value);
    }
    if (interestPct.present) {
      map['interest_pct'] = Variable<int>(interestPct.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CyclesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('endedOn: $endedOn, ')
          ..write('weeklyUnitCents: $weeklyUnitCents, ')
          ..write('interestPct: $interestPct, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MembersTable extends Members with TableInfo<$MembersTable, Member> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<String> cycleId = GeneratedColumn<String>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cycles (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _multiplierMeta = const VerificationMeta(
    'multiplier',
  );
  @override
  late final GeneratedColumn<int> multiplier = GeneratedColumn<int>(
    'multiplier',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, cycleId, name, multiplier];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'members';
  @override
  VerificationContext validateIntegrity(
    Insertable<Member> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('multiplier')) {
      context.handle(
        _multiplierMeta,
        multiplier.isAcceptableOrUnknown(data['multiplier']!, _multiplierMeta),
      );
    } else if (isInserting) {
      context.missing(_multiplierMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Member map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Member(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      multiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}multiplier'],
      )!,
    );
  }

  @override
  $MembersTable createAlias(String alias) {
    return $MembersTable(attachedDatabase, alias);
  }
}

class Member extends DataClass implements Insertable<Member> {
  final String id;
  final String cycleId;
  final String name;
  final int multiplier;
  const Member({
    required this.id,
    required this.cycleId,
    required this.name,
    required this.multiplier,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cycle_id'] = Variable<String>(cycleId);
    map['name'] = Variable<String>(name);
    map['multiplier'] = Variable<int>(multiplier);
    return map;
  }

  MembersCompanion toCompanion(bool nullToAbsent) {
    return MembersCompanion(
      id: Value(id),
      cycleId: Value(cycleId),
      name: Value(name),
      multiplier: Value(multiplier),
    );
  }

  factory Member.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Member(
      id: serializer.fromJson<String>(json['id']),
      cycleId: serializer.fromJson<String>(json['cycleId']),
      name: serializer.fromJson<String>(json['name']),
      multiplier: serializer.fromJson<int>(json['multiplier']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cycleId': serializer.toJson<String>(cycleId),
      'name': serializer.toJson<String>(name),
      'multiplier': serializer.toJson<int>(multiplier),
    };
  }

  Member copyWith({
    String? id,
    String? cycleId,
    String? name,
    int? multiplier,
  }) => Member(
    id: id ?? this.id,
    cycleId: cycleId ?? this.cycleId,
    name: name ?? this.name,
    multiplier: multiplier ?? this.multiplier,
  );
  Member copyWithCompanion(MembersCompanion data) {
    return Member(
      id: data.id.present ? data.id.value : this.id,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      name: data.name.present ? data.name.value : this.name,
      multiplier: data.multiplier.present
          ? data.multiplier.value
          : this.multiplier,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Member(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('name: $name, ')
          ..write('multiplier: $multiplier')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cycleId, name, multiplier);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Member &&
          other.id == this.id &&
          other.cycleId == this.cycleId &&
          other.name == this.name &&
          other.multiplier == this.multiplier);
}

class MembersCompanion extends UpdateCompanion<Member> {
  final Value<String> id;
  final Value<String> cycleId;
  final Value<String> name;
  final Value<int> multiplier;
  final Value<int> rowid;
  const MembersCompanion({
    this.id = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.name = const Value.absent(),
    this.multiplier = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MembersCompanion.insert({
    required String id,
    required String cycleId,
    required String name,
    required int multiplier,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cycleId = Value(cycleId),
       name = Value(name),
       multiplier = Value(multiplier);
  static Insertable<Member> custom({
    Expression<String>? id,
    Expression<String>? cycleId,
    Expression<String>? name,
    Expression<int>? multiplier,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cycleId != null) 'cycle_id': cycleId,
      if (name != null) 'name': name,
      if (multiplier != null) 'multiplier': multiplier,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MembersCompanion copyWith({
    Value<String>? id,
    Value<String>? cycleId,
    Value<String>? name,
    Value<int>? multiplier,
    Value<int>? rowid,
  }) {
    return MembersCompanion(
      id: id ?? this.id,
      cycleId: cycleId ?? this.cycleId,
      name: name ?? this.name,
      multiplier: multiplier ?? this.multiplier,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<String>(cycleId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (multiplier.present) {
      map['multiplier'] = Variable<int>(multiplier.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MembersCompanion(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('name: $name, ')
          ..write('multiplier: $multiplier, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContributionsTable extends Contributions
    with TableInfo<$ContributionsTable, Contribution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContributionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<String> cycleId = GeneratedColumn<String>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cycles (id)',
    ),
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id)',
    ),
  );
  static const VerificationMeta _saturdayMeta = const VerificationMeta(
    'saturday',
  );
  @override
  late final GeneratedColumn<String> saturday = GeneratedColumn<String>(
    'saturday',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedOnMeta = const VerificationMeta(
    'recordedOn',
  );
  @override
  late final GeneratedColumn<String> recordedOn = GeneratedColumn<String>(
    'recorded_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cycleId,
    memberId,
    saturday,
    amountCents,
    recordedOn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contributions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Contribution> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('saturday')) {
      context.handle(
        _saturdayMeta,
        saturday.isAcceptableOrUnknown(data['saturday']!, _saturdayMeta),
      );
    } else if (isInserting) {
      context.missing(_saturdayMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('recorded_on')) {
      context.handle(
        _recordedOnMeta,
        recordedOn.isAcceptableOrUnknown(data['recorded_on']!, _recordedOnMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedOnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {memberId, saturday},
  ];
  @override
  Contribution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contribution(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      saturday: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}saturday'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      recordedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recorded_on'],
      )!,
    );
  }

  @override
  $ContributionsTable createAlias(String alias) {
    return $ContributionsTable(attachedDatabase, alias);
  }
}

class Contribution extends DataClass implements Insertable<Contribution> {
  final String id;
  final String cycleId;
  final String memberId;
  final String saturday;
  final int amountCents;
  final String recordedOn;
  const Contribution({
    required this.id,
    required this.cycleId,
    required this.memberId,
    required this.saturday,
    required this.amountCents,
    required this.recordedOn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cycle_id'] = Variable<String>(cycleId);
    map['member_id'] = Variable<String>(memberId);
    map['saturday'] = Variable<String>(saturday);
    map['amount_cents'] = Variable<int>(amountCents);
    map['recorded_on'] = Variable<String>(recordedOn);
    return map;
  }

  ContributionsCompanion toCompanion(bool nullToAbsent) {
    return ContributionsCompanion(
      id: Value(id),
      cycleId: Value(cycleId),
      memberId: Value(memberId),
      saturday: Value(saturday),
      amountCents: Value(amountCents),
      recordedOn: Value(recordedOn),
    );
  }

  factory Contribution.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contribution(
      id: serializer.fromJson<String>(json['id']),
      cycleId: serializer.fromJson<String>(json['cycleId']),
      memberId: serializer.fromJson<String>(json['memberId']),
      saturday: serializer.fromJson<String>(json['saturday']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      recordedOn: serializer.fromJson<String>(json['recordedOn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cycleId': serializer.toJson<String>(cycleId),
      'memberId': serializer.toJson<String>(memberId),
      'saturday': serializer.toJson<String>(saturday),
      'amountCents': serializer.toJson<int>(amountCents),
      'recordedOn': serializer.toJson<String>(recordedOn),
    };
  }

  Contribution copyWith({
    String? id,
    String? cycleId,
    String? memberId,
    String? saturday,
    int? amountCents,
    String? recordedOn,
  }) => Contribution(
    id: id ?? this.id,
    cycleId: cycleId ?? this.cycleId,
    memberId: memberId ?? this.memberId,
    saturday: saturday ?? this.saturday,
    amountCents: amountCents ?? this.amountCents,
    recordedOn: recordedOn ?? this.recordedOn,
  );
  Contribution copyWithCompanion(ContributionsCompanion data) {
    return Contribution(
      id: data.id.present ? data.id.value : this.id,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      saturday: data.saturday.present ? data.saturday.value : this.saturday,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      recordedOn: data.recordedOn.present
          ? data.recordedOn.value
          : this.recordedOn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contribution(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('memberId: $memberId, ')
          ..write('saturday: $saturday, ')
          ..write('amountCents: $amountCents, ')
          ..write('recordedOn: $recordedOn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cycleId, memberId, saturday, amountCents, recordedOn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contribution &&
          other.id == this.id &&
          other.cycleId == this.cycleId &&
          other.memberId == this.memberId &&
          other.saturday == this.saturday &&
          other.amountCents == this.amountCents &&
          other.recordedOn == this.recordedOn);
}

class ContributionsCompanion extends UpdateCompanion<Contribution> {
  final Value<String> id;
  final Value<String> cycleId;
  final Value<String> memberId;
  final Value<String> saturday;
  final Value<int> amountCents;
  final Value<String> recordedOn;
  final Value<int> rowid;
  const ContributionsCompanion({
    this.id = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.saturday = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.recordedOn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContributionsCompanion.insert({
    required String id,
    required String cycleId,
    required String memberId,
    required String saturday,
    required int amountCents,
    required String recordedOn,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cycleId = Value(cycleId),
       memberId = Value(memberId),
       saturday = Value(saturday),
       amountCents = Value(amountCents),
       recordedOn = Value(recordedOn);
  static Insertable<Contribution> custom({
    Expression<String>? id,
    Expression<String>? cycleId,
    Expression<String>? memberId,
    Expression<String>? saturday,
    Expression<int>? amountCents,
    Expression<String>? recordedOn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cycleId != null) 'cycle_id': cycleId,
      if (memberId != null) 'member_id': memberId,
      if (saturday != null) 'saturday': saturday,
      if (amountCents != null) 'amount_cents': amountCents,
      if (recordedOn != null) 'recorded_on': recordedOn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContributionsCompanion copyWith({
    Value<String>? id,
    Value<String>? cycleId,
    Value<String>? memberId,
    Value<String>? saturday,
    Value<int>? amountCents,
    Value<String>? recordedOn,
    Value<int>? rowid,
  }) {
    return ContributionsCompanion(
      id: id ?? this.id,
      cycleId: cycleId ?? this.cycleId,
      memberId: memberId ?? this.memberId,
      saturday: saturday ?? this.saturday,
      amountCents: amountCents ?? this.amountCents,
      recordedOn: recordedOn ?? this.recordedOn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<String>(cycleId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (saturday.present) {
      map['saturday'] = Variable<String>(saturday.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (recordedOn.present) {
      map['recorded_on'] = Variable<String>(recordedOn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContributionsCompanion(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('memberId: $memberId, ')
          ..write('saturday: $saturday, ')
          ..write('amountCents: $amountCents, ')
          ..write('recordedOn: $recordedOn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LoansTable extends Loans with TableInfo<$LoansTable, Loan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<String> cycleId = GeneratedColumn<String>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cycles (id)',
    ),
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id)',
    ),
  );
  static const VerificationMeta _principalCentsMeta = const VerificationMeta(
    'principalCents',
  );
  @override
  late final GeneratedColumn<int> principalCents = GeneratedColumn<int>(
    'principal_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _owedCentsMeta = const VerificationMeta(
    'owedCents',
  );
  @override
  late final GeneratedColumn<int> owedCents = GeneratedColumn<int>(
    'owed_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loanDateMeta = const VerificationMeta(
    'loanDate',
  );
  @override
  late final GeneratedColumn<String> loanDate = GeneratedColumn<String>(
    'loan_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _parentLoanIdMeta = const VerificationMeta(
    'parentLoanId',
  );
  @override
  late final GeneratedColumn<String> parentLoanId = GeneratedColumn<String>(
    'parent_loan_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _closedOnMeta = const VerificationMeta(
    'closedOn',
  );
  @override
  late final GeneratedColumn<String> closedOn = GeneratedColumn<String>(
    'closed_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cycleId,
    memberId,
    principalCents,
    owedCents,
    loanDate,
    dueDate,
    status,
    parentLoanId,
    closedOn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loans';
  @override
  VerificationContext validateIntegrity(
    Insertable<Loan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('principal_cents')) {
      context.handle(
        _principalCentsMeta,
        principalCents.isAcceptableOrUnknown(
          data['principal_cents']!,
          _principalCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_principalCentsMeta);
    }
    if (data.containsKey('owed_cents')) {
      context.handle(
        _owedCentsMeta,
        owedCents.isAcceptableOrUnknown(data['owed_cents']!, _owedCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_owedCentsMeta);
    }
    if (data.containsKey('loan_date')) {
      context.handle(
        _loanDateMeta,
        loanDate.isAcceptableOrUnknown(data['loan_date']!, _loanDateMeta),
      );
    } else if (isInserting) {
      context.missing(_loanDateMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('parent_loan_id')) {
      context.handle(
        _parentLoanIdMeta,
        parentLoanId.isAcceptableOrUnknown(
          data['parent_loan_id']!,
          _parentLoanIdMeta,
        ),
      );
    }
    if (data.containsKey('closed_on')) {
      context.handle(
        _closedOnMeta,
        closedOn.isAcceptableOrUnknown(data['closed_on']!, _closedOnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Loan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Loan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      principalCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}principal_cents'],
      )!,
      owedCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owed_cents'],
      )!,
      loanDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}loan_date'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      parentLoanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_loan_id'],
      ),
      closedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}closed_on'],
      ),
    );
  }

  @override
  $LoansTable createAlias(String alias) {
    return $LoansTable(attachedDatabase, alias);
  }
}

class Loan extends DataClass implements Insertable<Loan> {
  final String id;
  final String cycleId;
  final String memberId;
  final int principalCents;
  final int owedCents;
  final String loanDate;
  final String dueDate;
  final String status;
  final String? parentLoanId;
  final String? closedOn;
  const Loan({
    required this.id,
    required this.cycleId,
    required this.memberId,
    required this.principalCents,
    required this.owedCents,
    required this.loanDate,
    required this.dueDate,
    required this.status,
    this.parentLoanId,
    this.closedOn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cycle_id'] = Variable<String>(cycleId);
    map['member_id'] = Variable<String>(memberId);
    map['principal_cents'] = Variable<int>(principalCents);
    map['owed_cents'] = Variable<int>(owedCents);
    map['loan_date'] = Variable<String>(loanDate);
    map['due_date'] = Variable<String>(dueDate);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || parentLoanId != null) {
      map['parent_loan_id'] = Variable<String>(parentLoanId);
    }
    if (!nullToAbsent || closedOn != null) {
      map['closed_on'] = Variable<String>(closedOn);
    }
    return map;
  }

  LoansCompanion toCompanion(bool nullToAbsent) {
    return LoansCompanion(
      id: Value(id),
      cycleId: Value(cycleId),
      memberId: Value(memberId),
      principalCents: Value(principalCents),
      owedCents: Value(owedCents),
      loanDate: Value(loanDate),
      dueDate: Value(dueDate),
      status: Value(status),
      parentLoanId: parentLoanId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentLoanId),
      closedOn: closedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(closedOn),
    );
  }

  factory Loan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Loan(
      id: serializer.fromJson<String>(json['id']),
      cycleId: serializer.fromJson<String>(json['cycleId']),
      memberId: serializer.fromJson<String>(json['memberId']),
      principalCents: serializer.fromJson<int>(json['principalCents']),
      owedCents: serializer.fromJson<int>(json['owedCents']),
      loanDate: serializer.fromJson<String>(json['loanDate']),
      dueDate: serializer.fromJson<String>(json['dueDate']),
      status: serializer.fromJson<String>(json['status']),
      parentLoanId: serializer.fromJson<String?>(json['parentLoanId']),
      closedOn: serializer.fromJson<String?>(json['closedOn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cycleId': serializer.toJson<String>(cycleId),
      'memberId': serializer.toJson<String>(memberId),
      'principalCents': serializer.toJson<int>(principalCents),
      'owedCents': serializer.toJson<int>(owedCents),
      'loanDate': serializer.toJson<String>(loanDate),
      'dueDate': serializer.toJson<String>(dueDate),
      'status': serializer.toJson<String>(status),
      'parentLoanId': serializer.toJson<String?>(parentLoanId),
      'closedOn': serializer.toJson<String?>(closedOn),
    };
  }

  Loan copyWith({
    String? id,
    String? cycleId,
    String? memberId,
    int? principalCents,
    int? owedCents,
    String? loanDate,
    String? dueDate,
    String? status,
    Value<String?> parentLoanId = const Value.absent(),
    Value<String?> closedOn = const Value.absent(),
  }) => Loan(
    id: id ?? this.id,
    cycleId: cycleId ?? this.cycleId,
    memberId: memberId ?? this.memberId,
    principalCents: principalCents ?? this.principalCents,
    owedCents: owedCents ?? this.owedCents,
    loanDate: loanDate ?? this.loanDate,
    dueDate: dueDate ?? this.dueDate,
    status: status ?? this.status,
    parentLoanId: parentLoanId.present ? parentLoanId.value : this.parentLoanId,
    closedOn: closedOn.present ? closedOn.value : this.closedOn,
  );
  Loan copyWithCompanion(LoansCompanion data) {
    return Loan(
      id: data.id.present ? data.id.value : this.id,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      principalCents: data.principalCents.present
          ? data.principalCents.value
          : this.principalCents,
      owedCents: data.owedCents.present ? data.owedCents.value : this.owedCents,
      loanDate: data.loanDate.present ? data.loanDate.value : this.loanDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      status: data.status.present ? data.status.value : this.status,
      parentLoanId: data.parentLoanId.present
          ? data.parentLoanId.value
          : this.parentLoanId,
      closedOn: data.closedOn.present ? data.closedOn.value : this.closedOn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Loan(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('memberId: $memberId, ')
          ..write('principalCents: $principalCents, ')
          ..write('owedCents: $owedCents, ')
          ..write('loanDate: $loanDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('parentLoanId: $parentLoanId, ')
          ..write('closedOn: $closedOn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cycleId,
    memberId,
    principalCents,
    owedCents,
    loanDate,
    dueDate,
    status,
    parentLoanId,
    closedOn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Loan &&
          other.id == this.id &&
          other.cycleId == this.cycleId &&
          other.memberId == this.memberId &&
          other.principalCents == this.principalCents &&
          other.owedCents == this.owedCents &&
          other.loanDate == this.loanDate &&
          other.dueDate == this.dueDate &&
          other.status == this.status &&
          other.parentLoanId == this.parentLoanId &&
          other.closedOn == this.closedOn);
}

class LoansCompanion extends UpdateCompanion<Loan> {
  final Value<String> id;
  final Value<String> cycleId;
  final Value<String> memberId;
  final Value<int> principalCents;
  final Value<int> owedCents;
  final Value<String> loanDate;
  final Value<String> dueDate;
  final Value<String> status;
  final Value<String?> parentLoanId;
  final Value<String?> closedOn;
  final Value<int> rowid;
  const LoansCompanion({
    this.id = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.principalCents = const Value.absent(),
    this.owedCents = const Value.absent(),
    this.loanDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.status = const Value.absent(),
    this.parentLoanId = const Value.absent(),
    this.closedOn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LoansCompanion.insert({
    required String id,
    required String cycleId,
    required String memberId,
    required int principalCents,
    required int owedCents,
    required String loanDate,
    required String dueDate,
    this.status = const Value.absent(),
    this.parentLoanId = const Value.absent(),
    this.closedOn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cycleId = Value(cycleId),
       memberId = Value(memberId),
       principalCents = Value(principalCents),
       owedCents = Value(owedCents),
       loanDate = Value(loanDate),
       dueDate = Value(dueDate);
  static Insertable<Loan> custom({
    Expression<String>? id,
    Expression<String>? cycleId,
    Expression<String>? memberId,
    Expression<int>? principalCents,
    Expression<int>? owedCents,
    Expression<String>? loanDate,
    Expression<String>? dueDate,
    Expression<String>? status,
    Expression<String>? parentLoanId,
    Expression<String>? closedOn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cycleId != null) 'cycle_id': cycleId,
      if (memberId != null) 'member_id': memberId,
      if (principalCents != null) 'principal_cents': principalCents,
      if (owedCents != null) 'owed_cents': owedCents,
      if (loanDate != null) 'loan_date': loanDate,
      if (dueDate != null) 'due_date': dueDate,
      if (status != null) 'status': status,
      if (parentLoanId != null) 'parent_loan_id': parentLoanId,
      if (closedOn != null) 'closed_on': closedOn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LoansCompanion copyWith({
    Value<String>? id,
    Value<String>? cycleId,
    Value<String>? memberId,
    Value<int>? principalCents,
    Value<int>? owedCents,
    Value<String>? loanDate,
    Value<String>? dueDate,
    Value<String>? status,
    Value<String?>? parentLoanId,
    Value<String?>? closedOn,
    Value<int>? rowid,
  }) {
    return LoansCompanion(
      id: id ?? this.id,
      cycleId: cycleId ?? this.cycleId,
      memberId: memberId ?? this.memberId,
      principalCents: principalCents ?? this.principalCents,
      owedCents: owedCents ?? this.owedCents,
      loanDate: loanDate ?? this.loanDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      parentLoanId: parentLoanId ?? this.parentLoanId,
      closedOn: closedOn ?? this.closedOn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<String>(cycleId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (principalCents.present) {
      map['principal_cents'] = Variable<int>(principalCents.value);
    }
    if (owedCents.present) {
      map['owed_cents'] = Variable<int>(owedCents.value);
    }
    if (loanDate.present) {
      map['loan_date'] = Variable<String>(loanDate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (parentLoanId.present) {
      map['parent_loan_id'] = Variable<String>(parentLoanId.value);
    }
    if (closedOn.present) {
      map['closed_on'] = Variable<String>(closedOn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoansCompanion(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('memberId: $memberId, ')
          ..write('principalCents: $principalCents, ')
          ..write('owedCents: $owedCents, ')
          ..write('loanDate: $loanDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('parentLoanId: $parentLoanId, ')
          ..write('closedOn: $closedOn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LoanPaymentsTable extends LoanPayments
    with TableInfo<$LoanPaymentsTable, LoanPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoanPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loanIdMeta = const VerificationMeta('loanId');
  @override
  late final GeneratedColumn<String> loanId = GeneratedColumn<String>(
    'loan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES loans (id)',
    ),
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidOnMeta = const VerificationMeta('paidOn');
  @override
  late final GeneratedColumn<String> paidOn = GeneratedColumn<String>(
    'paid_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedOnMeta = const VerificationMeta(
    'recordedOn',
  );
  @override
  late final GeneratedColumn<String> recordedOn = GeneratedColumn<String>(
    'recorded_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    loanId,
    amountCents,
    paidOn,
    recordedOn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loan_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoanPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('loan_id')) {
      context.handle(
        _loanIdMeta,
        loanId.isAcceptableOrUnknown(data['loan_id']!, _loanIdMeta),
      );
    } else if (isInserting) {
      context.missing(_loanIdMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('paid_on')) {
      context.handle(
        _paidOnMeta,
        paidOn.isAcceptableOrUnknown(data['paid_on']!, _paidOnMeta),
      );
    } else if (isInserting) {
      context.missing(_paidOnMeta);
    }
    if (data.containsKey('recorded_on')) {
      context.handle(
        _recordedOnMeta,
        recordedOn.isAcceptableOrUnknown(data['recorded_on']!, _recordedOnMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedOnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoanPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoanPayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      loanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}loan_id'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      paidOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paid_on'],
      )!,
      recordedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recorded_on'],
      )!,
    );
  }

  @override
  $LoanPaymentsTable createAlias(String alias) {
    return $LoanPaymentsTable(attachedDatabase, alias);
  }
}

class LoanPayment extends DataClass implements Insertable<LoanPayment> {
  final String id;
  final String loanId;
  final int amountCents;
  final String paidOn;
  final String recordedOn;
  const LoanPayment({
    required this.id,
    required this.loanId,
    required this.amountCents,
    required this.paidOn,
    required this.recordedOn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['loan_id'] = Variable<String>(loanId);
    map['amount_cents'] = Variable<int>(amountCents);
    map['paid_on'] = Variable<String>(paidOn);
    map['recorded_on'] = Variable<String>(recordedOn);
    return map;
  }

  LoanPaymentsCompanion toCompanion(bool nullToAbsent) {
    return LoanPaymentsCompanion(
      id: Value(id),
      loanId: Value(loanId),
      amountCents: Value(amountCents),
      paidOn: Value(paidOn),
      recordedOn: Value(recordedOn),
    );
  }

  factory LoanPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoanPayment(
      id: serializer.fromJson<String>(json['id']),
      loanId: serializer.fromJson<String>(json['loanId']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      paidOn: serializer.fromJson<String>(json['paidOn']),
      recordedOn: serializer.fromJson<String>(json['recordedOn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'loanId': serializer.toJson<String>(loanId),
      'amountCents': serializer.toJson<int>(amountCents),
      'paidOn': serializer.toJson<String>(paidOn),
      'recordedOn': serializer.toJson<String>(recordedOn),
    };
  }

  LoanPayment copyWith({
    String? id,
    String? loanId,
    int? amountCents,
    String? paidOn,
    String? recordedOn,
  }) => LoanPayment(
    id: id ?? this.id,
    loanId: loanId ?? this.loanId,
    amountCents: amountCents ?? this.amountCents,
    paidOn: paidOn ?? this.paidOn,
    recordedOn: recordedOn ?? this.recordedOn,
  );
  LoanPayment copyWithCompanion(LoanPaymentsCompanion data) {
    return LoanPayment(
      id: data.id.present ? data.id.value : this.id,
      loanId: data.loanId.present ? data.loanId.value : this.loanId,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      paidOn: data.paidOn.present ? data.paidOn.value : this.paidOn,
      recordedOn: data.recordedOn.present
          ? data.recordedOn.value
          : this.recordedOn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoanPayment(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('amountCents: $amountCents, ')
          ..write('paidOn: $paidOn, ')
          ..write('recordedOn: $recordedOn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, loanId, amountCents, paidOn, recordedOn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoanPayment &&
          other.id == this.id &&
          other.loanId == this.loanId &&
          other.amountCents == this.amountCents &&
          other.paidOn == this.paidOn &&
          other.recordedOn == this.recordedOn);
}

class LoanPaymentsCompanion extends UpdateCompanion<LoanPayment> {
  final Value<String> id;
  final Value<String> loanId;
  final Value<int> amountCents;
  final Value<String> paidOn;
  final Value<String> recordedOn;
  final Value<int> rowid;
  const LoanPaymentsCompanion({
    this.id = const Value.absent(),
    this.loanId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.paidOn = const Value.absent(),
    this.recordedOn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LoanPaymentsCompanion.insert({
    required String id,
    required String loanId,
    required int amountCents,
    required String paidOn,
    required String recordedOn,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       loanId = Value(loanId),
       amountCents = Value(amountCents),
       paidOn = Value(paidOn),
       recordedOn = Value(recordedOn);
  static Insertable<LoanPayment> custom({
    Expression<String>? id,
    Expression<String>? loanId,
    Expression<int>? amountCents,
    Expression<String>? paidOn,
    Expression<String>? recordedOn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loanId != null) 'loan_id': loanId,
      if (amountCents != null) 'amount_cents': amountCents,
      if (paidOn != null) 'paid_on': paidOn,
      if (recordedOn != null) 'recorded_on': recordedOn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LoanPaymentsCompanion copyWith({
    Value<String>? id,
    Value<String>? loanId,
    Value<int>? amountCents,
    Value<String>? paidOn,
    Value<String>? recordedOn,
    Value<int>? rowid,
  }) {
    return LoanPaymentsCompanion(
      id: id ?? this.id,
      loanId: loanId ?? this.loanId,
      amountCents: amountCents ?? this.amountCents,
      paidOn: paidOn ?? this.paidOn,
      recordedOn: recordedOn ?? this.recordedOn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (loanId.present) {
      map['loan_id'] = Variable<String>(loanId.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (paidOn.present) {
      map['paid_on'] = Variable<String>(paidOn.value);
    }
    if (recordedOn.present) {
      map['recorded_on'] = Variable<String>(recordedOn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoanPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('amountCents: $amountCents, ')
          ..write('paidOn: $paidOn, ')
          ..write('recordedOn: $recordedOn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShareOutsTable extends ShareOuts
    with TableInfo<$ShareOutsTable, ShareOut> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShareOutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<String> cycleId = GeneratedColumn<String>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cycles (id)',
    ),
  );
  static const VerificationMeta _potCentsMeta = const VerificationMeta(
    'potCents',
  );
  @override
  late final GeneratedColumn<int> potCents = GeneratedColumn<int>(
    'pot_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cashCentsMeta = const VerificationMeta(
    'cashCents',
  );
  @override
  late final GeneratedColumn<int> cashCents = GeneratedColumn<int>(
    'cash_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdOnMeta = const VerificationMeta(
    'createdOn',
  );
  @override
  late final GeneratedColumn<String> createdOn = GeneratedColumn<String>(
    'created_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cycleId,
    potCents,
    cashCents,
    createdOn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'share_outs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShareOut> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('pot_cents')) {
      context.handle(
        _potCentsMeta,
        potCents.isAcceptableOrUnknown(data['pot_cents']!, _potCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_potCentsMeta);
    }
    if (data.containsKey('cash_cents')) {
      context.handle(
        _cashCentsMeta,
        cashCents.isAcceptableOrUnknown(data['cash_cents']!, _cashCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_cashCentsMeta);
    }
    if (data.containsKey('created_on')) {
      context.handle(
        _createdOnMeta,
        createdOn.isAcceptableOrUnknown(data['created_on']!, _createdOnMeta),
      );
    } else if (isInserting) {
      context.missing(_createdOnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShareOut map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShareOut(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle_id'],
      )!,
      potCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pot_cents'],
      )!,
      cashCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cash_cents'],
      )!,
      createdOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_on'],
      )!,
    );
  }

  @override
  $ShareOutsTable createAlias(String alias) {
    return $ShareOutsTable(attachedDatabase, alias);
  }
}

class ShareOut extends DataClass implements Insertable<ShareOut> {
  final String id;
  final String cycleId;
  final int potCents;
  final int cashCents;
  final String createdOn;
  const ShareOut({
    required this.id,
    required this.cycleId,
    required this.potCents,
    required this.cashCents,
    required this.createdOn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cycle_id'] = Variable<String>(cycleId);
    map['pot_cents'] = Variable<int>(potCents);
    map['cash_cents'] = Variable<int>(cashCents);
    map['created_on'] = Variable<String>(createdOn);
    return map;
  }

  ShareOutsCompanion toCompanion(bool nullToAbsent) {
    return ShareOutsCompanion(
      id: Value(id),
      cycleId: Value(cycleId),
      potCents: Value(potCents),
      cashCents: Value(cashCents),
      createdOn: Value(createdOn),
    );
  }

  factory ShareOut.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShareOut(
      id: serializer.fromJson<String>(json['id']),
      cycleId: serializer.fromJson<String>(json['cycleId']),
      potCents: serializer.fromJson<int>(json['potCents']),
      cashCents: serializer.fromJson<int>(json['cashCents']),
      createdOn: serializer.fromJson<String>(json['createdOn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cycleId': serializer.toJson<String>(cycleId),
      'potCents': serializer.toJson<int>(potCents),
      'cashCents': serializer.toJson<int>(cashCents),
      'createdOn': serializer.toJson<String>(createdOn),
    };
  }

  ShareOut copyWith({
    String? id,
    String? cycleId,
    int? potCents,
    int? cashCents,
    String? createdOn,
  }) => ShareOut(
    id: id ?? this.id,
    cycleId: cycleId ?? this.cycleId,
    potCents: potCents ?? this.potCents,
    cashCents: cashCents ?? this.cashCents,
    createdOn: createdOn ?? this.createdOn,
  );
  ShareOut copyWithCompanion(ShareOutsCompanion data) {
    return ShareOut(
      id: data.id.present ? data.id.value : this.id,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      potCents: data.potCents.present ? data.potCents.value : this.potCents,
      cashCents: data.cashCents.present ? data.cashCents.value : this.cashCents,
      createdOn: data.createdOn.present ? data.createdOn.value : this.createdOn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShareOut(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('potCents: $potCents, ')
          ..write('cashCents: $cashCents, ')
          ..write('createdOn: $createdOn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cycleId, potCents, cashCents, createdOn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShareOut &&
          other.id == this.id &&
          other.cycleId == this.cycleId &&
          other.potCents == this.potCents &&
          other.cashCents == this.cashCents &&
          other.createdOn == this.createdOn);
}

class ShareOutsCompanion extends UpdateCompanion<ShareOut> {
  final Value<String> id;
  final Value<String> cycleId;
  final Value<int> potCents;
  final Value<int> cashCents;
  final Value<String> createdOn;
  final Value<int> rowid;
  const ShareOutsCompanion({
    this.id = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.potCents = const Value.absent(),
    this.cashCents = const Value.absent(),
    this.createdOn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShareOutsCompanion.insert({
    required String id,
    required String cycleId,
    required int potCents,
    required int cashCents,
    required String createdOn,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cycleId = Value(cycleId),
       potCents = Value(potCents),
       cashCents = Value(cashCents),
       createdOn = Value(createdOn);
  static Insertable<ShareOut> custom({
    Expression<String>? id,
    Expression<String>? cycleId,
    Expression<int>? potCents,
    Expression<int>? cashCents,
    Expression<String>? createdOn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cycleId != null) 'cycle_id': cycleId,
      if (potCents != null) 'pot_cents': potCents,
      if (cashCents != null) 'cash_cents': cashCents,
      if (createdOn != null) 'created_on': createdOn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShareOutsCompanion copyWith({
    Value<String>? id,
    Value<String>? cycleId,
    Value<int>? potCents,
    Value<int>? cashCents,
    Value<String>? createdOn,
    Value<int>? rowid,
  }) {
    return ShareOutsCompanion(
      id: id ?? this.id,
      cycleId: cycleId ?? this.cycleId,
      potCents: potCents ?? this.potCents,
      cashCents: cashCents ?? this.cashCents,
      createdOn: createdOn ?? this.createdOn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<String>(cycleId.value);
    }
    if (potCents.present) {
      map['pot_cents'] = Variable<int>(potCents.value);
    }
    if (cashCents.present) {
      map['cash_cents'] = Variable<int>(cashCents.value);
    }
    if (createdOn.present) {
      map['created_on'] = Variable<String>(createdOn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShareOutsCompanion(')
          ..write('id: $id, ')
          ..write('cycleId: $cycleId, ')
          ..write('potCents: $potCents, ')
          ..write('cashCents: $cashCents, ')
          ..write('createdOn: $createdOn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShareOutLinesTable extends ShareOutLines
    with TableInfo<$ShareOutLinesTable, ShareOutLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShareOutLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shareOutIdMeta = const VerificationMeta(
    'shareOutId',
  );
  @override
  late final GeneratedColumn<String> shareOutId = GeneratedColumn<String>(
    'share_out_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES share_outs (id)',
    ),
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id)',
    ),
  );
  static const VerificationMeta _multiplierMeta = const VerificationMeta(
    'multiplier',
  );
  @override
  late final GeneratedColumn<int> multiplier = GeneratedColumn<int>(
    'multiplier',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shareCentsMeta = const VerificationMeta(
    'shareCents',
  );
  @override
  late final GeneratedColumn<int> shareCents = GeneratedColumn<int>(
    'share_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _debtDeductedCentsMeta = const VerificationMeta(
    'debtDeductedCents',
  );
  @override
  late final GeneratedColumn<int> debtDeductedCents = GeneratedColumn<int>(
    'debt_deducted_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payoutCentsMeta = const VerificationMeta(
    'payoutCents',
  );
  @override
  late final GeneratedColumn<int> payoutCents = GeneratedColumn<int>(
    'payout_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shareOutId,
    memberId,
    multiplier,
    shareCents,
    debtDeductedCents,
    payoutCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'share_out_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShareOutLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('share_out_id')) {
      context.handle(
        _shareOutIdMeta,
        shareOutId.isAcceptableOrUnknown(
          data['share_out_id']!,
          _shareOutIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shareOutIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('multiplier')) {
      context.handle(
        _multiplierMeta,
        multiplier.isAcceptableOrUnknown(data['multiplier']!, _multiplierMeta),
      );
    } else if (isInserting) {
      context.missing(_multiplierMeta);
    }
    if (data.containsKey('share_cents')) {
      context.handle(
        _shareCentsMeta,
        shareCents.isAcceptableOrUnknown(data['share_cents']!, _shareCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_shareCentsMeta);
    }
    if (data.containsKey('debt_deducted_cents')) {
      context.handle(
        _debtDeductedCentsMeta,
        debtDeductedCents.isAcceptableOrUnknown(
          data['debt_deducted_cents']!,
          _debtDeductedCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_debtDeductedCentsMeta);
    }
    if (data.containsKey('payout_cents')) {
      context.handle(
        _payoutCentsMeta,
        payoutCents.isAcceptableOrUnknown(
          data['payout_cents']!,
          _payoutCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payoutCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShareOutLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShareOutLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      shareOutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}share_out_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      multiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}multiplier'],
      )!,
      shareCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}share_cents'],
      )!,
      debtDeductedCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}debt_deducted_cents'],
      )!,
      payoutCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payout_cents'],
      )!,
    );
  }

  @override
  $ShareOutLinesTable createAlias(String alias) {
    return $ShareOutLinesTable(attachedDatabase, alias);
  }
}

class ShareOutLine extends DataClass implements Insertable<ShareOutLine> {
  final String id;
  final String shareOutId;
  final String memberId;
  final int multiplier;
  final int shareCents;
  final int debtDeductedCents;
  final int payoutCents;
  const ShareOutLine({
    required this.id,
    required this.shareOutId,
    required this.memberId,
    required this.multiplier,
    required this.shareCents,
    required this.debtDeductedCents,
    required this.payoutCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['share_out_id'] = Variable<String>(shareOutId);
    map['member_id'] = Variable<String>(memberId);
    map['multiplier'] = Variable<int>(multiplier);
    map['share_cents'] = Variable<int>(shareCents);
    map['debt_deducted_cents'] = Variable<int>(debtDeductedCents);
    map['payout_cents'] = Variable<int>(payoutCents);
    return map;
  }

  ShareOutLinesCompanion toCompanion(bool nullToAbsent) {
    return ShareOutLinesCompanion(
      id: Value(id),
      shareOutId: Value(shareOutId),
      memberId: Value(memberId),
      multiplier: Value(multiplier),
      shareCents: Value(shareCents),
      debtDeductedCents: Value(debtDeductedCents),
      payoutCents: Value(payoutCents),
    );
  }

  factory ShareOutLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShareOutLine(
      id: serializer.fromJson<String>(json['id']),
      shareOutId: serializer.fromJson<String>(json['shareOutId']),
      memberId: serializer.fromJson<String>(json['memberId']),
      multiplier: serializer.fromJson<int>(json['multiplier']),
      shareCents: serializer.fromJson<int>(json['shareCents']),
      debtDeductedCents: serializer.fromJson<int>(json['debtDeductedCents']),
      payoutCents: serializer.fromJson<int>(json['payoutCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shareOutId': serializer.toJson<String>(shareOutId),
      'memberId': serializer.toJson<String>(memberId),
      'multiplier': serializer.toJson<int>(multiplier),
      'shareCents': serializer.toJson<int>(shareCents),
      'debtDeductedCents': serializer.toJson<int>(debtDeductedCents),
      'payoutCents': serializer.toJson<int>(payoutCents),
    };
  }

  ShareOutLine copyWith({
    String? id,
    String? shareOutId,
    String? memberId,
    int? multiplier,
    int? shareCents,
    int? debtDeductedCents,
    int? payoutCents,
  }) => ShareOutLine(
    id: id ?? this.id,
    shareOutId: shareOutId ?? this.shareOutId,
    memberId: memberId ?? this.memberId,
    multiplier: multiplier ?? this.multiplier,
    shareCents: shareCents ?? this.shareCents,
    debtDeductedCents: debtDeductedCents ?? this.debtDeductedCents,
    payoutCents: payoutCents ?? this.payoutCents,
  );
  ShareOutLine copyWithCompanion(ShareOutLinesCompanion data) {
    return ShareOutLine(
      id: data.id.present ? data.id.value : this.id,
      shareOutId: data.shareOutId.present
          ? data.shareOutId.value
          : this.shareOutId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      multiplier: data.multiplier.present
          ? data.multiplier.value
          : this.multiplier,
      shareCents: data.shareCents.present
          ? data.shareCents.value
          : this.shareCents,
      debtDeductedCents: data.debtDeductedCents.present
          ? data.debtDeductedCents.value
          : this.debtDeductedCents,
      payoutCents: data.payoutCents.present
          ? data.payoutCents.value
          : this.payoutCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShareOutLine(')
          ..write('id: $id, ')
          ..write('shareOutId: $shareOutId, ')
          ..write('memberId: $memberId, ')
          ..write('multiplier: $multiplier, ')
          ..write('shareCents: $shareCents, ')
          ..write('debtDeductedCents: $debtDeductedCents, ')
          ..write('payoutCents: $payoutCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    shareOutId,
    memberId,
    multiplier,
    shareCents,
    debtDeductedCents,
    payoutCents,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShareOutLine &&
          other.id == this.id &&
          other.shareOutId == this.shareOutId &&
          other.memberId == this.memberId &&
          other.multiplier == this.multiplier &&
          other.shareCents == this.shareCents &&
          other.debtDeductedCents == this.debtDeductedCents &&
          other.payoutCents == this.payoutCents);
}

class ShareOutLinesCompanion extends UpdateCompanion<ShareOutLine> {
  final Value<String> id;
  final Value<String> shareOutId;
  final Value<String> memberId;
  final Value<int> multiplier;
  final Value<int> shareCents;
  final Value<int> debtDeductedCents;
  final Value<int> payoutCents;
  final Value<int> rowid;
  const ShareOutLinesCompanion({
    this.id = const Value.absent(),
    this.shareOutId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.multiplier = const Value.absent(),
    this.shareCents = const Value.absent(),
    this.debtDeductedCents = const Value.absent(),
    this.payoutCents = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShareOutLinesCompanion.insert({
    required String id,
    required String shareOutId,
    required String memberId,
    required int multiplier,
    required int shareCents,
    required int debtDeductedCents,
    required int payoutCents,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       shareOutId = Value(shareOutId),
       memberId = Value(memberId),
       multiplier = Value(multiplier),
       shareCents = Value(shareCents),
       debtDeductedCents = Value(debtDeductedCents),
       payoutCents = Value(payoutCents);
  static Insertable<ShareOutLine> custom({
    Expression<String>? id,
    Expression<String>? shareOutId,
    Expression<String>? memberId,
    Expression<int>? multiplier,
    Expression<int>? shareCents,
    Expression<int>? debtDeductedCents,
    Expression<int>? payoutCents,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shareOutId != null) 'share_out_id': shareOutId,
      if (memberId != null) 'member_id': memberId,
      if (multiplier != null) 'multiplier': multiplier,
      if (shareCents != null) 'share_cents': shareCents,
      if (debtDeductedCents != null) 'debt_deducted_cents': debtDeductedCents,
      if (payoutCents != null) 'payout_cents': payoutCents,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShareOutLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? shareOutId,
    Value<String>? memberId,
    Value<int>? multiplier,
    Value<int>? shareCents,
    Value<int>? debtDeductedCents,
    Value<int>? payoutCents,
    Value<int>? rowid,
  }) {
    return ShareOutLinesCompanion(
      id: id ?? this.id,
      shareOutId: shareOutId ?? this.shareOutId,
      memberId: memberId ?? this.memberId,
      multiplier: multiplier ?? this.multiplier,
      shareCents: shareCents ?? this.shareCents,
      debtDeductedCents: debtDeductedCents ?? this.debtDeductedCents,
      payoutCents: payoutCents ?? this.payoutCents,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shareOutId.present) {
      map['share_out_id'] = Variable<String>(shareOutId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (multiplier.present) {
      map['multiplier'] = Variable<int>(multiplier.value);
    }
    if (shareCents.present) {
      map['share_cents'] = Variable<int>(shareCents.value);
    }
    if (debtDeductedCents.present) {
      map['debt_deducted_cents'] = Variable<int>(debtDeductedCents.value);
    }
    if (payoutCents.present) {
      map['payout_cents'] = Variable<int>(payoutCents.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShareOutLinesCompanion(')
          ..write('id: $id, ')
          ..write('shareOutId: $shareOutId, ')
          ..write('memberId: $memberId, ')
          ..write('multiplier: $multiplier, ')
          ..write('shareCents: $shareCents, ')
          ..write('debtDeductedCents: $debtDeductedCents, ')
          ..write('payoutCents: $payoutCents, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $CyclesTable cycles = $CyclesTable(this);
  late final $MembersTable members = $MembersTable(this);
  late final $ContributionsTable contributions = $ContributionsTable(this);
  late final $LoansTable loans = $LoansTable(this);
  late final $LoanPaymentsTable loanPayments = $LoanPaymentsTable(this);
  late final $ShareOutsTable shareOuts = $ShareOutsTable(this);
  late final $ShareOutLinesTable shareOutLines = $ShareOutLinesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cycles,
    members,
    contributions,
    loans,
    loanPayments,
    shareOuts,
    shareOutLines,
  ];
}

typedef $$CyclesTableCreateCompanionBuilder =
    CyclesCompanion Function({
      required String id,
      required String name,
      required String startDate,
      Value<String?> endDate,
      Value<String> status,
      Value<String?> endedOn,
      Value<int> weeklyUnitCents,
      Value<int> interestPct,
      Value<int> rowid,
    });
typedef $$CyclesTableUpdateCompanionBuilder =
    CyclesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> startDate,
      Value<String?> endDate,
      Value<String> status,
      Value<String?> endedOn,
      Value<int> weeklyUnitCents,
      Value<int> interestPct,
      Value<int> rowid,
    });

final class $$CyclesTableReferences
    extends BaseReferences<_$AppDb, $CyclesTable, Cycle> {
  $$CyclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MembersTable, List<Member>> _membersRefsTable(
    _$AppDb db,
  ) => MultiTypedResultKey.fromTable(
    db.members,
    aliasName: $_aliasNameGenerator(db.cycles.id, db.members.cycleId),
  );

  $$MembersTableProcessedTableManager get membersRefs {
    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.cycleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_membersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ContributionsTable, List<Contribution>>
  _contributionsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.contributions,
    aliasName: $_aliasNameGenerator(db.cycles.id, db.contributions.cycleId),
  );

  $$ContributionsTableProcessedTableManager get contributionsRefs {
    final manager = $$ContributionsTableTableManager(
      $_db,
      $_db.contributions,
    ).filter((f) => f.cycleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_contributionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LoansTable, List<Loan>> _loansRefsTable(
    _$AppDb db,
  ) => MultiTypedResultKey.fromTable(
    db.loans,
    aliasName: $_aliasNameGenerator(db.cycles.id, db.loans.cycleId),
  );

  $$LoansTableProcessedTableManager get loansRefs {
    final manager = $$LoansTableTableManager(
      $_db,
      $_db.loans,
    ).filter((f) => f.cycleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_loansRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ShareOutsTable, List<ShareOut>>
  _shareOutsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.shareOuts,
    aliasName: $_aliasNameGenerator(db.cycles.id, db.shareOuts.cycleId),
  );

  $$ShareOutsTableProcessedTableManager get shareOutsRefs {
    final manager = $$ShareOutsTableTableManager(
      $_db,
      $_db.shareOuts,
    ).filter((f) => f.cycleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_shareOutsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CyclesTableFilterComposer extends Composer<_$AppDb, $CyclesTable> {
  $$CyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endedOn => $composableBuilder(
    column: $table.endedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyUnitCents => $composableBuilder(
    column: $table.weeklyUnitCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interestPct => $composableBuilder(
    column: $table.interestPct,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> membersRefs(
    Expression<bool> Function($$MembersTableFilterComposer f) f,
  ) {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.cycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> contributionsRefs(
    Expression<bool> Function($$ContributionsTableFilterComposer f) f,
  ) {
    final $$ContributionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contributions,
      getReferencedColumn: (t) => t.cycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContributionsTableFilterComposer(
            $db: $db,
            $table: $db.contributions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> loansRefs(
    Expression<bool> Function($$LoansTableFilterComposer f) f,
  ) {
    final $$LoansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.cycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableFilterComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shareOutsRefs(
    Expression<bool> Function($$ShareOutsTableFilterComposer f) f,
  ) {
    final $$ShareOutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shareOuts,
      getReferencedColumn: (t) => t.cycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShareOutsTableFilterComposer(
            $db: $db,
            $table: $db.shareOuts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CyclesTableOrderingComposer extends Composer<_$AppDb, $CyclesTable> {
  $$CyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endedOn => $composableBuilder(
    column: $table.endedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyUnitCents => $composableBuilder(
    column: $table.weeklyUnitCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interestPct => $composableBuilder(
    column: $table.interestPct,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CyclesTableAnnotationComposer extends Composer<_$AppDb, $CyclesTable> {
  $$CyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get endedOn =>
      $composableBuilder(column: $table.endedOn, builder: (column) => column);

  GeneratedColumn<int> get weeklyUnitCents => $composableBuilder(
    column: $table.weeklyUnitCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get interestPct => $composableBuilder(
    column: $table.interestPct,
    builder: (column) => column,
  );

  Expression<T> membersRefs<T extends Object>(
    Expression<T> Function($$MembersTableAnnotationComposer a) f,
  ) {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.cycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> contributionsRefs<T extends Object>(
    Expression<T> Function($$ContributionsTableAnnotationComposer a) f,
  ) {
    final $$ContributionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contributions,
      getReferencedColumn: (t) => t.cycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContributionsTableAnnotationComposer(
            $db: $db,
            $table: $db.contributions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> loansRefs<T extends Object>(
    Expression<T> Function($$LoansTableAnnotationComposer a) f,
  ) {
    final $$LoansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.cycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableAnnotationComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> shareOutsRefs<T extends Object>(
    Expression<T> Function($$ShareOutsTableAnnotationComposer a) f,
  ) {
    final $$ShareOutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shareOuts,
      getReferencedColumn: (t) => t.cycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShareOutsTableAnnotationComposer(
            $db: $db,
            $table: $db.shareOuts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CyclesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $CyclesTable,
          Cycle,
          $$CyclesTableFilterComposer,
          $$CyclesTableOrderingComposer,
          $$CyclesTableAnnotationComposer,
          $$CyclesTableCreateCompanionBuilder,
          $$CyclesTableUpdateCompanionBuilder,
          (Cycle, $$CyclesTableReferences),
          Cycle,
          PrefetchHooks Function({
            bool membersRefs,
            bool contributionsRefs,
            bool loansRefs,
            bool shareOutsRefs,
          })
        > {
  $$CyclesTableTableManager(_$AppDb db, $CyclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> endedOn = const Value.absent(),
                Value<int> weeklyUnitCents = const Value.absent(),
                Value<int> interestPct = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CyclesCompanion(
                id: id,
                name: name,
                startDate: startDate,
                endDate: endDate,
                status: status,
                endedOn: endedOn,
                weeklyUnitCents: weeklyUnitCents,
                interestPct: interestPct,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String startDate,
                Value<String?> endDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> endedOn = const Value.absent(),
                Value<int> weeklyUnitCents = const Value.absent(),
                Value<int> interestPct = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CyclesCompanion.insert(
                id: id,
                name: name,
                startDate: startDate,
                endDate: endDate,
                status: status,
                endedOn: endedOn,
                weeklyUnitCents: weeklyUnitCents,
                interestPct: interestPct,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CyclesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                membersRefs = false,
                contributionsRefs = false,
                loansRefs = false,
                shareOutsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (membersRefs) db.members,
                    if (contributionsRefs) db.contributions,
                    if (loansRefs) db.loans,
                    if (shareOutsRefs) db.shareOuts,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (membersRefs)
                        await $_getPrefetchedData<Cycle, $CyclesTable, Member>(
                          currentTable: table,
                          referencedTable: $$CyclesTableReferences
                              ._membersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CyclesTableReferences(
                                db,
                                table,
                                p0,
                              ).membersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cycleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (contributionsRefs)
                        await $_getPrefetchedData<
                          Cycle,
                          $CyclesTable,
                          Contribution
                        >(
                          currentTable: table,
                          referencedTable: $$CyclesTableReferences
                              ._contributionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CyclesTableReferences(
                                db,
                                table,
                                p0,
                              ).contributionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cycleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (loansRefs)
                        await $_getPrefetchedData<Cycle, $CyclesTable, Loan>(
                          currentTable: table,
                          referencedTable: $$CyclesTableReferences
                              ._loansRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CyclesTableReferences(db, table, p0).loansRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cycleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shareOutsRefs)
                        await $_getPrefetchedData<
                          Cycle,
                          $CyclesTable,
                          ShareOut
                        >(
                          currentTable: table,
                          referencedTable: $$CyclesTableReferences
                              ._shareOutsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CyclesTableReferences(
                                db,
                                table,
                                p0,
                              ).shareOutsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cycleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CyclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $CyclesTable,
      Cycle,
      $$CyclesTableFilterComposer,
      $$CyclesTableOrderingComposer,
      $$CyclesTableAnnotationComposer,
      $$CyclesTableCreateCompanionBuilder,
      $$CyclesTableUpdateCompanionBuilder,
      (Cycle, $$CyclesTableReferences),
      Cycle,
      PrefetchHooks Function({
        bool membersRefs,
        bool contributionsRefs,
        bool loansRefs,
        bool shareOutsRefs,
      })
    >;
typedef $$MembersTableCreateCompanionBuilder =
    MembersCompanion Function({
      required String id,
      required String cycleId,
      required String name,
      required int multiplier,
      Value<int> rowid,
    });
typedef $$MembersTableUpdateCompanionBuilder =
    MembersCompanion Function({
      Value<String> id,
      Value<String> cycleId,
      Value<String> name,
      Value<int> multiplier,
      Value<int> rowid,
    });

final class $$MembersTableReferences
    extends BaseReferences<_$AppDb, $MembersTable, Member> {
  $$MembersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CyclesTable _cycleIdTable(_$AppDb db) => db.cycles.createAlias(
    $_aliasNameGenerator(db.members.cycleId, db.cycles.id),
  );

  $$CyclesTableProcessedTableManager get cycleId {
    final $_column = $_itemColumn<String>('cycle_id')!;

    final manager = $$CyclesTableTableManager(
      $_db,
      $_db.cycles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ContributionsTable, List<Contribution>>
  _contributionsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.contributions,
    aliasName: $_aliasNameGenerator(db.members.id, db.contributions.memberId),
  );

  $$ContributionsTableProcessedTableManager get contributionsRefs {
    final manager = $$ContributionsTableTableManager(
      $_db,
      $_db.contributions,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_contributionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LoansTable, List<Loan>> _loansRefsTable(
    _$AppDb db,
  ) => MultiTypedResultKey.fromTable(
    db.loans,
    aliasName: $_aliasNameGenerator(db.members.id, db.loans.memberId),
  );

  $$LoansTableProcessedTableManager get loansRefs {
    final manager = $$LoansTableTableManager(
      $_db,
      $_db.loans,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_loansRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ShareOutLinesTable, List<ShareOutLine>>
  _shareOutLinesRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.shareOutLines,
    aliasName: $_aliasNameGenerator(db.members.id, db.shareOutLines.memberId),
  );

  $$ShareOutLinesTableProcessedTableManager get shareOutLinesRefs {
    final manager = $$ShareOutLinesTableTableManager(
      $_db,
      $_db.shareOutLines,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_shareOutLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MembersTableFilterComposer extends Composer<_$AppDb, $MembersTable> {
  $$MembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get multiplier => $composableBuilder(
    column: $table.multiplier,
    builder: (column) => ColumnFilters(column),
  );

  $$CyclesTableFilterComposer get cycleId {
    final $$CyclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableFilterComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> contributionsRefs(
    Expression<bool> Function($$ContributionsTableFilterComposer f) f,
  ) {
    final $$ContributionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contributions,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContributionsTableFilterComposer(
            $db: $db,
            $table: $db.contributions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> loansRefs(
    Expression<bool> Function($$LoansTableFilterComposer f) f,
  ) {
    final $$LoansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableFilterComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shareOutLinesRefs(
    Expression<bool> Function($$ShareOutLinesTableFilterComposer f) f,
  ) {
    final $$ShareOutLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shareOutLines,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShareOutLinesTableFilterComposer(
            $db: $db,
            $table: $db.shareOutLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MembersTableOrderingComposer extends Composer<_$AppDb, $MembersTable> {
  $$MembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get multiplier => $composableBuilder(
    column: $table.multiplier,
    builder: (column) => ColumnOrderings(column),
  );

  $$CyclesTableOrderingComposer get cycleId {
    final $$CyclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableOrderingComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MembersTableAnnotationComposer
    extends Composer<_$AppDb, $MembersTable> {
  $$MembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get multiplier => $composableBuilder(
    column: $table.multiplier,
    builder: (column) => column,
  );

  $$CyclesTableAnnotationComposer get cycleId {
    final $$CyclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableAnnotationComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> contributionsRefs<T extends Object>(
    Expression<T> Function($$ContributionsTableAnnotationComposer a) f,
  ) {
    final $$ContributionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.contributions,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ContributionsTableAnnotationComposer(
            $db: $db,
            $table: $db.contributions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> loansRefs<T extends Object>(
    Expression<T> Function($$LoansTableAnnotationComposer a) f,
  ) {
    final $$LoansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableAnnotationComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> shareOutLinesRefs<T extends Object>(
    Expression<T> Function($$ShareOutLinesTableAnnotationComposer a) f,
  ) {
    final $$ShareOutLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shareOutLines,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShareOutLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.shareOutLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MembersTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $MembersTable,
          Member,
          $$MembersTableFilterComposer,
          $$MembersTableOrderingComposer,
          $$MembersTableAnnotationComposer,
          $$MembersTableCreateCompanionBuilder,
          $$MembersTableUpdateCompanionBuilder,
          (Member, $$MembersTableReferences),
          Member,
          PrefetchHooks Function({
            bool cycleId,
            bool contributionsRefs,
            bool loansRefs,
            bool shareOutLinesRefs,
          })
        > {
  $$MembersTableTableManager(_$AppDb db, $MembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cycleId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> multiplier = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MembersCompanion(
                id: id,
                cycleId: cycleId,
                name: name,
                multiplier: multiplier,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cycleId,
                required String name,
                required int multiplier,
                Value<int> rowid = const Value.absent(),
              }) => MembersCompanion.insert(
                id: id,
                cycleId: cycleId,
                name: name,
                multiplier: multiplier,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MembersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                cycleId = false,
                contributionsRefs = false,
                loansRefs = false,
                shareOutLinesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (contributionsRefs) db.contributions,
                    if (loansRefs) db.loans,
                    if (shareOutLinesRefs) db.shareOutLines,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cycleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cycleId,
                                    referencedTable: $$MembersTableReferences
                                        ._cycleIdTable(db),
                                    referencedColumn: $$MembersTableReferences
                                        ._cycleIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (contributionsRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          Contribution
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._contributionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).contributionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (loansRefs)
                        await $_getPrefetchedData<Member, $MembersTable, Loan>(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._loansRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(db, table, p0).loansRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shareOutLinesRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          ShareOutLine
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._shareOutLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).shareOutLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $MembersTable,
      Member,
      $$MembersTableFilterComposer,
      $$MembersTableOrderingComposer,
      $$MembersTableAnnotationComposer,
      $$MembersTableCreateCompanionBuilder,
      $$MembersTableUpdateCompanionBuilder,
      (Member, $$MembersTableReferences),
      Member,
      PrefetchHooks Function({
        bool cycleId,
        bool contributionsRefs,
        bool loansRefs,
        bool shareOutLinesRefs,
      })
    >;
typedef $$ContributionsTableCreateCompanionBuilder =
    ContributionsCompanion Function({
      required String id,
      required String cycleId,
      required String memberId,
      required String saturday,
      required int amountCents,
      required String recordedOn,
      Value<int> rowid,
    });
typedef $$ContributionsTableUpdateCompanionBuilder =
    ContributionsCompanion Function({
      Value<String> id,
      Value<String> cycleId,
      Value<String> memberId,
      Value<String> saturday,
      Value<int> amountCents,
      Value<String> recordedOn,
      Value<int> rowid,
    });

final class $$ContributionsTableReferences
    extends BaseReferences<_$AppDb, $ContributionsTable, Contribution> {
  $$ContributionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CyclesTable _cycleIdTable(_$AppDb db) => db.cycles.createAlias(
    $_aliasNameGenerator(db.contributions.cycleId, db.cycles.id),
  );

  $$CyclesTableProcessedTableManager get cycleId {
    final $_column = $_itemColumn<String>('cycle_id')!;

    final manager = $$CyclesTableTableManager(
      $_db,
      $_db.cycles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MembersTable _memberIdTable(_$AppDb db) => db.members.createAlias(
    $_aliasNameGenerator(db.contributions.memberId, db.members.id),
  );

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ContributionsTableFilterComposer
    extends Composer<_$AppDb, $ContributionsTable> {
  $$ContributionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saturday => $composableBuilder(
    column: $table.saturday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordedOn => $composableBuilder(
    column: $table.recordedOn,
    builder: (column) => ColumnFilters(column),
  );

  $$CyclesTableFilterComposer get cycleId {
    final $$CyclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableFilterComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContributionsTableOrderingComposer
    extends Composer<_$AppDb, $ContributionsTable> {
  $$ContributionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saturday => $composableBuilder(
    column: $table.saturday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordedOn => $composableBuilder(
    column: $table.recordedOn,
    builder: (column) => ColumnOrderings(column),
  );

  $$CyclesTableOrderingComposer get cycleId {
    final $$CyclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableOrderingComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContributionsTableAnnotationComposer
    extends Composer<_$AppDb, $ContributionsTable> {
  $$ContributionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get saturday =>
      $composableBuilder(column: $table.saturday, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordedOn => $composableBuilder(
    column: $table.recordedOn,
    builder: (column) => column,
  );

  $$CyclesTableAnnotationComposer get cycleId {
    final $$CyclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableAnnotationComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ContributionsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $ContributionsTable,
          Contribution,
          $$ContributionsTableFilterComposer,
          $$ContributionsTableOrderingComposer,
          $$ContributionsTableAnnotationComposer,
          $$ContributionsTableCreateCompanionBuilder,
          $$ContributionsTableUpdateCompanionBuilder,
          (Contribution, $$ContributionsTableReferences),
          Contribution,
          PrefetchHooks Function({bool cycleId, bool memberId})
        > {
  $$ContributionsTableTableManager(_$AppDb db, $ContributionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContributionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContributionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContributionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cycleId = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<String> saturday = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String> recordedOn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContributionsCompanion(
                id: id,
                cycleId: cycleId,
                memberId: memberId,
                saturday: saturday,
                amountCents: amountCents,
                recordedOn: recordedOn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cycleId,
                required String memberId,
                required String saturday,
                required int amountCents,
                required String recordedOn,
                Value<int> rowid = const Value.absent(),
              }) => ContributionsCompanion.insert(
                id: id,
                cycleId: cycleId,
                memberId: memberId,
                saturday: saturday,
                amountCents: amountCents,
                recordedOn: recordedOn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ContributionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cycleId = false, memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cycleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cycleId,
                                referencedTable: $$ContributionsTableReferences
                                    ._cycleIdTable(db),
                                referencedColumn: $$ContributionsTableReferences
                                    ._cycleIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable: $$ContributionsTableReferences
                                    ._memberIdTable(db),
                                referencedColumn: $$ContributionsTableReferences
                                    ._memberIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ContributionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $ContributionsTable,
      Contribution,
      $$ContributionsTableFilterComposer,
      $$ContributionsTableOrderingComposer,
      $$ContributionsTableAnnotationComposer,
      $$ContributionsTableCreateCompanionBuilder,
      $$ContributionsTableUpdateCompanionBuilder,
      (Contribution, $$ContributionsTableReferences),
      Contribution,
      PrefetchHooks Function({bool cycleId, bool memberId})
    >;
typedef $$LoansTableCreateCompanionBuilder =
    LoansCompanion Function({
      required String id,
      required String cycleId,
      required String memberId,
      required int principalCents,
      required int owedCents,
      required String loanDate,
      required String dueDate,
      Value<String> status,
      Value<String?> parentLoanId,
      Value<String?> closedOn,
      Value<int> rowid,
    });
typedef $$LoansTableUpdateCompanionBuilder =
    LoansCompanion Function({
      Value<String> id,
      Value<String> cycleId,
      Value<String> memberId,
      Value<int> principalCents,
      Value<int> owedCents,
      Value<String> loanDate,
      Value<String> dueDate,
      Value<String> status,
      Value<String?> parentLoanId,
      Value<String?> closedOn,
      Value<int> rowid,
    });

final class $$LoansTableReferences
    extends BaseReferences<_$AppDb, $LoansTable, Loan> {
  $$LoansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CyclesTable _cycleIdTable(_$AppDb db) => db.cycles.createAlias(
    $_aliasNameGenerator(db.loans.cycleId, db.cycles.id),
  );

  $$CyclesTableProcessedTableManager get cycleId {
    final $_column = $_itemColumn<String>('cycle_id')!;

    final manager = $$CyclesTableTableManager(
      $_db,
      $_db.cycles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MembersTable _memberIdTable(_$AppDb db) => db.members.createAlias(
    $_aliasNameGenerator(db.loans.memberId, db.members.id),
  );

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$LoanPaymentsTable, List<LoanPayment>>
  _loanPaymentsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.loanPayments,
    aliasName: $_aliasNameGenerator(db.loans.id, db.loanPayments.loanId),
  );

  $$LoanPaymentsTableProcessedTableManager get loanPaymentsRefs {
    final manager = $$LoanPaymentsTableTableManager(
      $_db,
      $_db.loanPayments,
    ).filter((f) => f.loanId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_loanPaymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LoansTableFilterComposer extends Composer<_$AppDb, $LoansTable> {
  $$LoansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get principalCents => $composableBuilder(
    column: $table.principalCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get owedCents => $composableBuilder(
    column: $table.owedCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loanDate => $composableBuilder(
    column: $table.loanDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentLoanId => $composableBuilder(
    column: $table.parentLoanId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get closedOn => $composableBuilder(
    column: $table.closedOn,
    builder: (column) => ColumnFilters(column),
  );

  $$CyclesTableFilterComposer get cycleId {
    final $$CyclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableFilterComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> loanPaymentsRefs(
    Expression<bool> Function($$LoanPaymentsTableFilterComposer f) f,
  ) {
    final $$LoanPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loanPayments,
      getReferencedColumn: (t) => t.loanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoanPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.loanPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LoansTableOrderingComposer extends Composer<_$AppDb, $LoansTable> {
  $$LoansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get principalCents => $composableBuilder(
    column: $table.principalCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get owedCents => $composableBuilder(
    column: $table.owedCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loanDate => $composableBuilder(
    column: $table.loanDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentLoanId => $composableBuilder(
    column: $table.parentLoanId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get closedOn => $composableBuilder(
    column: $table.closedOn,
    builder: (column) => ColumnOrderings(column),
  );

  $$CyclesTableOrderingComposer get cycleId {
    final $$CyclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableOrderingComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoansTableAnnotationComposer extends Composer<_$AppDb, $LoansTable> {
  $$LoansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get principalCents => $composableBuilder(
    column: $table.principalCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get owedCents =>
      $composableBuilder(column: $table.owedCents, builder: (column) => column);

  GeneratedColumn<String> get loanDate =>
      $composableBuilder(column: $table.loanDate, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get parentLoanId => $composableBuilder(
    column: $table.parentLoanId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get closedOn =>
      $composableBuilder(column: $table.closedOn, builder: (column) => column);

  $$CyclesTableAnnotationComposer get cycleId {
    final $$CyclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableAnnotationComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> loanPaymentsRefs<T extends Object>(
    Expression<T> Function($$LoanPaymentsTableAnnotationComposer a) f,
  ) {
    final $$LoanPaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loanPayments,
      getReferencedColumn: (t) => t.loanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoanPaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.loanPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LoansTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $LoansTable,
          Loan,
          $$LoansTableFilterComposer,
          $$LoansTableOrderingComposer,
          $$LoansTableAnnotationComposer,
          $$LoansTableCreateCompanionBuilder,
          $$LoansTableUpdateCompanionBuilder,
          (Loan, $$LoansTableReferences),
          Loan,
          PrefetchHooks Function({
            bool cycleId,
            bool memberId,
            bool loanPaymentsRefs,
          })
        > {
  $$LoansTableTableManager(_$AppDb db, $LoansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cycleId = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<int> principalCents = const Value.absent(),
                Value<int> owedCents = const Value.absent(),
                Value<String> loanDate = const Value.absent(),
                Value<String> dueDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> parentLoanId = const Value.absent(),
                Value<String?> closedOn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LoansCompanion(
                id: id,
                cycleId: cycleId,
                memberId: memberId,
                principalCents: principalCents,
                owedCents: owedCents,
                loanDate: loanDate,
                dueDate: dueDate,
                status: status,
                parentLoanId: parentLoanId,
                closedOn: closedOn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cycleId,
                required String memberId,
                required int principalCents,
                required int owedCents,
                required String loanDate,
                required String dueDate,
                Value<String> status = const Value.absent(),
                Value<String?> parentLoanId = const Value.absent(),
                Value<String?> closedOn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LoansCompanion.insert(
                id: id,
                cycleId: cycleId,
                memberId: memberId,
                principalCents: principalCents,
                owedCents: owedCents,
                loanDate: loanDate,
                dueDate: dueDate,
                status: status,
                parentLoanId: parentLoanId,
                closedOn: closedOn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$LoansTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({cycleId = false, memberId = false, loanPaymentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (loanPaymentsRefs) db.loanPayments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cycleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cycleId,
                                    referencedTable: $$LoansTableReferences
                                        ._cycleIdTable(db),
                                    referencedColumn: $$LoansTableReferences
                                        ._cycleIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (memberId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.memberId,
                                    referencedTable: $$LoansTableReferences
                                        ._memberIdTable(db),
                                    referencedColumn: $$LoansTableReferences
                                        ._memberIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (loanPaymentsRefs)
                        await $_getPrefetchedData<
                          Loan,
                          $LoansTable,
                          LoanPayment
                        >(
                          currentTable: table,
                          referencedTable: $$LoansTableReferences
                              ._loanPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LoansTableReferences(
                                db,
                                table,
                                p0,
                              ).loanPaymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.loanId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LoansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $LoansTable,
      Loan,
      $$LoansTableFilterComposer,
      $$LoansTableOrderingComposer,
      $$LoansTableAnnotationComposer,
      $$LoansTableCreateCompanionBuilder,
      $$LoansTableUpdateCompanionBuilder,
      (Loan, $$LoansTableReferences),
      Loan,
      PrefetchHooks Function({
        bool cycleId,
        bool memberId,
        bool loanPaymentsRefs,
      })
    >;
typedef $$LoanPaymentsTableCreateCompanionBuilder =
    LoanPaymentsCompanion Function({
      required String id,
      required String loanId,
      required int amountCents,
      required String paidOn,
      required String recordedOn,
      Value<int> rowid,
    });
typedef $$LoanPaymentsTableUpdateCompanionBuilder =
    LoanPaymentsCompanion Function({
      Value<String> id,
      Value<String> loanId,
      Value<int> amountCents,
      Value<String> paidOn,
      Value<String> recordedOn,
      Value<int> rowid,
    });

final class $$LoanPaymentsTableReferences
    extends BaseReferences<_$AppDb, $LoanPaymentsTable, LoanPayment> {
  $$LoanPaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LoansTable _loanIdTable(_$AppDb db) => db.loans.createAlias(
    $_aliasNameGenerator(db.loanPayments.loanId, db.loans.id),
  );

  $$LoansTableProcessedTableManager get loanId {
    final $_column = $_itemColumn<String>('loan_id')!;

    final manager = $$LoansTableTableManager(
      $_db,
      $_db.loans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_loanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LoanPaymentsTableFilterComposer
    extends Composer<_$AppDb, $LoanPaymentsTable> {
  $$LoanPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paidOn => $composableBuilder(
    column: $table.paidOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordedOn => $composableBuilder(
    column: $table.recordedOn,
    builder: (column) => ColumnFilters(column),
  );

  $$LoansTableFilterComposer get loanId {
    final $$LoansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableFilterComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoanPaymentsTableOrderingComposer
    extends Composer<_$AppDb, $LoanPaymentsTable> {
  $$LoanPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paidOn => $composableBuilder(
    column: $table.paidOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordedOn => $composableBuilder(
    column: $table.recordedOn,
    builder: (column) => ColumnOrderings(column),
  );

  $$LoansTableOrderingComposer get loanId {
    final $$LoansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableOrderingComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoanPaymentsTableAnnotationComposer
    extends Composer<_$AppDb, $LoanPaymentsTable> {
  $$LoanPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paidOn =>
      $composableBuilder(column: $table.paidOn, builder: (column) => column);

  GeneratedColumn<String> get recordedOn => $composableBuilder(
    column: $table.recordedOn,
    builder: (column) => column,
  );

  $$LoansTableAnnotationComposer get loanId {
    final $$LoansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableAnnotationComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoanPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $LoanPaymentsTable,
          LoanPayment,
          $$LoanPaymentsTableFilterComposer,
          $$LoanPaymentsTableOrderingComposer,
          $$LoanPaymentsTableAnnotationComposer,
          $$LoanPaymentsTableCreateCompanionBuilder,
          $$LoanPaymentsTableUpdateCompanionBuilder,
          (LoanPayment, $$LoanPaymentsTableReferences),
          LoanPayment,
          PrefetchHooks Function({bool loanId})
        > {
  $$LoanPaymentsTableTableManager(_$AppDb db, $LoanPaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoanPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoanPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoanPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> loanId = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String> paidOn = const Value.absent(),
                Value<String> recordedOn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LoanPaymentsCompanion(
                id: id,
                loanId: loanId,
                amountCents: amountCents,
                paidOn: paidOn,
                recordedOn: recordedOn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String loanId,
                required int amountCents,
                required String paidOn,
                required String recordedOn,
                Value<int> rowid = const Value.absent(),
              }) => LoanPaymentsCompanion.insert(
                id: id,
                loanId: loanId,
                amountCents: amountCents,
                paidOn: paidOn,
                recordedOn: recordedOn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LoanPaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({loanId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (loanId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.loanId,
                                referencedTable: $$LoanPaymentsTableReferences
                                    ._loanIdTable(db),
                                referencedColumn: $$LoanPaymentsTableReferences
                                    ._loanIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LoanPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $LoanPaymentsTable,
      LoanPayment,
      $$LoanPaymentsTableFilterComposer,
      $$LoanPaymentsTableOrderingComposer,
      $$LoanPaymentsTableAnnotationComposer,
      $$LoanPaymentsTableCreateCompanionBuilder,
      $$LoanPaymentsTableUpdateCompanionBuilder,
      (LoanPayment, $$LoanPaymentsTableReferences),
      LoanPayment,
      PrefetchHooks Function({bool loanId})
    >;
typedef $$ShareOutsTableCreateCompanionBuilder =
    ShareOutsCompanion Function({
      required String id,
      required String cycleId,
      required int potCents,
      required int cashCents,
      required String createdOn,
      Value<int> rowid,
    });
typedef $$ShareOutsTableUpdateCompanionBuilder =
    ShareOutsCompanion Function({
      Value<String> id,
      Value<String> cycleId,
      Value<int> potCents,
      Value<int> cashCents,
      Value<String> createdOn,
      Value<int> rowid,
    });

final class $$ShareOutsTableReferences
    extends BaseReferences<_$AppDb, $ShareOutsTable, ShareOut> {
  $$ShareOutsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CyclesTable _cycleIdTable(_$AppDb db) => db.cycles.createAlias(
    $_aliasNameGenerator(db.shareOuts.cycleId, db.cycles.id),
  );

  $$CyclesTableProcessedTableManager get cycleId {
    final $_column = $_itemColumn<String>('cycle_id')!;

    final manager = $$CyclesTableTableManager(
      $_db,
      $_db.cycles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ShareOutLinesTable, List<ShareOutLine>>
  _shareOutLinesRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.shareOutLines,
    aliasName: $_aliasNameGenerator(
      db.shareOuts.id,
      db.shareOutLines.shareOutId,
    ),
  );

  $$ShareOutLinesTableProcessedTableManager get shareOutLinesRefs {
    final manager = $$ShareOutLinesTableTableManager(
      $_db,
      $_db.shareOutLines,
    ).filter((f) => f.shareOutId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_shareOutLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShareOutsTableFilterComposer
    extends Composer<_$AppDb, $ShareOutsTable> {
  $$ShareOutsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get potCents => $composableBuilder(
    column: $table.potCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cashCents => $composableBuilder(
    column: $table.cashCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdOn => $composableBuilder(
    column: $table.createdOn,
    builder: (column) => ColumnFilters(column),
  );

  $$CyclesTableFilterComposer get cycleId {
    final $$CyclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableFilterComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> shareOutLinesRefs(
    Expression<bool> Function($$ShareOutLinesTableFilterComposer f) f,
  ) {
    final $$ShareOutLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shareOutLines,
      getReferencedColumn: (t) => t.shareOutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShareOutLinesTableFilterComposer(
            $db: $db,
            $table: $db.shareOutLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShareOutsTableOrderingComposer
    extends Composer<_$AppDb, $ShareOutsTable> {
  $$ShareOutsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get potCents => $composableBuilder(
    column: $table.potCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cashCents => $composableBuilder(
    column: $table.cashCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdOn => $composableBuilder(
    column: $table.createdOn,
    builder: (column) => ColumnOrderings(column),
  );

  $$CyclesTableOrderingComposer get cycleId {
    final $$CyclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableOrderingComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShareOutsTableAnnotationComposer
    extends Composer<_$AppDb, $ShareOutsTable> {
  $$ShareOutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get potCents =>
      $composableBuilder(column: $table.potCents, builder: (column) => column);

  GeneratedColumn<int> get cashCents =>
      $composableBuilder(column: $table.cashCents, builder: (column) => column);

  GeneratedColumn<String> get createdOn =>
      $composableBuilder(column: $table.createdOn, builder: (column) => column);

  $$CyclesTableAnnotationComposer get cycleId {
    final $$CyclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cycleId,
      referencedTable: $db.cycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CyclesTableAnnotationComposer(
            $db: $db,
            $table: $db.cycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> shareOutLinesRefs<T extends Object>(
    Expression<T> Function($$ShareOutLinesTableAnnotationComposer a) f,
  ) {
    final $$ShareOutLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shareOutLines,
      getReferencedColumn: (t) => t.shareOutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShareOutLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.shareOutLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShareOutsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $ShareOutsTable,
          ShareOut,
          $$ShareOutsTableFilterComposer,
          $$ShareOutsTableOrderingComposer,
          $$ShareOutsTableAnnotationComposer,
          $$ShareOutsTableCreateCompanionBuilder,
          $$ShareOutsTableUpdateCompanionBuilder,
          (ShareOut, $$ShareOutsTableReferences),
          ShareOut,
          PrefetchHooks Function({bool cycleId, bool shareOutLinesRefs})
        > {
  $$ShareOutsTableTableManager(_$AppDb db, $ShareOutsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShareOutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShareOutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShareOutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cycleId = const Value.absent(),
                Value<int> potCents = const Value.absent(),
                Value<int> cashCents = const Value.absent(),
                Value<String> createdOn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShareOutsCompanion(
                id: id,
                cycleId: cycleId,
                potCents: potCents,
                cashCents: cashCents,
                createdOn: createdOn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cycleId,
                required int potCents,
                required int cashCents,
                required String createdOn,
                Value<int> rowid = const Value.absent(),
              }) => ShareOutsCompanion.insert(
                id: id,
                cycleId: cycleId,
                potCents: potCents,
                cashCents: cashCents,
                createdOn: createdOn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShareOutsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({cycleId = false, shareOutLinesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (shareOutLinesRefs) db.shareOutLines,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cycleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cycleId,
                                    referencedTable: $$ShareOutsTableReferences
                                        ._cycleIdTable(db),
                                    referencedColumn: $$ShareOutsTableReferences
                                        ._cycleIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (shareOutLinesRefs)
                        await $_getPrefetchedData<
                          ShareOut,
                          $ShareOutsTable,
                          ShareOutLine
                        >(
                          currentTable: table,
                          referencedTable: $$ShareOutsTableReferences
                              ._shareOutLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShareOutsTableReferences(
                                db,
                                table,
                                p0,
                              ).shareOutLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.shareOutId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ShareOutsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $ShareOutsTable,
      ShareOut,
      $$ShareOutsTableFilterComposer,
      $$ShareOutsTableOrderingComposer,
      $$ShareOutsTableAnnotationComposer,
      $$ShareOutsTableCreateCompanionBuilder,
      $$ShareOutsTableUpdateCompanionBuilder,
      (ShareOut, $$ShareOutsTableReferences),
      ShareOut,
      PrefetchHooks Function({bool cycleId, bool shareOutLinesRefs})
    >;
typedef $$ShareOutLinesTableCreateCompanionBuilder =
    ShareOutLinesCompanion Function({
      required String id,
      required String shareOutId,
      required String memberId,
      required int multiplier,
      required int shareCents,
      required int debtDeductedCents,
      required int payoutCents,
      Value<int> rowid,
    });
typedef $$ShareOutLinesTableUpdateCompanionBuilder =
    ShareOutLinesCompanion Function({
      Value<String> id,
      Value<String> shareOutId,
      Value<String> memberId,
      Value<int> multiplier,
      Value<int> shareCents,
      Value<int> debtDeductedCents,
      Value<int> payoutCents,
      Value<int> rowid,
    });

final class $$ShareOutLinesTableReferences
    extends BaseReferences<_$AppDb, $ShareOutLinesTable, ShareOutLine> {
  $$ShareOutLinesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShareOutsTable _shareOutIdTable(_$AppDb db) =>
      db.shareOuts.createAlias(
        $_aliasNameGenerator(db.shareOutLines.shareOutId, db.shareOuts.id),
      );

  $$ShareOutsTableProcessedTableManager get shareOutId {
    final $_column = $_itemColumn<String>('share_out_id')!;

    final manager = $$ShareOutsTableTableManager(
      $_db,
      $_db.shareOuts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shareOutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MembersTable _memberIdTable(_$AppDb db) => db.members.createAlias(
    $_aliasNameGenerator(db.shareOutLines.memberId, db.members.id),
  );

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShareOutLinesTableFilterComposer
    extends Composer<_$AppDb, $ShareOutLinesTable> {
  $$ShareOutLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get multiplier => $composableBuilder(
    column: $table.multiplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shareCents => $composableBuilder(
    column: $table.shareCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get debtDeductedCents => $composableBuilder(
    column: $table.debtDeductedCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get payoutCents => $composableBuilder(
    column: $table.payoutCents,
    builder: (column) => ColumnFilters(column),
  );

  $$ShareOutsTableFilterComposer get shareOutId {
    final $$ShareOutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shareOutId,
      referencedTable: $db.shareOuts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShareOutsTableFilterComposer(
            $db: $db,
            $table: $db.shareOuts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShareOutLinesTableOrderingComposer
    extends Composer<_$AppDb, $ShareOutLinesTable> {
  $$ShareOutLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get multiplier => $composableBuilder(
    column: $table.multiplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shareCents => $composableBuilder(
    column: $table.shareCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get debtDeductedCents => $composableBuilder(
    column: $table.debtDeductedCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get payoutCents => $composableBuilder(
    column: $table.payoutCents,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShareOutsTableOrderingComposer get shareOutId {
    final $$ShareOutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shareOutId,
      referencedTable: $db.shareOuts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShareOutsTableOrderingComposer(
            $db: $db,
            $table: $db.shareOuts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShareOutLinesTableAnnotationComposer
    extends Composer<_$AppDb, $ShareOutLinesTable> {
  $$ShareOutLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get multiplier => $composableBuilder(
    column: $table.multiplier,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shareCents => $composableBuilder(
    column: $table.shareCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get debtDeductedCents => $composableBuilder(
    column: $table.debtDeductedCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get payoutCents => $composableBuilder(
    column: $table.payoutCents,
    builder: (column) => column,
  );

  $$ShareOutsTableAnnotationComposer get shareOutId {
    final $$ShareOutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shareOutId,
      referencedTable: $db.shareOuts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShareOutsTableAnnotationComposer(
            $db: $db,
            $table: $db.shareOuts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShareOutLinesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $ShareOutLinesTable,
          ShareOutLine,
          $$ShareOutLinesTableFilterComposer,
          $$ShareOutLinesTableOrderingComposer,
          $$ShareOutLinesTableAnnotationComposer,
          $$ShareOutLinesTableCreateCompanionBuilder,
          $$ShareOutLinesTableUpdateCompanionBuilder,
          (ShareOutLine, $$ShareOutLinesTableReferences),
          ShareOutLine,
          PrefetchHooks Function({bool shareOutId, bool memberId})
        > {
  $$ShareOutLinesTableTableManager(_$AppDb db, $ShareOutLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShareOutLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShareOutLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShareOutLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> shareOutId = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<int> multiplier = const Value.absent(),
                Value<int> shareCents = const Value.absent(),
                Value<int> debtDeductedCents = const Value.absent(),
                Value<int> payoutCents = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShareOutLinesCompanion(
                id: id,
                shareOutId: shareOutId,
                memberId: memberId,
                multiplier: multiplier,
                shareCents: shareCents,
                debtDeductedCents: debtDeductedCents,
                payoutCents: payoutCents,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String shareOutId,
                required String memberId,
                required int multiplier,
                required int shareCents,
                required int debtDeductedCents,
                required int payoutCents,
                Value<int> rowid = const Value.absent(),
              }) => ShareOutLinesCompanion.insert(
                id: id,
                shareOutId: shareOutId,
                memberId: memberId,
                multiplier: multiplier,
                shareCents: shareCents,
                debtDeductedCents: debtDeductedCents,
                payoutCents: payoutCents,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShareOutLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({shareOutId = false, memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (shareOutId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.shareOutId,
                                referencedTable: $$ShareOutLinesTableReferences
                                    ._shareOutIdTable(db),
                                referencedColumn: $$ShareOutLinesTableReferences
                                    ._shareOutIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable: $$ShareOutLinesTableReferences
                                    ._memberIdTable(db),
                                referencedColumn: $$ShareOutLinesTableReferences
                                    ._memberIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ShareOutLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $ShareOutLinesTable,
      ShareOutLine,
      $$ShareOutLinesTableFilterComposer,
      $$ShareOutLinesTableOrderingComposer,
      $$ShareOutLinesTableAnnotationComposer,
      $$ShareOutLinesTableCreateCompanionBuilder,
      $$ShareOutLinesTableUpdateCompanionBuilder,
      (ShareOutLine, $$ShareOutLinesTableReferences),
      ShareOutLine,
      PrefetchHooks Function({bool shareOutId, bool memberId})
    >;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$CyclesTableTableManager get cycles =>
      $$CyclesTableTableManager(_db, _db.cycles);
  $$MembersTableTableManager get members =>
      $$MembersTableTableManager(_db, _db.members);
  $$ContributionsTableTableManager get contributions =>
      $$ContributionsTableTableManager(_db, _db.contributions);
  $$LoansTableTableManager get loans =>
      $$LoansTableTableManager(_db, _db.loans);
  $$LoanPaymentsTableTableManager get loanPayments =>
      $$LoanPaymentsTableTableManager(_db, _db.loanPayments);
  $$ShareOutsTableTableManager get shareOuts =>
      $$ShareOutsTableTableManager(_db, _db.shareOuts);
  $$ShareOutLinesTableTableManager get shareOutLines =>
      $$ShareOutLinesTableTableManager(_db, _db.shareOutLines);
}
