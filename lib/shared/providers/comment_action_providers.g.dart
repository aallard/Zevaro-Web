// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_action_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$commentRepliesHash() => r'36106b76e2432a742985a12ed66a8e84d7537c99';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Replies to a specific comment.
///
/// Copied from [commentReplies].
@ProviderFor(commentReplies)
const commentRepliesProvider = CommentRepliesFamily();

/// Replies to a specific comment.
///
/// Copied from [commentReplies].
class CommentRepliesFamily extends Family<AsyncValue<List<Comment>>> {
  /// Replies to a specific comment.
  ///
  /// Copied from [commentReplies].
  const CommentRepliesFamily();

  /// Replies to a specific comment.
  ///
  /// Copied from [commentReplies].
  CommentRepliesProvider call(
    String commentId,
  ) {
    return CommentRepliesProvider(
      commentId,
    );
  }

  @override
  CommentRepliesProvider getProviderOverride(
    covariant CommentRepliesProvider provider,
  ) {
    return call(
      provider.commentId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'commentRepliesProvider';
}

/// Replies to a specific comment.
///
/// Copied from [commentReplies].
class CommentRepliesProvider extends AutoDisposeFutureProvider<List<Comment>> {
  /// Replies to a specific comment.
  ///
  /// Copied from [commentReplies].
  CommentRepliesProvider(
    String commentId,
  ) : this._internal(
          (ref) => commentReplies(
            ref as CommentRepliesRef,
            commentId,
          ),
          from: commentRepliesProvider,
          name: r'commentRepliesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$commentRepliesHash,
          dependencies: CommentRepliesFamily._dependencies,
          allTransitiveDependencies:
              CommentRepliesFamily._allTransitiveDependencies,
          commentId: commentId,
        );

  CommentRepliesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.commentId,
  }) : super.internal();

  final String commentId;

  @override
  Override overrideWith(
    FutureOr<List<Comment>> Function(CommentRepliesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CommentRepliesProvider._internal(
        (ref) => create(ref as CommentRepliesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        commentId: commentId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Comment>> createElement() {
    return _CommentRepliesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommentRepliesProvider && other.commentId == commentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, commentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CommentRepliesRef on AutoDisposeFutureProviderRef<List<Comment>> {
  /// The parameter `commentId` of this provider.
  String get commentId;
}

class _CommentRepliesProviderElement
    extends AutoDisposeFutureProviderElement<List<Comment>>
    with CommentRepliesRef {
  _CommentRepliesProviderElement(super.provider);

  @override
  String get commentId => (origin as CommentRepliesProvider).commentId;
}

String _$commentActionsHash() => r'066510725b523f18a1d8530e319ce706400f88d2';

/// Action provider for comment create/update/delete.
///
/// Copied from [CommentActions].
@ProviderFor(CommentActions)
final commentActionsProvider =
    AutoDisposeAsyncNotifierProvider<CommentActions, void>.internal(
  CommentActions.new,
  name: r'commentActionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$commentActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CommentActions = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
