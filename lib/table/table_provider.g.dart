// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tableControllerHash() => r'f510009447a31dd931837c374753ba94206713b0';

/// See also [tableController].
@ProviderFor(tableController)
final tableControllerProvider = AutoDisposeProvider<TableController>.internal(
  tableController,
  name: r'tableControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tableControllerHash,
  dependencies: <ProviderOrFamily>[
    isHostProvider,
    tableDataProvider,
    nameProvider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    isHostProvider,
    ...?isHostProvider.allTransitiveDependencies,
    tableDataProvider,
    ...?tableDataProvider.allTransitiveDependencies,
    nameProvider,
    ...?nameProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TableControllerRef = AutoDisposeProviderRef<TableController>;
String _$tableDataHash() => r'dc66d302c0b1effa9d8195da250b5fdc24d02d51';

/// See also [TableData].
@ProviderFor(TableData)
final tableDataProvider =
    NotifierProvider<TableData, List<TablePlayer>>.internal(
  TableData.new,
  name: r'tableDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tableDataHash,
  dependencies: <ProviderOrFamily>[nameProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    nameProvider,
    ...?nameProvider.allTransitiveDependencies
  },
);

typedef _$TableData = Notifier<List<TablePlayer>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
