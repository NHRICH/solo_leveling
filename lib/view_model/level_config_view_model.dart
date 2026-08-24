import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solo_leveling/data/db/app_database.dart';
import 'package:solo_leveling/domain/models/level_config_model.dart';

part 'level_config_view_model.g.dart';

/// View model for editing XP per level thresholds.
@riverpod
class LevelConfigViewModel extends _$LevelConfigViewModel {
  @override
  Future<List<LevelConfigModel>> build() async {
    final dao = ref.read(appDatabaseProviderProvider).levelConfigDao;
    await dao.seedDefaults();
    final configs = await dao.getAll();
    return configs
        .map((c) => LevelConfigModel(level: c.level, xpRequired: c.xpRequired))
        .toList();
  }

  /// Update XP requirement for a specific level.
  Future<void> updateLevel(int level, int xpRequired) async {
    final dao = ref.read(appDatabaseProviderProvider).levelConfigDao;
    await dao.upsert(level, xpRequired);
    ref.invalidateSelf();
  }

  /// Get XP requirement for a specific level.
  Future<int> getXpForLevel(int level) async {
    final dao = ref.read(appDatabaseProviderProvider).levelConfigDao;
    final config = await dao.getForLevel(level);
    return config?.xpRequired ?? level * 1000;
  }

  /// Compute cumulative XP needed to reach a given level.
  Future<int> cumulativeXpForLevel(int level) async {
    if (level <= 1) return 0;
    final dao = ref.read(appDatabaseProviderProvider).levelConfigDao;
    final allConfigs = await dao.getAll();
    int sum = 0;
    for (final config in allConfigs) {
      if (config.level < level) {
        sum += config.xpRequired;
      }
    }
    return sum;
  }

  /// Compute progress percentage for current level.
  Future<double> progressPercent(int currentLevel, int totalPoints) async {
    if (currentLevel <= 1) return 0.0;
    final currentBase = await cumulativeXpForLevel(currentLevel);
    final nextBase = await cumulativeXpForLevel(currentLevel + 1);
    final pointsInCurrentLevel = totalPoints - currentBase;
    final totalRequired = nextBase - currentBase;
    if (totalRequired <= 0) return 0.0;
    return (pointsInCurrentLevel / totalRequired).clamp(0.0, 1.0).toDouble();
  }
}