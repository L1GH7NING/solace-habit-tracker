// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyTypeMeta = const VerificationMeta(
    'frequencyType',
  );
  @override
  late final GeneratedColumn<String> frequencyType = GeneratedColumn<String>(
    'frequency_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('DAILY'),
  );
  static const VerificationMeta _frequencyDaysMeta = const VerificationMeta(
    'frequencyDays',
  );
  @override
  late final GeneratedColumn<String> frequencyDays = GeneratedColumn<String>(
    'frequency_days',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  @override
  late final GeneratedColumn<double> targetValue = GeneratedColumn<double>(
    'target_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('times'),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _habitTimeMeta = const VerificationMeta(
    'habitTime',
  );
  @override
  late final GeneratedColumn<int> habitTime = GeneratedColumn<int>(
    'habit_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderTimeMeta = const VerificationMeta(
    'reminderTime',
  );
  @override
  late final GeneratedColumn<int> reminderTime = GeneratedColumn<int>(
    'reminder_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pendingOperationMeta = const VerificationMeta(
    'pendingOperation',
  );
  @override
  late final GeneratedColumn<String> pendingOperation = GeneratedColumn<String>(
    'pending_operation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    userId,
    title,
    description,
    color,
    icon,
    frequencyType,
    frequencyDays,
    targetValue,
    unit,
    type,
    startDate,
    endDate,
    habitTime,
    reminderTime,
    isArchived,
    updatedAt,
    isSynced,
    pendingOperation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Habit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('frequency_type')) {
      context.handle(
        _frequencyTypeMeta,
        frequencyType.isAcceptableOrUnknown(
          data['frequency_type']!,
          _frequencyTypeMeta,
        ),
      );
    }
    if (data.containsKey('frequency_days')) {
      context.handle(
        _frequencyDaysMeta,
        frequencyDays.isAcceptableOrUnknown(
          data['frequency_days']!,
          _frequencyDaysMeta,
        ),
      );
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
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
    if (data.containsKey('habit_time')) {
      context.handle(
        _habitTimeMeta,
        habitTime.isAcceptableOrUnknown(data['habit_time']!, _habitTimeMeta),
      );
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
        _reminderTimeMeta,
        reminderTime.isAcceptableOrUnknown(
          data['reminder_time']!,
          _reminderTimeMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('pending_operation')) {
      context.handle(
        _pendingOperationMeta,
        pendingOperation.isAcceptableOrUnknown(
          data['pending_operation']!,
          _pendingOperationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Habit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Habit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      frequencyType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency_type'],
      )!,
      frequencyDays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency_days'],
      ),
      targetValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_value'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      habitTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}habit_time'],
      ),
      reminderTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_time'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      pendingOperation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pending_operation'],
      ),
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class Habit extends DataClass implements Insertable<Habit> {
  final int id;
  final String? serverId;
  final String userId;
  final String title;
  final String? description;
  final int color;
  final String icon;
  final String frequencyType;
  final String? frequencyDays;
  final double targetValue;
  final String unit;
  final String? type;
  final DateTime startDate;
  final DateTime? endDate;
  final int? habitTime;
  final int? reminderTime;
  final bool isArchived;
  final DateTime updatedAt;
  final bool isSynced;
  final String? pendingOperation;
  const Habit({
    required this.id,
    this.serverId,
    required this.userId,
    required this.title,
    this.description,
    required this.color,
    required this.icon,
    required this.frequencyType,
    this.frequencyDays,
    required this.targetValue,
    required this.unit,
    this.type,
    required this.startDate,
    this.endDate,
    this.habitTime,
    this.reminderTime,
    required this.isArchived,
    required this.updatedAt,
    required this.isSynced,
    this.pendingOperation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['color'] = Variable<int>(color);
    map['icon'] = Variable<String>(icon);
    map['frequency_type'] = Variable<String>(frequencyType);
    if (!nullToAbsent || frequencyDays != null) {
      map['frequency_days'] = Variable<String>(frequencyDays);
    }
    map['target_value'] = Variable<double>(targetValue);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || habitTime != null) {
      map['habit_time'] = Variable<int>(habitTime);
    }
    if (!nullToAbsent || reminderTime != null) {
      map['reminder_time'] = Variable<int>(reminderTime);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || pendingOperation != null) {
      map['pending_operation'] = Variable<String>(pendingOperation);
    }
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      userId: Value(userId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      color: Value(color),
      icon: Value(icon),
      frequencyType: Value(frequencyType),
      frequencyDays: frequencyDays == null && nullToAbsent
          ? const Value.absent()
          : Value(frequencyDays),
      targetValue: Value(targetValue),
      unit: Value(unit),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      habitTime: habitTime == null && nullToAbsent
          ? const Value.absent()
          : Value(habitTime),
      reminderTime: reminderTime == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderTime),
      isArchived: Value(isArchived),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      pendingOperation: pendingOperation == null && nullToAbsent
          ? const Value.absent()
          : Value(pendingOperation),
    );
  }

  factory Habit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Habit(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      color: serializer.fromJson<int>(json['color']),
      icon: serializer.fromJson<String>(json['icon']),
      frequencyType: serializer.fromJson<String>(json['frequencyType']),
      frequencyDays: serializer.fromJson<String?>(json['frequencyDays']),
      targetValue: serializer.fromJson<double>(json['targetValue']),
      unit: serializer.fromJson<String>(json['unit']),
      type: serializer.fromJson<String?>(json['type']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      habitTime: serializer.fromJson<int?>(json['habitTime']),
      reminderTime: serializer.fromJson<int?>(json['reminderTime']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      pendingOperation: serializer.fromJson<String?>(json['pendingOperation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'color': serializer.toJson<int>(color),
      'icon': serializer.toJson<String>(icon),
      'frequencyType': serializer.toJson<String>(frequencyType),
      'frequencyDays': serializer.toJson<String?>(frequencyDays),
      'targetValue': serializer.toJson<double>(targetValue),
      'unit': serializer.toJson<String>(unit),
      'type': serializer.toJson<String?>(type),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'habitTime': serializer.toJson<int?>(habitTime),
      'reminderTime': serializer.toJson<int?>(reminderTime),
      'isArchived': serializer.toJson<bool>(isArchived),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'pendingOperation': serializer.toJson<String?>(pendingOperation),
    };
  }

  Habit copyWith({
    int? id,
    Value<String?> serverId = const Value.absent(),
    String? userId,
    String? title,
    Value<String?> description = const Value.absent(),
    int? color,
    String? icon,
    String? frequencyType,
    Value<String?> frequencyDays = const Value.absent(),
    double? targetValue,
    String? unit,
    Value<String?> type = const Value.absent(),
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    Value<int?> habitTime = const Value.absent(),
    Value<int?> reminderTime = const Value.absent(),
    bool? isArchived,
    DateTime? updatedAt,
    bool? isSynced,
    Value<String?> pendingOperation = const Value.absent(),
  }) => Habit(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    color: color ?? this.color,
    icon: icon ?? this.icon,
    frequencyType: frequencyType ?? this.frequencyType,
    frequencyDays: frequencyDays.present
        ? frequencyDays.value
        : this.frequencyDays,
    targetValue: targetValue ?? this.targetValue,
    unit: unit ?? this.unit,
    type: type.present ? type.value : this.type,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    habitTime: habitTime.present ? habitTime.value : this.habitTime,
    reminderTime: reminderTime.present ? reminderTime.value : this.reminderTime,
    isArchived: isArchived ?? this.isArchived,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
    pendingOperation: pendingOperation.present
        ? pendingOperation.value
        : this.pendingOperation,
  );
  Habit copyWithCompanion(HabitsCompanion data) {
    return Habit(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      frequencyType: data.frequencyType.present
          ? data.frequencyType.value
          : this.frequencyType,
      frequencyDays: data.frequencyDays.present
          ? data.frequencyDays.value
          : this.frequencyDays,
      targetValue: data.targetValue.present
          ? data.targetValue.value
          : this.targetValue,
      unit: data.unit.present ? data.unit.value : this.unit,
      type: data.type.present ? data.type.value : this.type,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      habitTime: data.habitTime.present ? data.habitTime.value : this.habitTime,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      pendingOperation: data.pendingOperation.present
          ? data.pendingOperation.value
          : this.pendingOperation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('frequencyType: $frequencyType, ')
          ..write('frequencyDays: $frequencyDays, ')
          ..write('targetValue: $targetValue, ')
          ..write('unit: $unit, ')
          ..write('type: $type, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('habitTime: $habitTime, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('isArchived: $isArchived, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('pendingOperation: $pendingOperation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    userId,
    title,
    description,
    color,
    icon,
    frequencyType,
    frequencyDays,
    targetValue,
    unit,
    type,
    startDate,
    endDate,
    habitTime,
    reminderTime,
    isArchived,
    updatedAt,
    isSynced,
    pendingOperation,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Habit &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.description == this.description &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.frequencyType == this.frequencyType &&
          other.frequencyDays == this.frequencyDays &&
          other.targetValue == this.targetValue &&
          other.unit == this.unit &&
          other.type == this.type &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.habitTime == this.habitTime &&
          other.reminderTime == this.reminderTime &&
          other.isArchived == this.isArchived &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.pendingOperation == this.pendingOperation);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<int> id;
  final Value<String?> serverId;
  final Value<String> userId;
  final Value<String> title;
  final Value<String?> description;
  final Value<int> color;
  final Value<String> icon;
  final Value<String> frequencyType;
  final Value<String?> frequencyDays;
  final Value<double> targetValue;
  final Value<String> unit;
  final Value<String?> type;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<int?> habitTime;
  final Value<int?> reminderTime;
  final Value<bool> isArchived;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<String?> pendingOperation;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.frequencyType = const Value.absent(),
    this.frequencyDays = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.unit = const Value.absent(),
    this.type = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.habitTime = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.pendingOperation = const Value.absent(),
  });
  HabitsCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    required String userId,
    required String title,
    this.description = const Value.absent(),
    required int color,
    required String icon,
    this.frequencyType = const Value.absent(),
    this.frequencyDays = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.unit = const Value.absent(),
    this.type = const Value.absent(),
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.habitTime = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
    this.pendingOperation = const Value.absent(),
  }) : userId = Value(userId),
       title = Value(title),
       color = Value(color),
       icon = Value(icon),
       startDate = Value(startDate),
       updatedAt = Value(updatedAt);
  static Insertable<Habit> custom({
    Expression<int>? id,
    Expression<String>? serverId,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? color,
    Expression<String>? icon,
    Expression<String>? frequencyType,
    Expression<String>? frequencyDays,
    Expression<double>? targetValue,
    Expression<String>? unit,
    Expression<String>? type,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? habitTime,
    Expression<int>? reminderTime,
    Expression<bool>? isArchived,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<String>? pendingOperation,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (frequencyType != null) 'frequency_type': frequencyType,
      if (frequencyDays != null) 'frequency_days': frequencyDays,
      if (targetValue != null) 'target_value': targetValue,
      if (unit != null) 'unit': unit,
      if (type != null) 'type': type,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (habitTime != null) 'habit_time': habitTime,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (isArchived != null) 'is_archived': isArchived,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (pendingOperation != null) 'pending_operation': pendingOperation,
    });
  }

  HabitsCompanion copyWith({
    Value<int>? id,
    Value<String?>? serverId,
    Value<String>? userId,
    Value<String>? title,
    Value<String?>? description,
    Value<int>? color,
    Value<String>? icon,
    Value<String>? frequencyType,
    Value<String?>? frequencyDays,
    Value<double>? targetValue,
    Value<String>? unit,
    Value<String?>? type,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<int?>? habitTime,
    Value<int?>? reminderTime,
    Value<bool>? isArchived,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<String?>? pendingOperation,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      frequencyType: frequencyType ?? this.frequencyType,
      frequencyDays: frequencyDays ?? this.frequencyDays,
      targetValue: targetValue ?? this.targetValue,
      unit: unit ?? this.unit,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      habitTime: habitTime ?? this.habitTime,
      reminderTime: reminderTime ?? this.reminderTime,
      isArchived: isArchived ?? this.isArchived,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      pendingOperation: pendingOperation ?? this.pendingOperation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (frequencyType.present) {
      map['frequency_type'] = Variable<String>(frequencyType.value);
    }
    if (frequencyDays.present) {
      map['frequency_days'] = Variable<String>(frequencyDays.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<double>(targetValue.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (habitTime.present) {
      map['habit_time'] = Variable<int>(habitTime.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<int>(reminderTime.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (pendingOperation.present) {
      map['pending_operation'] = Variable<String>(pendingOperation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('frequencyType: $frequencyType, ')
          ..write('frequencyDays: $frequencyDays, ')
          ..write('targetValue: $targetValue, ')
          ..write('unit: $unit, ')
          ..write('type: $type, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('habitTime: $habitTime, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('isArchived: $isArchived, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('pendingOperation: $pendingOperation')
          ..write(')'))
        .toString();
  }
}

class $HabitCompletionsTable extends HabitCompletions
    with TableInfo<$HabitCompletionsTable, HabitCompletion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitCompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<int> habitId = GeneratedColumn<int>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (id)',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pendingOperationMeta = const VerificationMeta(
    'pendingOperation',
  );
  @override
  late final GeneratedColumn<String> pendingOperation = GeneratedColumn<String>(
    'pending_operation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    habitId,
    userId,
    completedAt,
    value,
    note,
    updatedAt,
    isSynced,
    pendingOperation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_completions';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitCompletion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('pending_operation')) {
      context.handle(
        _pendingOperationMeta,
        pendingOperation.isAcceptableOrUnknown(
          data['pending_operation']!,
          _pendingOperationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitCompletion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitCompletion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}habit_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      pendingOperation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pending_operation'],
      ),
    );
  }

  @override
  $HabitCompletionsTable createAlias(String alias) {
    return $HabitCompletionsTable(attachedDatabase, alias);
  }
}

class HabitCompletion extends DataClass implements Insertable<HabitCompletion> {
  final int id;
  final String? serverId;
  final int habitId;
  final String userId;
  final DateTime completedAt;
  final double value;
  final String? note;
  final DateTime updatedAt;
  final bool isSynced;
  final String? pendingOperation;
  const HabitCompletion({
    required this.id,
    this.serverId,
    required this.habitId,
    required this.userId,
    required this.completedAt,
    required this.value,
    this.note,
    required this.updatedAt,
    required this.isSynced,
    this.pendingOperation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['habit_id'] = Variable<int>(habitId);
    map['user_id'] = Variable<String>(userId);
    map['completed_at'] = Variable<DateTime>(completedAt);
    map['value'] = Variable<double>(value);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || pendingOperation != null) {
      map['pending_operation'] = Variable<String>(pendingOperation);
    }
    return map;
  }

  HabitCompletionsCompanion toCompanion(bool nullToAbsent) {
    return HabitCompletionsCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      habitId: Value(habitId),
      userId: Value(userId),
      completedAt: Value(completedAt),
      value: Value(value),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      pendingOperation: pendingOperation == null && nullToAbsent
          ? const Value.absent()
          : Value(pendingOperation),
    );
  }

  factory HabitCompletion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitCompletion(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      habitId: serializer.fromJson<int>(json['habitId']),
      userId: serializer.fromJson<String>(json['userId']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      value: serializer.fromJson<double>(json['value']),
      note: serializer.fromJson<String?>(json['note']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      pendingOperation: serializer.fromJson<String?>(json['pendingOperation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'habitId': serializer.toJson<int>(habitId),
      'userId': serializer.toJson<String>(userId),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'value': serializer.toJson<double>(value),
      'note': serializer.toJson<String?>(note),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'pendingOperation': serializer.toJson<String?>(pendingOperation),
    };
  }

  HabitCompletion copyWith({
    int? id,
    Value<String?> serverId = const Value.absent(),
    int? habitId,
    String? userId,
    DateTime? completedAt,
    double? value,
    Value<String?> note = const Value.absent(),
    DateTime? updatedAt,
    bool? isSynced,
    Value<String?> pendingOperation = const Value.absent(),
  }) => HabitCompletion(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    habitId: habitId ?? this.habitId,
    userId: userId ?? this.userId,
    completedAt: completedAt ?? this.completedAt,
    value: value ?? this.value,
    note: note.present ? note.value : this.note,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
    pendingOperation: pendingOperation.present
        ? pendingOperation.value
        : this.pendingOperation,
  );
  HabitCompletion copyWithCompanion(HabitCompletionsCompanion data) {
    return HabitCompletion(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      userId: data.userId.present ? data.userId.value : this.userId,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      value: data.value.present ? data.value.value : this.value,
      note: data.note.present ? data.note.value : this.note,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      pendingOperation: data.pendingOperation.present
          ? data.pendingOperation.value
          : this.pendingOperation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitCompletion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('habitId: $habitId, ')
          ..write('userId: $userId, ')
          ..write('completedAt: $completedAt, ')
          ..write('value: $value, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('pendingOperation: $pendingOperation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    habitId,
    userId,
    completedAt,
    value,
    note,
    updatedAt,
    isSynced,
    pendingOperation,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitCompletion &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.habitId == this.habitId &&
          other.userId == this.userId &&
          other.completedAt == this.completedAt &&
          other.value == this.value &&
          other.note == this.note &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.pendingOperation == this.pendingOperation);
}

class HabitCompletionsCompanion extends UpdateCompanion<HabitCompletion> {
  final Value<int> id;
  final Value<String?> serverId;
  final Value<int> habitId;
  final Value<String> userId;
  final Value<DateTime> completedAt;
  final Value<double> value;
  final Value<String?> note;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<String?> pendingOperation;
  const HabitCompletionsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.habitId = const Value.absent(),
    this.userId = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.value = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.pendingOperation = const Value.absent(),
  });
  HabitCompletionsCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    required int habitId,
    required String userId,
    required DateTime completedAt,
    this.value = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
    this.pendingOperation = const Value.absent(),
  }) : habitId = Value(habitId),
       userId = Value(userId),
       completedAt = Value(completedAt),
       updatedAt = Value(updatedAt);
  static Insertable<HabitCompletion> custom({
    Expression<int>? id,
    Expression<String>? serverId,
    Expression<int>? habitId,
    Expression<String>? userId,
    Expression<DateTime>? completedAt,
    Expression<double>? value,
    Expression<String>? note,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<String>? pendingOperation,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (habitId != null) 'habit_id': habitId,
      if (userId != null) 'user_id': userId,
      if (completedAt != null) 'completed_at': completedAt,
      if (value != null) 'value': value,
      if (note != null) 'note': note,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (pendingOperation != null) 'pending_operation': pendingOperation,
    });
  }

  HabitCompletionsCompanion copyWith({
    Value<int>? id,
    Value<String?>? serverId,
    Value<int>? habitId,
    Value<String>? userId,
    Value<DateTime>? completedAt,
    Value<double>? value,
    Value<String?>? note,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<String?>? pendingOperation,
  }) {
    return HabitCompletionsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      habitId: habitId ?? this.habitId,
      userId: userId ?? this.userId,
      completedAt: completedAt ?? this.completedAt,
      value: value ?? this.value,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      pendingOperation: pendingOperation ?? this.pendingOperation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<int>(habitId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (pendingOperation.present) {
      map['pending_operation'] = Variable<String>(pendingOperation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitCompletionsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('habitId: $habitId, ')
          ..write('userId: $userId, ')
          ..write('completedAt: $completedAt, ')
          ..write('value: $value, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('pendingOperation: $pendingOperation')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $HabitCompletionsTable habitCompletions = $HabitCompletionsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    habits,
    habitCompletions,
  ];
}

typedef $$HabitsTableCreateCompanionBuilder =
    HabitsCompanion Function({
      Value<int> id,
      Value<String?> serverId,
      required String userId,
      required String title,
      Value<String?> description,
      required int color,
      required String icon,
      Value<String> frequencyType,
      Value<String?> frequencyDays,
      Value<double> targetValue,
      Value<String> unit,
      Value<String?> type,
      required DateTime startDate,
      Value<DateTime?> endDate,
      Value<int?> habitTime,
      Value<int?> reminderTime,
      Value<bool> isArchived,
      required DateTime updatedAt,
      Value<bool> isSynced,
      Value<String?> pendingOperation,
    });
typedef $$HabitsTableUpdateCompanionBuilder =
    HabitsCompanion Function({
      Value<int> id,
      Value<String?> serverId,
      Value<String> userId,
      Value<String> title,
      Value<String?> description,
      Value<int> color,
      Value<String> icon,
      Value<String> frequencyType,
      Value<String?> frequencyDays,
      Value<double> targetValue,
      Value<String> unit,
      Value<String?> type,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<int?> habitTime,
      Value<int?> reminderTime,
      Value<bool> isArchived,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<String?> pendingOperation,
    });

final class $$HabitsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitsTable, Habit> {
  $$HabitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HabitCompletionsTable, List<HabitCompletion>>
  _habitCompletionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.habitCompletions,
    aliasName: $_aliasNameGenerator(db.habits.id, db.habitCompletions.habitId),
  );

  $$HabitCompletionsTableProcessedTableManager get habitCompletionsRefs {
    final manager = $$HabitCompletionsTableTableManager(
      $_db,
      $_db.habitCompletions,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _habitCompletionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequencyType => $composableBuilder(
    column: $table.frequencyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequencyDays => $composableBuilder(
    column: $table.frequencyDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get habitTime => $composableBuilder(
    column: $table.habitTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pendingOperation => $composableBuilder(
    column: $table.pendingOperation,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> habitCompletionsRefs(
    Expression<bool> Function($$HabitCompletionsTableFilterComposer f) f,
  ) {
    final $$HabitCompletionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitCompletions,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitCompletionsTableFilterComposer(
            $db: $db,
            $table: $db.habitCompletions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequencyType => $composableBuilder(
    column: $table.frequencyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequencyDays => $composableBuilder(
    column: $table.frequencyDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get habitTime => $composableBuilder(
    column: $table.habitTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pendingOperation => $composableBuilder(
    column: $table.pendingOperation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get frequencyType => $composableBuilder(
    column: $table.frequencyType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frequencyDays => $composableBuilder(
    column: $table.frequencyDays,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get habitTime =>
      $composableBuilder(column: $table.habitTime, builder: (column) => column);

  GeneratedColumn<int> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get pendingOperation => $composableBuilder(
    column: $table.pendingOperation,
    builder: (column) => column,
  );

  Expression<T> habitCompletionsRefs<T extends Object>(
    Expression<T> Function($$HabitCompletionsTableAnnotationComposer a) f,
  ) {
    final $$HabitCompletionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitCompletions,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitCompletionsTableAnnotationComposer(
            $db: $db,
            $table: $db.habitCompletions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          Habit,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (Habit, $$HabitsTableReferences),
          Habit,
          PrefetchHooks Function({bool habitCompletionsRefs})
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<String> frequencyType = const Value.absent(),
                Value<String?> frequencyDays = const Value.absent(),
                Value<double> targetValue = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<int?> habitTime = const Value.absent(),
                Value<int?> reminderTime = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> pendingOperation = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                serverId: serverId,
                userId: userId,
                title: title,
                description: description,
                color: color,
                icon: icon,
                frequencyType: frequencyType,
                frequencyDays: frequencyDays,
                targetValue: targetValue,
                unit: unit,
                type: type,
                startDate: startDate,
                endDate: endDate,
                habitTime: habitTime,
                reminderTime: reminderTime,
                isArchived: isArchived,
                updatedAt: updatedAt,
                isSynced: isSynced,
                pendingOperation: pendingOperation,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                required String userId,
                required String title,
                Value<String?> description = const Value.absent(),
                required int color,
                required String icon,
                Value<String> frequencyType = const Value.absent(),
                Value<String?> frequencyDays = const Value.absent(),
                Value<double> targetValue = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String?> type = const Value.absent(),
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<int?> habitTime = const Value.absent(),
                Value<int?> reminderTime = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> isSynced = const Value.absent(),
                Value<String?> pendingOperation = const Value.absent(),
              }) => HabitsCompanion.insert(
                id: id,
                serverId: serverId,
                userId: userId,
                title: title,
                description: description,
                color: color,
                icon: icon,
                frequencyType: frequencyType,
                frequencyDays: frequencyDays,
                targetValue: targetValue,
                unit: unit,
                type: type,
                startDate: startDate,
                endDate: endDate,
                habitTime: habitTime,
                reminderTime: reminderTime,
                isArchived: isArchived,
                updatedAt: updatedAt,
                isSynced: isSynced,
                pendingOperation: pendingOperation,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$HabitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({habitCompletionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (habitCompletionsRefs) db.habitCompletions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (habitCompletionsRefs)
                    await $_getPrefetchedData<
                      Habit,
                      $HabitsTable,
                      HabitCompletion
                    >(
                      currentTable: table,
                      referencedTable: $$HabitsTableReferences
                          ._habitCompletionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$HabitsTableReferences(
                        db,
                        table,
                        p0,
                      ).habitCompletionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.habitId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      Habit,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (Habit, $$HabitsTableReferences),
      Habit,
      PrefetchHooks Function({bool habitCompletionsRefs})
    >;
typedef $$HabitCompletionsTableCreateCompanionBuilder =
    HabitCompletionsCompanion Function({
      Value<int> id,
      Value<String?> serverId,
      required int habitId,
      required String userId,
      required DateTime completedAt,
      Value<double> value,
      Value<String?> note,
      required DateTime updatedAt,
      Value<bool> isSynced,
      Value<String?> pendingOperation,
    });
typedef $$HabitCompletionsTableUpdateCompanionBuilder =
    HabitCompletionsCompanion Function({
      Value<int> id,
      Value<String?> serverId,
      Value<int> habitId,
      Value<String> userId,
      Value<DateTime> completedAt,
      Value<double> value,
      Value<String?> note,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<String?> pendingOperation,
    });

final class $$HabitCompletionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $HabitCompletionsTable, HabitCompletion> {
  $$HabitCompletionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HabitsTable _habitIdTable(_$AppDatabase db) => db.habits.createAlias(
    $_aliasNameGenerator(db.habitCompletions.habitId, db.habits.id),
  );

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<int>('habit_id')!;

    final manager = $$HabitsTableTableManager(
      $_db,
      $_db.habits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HabitCompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitCompletionsTable> {
  $$HabitCompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pendingOperation => $composableBuilder(
    column: $table.pendingOperation,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableFilterComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitCompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitCompletionsTable> {
  $$HabitCompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pendingOperation => $composableBuilder(
    column: $table.pendingOperation,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableOrderingComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitCompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitCompletionsTable> {
  $$HabitCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get pendingOperation => $composableBuilder(
    column: $table.pendingOperation,
    builder: (column) => column,
  );

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableAnnotationComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitCompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitCompletionsTable,
          HabitCompletion,
          $$HabitCompletionsTableFilterComposer,
          $$HabitCompletionsTableOrderingComposer,
          $$HabitCompletionsTableAnnotationComposer,
          $$HabitCompletionsTableCreateCompanionBuilder,
          $$HabitCompletionsTableUpdateCompanionBuilder,
          (HabitCompletion, $$HabitCompletionsTableReferences),
          HabitCompletion,
          PrefetchHooks Function({bool habitId})
        > {
  $$HabitCompletionsTableTableManager(
    _$AppDatabase db,
    $HabitCompletionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitCompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitCompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitCompletionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<int> habitId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> pendingOperation = const Value.absent(),
              }) => HabitCompletionsCompanion(
                id: id,
                serverId: serverId,
                habitId: habitId,
                userId: userId,
                completedAt: completedAt,
                value: value,
                note: note,
                updatedAt: updatedAt,
                isSynced: isSynced,
                pendingOperation: pendingOperation,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                required int habitId,
                required String userId,
                required DateTime completedAt,
                Value<double> value = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> isSynced = const Value.absent(),
                Value<String?> pendingOperation = const Value.absent(),
              }) => HabitCompletionsCompanion.insert(
                id: id,
                serverId: serverId,
                habitId: habitId,
                userId: userId,
                completedAt: completedAt,
                value: value,
                note: note,
                updatedAt: updatedAt,
                isSynced: isSynced,
                pendingOperation: pendingOperation,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HabitCompletionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
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
                    if (habitId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.habitId,
                                referencedTable:
                                    $$HabitCompletionsTableReferences
                                        ._habitIdTable(db),
                                referencedColumn:
                                    $$HabitCompletionsTableReferences
                                        ._habitIdTable(db)
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

typedef $$HabitCompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitCompletionsTable,
      HabitCompletion,
      $$HabitCompletionsTableFilterComposer,
      $$HabitCompletionsTableOrderingComposer,
      $$HabitCompletionsTableAnnotationComposer,
      $$HabitCompletionsTableCreateCompanionBuilder,
      $$HabitCompletionsTableUpdateCompanionBuilder,
      (HabitCompletion, $$HabitCompletionsTableReferences),
      HabitCompletion,
      PrefetchHooks Function({bool habitId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$HabitCompletionsTableTableManager get habitCompletions =>
      $$HabitCompletionsTableTableManager(_db, _db.habitCompletions);
}
