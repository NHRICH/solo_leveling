import 'package:solo_leveling/core/constants/default_quests.dart';
import 'package:solo_leveling/core/services/app_preferences.dart';
import 'package:solo_leveling/data/db/tables/note_table.dart';
import 'package:solo_leveling/data/repository/note_repository.dart';
import 'package:solo_leveling/feature/tasks/view_models/note_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Seeds the default Solo Leveling DAILY quests on first launch.
/// Uses SharedPreferences to only seed once.
class DefaultQuestsService {
  // v2: re-runs the seed on older installs so defaults become true daily
  // recurring quests (they were seeded as one-offs before recurrence existed).
  static const String _seededKey = 'default_quests_seeded_v2';

  /// Whether default quests have already been seeded.
  static bool get hasSeededDefaults =>
      AppPreferences.instance.getBool(_seededKey) ?? false;

  /// Seeds default quests once. Returns true if it seeded.
  static Future<bool> seedIfNeeded(WidgetRef ref) async {
    if (hasSeededDefaults) return false;

    final notifier = ref.read(noteViewModelProvider.notifier);
    final repository = ref.read(noteRepositoryProvider);

    // Remove stale copies from the previous one-off seed so the new daily
    // quests don't pile up as duplicates.
    final titles = defaultDailyQuests.map((q) => q.title).toList();
    try {
      await repository.deleteNotesByTitles(titles);
    } catch (_) {
      // Non-fatal: proceed to seed even if cleanup fails.
    }

    final now = DateTime.now();

    for (final quest in defaultDailyQuests) {
      await notifier.insertNote(
        quest.title,
        quest.description,
        now.toIso8601String(),
        quest.priority,
        quest.difficulty,
        null,
        Recurrence.daily,
      );
    }

    await AppPreferences.setPreferenceBool(_seededKey, true);
    return true;
  }
}
