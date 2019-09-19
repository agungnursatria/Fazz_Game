import 'dart:math';

import 'package:fazz_game/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fazz_game/page/maze/bloc/maze_bloc.dart';
import 'package:fazz_game/page/maze/bloc/maze_event.dart';
import 'package:fazz_game/page/maze/bloc/maze_state.dart';
import 'package:fazz_game/page/maze/maze_view.dart';
import 'package:fazz_game/page/maze/data.dart';

class Maze extends StatefulWidget {
  static const PATH = '/maze';
  static const TAG = 'Maze Game';

  @override
  _MazeState createState() => _MazeState();
}

class _MazeState extends State<Maze> {
  double canvasSize = 0;
  MazeBloc mazeBloc;

  @override
  void initState() {
    super.initState();
    mazeBloc = MazeBloc();
    mazeBloc.dispatch(StartGame());

    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrame());
  }

  onPostFrame() {
    setState(() {
      canvasSize = min(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height) -
          64;
    });
  }

  @override
  void dispose() {
    mazeBloc.dispose();
    super.dispose();
  }

  onTryAgain() {
    mazeBloc.dispatch(StartGame());
  }

  onMove(
    int currentPosition,
    int rowNumber,
    List<Direction> blockedDirection,
    Direction targetDirection,
  ) {
    mazeBloc.dispatch(Move(
      blockedDirection: blockedDirection,
      currentPosition: currentPosition,
      rowNumber: rowNumber,
      targetDirection: targetDirection,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fazz Maze'),
        backgroundColor: colorPrimary,
      ),
      body: BlocListener(
        bloc: mazeBloc,
        listener: (BuildContext context, MazeState state) {
          if (state is MazeRunning && state.errorMessage.isNotEmpty) {
            final snackBar = SnackBar(content: Text(state.errorMessage));
            Scaffold.of(context).showSnackBar(snackBar);
            mazeBloc.dispatch(ClearErrorMessage());
          }
        },
        child: BlocBuilder(
          bloc: mazeBloc,
          builder: (BuildContext context, MazeState state) {
            return MazeView(
              canvasSize: canvasSize,
              currentIndexPosition:
                  (state is MazeRunning) ? state.currentIndexPosition : -1,
              finishIndexPosition:
                  (state is MazeRunning) ? state.finishIndexPosition : -1,
              numberOfStep: (state is MazeFinished) ? state.finalStep : -1,
              onMove: onMove,
              onTryAgain: onTryAgain,
              isFinished: state is MazeFinished,
              isRunning: state is MazeRunning,
              isInitial: state is MazeInitial,
            );
          },
        ),
      ),
    );
  }
}
