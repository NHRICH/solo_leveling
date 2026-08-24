import 'package:drift/drift.dart';

/// Stores configurable XP thresholds per level.
/// The user can edit these values in the settings screen.
class LevelConfigTable extends Table {
  @override
  String get tableName => 'level_config_table';

  IntColumn get level => integer()();

  IntColumn get xpRequired => integer()();

  @override
  Set<Column> get primaryKey => {level};
}