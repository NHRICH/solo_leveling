import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solo_leveling/data/db/app_database.dart';
import 'dart:math' as math;

part 'user_progress_model.freezed.dart';

/// Solo Leveling "System" ranks based on completed tasks / progression.
enum Rank {
  e('E', 0),
  d('D', 10),
  c('C', 25),
  b('B', 50),
  a('A', 100),
  s('S', 200);

  final String label;
  final int minLevel;

  const Rank(this.label, this.minLevel);

  static Rank fromString(String? value) {
    return Rank.values.firstWhere(
      (r) => r.name.toUpperCase() == (value ?? '').toUpperCase(),
      orElse: () => Rank.e,
    );
  }

  static Rank forLevel(int level) {
    Rank result = Rank.e;
    for (final r in Rank.values) {
      if (level >= r.minLevel) result = r;
    }
    return result;
  }
}

@freezed
abstract class UserProgressModel with _$UserProgressModel {
  const UserProgressModel._();

  factory UserProgressModel({
    required int id,
    required int totalPoints,
    required int currentLevel,
    required int currentStreak,
    required DateTime? lastCompletionDate,
    required bool weeklyStreakRewardClaimed,
    @Default('E') String rank,
    @Default(0) int totalTasksCompleted,
    // Optional configurable XP thresholds. When provided, these override the
    // static Solo Leveling formula so the user can customize XP per level.
    int? currentLevelXpBase,
    int? nextLevelXpBase,
  }) = _UserProgressModel;

  factory UserProgressModel.fromEntity(UserProgressTableData data) {
    return UserProgressModel(
      id: data.id,
      totalPoints: data.totalPoints,
      currentLevel: data.currentLevel,
      currentStreak: data.currentStreak,
      lastCompletionDate: data.lastCompletionDate,
      weeklyStreakRewardClaimed: data.weeklyStreakRewardClaimed,
      rank: data.rank,
      totalTasksCompleted: data.totalTasksCompleted,
    );
  }

  /// Solo Leveling formula: Next Level XP = (Current Level ^ 1.5) * 100
  static int _xpForLevel(int n) {
    if (n <= 1) return 0;
    // Sum of xp thresholds: sum_{l=1}^{n-1} (l^1.5) * 100
    double sum = 0;
    for (var l = 1; l < n; l++) {
      sum += math.pow(l, 1.5).toDouble() * 100;
    }
    return sum.round();
  }

  /// Cumulative XP required to reach the current level.
  /// Uses the configurable override if provided, otherwise the static formula.
  int get currentLevelBase => currentLevelXpBase ?? _xpForLevel(currentLevel);

  /// Cumulative XP required to reach the next level.
  /// Uses the configurable override if provided, otherwise the static formula.
  int get nextLevelBase => nextLevelXpBase ?? _xpForLevel(currentLevel + 1);

  double get progressPercent {
    final pointsInCurrentLevel = totalPoints - currentLevelBase;
    final totalPointsRequired = nextLevelBase - currentLevelBase;
    if (totalPointsRequired <= 0) return 0.0;
    return (pointsInCurrentLevel / totalPointsRequired).clamp(0.0, 1.0);
  }

  int get nextLevelPoints => nextLevelBase;

  int get pointsToNextLevel => nextLevelPoints - totalPoints;

  Rank get rankEnum => Rank.forLevel(currentLevel);
}
