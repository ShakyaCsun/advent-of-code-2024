import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  @override
  (List<int>, List<int>) parseInput() {
    final left = <int>[];
    final right = <int>[];
    for (final line in input.getPerLine()) {
      final [a, b, ...] = line.split(RegExp(r'\s+')).map(int.parse).toList();
      left.add(a);
      right.add(b);
    }
    return (left, right);
  }

  @override
  int solvePart1() {
    final (left, right) = parseInput();
    right.sort();
    return (left..sort()).foldIndexed(
      0,
      (index, previous, element) {
        return previous + (element - right[index]).abs();
      },
    );
  }

  @override
  int solvePart2() {
    final (left, right) = parseInput();
    return left.fold(
      0,
      (previousValue, element) {
        return previousValue +
            element *
                right
                    .where(
                      (r) => r == element,
                    )
                    .length;
      },
    );
  }
}
