import '../utils/index.dart';

class Day02 extends GenericDay {
  Day02() : super(2);

  @override
  List<List<int>> parseInput() {
    return input.getPerLine().map((line) {
      return line.split(' ').map(int.parse).toList();
    }).toList();
  }

  @override
  int solvePart1() {
    final reports = parseInput();
    return reports.fold(0, (previousValue, levels) {
      if (isSafe(levels)) {
        return previousValue + 1;
      }
      return previousValue;
    });
  }

  @override
  int solvePart2() {
    final reports = parseInput();
    return reports.fold(0, (previousValue, levels) {
      if (isSafe(levels)) {
        return previousValue + 1;
      }
      return levels.indexed
              .map((e) {
                final (index, _) = e;
                final newLevels = [...levels]..removeAt(index);
                return isSafe(newLevels);
              })
              .any((element) => element)
          ? previousValue + 1
          : previousValue;
    });
  }

  bool isSafe(List<int> levels) {
    bool inSafeRange(int difference, {bool increasing = true}) {
      if (increasing) {
        return difference >= 1 && difference <= 3;
      }
      return difference >= -3 && difference <= -1;
    }

    final differences = [
      for (final (index, level) in levels.indexed.take(levels.length - 1))
        levels[index + 1] - level,
    ];
    if (differences.every(inSafeRange)) {
      return true;
    }
    return differences.every(
      (difference) => inSafeRange(difference, increasing: false),
    );
  }
}
