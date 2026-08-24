import 'dart:math' as math;
import 'package:drift/drift.dart';
import 'package:solo_leveling/data/db/app_database.dart';
import 'package:solo_leveling/data/db/tables/note_table.dart';
import 'package:solo_leveling/domain/models/user_progress_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_progress_view_model.g.dart';

@riverpod
class UserProgressViewModel extends _$UserProgressViewModel {
  @override
  Future<UserProgressModel?> build() async {
    final dao = ref.watch(appDatabaseProviderProvider).userProgressDao;
    var progress = await dao.getProgress();

    if (progress == null) {
      final newProgress = UserProgressTableCompanion.insert(
        totalPoints: const Value(0),
        currentLevel: const Value(1),
        currentStreak: const Value(0),
        rank: const Value('E'),
        totalTasksCompleted: const Value(0),
        weeklyStreakRewardClaimed: const Value(false),
      );
      await dao.insertProgress(newProgress);
      progress = await dao.getProgress();
    }

    return progress != null ? UserProgressModel.fromEntity(progress) : null;
  }

  /// Solo Leveling XP map: Low = 10 XP, Medium = 25 XP, High = 50 XP.
  /// Public so UI can display the XP gained without recomputing.
  static int xpForDifficulty(TaskDifficulty difficulty) {
    return switch (difficulty) {
      TaskDifficulty.easy => 10,
      TaskDifficulty.medium => 25,
      TaskDifficulty.hard => 50,
    };
  }

  /// Alias used internally by [awardPoints].
  int _xpForDifficulty(TaskDifficulty difficulty) =>
      xpForDifficulty(difficulty);

  /// Award XP, update level/points/rank/streak. Returns true if leveled up.
  Future<bool> awardPoints(TaskDifficulty difficulty) async {
    final currentProgress = state.value;
    if (currentProgress == null) return false;

    final pointsToAdd = _xpForDifficulty(difficulty);

    int newStreak = currentProgress.currentStreak;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime? lastCompletion;
    if (currentProgress.lastCompletionDate != null) {
      lastCompletion = DateTime(
        currentProgress.lastCompletionDate!.year,
        currentProgress.lastCompletionDate!.month,
        currentProgress.lastCompletionDate!.day,
      );
    }

    if (lastCompletion == null) {
      newStreak = 1;
    } else {
      final difference = today.difference(lastCompletion).inDays;
      if (difference == 1) {
        newStreak++;
      } else if (difference > 1) {
        newStreak = 1;
      }
    }

    int streakPoints = 0;
    bool weeklyClaimed = currentProgress.weeklyStreakRewardClaimed;
    if (newStreak % 7 == 0 && newStreak != 0) {
      if (lastCompletion == null || today.isAfter(lastCompletion)) {
        if (lastCompletion != null && today.isAfter(lastCompletion)) {
          weeklyClaimed = false;
        }
        if (!weeklyClaimed) {
          streakPoints = 50;
          weeklyClaimed = true;
        }
      }
    } else {
      weeklyClaimed = false;
    }

    final finalPoints =
        currentProgress.totalPoints + pointsToAdd + streakPoints;

    final oldLevel = currentProgress.currentLevel;
    int newLevel = oldLevel;
    while (_xpForLevel(newLevel + 1) <= finalPoints) {
      newLevel++;
    }
    final leveledUp = newLevel > oldLevel;

    final updatedCompanion = UserProgressTableCompanion(
      totalPoints: Value(finalPoints),
      currentLevel: Value(newLevel),
      currentStreak: Value(newStreak),
      rank: Value(Rank.forLevel(newLevel).name.toLowerCase()),
      totalTasksCompleted: Value(currentProgress.totalTasksCompleted + 1),
      lastCompletionDate: Value(today),
      weeklyStreakRewardClaimed: Value(weeklyClaimed),
      updatedAt: Value(DateTime.now()),
    );

    await ref
        .read(appDatabaseProviderProvider)
        .userProgressDao
        .updateProgress(updatedCompanion);
    ref.invalidateSelf();

    return leveledUp;
  }

  /// Solo Leveling formula: Next Level XP = (Current Level ^ 1.5) * 100.
  static int _xpForLevel(int n) {
    if (n <= 1) return 0;
    double sum = 0;
    for (var l = 1; l < n; l++) {
      sum += math.pow(l, 1.5).toDouble() * 100;
    }
    return sum.round();
  }
}