// Puzzle Solutions are null before they are solved and we can skip the tests
// ignore_for_file: unnecessary_null_comparison

import 'package:test/test.dart';

import '../solutions/day16.dart';

// *******************************************************************
// Fill out the variables below according to the puzzle description!
// The test code should usually not need to be changed, apart from uncommenting
// the puzzle tests for regression testing.
// *******************************************************************

/// Paste in the small example that is given for the FIRST PART of the puzzle.
/// It will be evaluated against the `_exampleSolutionPart1` below.
/// Make sure to respect the multiline string format to avoid additional
/// newlines at the end.
const _exampleInput1 = '''
###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############
''';

/// Paste in the small example that is given for the SECOND PART of the puzzle.
/// It will be evaluated against the `_exampleSolutionPart2` below.
///
/// In case the second part uses the same example, uncomment below line instead:
const _exampleInput2 = '''
#################
#...#...#...#..E#
#.#.#.#.#.#.#.#.#
#.#.#.#...#...#.#
#.#.#.#.###.#.#.#
#...#.#.#.....#.#
#.#.#.#.#.#####.#
#.#...#.#.#.....#
#.#.#####.#.###.#
#.#.#.......#...#
#.#.###.#####.###
#.#.#...#.....#.#
#.#.#.#####.###.#
#.#.#.........#.#
#.#.#.#########.#
#S#.............#
#################''';

/// The solution for the FIRST PART's example, which is given by the puzzle.
const _exampleSolutionPart1Input1 = 7036;
const _exampleSolutionPart1 = 11048;

/// The solution for the SECOND PART's example, which is given by the puzzle.
const _exampleSolutionPart2Input1 = 45;
const _exampleSolutionPart2 = 64;

/// The actual solution for the FIRST PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart1 = 109516;

/// The actual solution for the SECOND PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart2 = 568;

void main() {
  group('Day 16 - Example Input 1', () {
    test('Part 1', () {
      final day = Day16()..inputForTesting = _exampleInput1;
      expect(day.solvePart1(), _exampleSolutionPart1Input1);
    });
    test('Part 2', () {
      final day = Day16()..inputForTesting = _exampleInput1;
      expect(day.solvePart2(), _exampleSolutionPart2Input1);
    });
  });
  group('Day 16 - Example Input 2', () {
    test('Part 1', () {
      final day = Day16()..inputForTesting = _exampleInput2;
      expect(day.solvePart1(), _exampleSolutionPart1);
    });
    test('Part 2', () {
      final day = Day16()..inputForTesting = _exampleInput2;
      expect(day.solvePart2(), _exampleSolutionPart2);
    });
  });
  group('Day 16 - Puzzle Input', () {
    final day = Day16();
    test(
      'Part 1',
      skip:
          _puzzleSolutionPart1 == null
              ? 'Skipped because _puzzleSolutionPart1 is null'
              : false,
      () => expect(day.solvePart1(), _puzzleSolutionPart1),
    );
    test(
      'Part 2',
      skip:
          _puzzleSolutionPart2 == null
              ? 'Skipped because _puzzleSolutionPart2 is null'
              : false,
      () => expect(day.solvePart2(), _puzzleSolutionPart2),
    );
  });
}
