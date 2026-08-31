import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solo_leveling/data/db/app_database.dart';
import 'package:solo_leveling/data/db/tables/note_table.dart';

part 'note_model.freezed.dart';

@freezed
abstract class NoteModel with _$NoteModel {
  factory NoteModel({
    @Default(0) int id,
    required String title,
    required String? description,
    required DateTime? dueDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isCompleted,
    required Priority priority,
    required TaskDifficulty difficulty,
    String? taskType,
    @Default(10) int xpValue,
    @Default(Recurrence.none) Recurrence recurrence,
  }) = _NoteModel;

  factory NoteModel.fromEntity(NoteTableData note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      description: note.description,
      dueDate: note.dueDate,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      isCompleted: note.isCompleted,
      priority: note.priority,
      difficulty: note.difficulty,
      taskType: note.taskType,
      xpValue: note.xpValue,
      recurrence: note.recurrence,
    );
  }
}

String formatDateAndTimeDifference(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);

  if (diff.inDays > 0) {
    return '${diff.inDays}d ago';
  } else if (diff.inHours > 0) {
    return '${diff.inHours}h ago';
  } else if (diff.inMinutes > 0) {
    return '${diff.inMinutes}m ago';
  } else {
    return 'Just now';
  }
}
bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

int _daysInMonth(DateTime d) => DateTime(d.year, d.month + 1, 0).day;

/// Whether a quest should be listed for the given [day].
///
/// Non-recurring quests (and already-completed recurring instances) only appear
/// on the concrete day they were due. Pending recurring quests expand to every
/// occurrence from their start date onward, so a daily quest created today is
/// available on every future day — matching the "Solo Leveling daily training"
/// idea. Completing an instance marks that concrete row done (shown on its own
/// day) and respawns the next pending occurrence.
bool noteVisibleOnDay(NoteModel note, DateTime day) {
  final due = note.dueDate ?? note.createdAt;

  if (note.recurrence == Recurrence.none || note.isCompleted) {
    return _isSameDay(due, day);
  }

  final start = DateTime(due.year, due.month, due.day);
  final target = DateTime(day.year, day.month, day.day);
  if (target.isBefore(start)) return false;

  switch (note.recurrence) {
    case Recurrence.daily:
      return true;
    case Recurrence.weekly:
      return target.difference(start).inDays % 7 == 0;
    case Recurrence.monthly:
      final anchor = start.day;
      final last = _daysInMonth(target);
      final occurrenceDay = anchor > last ? last : anchor;
      return target.day == occurrenceDay;
    case Recurrence.none:
      return true;
  }
}