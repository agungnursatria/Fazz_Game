import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MazeState extends Equatable {
  MazeState([List props = const []]) : super(props);
}

class MazeInitial extends MazeState {}

class MazeRunning extends MazeState {
  final int currentIndexPosition;
  final int finishIndexPosition;
  final int numberOfStep;
  final String errorMessage;

  MazeRunning({
    @required this.currentIndexPosition,
    @required this.finishIndexPosition,
    @required this.numberOfStep,
    @required this.errorMessage,
  }) : super([
          currentIndexPosition,
          finishIndexPosition,
          numberOfStep,
          errorMessage
        ]);

  static MazeRunning initial() {
    // based on number of column & row = 5
    return MazeRunning(
      currentIndexPosition: 20,
      finishIndexPosition: 4,
      numberOfStep: 0,
      errorMessage: '',
    );
  }

  MazeRunning copyWith({
    int currentIndex,
    int finishIndex,
    int numberOfStep,
    String isError,
  }) {
    return MazeRunning(
      currentIndexPosition: currentIndex ?? this.currentIndexPosition,
      finishIndexPosition: finishIndex ?? this.finishIndexPosition,
      numberOfStep: numberOfStep ?? this.numberOfStep,
      errorMessage: isError ?? this.errorMessage,
    );
  }
}

class MazeFinished extends MazeState {
  int finalStep;
  MazeFinished({@required this.finalStep});
}
