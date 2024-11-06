import 'dart:convert';
import 'dart:io';

import 'package:crispy_fires/client/client.dart';
import 'package:crispy_fires/lobby/lobby_provider.dart';
import 'package:crispy_fires/main.dart';
import 'package:crispy_fires/messages/lobby.dart';
import 'package:crispy_fires/models/connection_request.dart';
import 'package:crispy_fires/table/table_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'server.g.dart';

@Riverpod(keepAlive: true)
Server server(Ref ref) {
  return Server(ref: ref);
}

class Server {
  final Ref ref;
  late final ServerSocket server;
  final List<(Socket, String)> _connections = [];

  Server({required this.ref});

  Future<void> start() async {
    server = await ServerSocket.bind(InternetAddress.anyIPv4, 5555);

    ref.read(lobbyProvider.notifier).add(ref.read(nameProvider));
    ref.read(lobbyProvider.notifier).accept(ref.read(nameProvider));

    server.listen((Socket socket) {
      socket.listen((data) {
        final s = String.fromCharCodes(data);
        final message = SocketMessage.fromJson(jsonDecode(s));

        switch (message.path) {
          case CONNECT_MESSAGE:
            onConnect(socket, message);
            break;
          case BET_MESSAGE:
            onBet(message);
            break;
          case APROVE_BET_MESSAGE:
            onAproveBet(message);
            break;
          case CANCEL_BET_MESSAGE:
            onCancelBet(message);
            break;
          case SPLIT_OR_DOUBLE_DOWN_MESSAGE:
            onSplitOrDoubleDown(message);
            break;
        }
      }, onDone: () {
        _connections.removeWhere((e) => e.$1 == socket);
      });
    });
  }

  void onConnect(Socket socket, SocketMessage message) async {
    final connectRequest = ConnectRequest.fromJson(jsonDecode(message.data));
    _connections.add((socket, connectRequest.name));
    ref.read(lobbyProvider.notifier).add(connectRequest.name);
  }

  void sendLobby(List<LobbyUser> users) {
    for (final socket in _connections) {
      socket.$1.write(jsonEncode(
          SocketMessage(path: LOBBY_CONTENT_MESSAGE, data: jsonEncode(users))));
    }
  }

  void sendDecline(String name) {
    final conn = _connections.where((e) => e.$2 == name).firstOrNull;

    conn?.$1
        .write(jsonEncode(const SocketMessage(path: DECLINE_CONNECT_MESSAGE)));
  }

  void sendGameStart() {
    final players = ref
        .read(lobbyProvider)
        .where((e) => e.isAccepted)
        .map((e) => TablePlayer(
            name: e.name,
            totalCash: 400,
            bet: 0,
            isCasino: e.name == ref.read(nameProvider)))
        .toList();

    ref.read(tableDataProvider.notifier).setGameState(players);

    for (final socket in _connections) {
      socket.$1.write(jsonEncode(
          SocketMessage(path: GAME_START_MESSAGE, data: jsonEncode(players))));
    }
  }

  void sendGameState(List<TablePlayer> state) {
    for (final socket in _connections) {
      socket.$1.write(jsonEncode(
          SocketMessage(path: GAME_STATE_MESSAGE, data: jsonEncode(state))));
    }
  }

  void onBet(SocketMessage message) {
    final bet = BetMessage.fromJson(jsonDecode(message.data));

    ref.read(tableDataProvider.notifier).bet(bet.amount, bet.name);

    sendGameState(ref.read(tableDataProvider));
  }

  void onCancelBet(SocketMessage message) {
    ref.read(tableDataProvider.notifier).cancelBet(message.data);
  }

  void onAproveBet(SocketMessage message) {
    ref.read(tableDataProvider.notifier).aproveBet(message.data);
  }

  void onSplitOrDoubleDown(SocketMessage message) {
    ref.read(tableDataProvider.notifier).splitOrDoubleDown(message.data);
  }
}
