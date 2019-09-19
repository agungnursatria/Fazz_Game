import 'package:fazz_game/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:fazz_game/page/maze/data.dart';

class MazeView extends StatelessWidget {
  final int currentIndexPosition;
  final finishIndexPosition;
  final double canvasSize;
  final int numberOfStep;
  final bool isInitial;
  final bool isRunning;
  final bool isFinished;
  final VoidCallback onTryAgain;
  final Function onMove;

  MazeView({
    @required this.finishIndexPosition,
    @required this.currentIndexPosition,
    @required this.canvasSize,
    @required this.numberOfStep,
    this.isInitial = false,
    this.isFinished = false,
    this.isRunning = false,
    @required this.onTryAgain,
    @required this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    if (isInitial) {
      return Center(
        child: Container(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(),
        ),
      );
    } else if (isRunning) {
      return MazeGameArenaView(
        canvasSize: canvasSize,
        currentPosition: currentIndexPosition,
        finishPosition: finishIndexPosition,
        onBackward: () {
          onMove(
            currentIndexPosition,
            sliceNumber,
            blockedDirections[currentIndexPosition],
            Direction.Left,
          );
        },
        onDownward: () {
          onMove(
            currentIndexPosition,
            sliceNumber,
            blockedDirections[currentIndexPosition],
            Direction.Bottom,
          );
        },
        onForward: () {
          onMove(
            currentIndexPosition,
            sliceNumber,
            blockedDirections[currentIndexPosition],
            Direction.Right,
          );
        },
        onUpward: () {
          onMove(
            currentIndexPosition,
            sliceNumber,
            blockedDirections[currentIndexPosition],
            Direction.Top,
          );
        },
      );
    } else if (isFinished) {
      return MazeGameFinishedView(
        onTryAgain: onTryAgain,
        step: numberOfStep,
      );
    }
  }
}

class MazeGameLoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 60,
        width: 60,
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class MazeGameFinishedView extends StatelessWidget {
  int step;
  VoidCallback
      onTryAgain; //TODO: Buat fungsi untuk mengulangi game ketika ditekan
  MazeGameFinishedView({this.step, this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 80,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text('Number of step: $step'),
            SizedBox(height: 16.0),
            FlatButton(
              child: Text('Try Again?'),
              onPressed: onTryAgain,
            ),
          ],
        ),
      ),
    );
  }
}

class MazeGameArenaView extends StatelessWidget {
  double canvasSize = 0;
  int currentPosition;
  int finishPosition;
  VoidCallback onBackward;
  VoidCallback onForward;
  VoidCallback onUpward;
  VoidCallback onDownward;

  MazeGameArenaView({
    @required this.canvasSize,
    @required this.currentPosition,
    @required this.finishPosition,
    @required this.onBackward,
    @required this.onForward,
    @required this.onUpward,
    @required this.onDownward,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Maze Playground
        Container(
          padding: const EdgeInsets.all(32.0).copyWith(top: 56.0),
          child: Table(
            children: List.generate(
              sliceNumber,
              (indexCol) => TableRow(
                children: List.generate(sliceNumber, (indexRow) {
                  int currentIndex = (indexCol * sliceNumber) + indexRow;
                  return MazeBlockView(
                    areaSize: canvasSize / sliceNumber,
                    isCurrentPosition: currentIndex == currentPosition,
                    isFinishPlace: currentIndex == finishPosition,
                    blockedDirection: blockedDirections[currentIndex],
                  );
                }).toList(),
              ),
            ),
          ),
        ),

        //Controller red dot
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              MaterialButton(
                height: 64.0,
                child: Icon(
                  Icons.arrow_left,
                  color: Colors.white,
                ),
                color: colorPrimary,
                onPressed: onBackward,
              ),
              MaterialButton(
                height: 64.0,
                child: Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                ),
                color: colorPrimary,
                onPressed: onForward,
              ),
              MaterialButton(
                height: 64.0,
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                ),
                color: colorPrimary,
                onPressed: onUpward,
              ),
              MaterialButton(
                height: 64.0,
                child: Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                ),
                color: colorPrimary,
                onPressed: onDownward,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class MazeBlockView extends StatelessWidget {
  double areaSize;
  bool isCurrentPosition;
  bool isFinishPlace;
  List<Direction> blockedDirection;

  MazeBlockView({
    this.isCurrentPosition = false,
    this.isFinishPlace = false,
    @required this.areaSize,
    @required this.blockedDirection,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(areaSize, areaSize),
      painter: MazeBlock(
          areaSize: areaSize,
          isCurrentPosition: isCurrentPosition,
          blockedDirection: blockedDirection,
          isFinishPlace: isFinishPlace),
    );
  }
}

class MazeBlock extends CustomPainter {
  double areaSize;
  bool isCurrentPosition;
  bool isFinishPlace;
  List<Direction> blockedDirection;

  MazeBlock({
    @required this.areaSize,
    @required this.isCurrentPosition,
    @required this.blockedDirection,
    @required this.isFinishPlace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(0, 0);
    final p2 = Offset(0, areaSize);
    final p3 = Offset(areaSize, areaSize);
    final p4 = Offset(areaSize, 0);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;

    if (isFinishPlace) {
      final rectPain = Paint()..color = Colors.amber;
      canvas.drawRect(Rect.fromLTRB(0, 0, areaSize, areaSize), rectPain);
    }

    if (blockedDirection.contains(Direction.Left)) {
      canvas.drawLine(p1, p2, paint);
    }

    if (blockedDirection.contains(Direction.Bottom)) {
      canvas.drawLine(p2, p3, paint);
    }

    if (blockedDirection.contains(Direction.Right)) {
      canvas.drawLine(p3, p4, paint);
    }

    if (blockedDirection.contains(Direction.Top)) {
      canvas.drawLine(p4, p1, paint);
    }

    if (isCurrentPosition) {
      final circleOffset = Offset(areaSize / 2, areaSize / 2);
      final circleRadius = areaSize / 10;
      final circlePaint = Paint()
        ..color = Colors.red
        ..strokeWidth = 4;
      canvas.drawCircle(circleOffset, circleRadius, circlePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
