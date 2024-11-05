import 'package:crispy_fires/table/widgets/player_avatar.dart';
import 'package:flutter/material.dart';

List<PlayerAvatarPosition> getPositions(BoxConstraints constraints) => [
      PlayerAvatarPosition(
        left: constraints.maxWidth / 2,
        betTopCorrection: 4.5,
      ),
      PlayerAvatarPosition(
        left: constraints.maxWidth,
        topCorrection: 0.5,
        leftCorrection: 1.5,
        betLeftCorrection: -2,
        betTopCorrection: 4,
      ),
      PlayerAvatarPosition(
        top: constraints.maxWidth / 2,
        left: constraints.maxWidth,
        leftCorrection: 1.5,
        betLeftCorrection: -2,
        betTopCorrection: 1.5,
      ),
      PlayerAvatarPosition(
        top: constraints.maxWidth,
        topCorrection: 1.5,
        left: constraints.maxWidth,
        leftCorrection: 1.5,
        betLeftCorrection: -2,
        betTopCorrection: -1,
      ),
      PlayerAvatarPosition(
        top: constraints.maxWidth,
        left: constraints.maxWidth / 2,
        betTopCorrection: -1.5,
      ),
      PlayerAvatarPosition(
        top: constraints.maxWidth,
        topCorrection: 1.5,
        leftCorrection: 0.5,
        betTopCorrection: -1,
        betLeftCorrection: 3,
      ),
      PlayerAvatarPosition(
        top: constraints.maxWidth / 2,
        leftCorrection: 0.5,
        betLeftCorrection: 3,
        betTopCorrection: 1.5,
      ),
      const PlayerAvatarPosition(
        topCorrection: 0.5,
        leftCorrection: 0.5,
        betLeftCorrection: 3,
        betTopCorrection: 4,
      )
    ];

