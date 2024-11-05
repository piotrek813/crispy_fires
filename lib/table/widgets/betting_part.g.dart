// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'betting_part.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentPlayerHash() => r'92ca1cf1e9e53fef78cae1851317844829a898ba';

/// See also [currentPlayer].
@ProviderFor(currentPlayer)
final currentPlayerProvider = AutoDisposeProvider<TablePlayer>.internal(
  currentPlayer,
  name: r'currentPlayerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentPlayerHash,
  dependencies: <ProviderOrFamily>[nameProvider, tableDataProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    nameProvider,
    ...?nameProvider.allTransitiveDependencies,
    tableDataProvider,
    ...?tableDataProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentPlayerRef = AutoDisposeProviderRef<TablePlayer>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
