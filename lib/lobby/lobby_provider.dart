import 'package:crispy_fires/server/server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lobby_provider.g.dart';

class LobbyUser {
  final String name;
  bool isAccepted;

  LobbyUser({required this.name, this.isAccepted = false});

  factory LobbyUser.fromJson(data) {
    final name = data["name"];
    final isAccepted = data["isAccepted"];
    return LobbyUser(name: name, isAccepted: isAccepted);
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "isAccepted": isAccepted};
  }
}

@Riverpod(keepAlive: true)
class Lobby extends _$Lobby {
  @override
  List<LobbyUser> build() {
    return [];
  }

  void accept(String user) {
    state = [
      for (final e in state)
        if (e.name == user) e..isAccepted = true else e
    ];

    ref.read(serverProvider).sendLobby(state);
  }

  void add(String user) {
    state = [...state, LobbyUser(name: user)];

    ref.read(serverProvider).sendLobby(state);
  }

  void decline(String user) {
    state = [
      for (final e in state)
        if (e.name != user) e
    ];

    ref.read(serverProvider).sendDecline(user);
    ref.read(serverProvider).sendLobby(state);
  }

  void setLobby(List<LobbyUser> lobbyUsers) {
    state = [...lobbyUsers];
  }
}

