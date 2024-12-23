// Puzzle Solutions are null before they are solved and we can skip the tests
// ignore_for_file: unnecessary_null_comparison

import 'package:test/test.dart';

import '../solutions/day17.dart';

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
Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0
''';

/// Paste in the small example that is given for the SECOND PART of the puzzle.
/// It will be evaluated against the `_exampleSolutionPart2` below.
///
/// In case the second part uses the same example, uncomment below line instead:
const _exampleInput2 = '''
Register A: 2024
Register B: 0
Register C: 0

Program: 0,3,5,4,3,0''';

/// The solution for the FIRST PART's example, which is given by the puzzle.
const _exampleSolutionPart1 = '4,6,3,5,6,3,5,2,1,0';

/// The solution for the SECOND PART's example, which is given by the puzzle.
const _exampleSolutionPart2 = 117440;

/// The actual solution for the FIRST PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart1 = '5,0,3,5,7,6,1,5,4';

/// The actual solution for the SECOND PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart2 = 164516454365621;

void main() {
  group('Day 17 - Example Input', () {
    test('Part 1', () {
      final day = Day17()..inputForTesting = _exampleInput1;
      expect(day.solvePart1(), _exampleSolutionPart1);
    });
    test('Part 2', skip: true, () {
      final day = Day17()..inputForTesting = _exampleInput2;
      expect(day.solvePart2(), _exampleSolutionPart2);
    });
  });
  group('Day 17 - Puzzle Input', () {
    final day = Day17();
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
