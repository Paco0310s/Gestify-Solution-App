// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'businesses_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(businessesList)
final businessesListProvider = BusinessesListProvider._();

final class BusinessesListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BusinessModel>>,
          List<BusinessModel>,
          FutureOr<List<BusinessModel>>
        >
    with
        $FutureModifier<List<BusinessModel>>,
        $FutureProvider<List<BusinessModel>> {
  BusinessesListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessesListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessesListHash();

  @$internal
  @override
  $FutureProviderElement<List<BusinessModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BusinessModel>> create(Ref ref) {
    return businessesList(ref);
  }
}

String _$businessesListHash() => r'b29194849c0b0f4a8f64f8e18d632bd2e015d7ae';

@ProviderFor(BusinessAddLoading)
final businessAddLoadingProvider = BusinessAddLoadingProvider._();

final class BusinessAddLoadingProvider
    extends $NotifierProvider<BusinessAddLoading, bool> {
  BusinessAddLoadingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessAddLoadingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessAddLoadingHash();

  @$internal
  @override
  BusinessAddLoading create() => BusinessAddLoading();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$businessAddLoadingHash() =>
    r'f3470f55ffd36284e1b6fd79dfc751fbe41c0923';

abstract class _$BusinessAddLoading extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(BusinessActionLoading)
final businessActionLoadingProvider = BusinessActionLoadingProvider._();

final class BusinessActionLoadingProvider
    extends $NotifierProvider<BusinessActionLoading, bool> {
  BusinessActionLoadingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessActionLoadingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessActionLoadingHash();

  @$internal
  @override
  BusinessActionLoading create() => BusinessActionLoading();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$businessActionLoadingHash() =>
    r'20283e3617cad47778d4102569e063f2c27441cc';

abstract class _$BusinessActionLoading extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SelectedBusiness)
final selectedBusinessProvider = SelectedBusinessProvider._();

final class SelectedBusinessProvider
    extends $NotifierProvider<SelectedBusiness, BusinessModel?> {
  SelectedBusinessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedBusinessProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedBusinessHash();

  @$internal
  @override
  SelectedBusiness create() => SelectedBusiness();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BusinessModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BusinessModel?>(value),
    );
  }
}

String _$selectedBusinessHash() => r'eb01e6ead240bdd2f9b1a8df753a231693e19d16';

abstract class _$SelectedBusiness extends $Notifier<BusinessModel?> {
  BusinessModel? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<BusinessModel?, BusinessModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BusinessModel?, BusinessModel?>,
              BusinessModel?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
