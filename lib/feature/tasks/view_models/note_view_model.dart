import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solo_leveling/data/db/tables/note_table.dart';
import 'package:solo_leveling/data/repository/note_repository.dart';
import 'package:solo_leveling/feature/tasks/view_models/state/note_state.dart';
import 'package:solo_leveling/view_model/gamification_provider.dart';
import 'package:solo_leveling/view_model/user_progress_view_model.dart';

/// Result of completing a quest, exposed to the UI for "System" popups.
class QuestCompletionResult {
  final bool leveledUp;
  final int xpGained;
  final int newLevel;
  final String newRank;

  const QuestCompletionResult({
    required this.leveledUp,
    required this.xpGained,
    required this.newLevel,
    required this.newRank,
  });
}

final noteViewModelProvider = NotifierProvider<NoteViewModel, NoteState>(
  () => NoteViewModel(),
);

class NoteViewModel extends Notifier<NoteState> {
  @override
  NoteState build() {
    Future.microtask(() => getAllNotes());
    return NoteState();
  }

  Future<void> getAllNotes() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final notes = await ref.read(noteRepositoryProvider).getAllNotes();
      state = state.copyWith(isLoading: false, notes: notes, error: null);
    } catch (e, s) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load notes: $e\n$s',
      );
    }
  }

  Future<void> getNoteById(int id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final note = await ref.read(noteRepositoryProvider).getNoteById(id);
      state = state.copyWith(isLoading: false, notes: [note], error: null);
    } catch (e, s) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load note: $e\n$s',
      );
    }
  }

  Future<void> insertNote(
    String title,
    String? description,
    String? dueDate,
    Priority? priority,
    TaskDifficulty difficulty,
    String? taskType,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await ref
          .read(noteRepositoryProvider)
          .insertNote(
            title,
            description,
            dueDate,
            priority,
            difficulty,
            taskType,
          );
      await getAllNotes();
    } catch (e, s) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to insert note: $e\n$s',
      );
    }
  }

  /// Completes a quest (task). Returns the completion result so the UI can
  /// show the Solo Leveling "System" popups.
  Future<QuestCompletionResult?> toggleNoteCompletion(int id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(noteRepositoryProvider);
      final note = await repository.getNoteById(id);

      await repository.toggleCompletion(id);

      if (ref.read(gamificationProvider) && !note.isCompleted) {
        final xpGained = UserProgressViewModel.xpForDifficulty(note.difficulty);
        final leveledUp = await ref
            .read(userProgressViewModelProvider.notifier)
            .awardPoints(note.difficulty);

        // Await the fresh progress (awardPoints invalidated the provider).
        final progress = await ref.read(userProgressViewModelProvider.future);
        await getAllNotes();

        return QuestCompletionResult(
          leveledUp: leveledUp,
          xpGained: xpGained,
          newLevel: progress?.currentLevel ?? 1,
          newRank: (progress?.rank ?? 'e').toUpperCase(),
        );
      }

      await getAllNotes();
      return null;
    } catch (e, s) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to toggle note completion: $e\n$s',
      );
      return null;
    }
  }

  Future<void> updateNotePriority(int id, Priority priority) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await ref.read(noteRepositoryProvider).updateNotePriority(id, priority);
      await getAllNotes();
    } catch (e, s) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update note priority: $e\n$s',
      );
    }
  }

  Future<void> updateNote(
    int id,
    String title,
    String? description,
    String? dueDate,
    TaskDifficulty? difficulty,
    String? taskType,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await ref
          .read(noteRepositoryProvider)
          .updateNote(id, title, description, dueDate, difficulty, taskType);
      await getAllNotes();
    } catch (e, s) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update note: $e\n$s',
      );
    }
  }

  Future<void> deleteNote(int id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await ref.read(noteRepositoryProvider).deleteNote(id);
      await getAllNotes();
    } catch (e, s) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete note: $e\n$s',
      );
    }
  }

  Future<void> deleteAllNotes() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await ref.read(noteRepositoryProvider).deleteAllNotes();
      await getAllNotes();
    } catch (e, s) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete all notes: $e\n$s',
      );
    }
  }
}