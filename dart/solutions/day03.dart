import '../utils/index.dart';

class Day03 extends GenericDay {
  Day03() : super(3);

  @override
  List<(int, int)> parseInput() {
    final lines = input.getPerLine();
    final mulPattern = RegExp(r'mul\((\d+),(\d+)\)');
    return lines.fold(<(int, int)>[], (previousValue, line) {
      final matches = mulPattern.allMatches(line);
      return [
        ...previousValue,
        ...matches.map((match) {
          return (int.parse(match[1]!), int.parse(match[2]!));
        }),
      ];
    });
  }

  List<(int, int)> parseInput2() {
    final lines = input.getPerLine();
    final mulPattern = RegExp(r'mul\((\d+),(\d+)\)');
    const doPattern = 'do()';
    const dontPattern = "don't()";
    final jointLines = lines.join();

    final doLines = jointLines.split(doPattern);
    return doLines.fold(<(int, int)>[], (previousValue, element) {
      final doLine = element.split(dontPattern)[0];
      final matches = mulPattern.allMatches(doLine);
      return [
        ...previousValue,
        ...matches.map((match) {
          return (int.parse(match[1]!), int.parse(match[2]!));
        }),
      ];
    });
  }

  @override
  int solvePart1() {
    return parseInput().fold(0, (previousValue, element) {
      final (a, b) = element;
      return previousValue + a * b;
    });
  }

  @override
  int solvePart2() {
    return parseInput2().fold(0, (previousValue, element) {
      final (a, b) = element;
      return previousValue + a * b;
    });
  }
}
