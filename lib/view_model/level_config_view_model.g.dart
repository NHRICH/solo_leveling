// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_config_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// View model for editing XP per level thresholds.

@ProviderFor(LevelConfigViewModel)
final levelConfigViewModelProvider = LevelConfigViewModelProvider._();

/// View model for editing XP per level thresholds.
final class LevelConfigViewModelProvider
    extends
        $AsyncNotifierProvider<LevelConfigViewModel, List<LevelConfigModel>> {
  /// View model for editing XP per level thresholds.
  LevelConfigViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'levelConfigViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$levelConfigViewModelHash();

  @$internal
  @override
  LevelConfigViewModel create() => LevelConfigViewModel();
}

String _$levelConfigViewModelHash() =>
    r'0130171c06d1884175802a3bb2d27566c369c96b';

/// View model for editing XP per level thresholds.

abstract class _$LevelConfigViewModel
    extends $AsyncNotifier<List<LevelConfigModel>> {
  FutureOr<List<LevelConfigModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<LevelConfigModel>>, List<LevelConfigModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<LevelConfigModel>>,
                List<LevelConfigModel>
              >,
              AsyncValue<List<LevelConfigModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
