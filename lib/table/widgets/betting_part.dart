import 'package:crispy_fires/colors.dart';
import 'package:crispy_fires/main.dart';
import 'package:crispy_fires/table/table_provider.dart';
import 'package:crispy_fires/widgets/button.dart';
import 'package:crispy_fires/widgets/circular_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'betting_part.g.dart';

@Riverpod(dependencies: [name, TableData])
TablePlayer currentPlayer(Ref ref) {
  return ref
      .watch(tableDataProvider)
      .firstWhere((e) => e.name == ref.watch(nameProvider));
}

class BettingPart extends ConsumerStatefulWidget {
  const BettingPart({
    super.key,
  });

  @override
  ConsumerState<BettingPart> createState() => _BettingPartState();
}

class _BettingPartState extends ConsumerState<BettingPart> {
  @override
  Widget build(BuildContext context) {
    final didBet = ref.watch(currentPlayerProvider.select((e) => e.didBet));
    final betAmount = ref.watch(currentPlayerProvider.select((e) => e.bet));
    final isSplitAndDoubleDownDisabled = ref.watch(
            currentPlayerProvider.select((e) => e.didSplitOrDoubleDown)) ||
        betAmount * 2 >
            ref.read(currentPlayerProvider.select((e) => e.totalCash));

    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: Column(
        children: [
          LayoutBuilder(builder: (context, constarins) {
            final crispWidth = constarins.maxWidth / 3 - 27 * 2 / 3;
            return Row(
              children: [
                Crisp(color: CrispyColors.green, value: 5, width: crispWidth),
                const SizedBox(
                  width: 27.0,
                ),
                Crisp(color: CrispyColors.red, value: 20, width: crispWidth),
                const SizedBox(
                  width: 27.0,
                ),
                Crisp(color: CrispyColors.blue, value: 50, width: crispWidth),
              ],
            );
          }),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (didBet) ...[
                CrispyButton(
                  label: "Stand",
                  onPressed: () =>
                      ref.read(tableControllerProvider).splitOrStand(),
                  isDisabled: isSplitAndDoubleDownDisabled,
                ),
                const SizedBox(
                  width: 17,
                ),
                CrispyButton(
                  label: "Split",
                  isDisabled: isSplitAndDoubleDownDisabled,
                  onPressed: () =>
                      ref.read(tableControllerProvider).splitOrStand(),
                ),
              ] else ...[
                CrispyButton(
                  icon: const Icon(Icons.close),
                  isDisabled: betAmount == 0,
                  onPressed: () =>
                      ref.read(tableControllerProvider).cancelBet(),
                ),
                const SizedBox(
                  width: 17,
                ),
                CrispyButton(
                  icon: const Icon(Icons.check),
                  isDisabled: betAmount == 0,
                  onPressed: () =>
                      ref.read(tableControllerProvider).aproveBet(),
                ),
              ]
            ],
          )
        ],
      ),
    );
  }
}

class Crisp extends ConsumerWidget {
  const Crisp(
      {super.key,
      required this.color,
      required this.value,
      required this.width});

  final Color color;
  final int value;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(currentPlayerProvider);
    final disabled = player.totalCash - value < 0 || player.didBet;

    return GestureDetector(
      onTap: () {
        if (disabled) return;
        ref.read(tableControllerProvider).bet(value);
      },
      child: Opacity(
        opacity: disabled ? 0.57 : 1,
        child: CircularBorder(
          borderWidth: 8,
          color: color,
          width: width,
          child: Container(
            decoration: const BoxDecoration(
                color: CrispyColors.white,
                borderRadius: BorderRadius.all(Radius.circular(149))),
            child: Center(
              child: Text(
                "$value",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
