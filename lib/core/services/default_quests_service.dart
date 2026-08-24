import 'package:solo_leveling/core/constants/default_quests.dart';
import 'package:solo_leveling/core/services/app_preferences.dart';
import 'package:solo_leveling/feature/tasks/view_models/note_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Seeds the default Solo Leveling daily quests on first launch.
/// Uses SharedPreferences to only seed once.
class DefaultQuestsService {
  static const String _seededKey = 'default_quests_seeded_v1';

  /// Whether default quests have already been seeded.
  static bool get hasSeededDefaults =>
      AppPreferences.instance.getBool(_seededKey) ?? false;

  /// Seeds default quests once. Returns true if it seeded.
  static Future<bool> seedIfNeeded(WidgetRef ref) async {
    if (hasSeededDefaults) return false;

    final notifier = ref.read(noteViewModelProvider.notifier);
    final now = DateTime.now();

    for (final quest in defaultDailyQuests) {
      await notifier.insertNote(
        quest.title,
        quest.description,
        now.toIso8601String(),
        quest.priority,
        quest.difficulty,
        null,
      );
    }

    await AppPreferences.setPreferenceBool(_seededKey, true);
    return true;
  }
}
