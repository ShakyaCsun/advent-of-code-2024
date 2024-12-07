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
    return calibrations.fold(
      0,
      (previousValue, calibration) {
        final containsResult =
            calibration.possibleResults().contains(calibration.result);
        return containsResult
            ? previousValue + calibration.result
            : previousValue;
      },
    );
  }

  @override
  int solvePart2() {
    final calibrations = parseInput();
    return calibrations.fold(
      0,
      (previousValue, calibration) {
        final containsResult =
            calibration.possibleResults2().contains(calibration.result);
        return containsResult
            ? previousValue + calibration.result
            : previousValue;
      },
    );
  }
}

class Calibration {
  Calibration({required this.result, required this.numbers});

  factory Calibration.fromLine(String line) {
    final [result, numbers, ...] = line.split(': ');
    return Calibration(
      result: int.parse(result),
      numbers: numbers.split(' ').map(int.parse).toList(),
    );
  }

  final int result;
  final List<int> numbers;

  List<int> possibleResults() {
    if (numbers.length == 2) {
      return [
        ...Operator.values.map(
          (e) {
            return e.apply(numbers[0], numbers[1]);
          },
        ),
      ];
    }
    final possibleResults = Calibration(
      result: result,
      numbers: numbers.take(2).toList(),
    ).possibleResults();
    return possibleResults
        .map(
          (resultOfTwo) {
            if (resultOfTwo > result) {
              return <int>[];
            }
            return Calibration(
              result: result,
              numbers: [resultOfTwo, ...numbers.skip(2)],
            ).possibleResults();
          },
        )
        .expand(
          (element) => element,
        )
        .toList();
  }

  List<int> possibleResults2() {
    if (numbers.length == 2) {
      return [
        int.parse('${numbers[0]}${numbers[1]}'),
        ...Operator.values.map(
          (e) {
            return e.apply(numbers[0], numbers[1]);
          },
        ),
      ];
    }
    final possibleResults = Calibration(
      result: result,
      numbers: numbers.take(2).toList(),
    ).possibleResults2();
    return possibleResults
        .map(
          (resultOfTwo) {
            if (resultOfTwo > result) {
              return <int>[];
            }
            return Calibration(
              result: result,
              numbers: [resultOfTwo, ...numbers.skip(2)],
            ).possibleResults2();
          },
        )
        .expand(
          (element) => element,
        )
        .toList();
  }
}

enum Operator {
  add,
  multiply;

  int apply(int a, int b) {
    return switch (this) {
      Operator.add => a + b,
      Operator.multiply => a * b,
    };
  }
}
