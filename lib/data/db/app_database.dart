import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:solo_leveling/data/db/dao/level_config_dao.dart';
import 'package:solo_leveling/data/db/dao/note_dao.dart';
import 'package:solo_leveling/data/db/dao/task_category_dao.dart';
import 'package:solo_leveling/data/db/dao/user_progress_dao.dart';
import 'package:solo_leveling/data/db/tables/level_config_table.dart';
import 'package:solo_leveling/data/db/tables/note_table.dart';
import 'package:solo_leveling/data/db/tables/task_categories_table.dart';
import 'package:solo_leveling/data/db/tables/user_progress_table.dart';
import 'package:solo_leveling/core/constants/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

// this is the db provider
@Riverpod(keepAlive: true)
AppDatabase appDatabaseProvider(Ref ref) {
  final db = AppDatabase();

  ref.onDispose(() {
    db.close();
  });
  return db;
}

// this is the main db class
@DriftDatabase(
  tables: [NoteTable, TaskCategoriesTable, UserProgressTable, LevelConfigTable],
  daos: [NoteDao, TaskCategoryDao, UserProgressDao, LevelConfigDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 6;

  // migration strategy to add new columns to the db
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          // Seed default level configs
          await _seedLevelConfigs();
        },
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            // Add the priority column (intEnum, default 0 = Priority.none)
            await customStatement(
              'ALTER TABLE note_table ADD COLUMN priority INTEGER NOT NULL DEFAULT 0',
            );
          }
          if (from < 3) {
            await migrator.createTable(taskCategoriesTable);
            await migrator.addColumn(noteTable, noteTable.taskType);
          }
          if (from < 4) {
            await migrator.addColumn(noteTable, noteTable.difficulty);
            await migrator.createTable(userProgressTable);
          }
          if (from < 5) {
            await migrator.addColumn(noteTable, noteTable.xpValue);
            await migrator.addColumn(userProgressTable, userProgressTable.rank);
            await migrator.addColumn(
              userProgressTable,
              userProgressTable.totalTasksCompleted,
            );
          }
          if (from < 6) {
            await migrator.createTable(levelConfigTable);
            await _seedLevelConfigs();
          }
        },
  );

  /// Seed default XP values for levels 1-100.
  Future<void> _seedLevelConfigs() async {
    for (var l = 1; l <= 100; l++) {
      final xp = l * 1000;
      await into(levelConfigTable).insertOnConflictUpdate(
        LevelConfigTableCompanion(
          level: Value(l),
          xpRequired: Value(xp),
        ),
      );
    }
  }

  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(noteTable).go();
      await delete(taskCategoriesTable).go();
    });
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: DatabaseConstants.name,
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}