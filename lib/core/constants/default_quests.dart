import 'package:solo_leveling/data/db/tables/note_table.dart';

/// Default Solo Leveling daily quests seeded on first launch.
/// Each quest has a title, description, difficulty (XP value), and priority.
class DefaultQuest {
  final String title;
  final String? description;
  final TaskDifficulty difficulty;
  final Priority priority;

  const DefaultQuest({
    required this.title,
    this.description,
    required this.difficulty,
    this.priority = Priority.none,
  });
}

const List<DefaultQuest> defaultDailyQuests = [
  DefaultQuest(
    title: '100 Push Ups',
    description: 'Do 100 push ups to build strength. Increase your physical stats.',
    difficulty: TaskDifficulty.medium,
    priority: Priority.high,
  ),
  DefaultQuest(
    title: '100 Sit Ups',
    description: 'Do 100 sit ups to strengthen your core. Endurance training.',
    difficulty: TaskDifficulty.medium,
    priority: Priority.high,
  ),
  DefaultQuest(
    title: '100 Squats',
    description: 'Do 100 squats to build lower body power. Leg day, every day.',
    difficulty: TaskDifficulty.medium,
    priority: Priority.high,
  ),
  DefaultQuest(
    title: '10 km Run',
    description: 'Run 10 km to build cardiovascular endurance. Shadow army training.',
    difficulty: TaskDifficulty.hard,
    priority: Priority.high,
  ),
  DefaultQuest(
    title: 'Read 30 Minutes',
    description: 'Read for 30 minutes to increase intelligence. Knowledge is power.',
    difficulty: TaskDifficulty.easy,
    priority: Priority.medium,
  ),
  DefaultQuest(
    title: 'Cold Shower',
    description: 'Take a cold shower to build mental fortitude. Mind over matter.',
    difficulty: TaskDifficulty.medium,
    priority: Priority.medium,
  ),
  DefaultQuest(
    title: 'Meditate 10 Minutes',
    description: 'Meditate for 10 minutes to sharpen your focus. Mana regeneration.',
    difficulty: TaskDifficulty.easy,
    priority: Priority.low,
  ),
  DefaultQuest(
    title: 'Drink 8 Glasses of Water',
    description: 'Stay hydrated. Your body is your weapon.',
    difficulty: TaskDifficulty.easy,
    priority: Priority.low,
  ),
  DefaultQuest(
    title: 'Stretch 15 Minutes',
    description: 'Stretch for 15 minutes to maintain flexibility. Avoid injuries.',
    difficulty: TaskDifficulty.easy,
    priority: Priority.low,
  ),
];