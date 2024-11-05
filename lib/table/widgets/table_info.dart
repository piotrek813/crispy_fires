
import 'package:crispy_fires/colors.dart';
import 'package:flutter/material.dart';

class TableInfo extends StatelessWidget {
  const TableInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 20, color: CrispyColors.white);
    return Padding(
      padding: const EdgeInsets.only(left: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Kolej na:",
                  style: textStyle.copyWith(fontWeight: FontWeight.bold)),
              const Text("Piter", style: textStyle)
            ],
          ),
          Container(
              width: 25,
              height: 45,
              decoration: const BoxDecoration(
                color: CrispyColors.blue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4)),
              ))
        ],
      ),
    );
  }
}
