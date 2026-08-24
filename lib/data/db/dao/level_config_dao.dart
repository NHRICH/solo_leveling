import 'package:drift/drift.dart';
import 'package:solo_leveling/data/db/app_database.dart';
import 'package:solo_leveling/data/db/tables/level_config_table.dart';

part 'level_config_dao.g.dart';

@DriftAccessor(tables: [LevelConfigTable])
class LevelConfigDao extends DatabaseAccessor<AppDatabase>
    with _$LevelConfigDaoMixin {
  LevelConfigDao(super.db);

  /// Get XP requirement for a specific level.
  Future<LevelConfigTableData?> getForLevel(int level) {
    return (select(levelConfigTable)
          ..where((t) => t.level.equals(level)))
        .getSingleOrNull();
  }

  /// Get all level configs sorted by level.
  Future<List<LevelConfigTableData>> getAll() {
    return (select(levelConfigTable)
          ..orderBy([(t) => OrderingTerm(expression: t.level)]))
        .get();
  }

  /// Upsert a level config.
  Future<void> upsert(int level, int xpRequired) {
    return into(levelConfigTable).insertOnConflictUpdate(
      LevelConfigTableCompanion(
        level: Value(level),
        xpRequired: Value(xpRequired),
      ),
    );
  }

  /// Delete a level config.
  Future<void> deleteLevel(int level) {
    return (delete(levelConfigTable)
          ..where((t) => t.level.equals(level)))
        .go();
  }

  /// Seed default XP values for levels 1-100.
  Future<void> seedDefaults() async {
    final existing = await getAll();
    if (existing.isNotEmpty) return; // Already seeded

    for (var l = 1; l <= 100; l++) {
      // Level 1 = 1000, Level 2 = 2000, ..., Level 100 = 100000
      // Formula: level * 1000
      final xp = l * 1000;
      await upsert(l, xp);
    }
  }
}