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

String _$businessesListHash() => r'7019b043f0a83e4a05c645cdfc6cae92b2c817c9';
