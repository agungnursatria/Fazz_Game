import 'package:bloc/bloc.dart';
import 'package:fazz_game/page/maze/bloc/maze_event.dart';
import 'package:fazz_game/page/maze/bloc/maze_state.dart';
import 'package:fazz_game/page/maze/data.dart';

class MazeBloc extends Bloc<MazeEvent, MazeState> {
  @override
  MazeState get initialState => MazeInitial();

  @override
  Stream<MazeState> mapEventToState(MazeEvent event) async* {
    if (event is StartGame) {
      yield MazeRunning.initial();
    } else if (event is Move && currentState is MazeRunning) {
      MazeRunning currState = currentState as MazeRunning;

      if (!event.blockedDirection.contains(event.targetDirection)) {
        int newNumOfStep = currState.numberOfStep + 1;

        int newIndex;
        switch (event.targetDirection) {
          case Direction.Left:
            newIndex = currState.currentIndexPosition - 1;
            break;
          case Direction.Right:
            newIndex = currState.currentIndexPosition + 1;
            break;
          case Direction.Top:
            newIndex = currState.currentIndexPosition - event.rowNumber;
            break;
          case Direction.Bottom:
            newIndex = currState.currentIndexPosition + event.rowNumber;
            break;
          default:
            throw "Unidentified Direction";
        }

        if (newIndex == currState.finishIndexPosition) {
          yield MazeFinished(finalStep: newNumOfStep);
        } else {
          yield currState.copyWith(
            currentIndex: newIndex,
            numberOfStep: newNumOfStep,
          );
        }
      } else {
        yield currState.copyWith(
            isError:
                "Current direction is blocked, please move to another direction.");
      }
    } else if (event is ClearErrorMessage) {
      yield (currentState as MazeRunning).copyWith(isError: '');
    }
  }
}
