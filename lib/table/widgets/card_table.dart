import 'package:crispy_fires/colors.dart';
import 'package:crispy_fires/table/table_provider.dart';
import 'package:crispy_fires/table/utils.dart';
import 'package:crispy_fires/table/widgets/player_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardTable extends ConsumerWidget {
  const CardTable({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: LayoutBuilder(builder: (context, constraints) {
        final positions = getPositions(constraints);
        return Stack(clipBehavior: Clip.none, children: [
          AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(28)),
                      border:
                          Border.all(color: CrispyColors.darkBrown, width: 8.0),
                      color: CrispyColors.green))),
          ...ref
              .watch(tableDataProvider)
              .asMap()
              .entries
              .map((e) => PlayerAvatar(
                    name: e.value.name,
                    bet: e.value.bet,
                    totalCash: e.value.totalCash,
                    position: positions[e.key],
                  ))
        ]);
      }),
    );
  }
}



