
import 'package:crispy_fires/colors.dart';
import 'package:crispy_fires/widgets/player_photo.dart';
import 'package:flutter/material.dart';

class PlayerAvatarPosition {
  const PlayerAvatarPosition({
    this.top = 0,
    this.left = 0,
    this.topCorrection = 1,
    this.leftCorrection = 1,
    this.betTopCorrection,
    this.betLeftCorrection,
  });

  final double top;
  final double left;
  final double topCorrection;
  final double leftCorrection;
  final double? betTopCorrection;
  final double? betLeftCorrection;
}

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar(
      {super.key,
      required this.name,
      required this.totalCash,
      required this.bet,
      this.position = const PlayerAvatarPosition()});

  final PlayerAvatarPosition position;
  final String name;
  final int totalCash;
  final int bet;

  static const _radius = 28.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: position.top - _radius * position.topCorrection,
        left: position.left - _radius * position.leftCorrection,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                PlayerPhoto(radius: _radius, name: name),
              ],
            ),
            Positioned(
              top: _radius * 1.8,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: const BoxDecoration(
                      color: CrispyColors.lightBrown,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: Text(
                    "$name\n$totalCash",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: CrispyColors.white),
                  )),
            ),
            Positioned(
              top: position.betTopCorrection == null
                  ? null
                  : _radius * position.betTopCorrection!,
              left: position.betLeftCorrection == null
                  ? null
                  : _radius * position.betLeftCorrection!,
              child: Text(
                "$bet",
                style: const TextStyle(color: CrispyColors.white),
              ),
            ),
          ],
        ));
  }
}
