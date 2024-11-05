import 'package:crispy_fires/client/client.dart';
import 'package:crispy_fires/main.dart';
import 'package:crispy_fires/server/server.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'table_provider.g.dart';

class TablePlayer {
  final String name;
  final int totalCash;
  final int bet;
  final bool isCasino;
  final bool didBet;
  final bool didSplitOrDoubleDown;

  TablePlayer(
      {required this.name,
      required this.totalCash,
      required this.bet,
      this.isCasino = false,
      this.didBet = false,
      this.didSplitOrDoubleDown = false});

  TablePlayer copyWith(
      {String? name,
      int? totalCash,
      int? bet,
      bool? isCasino,
      bool? didBet,
      bool? didSplitOrDoubleDown}) {
    return TablePlayer(
        name: name ?? this.name,
        totalCash: totalCash ?? this.totalCash,
        bet: bet ?? this.bet,
        isCasino: isCasino ?? this.isCasino,
        didBet: didBet ?? this.didBet,
        didSplitOrDoubleDown:
            didSplitOrDoubleDown ?? this.didSplitOrDoubleDown);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "totalCash": totalCash,
      "bet": bet,
      "isCasino": isCasino,
      "didBet": didBet,
      "didSplitOrDoubleDown": didSplitOrDoubleDown
    };
  }

  factory TablePlayer.fromJson(data) {
    return TablePlayer(
      name: data["name"],
      totalCash: data["totalCash"],
      bet: data["bet"],
      isCasino: data["isCasino"],
      didBet: data["didBet"],
      didSplitOrDoubleDown: data["didSplitOrDoubleDown"],
    );
  }
}

@Riverpod(keepAlive: true, dependencies: [name])
class TableData extends _$TableData {
  @override
  List<TablePlayer> build() {
    return [];
  }

  void bet(int amount, [String? playerName]) {
    final name = playerName ?? ref.read(nameProvider);

    state = [
      for (final player in state)
        if (player.name == name)
          player.copyWith(
              bet: amount + player.bet, totalCash: player.totalCash - amount)
        else
          player
    ];
  }

  void setGameState(List<TablePlayer> players) {
    state = [...players];
  }

  void cancelBet([String? playerName]) {
    final name = playerName ?? ref.read(nameProvider);

    state = [
      for (final player in state)
        if (player.name == name)
          player.copyWith(bet: 0, totalCash: player.totalCash + player.bet)
        else
          player
    ];
  }

  void aproveBet([String? playerName]) {
    final name = playerName ?? ref.read(nameProvider);

    state = [
      for (final player in state)
        if (player.name == name) player.copyWith(didBet: true) else player
    ];
  }

  void splitOrDoubleDown([String? playerName]) {
    final name = playerName ?? ref.read(nameProvider);

    state = [
      for (final player in state)
        if (player.name == name)
          player.copyWith(
              bet: player.bet * 2,
              totalCash: player.totalCash - player.bet,
              didSplitOrDoubleDown: true)
        else
          player
    ];
  }
}

@Riverpod(dependencies: [isHost, TableData, name])
TableController tableController(Ref ref) {
  ref.read(tableDataProvider);
  return TableController(
      ref, ref.watch(isHostProvider), ref.watch(nameProvider));
}

class TableController {
  final Ref ref;
  final bool isHost;
  final String name;

  TableController(this.ref, this.isHost, this.name);

  void bet(int amount) {
    ref.read(tableDataProvider.notifier).bet(amount);
    if (isHost) {
      ref.read(serverProvider).sendGameState(ref.read(tableDataProvider));
    } else {
      ref.read(clientProvider).sendBet(amount);
    }
  }

  cancelBet() {
    ref.read(tableDataProvider.notifier).cancelBet();

    if (isHost) {
      ref.read(serverProvider).sendGameState(ref.read(tableDataProvider));
    } else {
      ref.read(clientProvider).sendCancelBet();
    }
  }

  aproveBet() {
    ref.read(tableDataProvider.notifier).aproveBet();

    if (isHost) {
      ref.read(serverProvider).sendGameState(ref.read(tableDataProvider));
    } else {
      ref.read(clientProvider).sendAproveBet();
    }
  }

  splitOrStand() {
    ref.read(tableDataProvider.notifier).splitOrDoubleDown();

    if (isHost) {
      ref.read(serverProvider).sendGameState(ref.read(tableDataProvider));
    } else {
      ref.read(clientProvider).sendSplitOrDoubleDown();
    }
  }
}
