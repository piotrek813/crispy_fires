// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobby_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lobbyHash() => r'56e629c9322fb9c3d673a3e2a009b1a0411e0f77';

/// See also [Lobby].
@ProviderFor(Lobby)
final lobbyProvider = NotifierProvider<Lobby, List<LobbyUser>>.internal(
  Lobby.new,
  name: r'lobbyProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$lobbyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Lobby = Notifier<List<LobbyUser>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
