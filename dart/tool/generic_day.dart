import 'package:meta/meta.dart';
import 'package:timing/timing.dart';

import '../utils/input_util.dart';

typedef SolveFunction = Object Function();
typedef SolutionWithDuration = (Object, Duration);

/// Provides the [InputUtil] for given day and a [printSolutions] method to show
/// the puzzle solutions for given day.
abstract class GenericDay {
  GenericDay(this.day) : input = InputUtil(day);
  final int day;
  InputUtil input;

  /// This setter must only be used to mutate the input of an existing day
  /// implementation for testing purposes.
  @visibleForTesting
  // Used only for testing
  // ignore: avoid_setters_without_getters
  set inputForTesting(String example) =>
      input = InputUtil.fromMultiLineString(example);

  dynamic parseInput();
  Object solvePart1();
  Object solvePart2();

  void printSolutions() {
    final result1 = _solveAndTrackTime(solvePart1);
    final result2 = _solveAndTrackTime(solvePart2);

    print('-------------------------');
    print('         Day $day        ');
    print('Solution for part one: ${_formatResult(result1)}');
    print('Solution for part two: ${_formatResult(result2)}');
    print('\n');
  }

  SolutionWithDuration _solveAndTrackTime(SolveFunction solve) {
    final tracker = SyncTimeTracker();
    late final Object solution;
    tracker.track(() => solution = solve());
    return (solution, tracker.duration);
  }

  String _formatResult(SolutionWithDuration result) {
    final (solution, duration) = result;
    return '$solution - Took ${duration.inMilliseconds} milliseconds';
  }
}
