import 'package:crispy_fires/colors.dart';
import 'package:crispy_fires/table/widgets/betting_part.dart';
import 'package:crispy_fires/table/widgets/card_table.dart';
import 'package:crispy_fires/table/widgets/table_info.dart';
import 'package:flutter/material.dart';

class TableScreen extends StatelessWidget {
  const TableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CrispyColors.background,
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TableInfo(),
          SizedBox(
            height: 14,
          ),
          CardTable(),
          SizedBox(
            height: 25,
          ),
          BettingPart()
        ],
      ),
    );
  }
}
