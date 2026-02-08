// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spaces_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createSpaceActionHash() => r'6e1a6849c643b846007c7793e7257dd98c4592e6';

/// Create space action
///
/// Copied from [CreateSpaceAction].
@ProviderFor(CreateSpaceAction)
final createSpaceActionProvider =
    AutoDisposeAsyncNotifierProvider<CreateSpaceAction, void>.internal(
  CreateSpaceAction.new,
  name: r'createSpaceActionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createSpaceActionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateSpaceAction = AutoDisposeAsyncNotifier<void>;
String _$selectedDocumentIdHash() =>
    r'30733d8e973f51ffef2758a0bfb175666cd67615';

/// Currently selected document ID within a space detail view
///
/// Copied from [SelectedDocumentId].
@ProviderFor(SelectedDocumentId)
final selectedDocumentIdProvider =
    AutoDisposeNotifierProvider<SelectedDocumentId, String?>.internal(
  SelectedDocumentId.new,
  name: r'selectedDocumentIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedDocumentIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedDocumentId = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
