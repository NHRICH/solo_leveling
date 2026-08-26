// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NoteTableTable extends NoteTable
    with TableInfo<$NoteTableTable, NoteTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
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
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Priority, int> priority =
      GeneratedColumn<int>(
        'priority',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<Priority>($NoteTableTable.$converterpriority);
  static const VerificationMeta _taskTypeMeta = const VerificationMeta(
    'taskType',
  );
  @override
  late final GeneratedColumn<String> taskType = GeneratedColumn<String>(
    'task_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskDifficulty, int> difficulty =
      GeneratedColumn<int>(
        'difficulty',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<TaskDifficulty>($NoteTableTable.$converterdifficulty);
  static const VerificationMeta _xpValueMeta = const VerificationMeta(
    'xpValue',
  );
  @override
  late final GeneratedColumn<int> xpValue = GeneratedColumn<int>(
    'xp_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Recurrence, int> recurrence =
      GeneratedColumn<int>(
        'recurrence',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<Recurrence>($NoteTableTable.$converterrecurrence);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    isCompleted,
    dueDate,
    createdAt,
    updatedAt,
    priority,
    taskType,
    difficulty,
    xpValue,
    recurrence,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('task_type')) {
      context.handle(
        _taskTypeMeta,
        taskType.isAcceptableOrUnknown(data['task_type']!, _taskTypeMeta),
      );
    }
    if (data.containsKey('xp_value')) {
      context.handle(
        _xpValueMeta,
        xpValue.isAcceptableOrUnknown(data['xp_value']!, _xpValueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      priority: $NoteTableTable.$converterpriority.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}priority'],
        )!,
      ),
      taskType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_type'],
      ),
      difficulty: $NoteTableTable.$converterdifficulty.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}difficulty'],
        )!,
      ),
      xpValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp_value'],
      )!,
      recurrence: $NoteTableTable.$converterrecurrence.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}recurrence'],
        )!,
      ),
    );
  }

  @override
  $NoteTableTable createAlias(String alias) {
    return $NoteTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Priority, int, int> $converterpriority =
      const EnumIndexConverter<Priority>(Priority.values);
  static JsonTypeConverter2<TaskDifficulty, int, int> $converterdifficulty =
      const EnumIndexConverter<TaskDifficulty>(TaskDifficulty.values);
  static JsonTypeConverter2<Recurrence, int, int> $converterrecurrence =
      const EnumIndexConverter<Recurrence>(Recurrence.values);
}

class NoteTableData extends DataClass implements Insertable<NoteTableData> {
  final int id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Priority priority;
  final String? taskType;
  final TaskDifficulty difficulty;
  final int xpValue;
  final Recurrence recurrence;
  const NoteTableData({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    required this.priority,
    this.taskType,
    required this.difficulty,
    required this.xpValue,
    required this.recurrence,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['priority'] = Variable<int>(
        $NoteTableTable.$converterpriority.toSql(priority),
      );
    }
    if (!nullToAbsent || taskType != null) {
      map['task_type'] = Variable<String>(taskType);
    }
    {
      map['difficulty'] = Variable<int>(
        $NoteTableTable.$converterdifficulty.toSql(difficulty),
      );
    }
    map['xp_value'] = Variable<int>(xpValue);
    {
      map['recurrence'] = Variable<int>(
        $NoteTableTable.$converterrecurrence.toSql(recurrence),
      );
    }
    return map;
  }

