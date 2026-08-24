// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_config_dao.dart';

// ignore_for_file: type=lint
mixin _$LevelConfigDaoMixin on DatabaseAccessor<AppDatabase> {
  $LevelConfigTableTable get levelConfigTable =>
      attachedDatabase.levelConfigTable;
  LevelConfigDaoManager get managers => LevelConfigDaoManager(this);
}

class LevelConfigDaoManager {
  final _$LevelConfigDaoMixin _db;
  LevelConfigDaoManager(this._db);
  $$LevelConfigTableTableTableManager get levelConfigTable =>
      $$LevelConfigTableTableTableManager(
        _db.attachedDatabase,
        _db.levelConfigTable,
      );
}
