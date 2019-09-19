import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fazz_game/page/maze/data.dart';

abstract class MazeEvent extends Equatable {
  MazeEvent([List props = const []]) : super(props);
}

class StartGame extends MazeEvent {}

class Move extends MazeEvent {
  int currentPosition;
  int rowNumber;
  List<Direction> blockedDirection;
  Direction targetDirection;

  Move({
    @required this.currentPosition,
    @required this.rowNumber,
    @required this.blockedDirection,
    @required this.targetDirection,
  }) : super([currentPosition, rowNumber, blockedDirection, targetDirection]);
}

class ClearErrorMessage extends MazeEvent {}