  NoteTableCompanion toCompanion(bool nullToAbsent) {
    return NoteTableCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isCompleted: Value(isCompleted),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      priority: Value(priority),
      taskType: taskType == null && nullToAbsent
          ? const Value.absent()
          : Value(taskType),
      difficulty: Value(difficulty),
      xpValue: Value(xpValue),
      recurrence: Value(recurrence),
    );
  }

  factory NoteTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      priority: $NoteTableTable.$converterpriority.fromJson(
        serializer.fromJson<int>(json['priority']),
      ),
      taskType: serializer.fromJson<String?>(json['taskType']),
      difficulty: $NoteTableTable.$converterdifficulty.fromJson(
        serializer.fromJson<int>(json['difficulty']),
      ),
      xpValue: serializer.fromJson<int>(json['xpValue']),
      recurrence: $NoteTableTable.$converterrecurrence.fromJson(
        serializer.fromJson<int>(json['recurrence']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'priority': serializer.toJson<int>(
        $NoteTableTable.$converterpriority.toJson(priority),
      ),
      'taskType': serializer.toJson<String?>(taskType),
      'difficulty': serializer.toJson<int>(
        $NoteTableTable.$converterdifficulty.toJson(difficulty),
      ),
      'xpValue': serializer.toJson<int>(xpValue),
      'recurrence': serializer.toJson<int>(
        $NoteTableTable.$converterrecurrence.toJson(recurrence),
      ),
    };
  }

  NoteTableData copyWith({
    int? id,
    String? title,
    Value<String?> description = const Value.absent(),
    bool? isCompleted,
    Value<DateTime?> dueDate = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Priority? priority,
    Value<String?> taskType = const Value.absent(),
    TaskDifficulty? difficulty,
    int? xpValue,
    Recurrence? recurrence,
  }) => NoteTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    isCompleted: isCompleted ?? this.isCompleted,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    priority: priority ?? this.priority,
    taskType: taskType.present ? taskType.value : this.taskType,
    difficulty: difficulty ?? this.difficulty,
    xpValue: xpValue ?? this.xpValue,
    recurrence: recurrence ?? this.recurrence,
  );
  NoteTableData copyWithCompanion(NoteTableCompanion data) {
    return NoteTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      priority: data.priority.present ? data.priority.value : this.priority,
      taskType: data.taskType.present ? data.taskType.value : this.taskType,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      xpValue: data.xpValue.present ? data.xpValue.value : this.xpValue,
      recurrence: data.recurrence.present
          ? data.recurrence.value
          : this.recurrence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('dueDate: $dueDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('priority: $priority, ')
          ..write('taskType: $taskType, ')
          ..write('difficulty: $difficulty, ')
          ..write('xpValue: $xpValue, ')
          ..write('recurrence: $recurrence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    isCompleted,
    dueDate,
    createdAt,
    updatedAt,
    priority,
    taskType,
    difficulty,
    xpValue,
    recurrence,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.isCompleted == this.isCompleted &&
          other.dueDate == this.dueDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.priority == this.priority &&
          other.taskType == this.taskType &&
          other.difficulty == this.difficulty &&
          other.xpValue == this.xpValue &&
          other.recurrence == this.recurrence);
}

class NoteTableCompanion extends UpdateCompanion<NoteTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<bool> isCompleted;
  final Value<DateTime?> dueDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<Priority> priority;
  final Value<String?> taskType;
  final Value<TaskDifficulty> difficulty;
  final Value<int> xpValue;
  final Value<Recurrence> recurrence;
  const NoteTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.priority = const Value.absent(),
    this.taskType = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.xpValue = const Value.absent(),
    this.recurrence = const Value.absent(),
  });
  NoteTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.priority = const Value.absent(),
    this.taskType = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.xpValue = const Value.absent(),
    this.recurrence = const Value.absent(),
  }) : title = Value(title);
  static Insertable<NoteTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<bool>? isCompleted,
    Expression<DateTime>? dueDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? priority,
    Expression<String>? taskType,
    Expression<int>? difficulty,
    Expression<int>? xpValue,
    Expression<int>? recurrence,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (dueDate != null) 'due_date': dueDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (priority != null) 'priority': priority,
      if (taskType != null) 'task_type': taskType,
      if (difficulty != null) 'difficulty': difficulty,
      if (xpValue != null) 'xp_value': xpValue,
      if (recurrence != null) 'recurrence': recurrence,
    });
  }

  NoteTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<bool>? isCompleted,
    Value<DateTime?>? dueDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<Priority>? priority,
    Value<String?>? taskType,
    Value<TaskDifficulty>? difficulty,
    Value<int>? xpValue,
    Value<Recurrence>? recurrence,
  }) {
    return NoteTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      priority: priority ?? this.priority,
      taskType: taskType ?? this.taskType,
      difficulty: difficulty ?? this.difficulty,
      xpValue: xpValue ?? this.xpValue,
      recurrence: recurrence ?? this.recurrence,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(
        $NoteTableTable.$converterpriority.toSql(priority.value),
      );
    }
    if (taskType.present) {
      map['task_type'] = Variable<String>(taskType.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(
        $NoteTableTable.$converterdifficulty.toSql(difficulty.value),
      );
    }
    if (xpValue.present) {
      map['xp_value'] = Variable<int>(xpValue.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<int>(
        $NoteTableTable.$converterrecurrence.toSql(recurrence.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('dueDate: $dueDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('priority: $priority, ')
          ..write('taskType: $taskType, ')
          ..write('difficulty: $difficulty, ')
          ..write('xpValue: $xpValue, ')
          ..write('recurrence: $recurrence')
          ..write(')'))
        .toString();
  }
}

class $TaskCategoriesTableTable extends TaskCategoriesTable
    with TableInfo<$TaskCategoriesTableTable, TaskCategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskCategoriesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, icon, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_categories_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskCategoriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskCategoriesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskCategoriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TaskCategoriesTableTable createAlias(String alias) {
    return $TaskCategoriesTableTable(attachedDatabase, alias);
  }
}

class TaskCategoriesTableData extends DataClass
    implements Insertable<TaskCategoriesTableData> {
  final int id;
  final String name;
  final String icon;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskCategoriesTableData({
    required this.id,
    required this.name,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaskCategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return TaskCategoriesTableCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskCategoriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskCategoriesTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskCategoriesTableData copyWith({
    int? id,
    String? name,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaskCategoriesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskCategoriesTableData copyWithCompanion(TaskCategoriesTableCompanion data) {
    return TaskCategoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskCategoriesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskCategoriesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaskCategoriesTableCompanion
    extends UpdateCompanion<TaskCategoriesTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TaskCategoriesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TaskCategoriesTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String icon,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       icon = Value(icon);
  static Insertable<TaskCategoriesTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TaskCategoriesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? icon,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TaskCategoriesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskCategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UserProgressTableTable extends UserProgressTable
    with TableInfo<$UserProgressTableTable, UserProgressTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProgressTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _totalPointsMeta = const VerificationMeta(
    'totalPoints',
  );
  @override
  late final GeneratedColumn<int> totalPoints = GeneratedColumn<int>(
    'total_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentLevelMeta = const VerificationMeta(
    'currentLevel',
  );
  @override
  late final GeneratedColumn<int> currentLevel = GeneratedColumn<int>(
    'current_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _currentStreakMeta = const VerificationMeta(
    'currentStreak',
  );
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
    'current_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<String> rank = GeneratedColumn<String>(
    'rank',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('E'),
  );
  static const VerificationMeta _totalTasksCompletedMeta =
      const VerificationMeta('totalTasksCompleted');
  @override
  late final GeneratedColumn<int> totalTasksCompleted = GeneratedColumn<int>(
    'total_tasks_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastCompletionDateMeta =
      const VerificationMeta('lastCompletionDate');
  @override
  late final GeneratedColumn<DateTime> lastCompletionDate =
      GeneratedColumn<DateTime>(
        'last_completion_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _weeklyStreakRewardClaimedMeta =
      const VerificationMeta('weeklyStreakRewardClaimed');
  @override
  late final GeneratedColumn<bool> weeklyStreakRewardClaimed =
      GeneratedColumn<bool>(
        'weekly_streak_reward_claimed',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("weekly_streak_reward_claimed" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    totalPoints,
    currentLevel,
    currentStreak,
    rank,
    totalTasksCompleted,
    lastCompletionDate,
    weeklyStreakRewardClaimed,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_progress_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProgressTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('total_points')) {
      context.handle(
        _totalPointsMeta,
        totalPoints.isAcceptableOrUnknown(
          data['total_points']!,
          _totalPointsMeta,
        ),
      );
    }
    if (data.containsKey('current_level')) {
      context.handle(
        _currentLevelMeta,
        currentLevel.isAcceptableOrUnknown(
          data['current_level']!,
          _currentLevelMeta,
        ),
      );
    }
    if (data.containsKey('current_streak')) {
      context.handle(
        _currentStreakMeta,
        currentStreak.isAcceptableOrUnknown(
          data['current_streak']!,
          _currentStreakMeta,
        ),
      );
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    }
    if (data.containsKey('total_tasks_completed')) {
      context.handle(
        _totalTasksCompletedMeta,
        totalTasksCompleted.isAcceptableOrUnknown(
          data['total_tasks_completed']!,
          _totalTasksCompletedMeta,
        ),
      );
    }
    if (data.containsKey('last_completion_date')) {
      context.handle(
        _lastCompletionDateMeta,
        lastCompletionDate.isAcceptableOrUnknown(
          data['last_completion_date']!,
          _lastCompletionDateMeta,
        ),
      );
    }
    if (data.containsKey('weekly_streak_reward_claimed')) {
      context.handle(
        _weeklyStreakRewardClaimedMeta,
        weeklyStreakRewardClaimed.isAcceptableOrUnknown(
          data['weekly_streak_reward_claimed']!,
          _weeklyStreakRewardClaimedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProgressTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProgressTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      totalPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_points'],
      )!,
      currentLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_level'],
      )!,
      currentStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_streak'],
      )!,
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rank'],
      )!,
      totalTasksCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_tasks_completed'],
      )!,
      lastCompletionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_completion_date'],
      ),
      weeklyStreakRewardClaimed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}weekly_streak_reward_claimed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserProgressTableTable createAlias(String alias) {
    return $UserProgressTableTable(attachedDatabase, alias);
  }
}

class UserProgressTableData extends DataClass
    implements Insertable<UserProgressTableData> {
  final int id;
  final int totalPoints;
  final int currentLevel;
  final int currentStreak;
  final String rank;
  final int totalTasksCompleted;
  final DateTime? lastCompletionDate;
  final bool weeklyStreakRewardClaimed;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserProgressTableData({
    required this.id,
    required this.totalPoints,
    required this.currentLevel,
    required this.currentStreak,
    required this.rank,
    required this.totalTasksCompleted,
    this.lastCompletionDate,
    required this.weeklyStreakRewardClaimed,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['total_points'] = Variable<int>(totalPoints);
    map['current_level'] = Variable<int>(currentLevel);
    map['current_streak'] = Variable<int>(currentStreak);
    map['rank'] = Variable<String>(rank);
    map['total_tasks_completed'] = Variable<int>(totalTasksCompleted);
    if (!nullToAbsent || lastCompletionDate != null) {
      map['last_completion_date'] = Variable<DateTime>(lastCompletionDate);
    }
    map['weekly_streak_reward_claimed'] = Variable<bool>(
      weeklyStreakRewardClaimed,
    );
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserProgressTableCompanion toCompanion(bool nullToAbsent) {
    return UserProgressTableCompanion(
      id: Value(id),
      totalPoints: Value(totalPoints),
      currentLevel: Value(currentLevel),
      currentStreak: Value(currentStreak),
      rank: Value(rank),
      totalTasksCompleted: Value(totalTasksCompleted),
      lastCompletionDate: lastCompletionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletionDate),
      weeklyStreakRewardClaimed: Value(weeklyStreakRewardClaimed),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserProgressTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProgressTableData(
      id: serializer.fromJson<int>(json['id']),
      totalPoints: serializer.fromJson<int>(json['totalPoints']),
      currentLevel: serializer.fromJson<int>(json['currentLevel']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      rank: serializer.fromJson<String>(json['rank']),
      totalTasksCompleted: serializer.fromJson<int>(
        json['totalTasksCompleted'],
      ),
      lastCompletionDate: serializer.fromJson<DateTime?>(
        json['lastCompletionDate'],
      ),
      weeklyStreakRewardClaimed: serializer.fromJson<bool>(
        json['weeklyStreakRewardClaimed'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'totalPoints': serializer.toJson<int>(totalPoints),
      'currentLevel': serializer.toJson<int>(currentLevel),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'rank': serializer.toJson<String>(rank),
      'totalTasksCompleted': serializer.toJson<int>(totalTasksCompleted),
      'lastCompletionDate': serializer.toJson<DateTime?>(lastCompletionDate),
      'weeklyStreakRewardClaimed': serializer.toJson<bool>(
        weeklyStreakRewardClaimed,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserProgressTableData copyWith({
    int? id,
    int? totalPoints,
    int? currentLevel,
    int? currentStreak,
    String? rank,
    int? totalTasksCompleted,
    Value<DateTime?> lastCompletionDate = const Value.absent(),
    bool? weeklyStreakRewardClaimed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserProgressTableData(
    id: id ?? this.id,
    totalPoints: totalPoints ?? this.totalPoints,
    currentLevel: currentLevel ?? this.currentLevel,
    currentStreak: currentStreak ?? this.currentStreak,
    rank: rank ?? this.rank,
    totalTasksCompleted: totalTasksCompleted ?? this.totalTasksCompleted,
    lastCompletionDate: lastCompletionDate.present
        ? lastCompletionDate.value
        : this.lastCompletionDate,
    weeklyStreakRewardClaimed:
        weeklyStreakRewardClaimed ?? this.weeklyStreakRewardClaimed,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserProgressTableData copyWithCompanion(UserProgressTableCompanion data) {
    return UserProgressTableData(
      id: data.id.present ? data.id.value : this.id,
      totalPoints: data.totalPoints.present
          ? data.totalPoints.value
          : this.totalPoints,
      currentLevel: data.currentLevel.present
          ? data.currentLevel.value
          : this.currentLevel,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      rank: data.rank.present ? data.rank.value : this.rank,
      totalTasksCompleted: data.totalTasksCompleted.present
          ? data.totalTasksCompleted.value
          : this.totalTasksCompleted,
      lastCompletionDate: data.lastCompletionDate.present
          ? data.lastCompletionDate.value
          : this.lastCompletionDate,
      weeklyStreakRewardClaimed: data.weeklyStreakRewardClaimed.present
          ? data.weeklyStreakRewardClaimed.value
          : this.weeklyStreakRewardClaimed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressTableData(')
          ..write('id: $id, ')
          ..write('totalPoints: $totalPoints, ')
          ..write('currentLevel: $currentLevel, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('rank: $rank, ')
          ..write('totalTasksCompleted: $totalTasksCompleted, ')
          ..write('lastCompletionDate: $lastCompletionDate, ')
          ..write('weeklyStreakRewardClaimed: $weeklyStreakRewardClaimed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    totalPoints,
    currentLevel,
    currentStreak,
    rank,
    totalTasksCompleted,
    lastCompletionDate,
    weeklyStreakRewardClaimed,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProgressTableData &&
          other.id == this.id &&
          other.totalPoints == this.totalPoints &&
          other.currentLevel == this.currentLevel &&
          other.currentStreak == this.currentStreak &&
          other.rank == this.rank &&
          other.totalTasksCompleted == this.totalTasksCompleted &&
          other.lastCompletionDate == this.lastCompletionDate &&
          other.weeklyStreakRewardClaimed == this.weeklyStreakRewardClaimed &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserProgressTableCompanion
    extends UpdateCompanion<UserProgressTableData> {
  final Value<int> id;
  final Value<int> totalPoints;
  final Value<int> currentLevel;
  final Value<int> currentStreak;
  final Value<String> rank;
  final Value<int> totalTasksCompleted;
  final Value<DateTime?> lastCompletionDate;
  final Value<bool> weeklyStreakRewardClaimed;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UserProgressTableCompanion({
    this.id = const Value.absent(),
    this.totalPoints = const Value.absent(),
    this.currentLevel = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.rank = const Value.absent(),
    this.totalTasksCompleted = const Value.absent(),
    this.lastCompletionDate = const Value.absent(),
    this.weeklyStreakRewardClaimed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserProgressTableCompanion.insert({
    this.id = const Value.absent(),
    this.totalPoints = const Value.absent(),
    this.currentLevel = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.rank = const Value.absent(),
    this.totalTasksCompleted = const Value.absent(),
    this.lastCompletionDate = const Value.absent(),
    this.weeklyStreakRewardClaimed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<UserProgressTableData> custom({
    Expression<int>? id,
    Expression<int>? totalPoints,
    Expression<int>? currentLevel,
    Expression<int>? currentStreak,
    Expression<String>? rank,
    Expression<int>? totalTasksCompleted,
    Expression<DateTime>? lastCompletionDate,
    Expression<bool>? weeklyStreakRewardClaimed,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (totalPoints != null) 'total_points': totalPoints,
      if (currentLevel != null) 'current_level': currentLevel,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (rank != null) 'rank': rank,
      if (totalTasksCompleted != null)
        'total_tasks_completed': totalTasksCompleted,
      if (lastCompletionDate != null)
        'last_completion_date': lastCompletionDate,
      if (weeklyStreakRewardClaimed != null)
        'weekly_streak_reward_claimed': weeklyStreakRewardClaimed,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserProgressTableCompanion copyWith({
    Value<int>? id,
    Value<int>? totalPoints,
    Value<int>? currentLevel,
    Value<int>? currentStreak,
    Value<String>? rank,
    Value<int>? totalTasksCompleted,
    Value<DateTime?>? lastCompletionDate,
    Value<bool>? weeklyStreakRewardClaimed,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return UserProgressTableCompanion(
      id: id ?? this.id,
      totalPoints: totalPoints ?? this.totalPoints,
      currentLevel: currentLevel ?? this.currentLevel,
      currentStreak: currentStreak ?? this.currentStreak,
      rank: rank ?? this.rank,
      totalTasksCompleted: totalTasksCompleted ?? this.totalTasksCompleted,
      lastCompletionDate: lastCompletionDate ?? this.lastCompletionDate,
      weeklyStreakRewardClaimed:
          weeklyStreakRewardClaimed ?? this.weeklyStreakRewardClaimed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (totalPoints.present) {
      map['total_points'] = Variable<int>(totalPoints.value);
    }
    if (currentLevel.present) {
      map['current_level'] = Variable<int>(currentLevel.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (rank.present) {
      map['rank'] = Variable<String>(rank.value);
    }
    if (totalTasksCompleted.present) {
      map['total_tasks_completed'] = Variable<int>(totalTasksCompleted.value);
    }
    if (lastCompletionDate.present) {
      map['last_completion_date'] = Variable<DateTime>(
        lastCompletionDate.value,
      );
    }
    if (weeklyStreakRewardClaimed.present) {
      map['weekly_streak_reward_claimed'] = Variable<bool>(
        weeklyStreakRewardClaimed.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressTableCompanion(')
          ..write('id: $id, ')
          ..write('totalPoints: $totalPoints, ')
          ..write('currentLevel: $currentLevel, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('rank: $rank, ')
          ..write('totalTasksCompleted: $totalTasksCompleted, ')
          ..write('lastCompletionDate: $lastCompletionDate, ')
          ..write('weeklyStreakRewardClaimed: $weeklyStreakRewardClaimed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $LevelConfigTableTable extends LevelConfigTable
    with TableInfo<$LevelConfigTableTable, LevelConfigTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LevelConfigTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _xpRequiredMeta = const VerificationMeta(
    'xpRequired',
  );
  @override
  late final GeneratedColumn<int> xpRequired = GeneratedColumn<int>(
    'xp_required',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [level, xpRequired];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'level_config_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LevelConfigTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('xp_required')) {
      context.handle(
        _xpRequiredMeta,
        xpRequired.isAcceptableOrUnknown(data['xp_required']!, _xpRequiredMeta),
      );
    } else if (isInserting) {
      context.missing(_xpRequiredMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {level};
  @override
  LevelConfigTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LevelConfigTableData(
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      xpRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp_required'],
      )!,
    );
  }

  @override
  $LevelConfigTableTable createAlias(String alias) {
    return $LevelConfigTableTable(attachedDatabase, alias);
  }
}

class LevelConfigTableData extends DataClass
    implements Insertable<LevelConfigTableData> {
  final int level;
  final int xpRequired;
  const LevelConfigTableData({required this.level, required this.xpRequired});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['level'] = Variable<int>(level);
    map['xp_required'] = Variable<int>(xpRequired);
    return map;
  }

  LevelConfigTableCompanion toCompanion(bool nullToAbsent) {
    return LevelConfigTableCompanion(
      level: Value(level),
      xpRequired: Value(xpRequired),
    );
  }

  factory LevelConfigTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LevelConfigTableData(
      level: serializer.fromJson<int>(json['level']),
      xpRequired: serializer.fromJson<int>(json['xpRequired']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'level': serializer.toJson<int>(level),
      'xpRequired': serializer.toJson<int>(xpRequired),
    };
  }

  LevelConfigTableData copyWith({int? level, int? xpRequired}) =>
      LevelConfigTableData(
        level: level ?? this.level,
        xpRequired: xpRequired ?? this.xpRequired,
      );
  LevelConfigTableData copyWithCompanion(LevelConfigTableCompanion data) {
    return LevelConfigTableData(
      level: data.level.present ? data.level.value : this.level,
      xpRequired: data.xpRequired.present
          ? data.xpRequired.value
          : this.xpRequired,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LevelConfigTableData(')
          ..write('level: $level, ')
          ..write('xpRequired: $xpRequired')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(level, xpRequired);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LevelConfigTableData &&
          other.level == this.level &&
          other.xpRequired == this.xpRequired);
}

class LevelConfigTableCompanion extends UpdateCompanion<LevelConfigTableData> {
  final Value<int> level;
  final Value<int> xpRequired;
  const LevelConfigTableCompanion({
    this.level = const Value.absent(),
    this.xpRequired = const Value.absent(),
  });
  LevelConfigTableCompanion.insert({
    this.level = const Value.absent(),
    required int xpRequired,
  }) : xpRequired = Value(xpRequired);
  static Insertable<LevelConfigTableData> custom({
    Expression<int>? level,
    Expression<int>? xpRequired,
  }) {
    return RawValuesInsertable({
      if (level != null) 'level': level,
      if (xpRequired != null) 'xp_required': xpRequired,
    });
  }

  LevelConfigTableCompanion copyWith({
    Value<int>? level,
    Value<int>? xpRequired,
  }) {
    return LevelConfigTableCompanion(
      level: level ?? this.level,
      xpRequired: xpRequired ?? this.xpRequired,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (xpRequired.present) {
      map['xp_required'] = Variable<int>(xpRequired.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LevelConfigTableCompanion(')
          ..write('level: $level, ')
          ..write('xpRequired: $xpRequired')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NoteTableTable noteTable = $NoteTableTable(this);
  late final $TaskCategoriesTableTable taskCategoriesTable =
      $TaskCategoriesTableTable(this);
  late final $UserProgressTableTable userProgressTable =
      $UserProgressTableTable(this);
  late final $LevelConfigTableTable levelConfigTable = $LevelConfigTableTable(
    this,
  );
  late final NoteDao noteDao = NoteDao(this as AppDatabase);
  late final TaskCategoryDao taskCategoryDao = TaskCategoryDao(
    this as AppDatabase,
  );
  late final UserProgressDao userProgressDao = UserProgressDao(
    this as AppDatabase,
  );
  late final LevelConfigDao levelConfigDao = LevelConfigDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    noteTable,
    taskCategoriesTable,
    userProgressTable,
    levelConfigTable,
  ];
}

typedef $$NoteTableTableCreateCompanionBuilder =
    NoteTableCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> description,
      Value<bool> isCompleted,
      Value<DateTime?> dueDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<Priority> priority,
      Value<String?> taskType,
      Value<TaskDifficulty> difficulty,
      Value<int> xpValue,
      Value<Recurrence> recurrence,
    });
typedef $$NoteTableTableUpdateCompanionBuilder =
    NoteTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> description,
      Value<bool> isCompleted,
      Value<DateTime?> dueDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<Priority> priority,
      Value<String?> taskType,
      Value<TaskDifficulty> difficulty,
      Value<int> xpValue,
      Value<Recurrence> recurrence,
    });

class $$NoteTableTableFilterComposer
    extends Composer<_$AppDatabase, $NoteTableTable> {
  $$NoteTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Priority, Priority, int> get priority =>
      $composableBuilder(
        column: $table.priority,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskDifficulty, TaskDifficulty, int>
  get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get xpValue => $composableBuilder(
    column: $table.xpValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Recurrence, Recurrence, int> get recurrence =>
      $composableBuilder(
        column: $table.recurrence,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$NoteTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteTableTable> {
  $$NoteTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xpValue => $composableBuilder(
    column: $table.xpValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NoteTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteTableTable> {
  $$NoteTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Priority, int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get taskType =>
      $composableBuilder(column: $table.taskType, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TaskDifficulty, int> get difficulty =>
      $composableBuilder(
        column: $table.difficulty,
        builder: (column) => column,
      );

  GeneratedColumn<int> get xpValue =>
      $composableBuilder(column: $table.xpValue, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Recurrence, int> get recurrence =>
      $composableBuilder(
        column: $table.recurrence,
        builder: (column) => column,
      );
}

class $$NoteTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NoteTableTable,
          NoteTableData,
          $$NoteTableTableFilterComposer,
          $$NoteTableTableOrderingComposer,
          $$NoteTableTableAnnotationComposer,
          $$NoteTableTableCreateCompanionBuilder,
          $$NoteTableTableUpdateCompanionBuilder,
          (
            NoteTableData,
            BaseReferences<_$AppDatabase, $NoteTableTable, NoteTableData>,
          ),
          NoteTableData,
          PrefetchHooks Function()
        > {
  $$NoteTableTableTableManager(_$AppDatabase db, $NoteTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<Priority> priority = const Value.absent(),
                Value<String?> taskType = const Value.absent(),
                Value<TaskDifficulty> difficulty = const Value.absent(),
                Value<int> xpValue = const Value.absent(),
                Value<Recurrence> recurrence = const Value.absent(),
              }) => NoteTableCompanion(
                id: id,
                title: title,
                description: description,
                isCompleted: isCompleted,
                dueDate: dueDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                priority: priority,
                taskType: taskType,
                difficulty: difficulty,
                xpValue: xpValue,
                recurrence: recurrence,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<Priority> priority = const Value.absent(),
                Value<String?> taskType = const Value.absent(),
                Value<TaskDifficulty> difficulty = const Value.absent(),
                Value<int> xpValue = const Value.absent(),
                Value<Recurrence> recurrence = const Value.absent(),
              }) => NoteTableCompanion.insert(
                id: id,
                title: title,
                description: description,
                isCompleted: isCompleted,
                dueDate: dueDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                priority: priority,
                taskType: taskType,
                difficulty: difficulty,
                xpValue: xpValue,
                recurrence: recurrence,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NoteTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NoteTableTable,
      NoteTableData,
      $$NoteTableTableFilterComposer,
      $$NoteTableTableOrderingComposer,
      $$NoteTableTableAnnotationComposer,
      $$NoteTableTableCreateCompanionBuilder,
      $$NoteTableTableUpdateCompanionBuilder,
      (
        NoteTableData,
        BaseReferences<_$AppDatabase, $NoteTableTable, NoteTableData>,
      ),
      NoteTableData,
      PrefetchHooks Function()
    >;
typedef $$TaskCategoriesTableTableCreateCompanionBuilder =
    TaskCategoriesTableCompanion Function({
      Value<int> id,
      required String name,
      required String icon,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$TaskCategoriesTableTableUpdateCompanionBuilder =
    TaskCategoriesTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> icon,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$TaskCategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $TaskCategoriesTableTable> {
  $$TaskCategoriesTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskCategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskCategoriesTableTable> {
  $$TaskCategoriesTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskCategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskCategoriesTableTable> {
  $$TaskCategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TaskCategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskCategoriesTableTable,
          TaskCategoriesTableData,
          $$TaskCategoriesTableTableFilterComposer,
          $$TaskCategoriesTableTableOrderingComposer,
          $$TaskCategoriesTableTableAnnotationComposer,
          $$TaskCategoriesTableTableCreateCompanionBuilder,
          $$TaskCategoriesTableTableUpdateCompanionBuilder,
          (
            TaskCategoriesTableData,
            BaseReferences<
              _$AppDatabase,
              $TaskCategoriesTableTable,
              TaskCategoriesTableData
            >,
          ),
          TaskCategoriesTableData,
          PrefetchHooks Function()
        > {
  $$TaskCategoriesTableTableTableManager(
    _$AppDatabase db,
    $TaskCategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskCategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskCategoriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TaskCategoriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TaskCategoriesTableCompanion(
                id: id,
                name: name,
                icon: icon,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String icon,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TaskCategoriesTableCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskCategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskCategoriesTableTable,
      TaskCategoriesTableData,
      $$TaskCategoriesTableTableFilterComposer,
      $$TaskCategoriesTableTableOrderingComposer,
      $$TaskCategoriesTableTableAnnotationComposer,
      $$TaskCategoriesTableTableCreateCompanionBuilder,
      $$TaskCategoriesTableTableUpdateCompanionBuilder,
      (
        TaskCategoriesTableData,
        BaseReferences<
          _$AppDatabase,
          $TaskCategoriesTableTable,
          TaskCategoriesTableData
        >,
      ),
      TaskCategoriesTableData,
      PrefetchHooks Function()
    >;
typedef $$UserProgressTableTableCreateCompanionBuilder =
    UserProgressTableCompanion Function({
      Value<int> id,
      Value<int> totalPoints,
      Value<int> currentLevel,
      Value<int> currentStreak,
      Value<String> rank,
      Value<int> totalTasksCompleted,
      Value<DateTime?> lastCompletionDate,
      Value<bool> weeklyStreakRewardClaimed,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$UserProgressTableTableUpdateCompanionBuilder =
    UserProgressTableCompanion Function({
      Value<int> id,
      Value<int> totalPoints,
      Value<int> currentLevel,
      Value<int> currentStreak,
      Value<String> rank,
      Value<int> totalTasksCompleted,
      Value<DateTime?> lastCompletionDate,
      Value<bool> weeklyStreakRewardClaimed,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$UserProgressTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserProgressTableTable> {
  $$UserProgressTableTableFilterComposer({
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

  ColumnFilters<int> get totalPoints => $composableBuilder(
    column: $table.totalPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentLevel => $composableBuilder(
    column: $table.currentLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalTasksCompleted => $composableBuilder(
    column: $table.totalTasksCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCompletionDate => $composableBuilder(
    column: $table.lastCompletionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get weeklyStreakRewardClaimed => $composableBuilder(
    column: $table.weeklyStreakRewardClaimed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProgressTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProgressTableTable> {
  $$UserProgressTableTableOrderingComposer({
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

  ColumnOrderings<int> get totalPoints => $composableBuilder(
    column: $table.totalPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentLevel => $composableBuilder(
    column: $table.currentLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalTasksCompleted => $composableBuilder(
    column: $table.totalTasksCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCompletionDate => $composableBuilder(
    column: $table.lastCompletionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get weeklyStreakRewardClaimed => $composableBuilder(
    column: $table.weeklyStreakRewardClaimed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProgressTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProgressTableTable> {
  $$UserProgressTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get totalPoints => $composableBuilder(
    column: $table.totalPoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentLevel => $composableBuilder(
    column: $table.currentLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumn<int> get totalTasksCompleted => $composableBuilder(
    column: $table.totalTasksCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastCompletionDate => $composableBuilder(
    column: $table.lastCompletionDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get weeklyStreakRewardClaimed => $composableBuilder(
    column: $table.weeklyStreakRewardClaimed,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserProgressTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProgressTableTable,
          UserProgressTableData,
          $$UserProgressTableTableFilterComposer,
          $$UserProgressTableTableOrderingComposer,
          $$UserProgressTableTableAnnotationComposer,
          $$UserProgressTableTableCreateCompanionBuilder,
          $$UserProgressTableTableUpdateCompanionBuilder,
          (
            UserProgressTableData,
            BaseReferences<
              _$AppDatabase,
              $UserProgressTableTable,
              UserProgressTableData
            >,
          ),
          UserProgressTableData,
          PrefetchHooks Function()
        > {
  $$UserProgressTableTableTableManager(
    _$AppDatabase db,
    $UserProgressTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProgressTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProgressTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProgressTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> totalPoints = const Value.absent(),
                Value<int> currentLevel = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<String> rank = const Value.absent(),
                Value<int> totalTasksCompleted = const Value.absent(),
                Value<DateTime?> lastCompletionDate = const Value.absent(),
                Value<bool> weeklyStreakRewardClaimed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserProgressTableCompanion(
                id: id,
                totalPoints: totalPoints,
                currentLevel: currentLevel,
                currentStreak: currentStreak,
                rank: rank,
                totalTasksCompleted: totalTasksCompleted,
                lastCompletionDate: lastCompletionDate,
                weeklyStreakRewardClaimed: weeklyStreakRewardClaimed,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> totalPoints = const Value.absent(),
                Value<int> currentLevel = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<String> rank = const Value.absent(),
                Value<int> totalTasksCompleted = const Value.absent(),
                Value<DateTime?> lastCompletionDate = const Value.absent(),
                Value<bool> weeklyStreakRewardClaimed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserProgressTableCompanion.insert(
                id: id,
                totalPoints: totalPoints,
                currentLevel: currentLevel,
                currentStreak: currentStreak,
                rank: rank,
                totalTasksCompleted: totalTasksCompleted,
                lastCompletionDate: lastCompletionDate,
                weeklyStreakRewardClaimed: weeklyStreakRewardClaimed,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProgressTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProgressTableTable,
      UserProgressTableData,
      $$UserProgressTableTableFilterComposer,
      $$UserProgressTableTableOrderingComposer,
      $$UserProgressTableTableAnnotationComposer,
      $$UserProgressTableTableCreateCompanionBuilder,
      $$UserProgressTableTableUpdateCompanionBuilder,
      (
        UserProgressTableData,
        BaseReferences<
          _$AppDatabase,
          $UserProgressTableTable,
          UserProgressTableData
        >,
      ),
      UserProgressTableData,
      PrefetchHooks Function()
    >;
typedef $$LevelConfigTableTableCreateCompanionBuilder =
    LevelConfigTableCompanion Function({
      Value<int> level,
      required int xpRequired,
    });
typedef $$LevelConfigTableTableUpdateCompanionBuilder =
    LevelConfigTableCompanion Function({
      Value<int> level,
      Value<int> xpRequired,
    });

class $$LevelConfigTableTableFilterComposer
    extends Composer<_$AppDatabase, $LevelConfigTableTable> {
  $$LevelConfigTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xpRequired => $composableBuilder(
    column: $table.xpRequired,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LevelConfigTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LevelConfigTableTable> {
  $$LevelConfigTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xpRequired => $composableBuilder(
    column: $table.xpRequired,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LevelConfigTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LevelConfigTableTable> {
  $$LevelConfigTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get xpRequired => $composableBuilder(
    column: $table.xpRequired,
    builder: (column) => column,
  );
}

class $$LevelConfigTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LevelConfigTableTable,
          LevelConfigTableData,
          $$LevelConfigTableTableFilterComposer,
          $$LevelConfigTableTableOrderingComposer,
          $$LevelConfigTableTableAnnotationComposer,
          $$LevelConfigTableTableCreateCompanionBuilder,
          $$LevelConfigTableTableUpdateCompanionBuilder,
          (
            LevelConfigTableData,
            BaseReferences<
              _$AppDatabase,
              $LevelConfigTableTable,
              LevelConfigTableData
            >,
          ),
          LevelConfigTableData,
          PrefetchHooks Function()
        > {
  $$LevelConfigTableTableTableManager(
    _$AppDatabase db,
    $LevelConfigTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LevelConfigTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LevelConfigTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LevelConfigTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> level = const Value.absent(),
                Value<int> xpRequired = const Value.absent(),
              }) => LevelConfigTableCompanion(
                level: level,
                xpRequired: xpRequired,
              ),
          createCompanionCallback:
              ({
                Value<int> level = const Value.absent(),
                required int xpRequired,
              }) => LevelConfigTableCompanion.insert(
                level: level,
                xpRequired: xpRequired,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LevelConfigTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LevelConfigTableTable,
      LevelConfigTableData,
      $$LevelConfigTableTableFilterComposer,
      $$LevelConfigTableTableOrderingComposer,
      $$LevelConfigTableTableAnnotationComposer,
      $$LevelConfigTableTableCreateCompanionBuilder,
      $$LevelConfigTableTableUpdateCompanionBuilder,
      (
        LevelConfigTableData,
        BaseReferences<
          _$AppDatabase,
          $LevelConfigTableTable,
          LevelConfigTableData
        >,
      ),
      LevelConfigTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NoteTableTableTableManager get noteTable =>
      $$NoteTableTableTableManager(_db, _db.noteTable);
  $$TaskCategoriesTableTableTableManager get taskCategoriesTable =>
      $$TaskCategoriesTableTableTableManager(_db, _db.taskCategoriesTable);
  $$UserProgressTableTableTableManager get userProgressTable =>
      $$UserProgressTableTableTableManager(_db, _db.userProgressTable);
  $$LevelConfigTableTableTableManager get levelConfigTable =>
      $$LevelConfigTableTableTableManager(_db, _db.levelConfigTable);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabaseProvider)
final appDatabaseProviderProvider = AppDatabaseProviderProvider._();

final class AppDatabaseProviderProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProviderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseProviderHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabaseProvider(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseProviderHash() =>
    r'd49eeca4b03dfd2b0de1d300e6f44dcaf6d85055';
