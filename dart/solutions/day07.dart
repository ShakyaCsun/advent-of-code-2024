import '../utils/index.dart';

class Day07 extends GenericDay {
  Day07() : super(7);

  @override
  List<Calibration> parseInput() {
    final lines = input.getPerLine();
    return lines.map(Calibration.fromLine).toList();
  }

  @override
  int solvePart1() {
    final calibrations = parseInput();
    return calibrations.fold(0, (previousValue, calibration) {
      final containsResult = calibration.canBeTrue();
      return containsResult
          ? previousValue + calibration.result
          : previousValue;
    });
  }

  @override
  int solvePart2() {
    final calibrations = parseInput();
    return calibrations.fold(0, (previousValue, calibration) {
      final containsResult =
          calibration.canBeTrue() || calibration.canBeTrue(stepTwo: true);
      return containsResult
          ? previousValue + calibration.result
          : previousValue;
    });
  }
}

class Calibration {
  const Calibration({required this.result, required this.numbers});

  factory Calibration.fromLine(String line) {
    final [result, numbers, ...] = line.split(': ');
    return Calibration(
      result: int.parse(result),
      numbers: numbers.split(' ').map(int.parse).toList(),
    );
  }

  final int result;
  final List<int> numbers;

  bool canBeTrue({bool stepTwo = false}) {
    return possibleResults(stepTwo: stepTwo).contains(result);
  }

  Iterable<int> possibleResults({bool stepTwo = false}) {
    final [a, b, ...rest] = numbers;
    if (rest.isEmpty) {
      return [if (stepTwo) int.parse('$a$b'), a * b, a + b];
    }
    final resultsCombination = Calibration(
      result: result,
      numbers: [a, b],
    ).possibleResults(stepTwo: stepTwo);
    return resultsCombination
        .map((resultOfTwo) {
          if (resultOfTwo > result) {
            return <int>[];
          }
          return Calibration(
            result: result,
            numbers: [resultOfTwo, ...rest],
          ).possibleResults(stepTwo: stepTwo);
        })
        .expand((element) => element);
  }
}
