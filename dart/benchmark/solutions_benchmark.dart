import 'package:benchmark_harness/benchmark_harness.dart';

import '../solutions/index.dart';
import '../utils/index.dart';

enum Part {
  one,
  two;

  @override
  String toString() {
    return switch (this) {
      Part.one => 'Part 1',
      Part.two => 'Part 2',
    };
  }
}

// Create a new benchmark by extending BenchmarkBase
class SolutionsBenchmark extends BenchmarkBase {
  SolutionsBenchmark({
    required GenericDay day,
    required Part part,
  })  : _solve = switch (part) {
          Part.one => day.solvePart1,
          Part.two => day.solvePart2,
        },
        super('Solutions Day ${day.day} $part');

  final void Function() _solve;

  // The benchmark code.
  @override
  void run() {
    _solve();
  }
}

void runBenchmark(List<GenericDay> days) {
  for (final day in days) {
    SolutionsBenchmark(day: day, part: Part.one).report();
    SolutionsBenchmark(day: day, part: Part.two).report();
  }
}

void main() {
  final days = [
    Day01(),
    Day02(),
    Day03(),
    Day04(),
    Day05(),
    Day06(),
    Day07(),
    Day08(),
    Day09(),
    Day10(),
  ];
  runBenchmark(days);
}
