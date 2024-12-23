// Puzzle Solutions are null before they are solved and we can skip the tests
// ignore_for_file: unnecessary_null_comparison

import 'package:test/test.dart';

import '../solutions/day23.dart';

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
kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn
''';

/// Paste in the small example that is given for the SECOND PART of the puzzle.
/// It will be evaluated against the `_exampleSolutionPart2` below.
///
/// In case the second part uses the same example, uncomment below line instead:
const _exampleInput2 = _exampleInput1;

/// The solution for the FIRST PART's example, which is given by the puzzle.
const _exampleSolutionPart1 = 7;

/// The solution for the SECOND PART's example, which is given by the puzzle.
const _exampleSolutionPart2 = 'co,de,ka,ta';

/// The actual solution for the FIRST PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart1 = 1437;

/// The actual solution for the SECOND PART of the puzzle, based on your input.
/// This can only be filled out after you have solved the puzzle and is used
/// for regression testing when refactoring.
/// As long as the variable is `null`, the tests will be skipped.
const _puzzleSolutionPart2 = 'da,do,gx,ly,mb,ns,nt,pz,sc,si,tp,ul,vl';

void main() {
  group('Day 23 - Example Input', () {
    test('Part 1', () {
      final day = Day23()..inputForTesting = _exampleInput1;
      expect(day.solvePart1(), _exampleSolutionPart1);
    });
    test('Part 2', () {
      final day = Day23()..inputForTesting = _exampleInput2;
      expect(day.largestLan(), _exampleSolutionPart2);
    });
  });
  group('Day 23 - Puzzle Input', () {
    final day = Day23();
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
      () => expect(day.largestLan(), _puzzleSolutionPart2),
    );
  });
}
