import 'dart:convert';
import 'dart:io';

import 'package:crispy_fires/database/database.dart';
import 'package:crispy_fires/lobby/lobby_provider.dart';
import 'package:crispy_fires/main.dart';
import 'package:crispy_fires/messages/lobby.dart';
import 'package:crispy_fires/models/connection_request.dart';
import 'package:crispy_fires/table/table_provider.dart';
import 'package:crispy_fires/table/table_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'client.g.dart';

class SocketMessage {
  final String path;
  final String data;

  const SocketMessage({required this.path, this.data = ""});

  Map<String, dynamic> toJson() {
    return {
      "path": path,
      "data": data,
    };
  }

  factory SocketMessage.fromJson(Map<String, dynamic> data) {
    return SocketMessage(path: data["path"], data: data["data"] ?? "");
  }
}

class BetMessage {
  final String name;
  final int amount;

  const BetMessage({required this.name, required this.amount});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "amount": amount,
    };
  }

  factory BetMessage.fromJson(Map<String, dynamic> data) {
    return BetMessage(name: data["name"], amount: data["amount"]);
  }
}

@Riverpod(keepAlive: true)
Client client(Ref ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  final name = sharedPrefs.getString("name");

  return Client(ref: ref, name: name!, sharedPreferences: sharedPrefs);
}

class Client {
  final String name;
  final Ref ref;
  String? uri;
  final SharedPreferences sharedPreferences;
  late Socket socket;

  Client(
      {required this.ref, required this.sharedPreferences, required this.name});

  Future<void> connect(String ip) async {
    uri = ip;

    socket = await Socket.connect(uri, 5555);
    final request = SocketMessage(
        path: CONNECT_MESSAGE, data: jsonEncode(ConnectRequest(name: name)));
    socket.write(jsonEncode(request));

    socket.listen((data) {
      onData(SocketMessage.fromJson(jsonDecode(String.fromCharCodes(data))));
    });

    sharedPreferences.setString("connectedGame", ip);
  }

  onData(SocketMessage request) {
    switch (request.path) {
      case LOBBY_CONTENT_MESSAGE:
        onLobbyContent(request);
        break;
      case DECLINE_CONNECT_MESSAGE:
        onDeclineConnect(request);
        break;
      case GAME_START_MESSAGE:
        onGameStart(request);
        break;
      case GAME_STATE_MESSAGE:
        onGameState(request);
        break;
    }
  }

  onLobbyContent(SocketMessage request) {
    final lobbyUsers =
        List.from(jsonDecode(request.data)).map(LobbyUser.fromJson).toList();

    ref.read(lobbyProvider.notifier).setLobby(lobbyUsers);
  }

  void onDeclineConnect(SocketMessage request) {
    navigatorKey.currentState?.pop();
  }

  void onGameState(SocketMessage request) {
    final players =
        List.from(jsonDecode(request.data)).map(TablePlayer.fromJson).toList();
    ref.read(tableDataProvider.notifier).setGameState(players);
  }

  void onGameStart(SocketMessage request) {
    onGameState(request);

    navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (_) => const TableScreen()));
  }

  void sendBet(int amount) {
    socket.write(jsonEncode(SocketMessage(
        path: BET_MESSAGE,
        data: jsonEncode(
            BetMessage(name: ref.read(nameProvider), amount: amount)))));
  }

  void sendAproveBet() {
    socket.write(jsonEncode(
        SocketMessage(path: APROVE_BET_MESSAGE, data: ref.read(nameProvider))));
  }

  void sendCancelBet() {
    socket.write(jsonEncode(
        SocketMessage(path: CANCEL_BET_MESSAGE, data: ref.read(nameProvider))));
  }

  void sendSplitOrDoubleDown() {
    socket.write(jsonEncode(
        SocketMessage(path: SPLIT_OR_DOUBLE_DOWN_MESSAGE , data: ref.read(nameProvider))));
  }
}
