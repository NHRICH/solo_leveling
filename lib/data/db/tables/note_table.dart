import 'package:drift/drift.dart';

enum Priority { none, low, medium, high }

enum TaskDifficulty { easy, medium, hard }

/// How often a completed quest should respawn as a fresh instance.
/// [none] means it's a one-off quest that stays done until deleted.
enum Recurrence { none, daily, weekly, monthly }

class NoteTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 50)();

  TextColumn get description => text().withLength(max: 200).nullable()();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  DateTimeColumn get dueDate => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  IntColumn get priority =>
      intEnum<Priority>().withDefault(const Constant(0))();

  TextColumn get taskType => text().nullable()();

  IntColumn get difficulty =>
      intEnum<TaskDifficulty>().withDefault(const Constant(0))();

  // Solo Leveling: XP awarded for completing this quest
  IntColumn get xpValue => integer().withDefault(const Constant(10))();

  // Repeat schedule: when a repeating quest is completed, a fresh copy is
  // created for the next occurrence (until the quest is deleted).
  IntColumn get recurrence =>
      intEnum<Recurrence>().withDefault(const Constant(0))();
}
