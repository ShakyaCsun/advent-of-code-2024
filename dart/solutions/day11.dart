import 'dart:math';

import '../utils/index.dart';

class Day11 extends GenericDay {
  Day11() : super(11);

  @override
  List<int> parseInput() {
    return input.asString.trim().split(' ').map(int.parse).toList();
  }

  @override
  int solvePart1() {
    final stones = parseInput();
    return blinkMultiple(blink, stones).length;
  }

  @override
  int solvePart2() {
    final stoneCount = parseInput().stoneCount;
    return blinkMultiple(
      blinkOptimized,
      stoneCount,
      times: 75,
    ).values.fold(0, (previousValue, element) => previousValue + element);
  }

  T blinkMultiple<T>(T Function(T) blink, T stones, {int times = 25}) {
    if (times <= 0) {
      return stones;
    }
    return blinkMultiple(blink, blink(stones), times: times - 1);
  }

  List<int> blink(List<int> stones) {
    return stones
        .map<List<int>>((number) {
          if (number == 0) {
            return [1];
          }
          if (number.digitCount.isEven) {
            final (left, right) = number.halves;
            return [left, right];
          }
          return [number * 2024];
        })
        .expand((element) => element)
        .toList();
  }

  Map<int, int> blinkOptimized(Map<int, int> stoneCounts) {
    return stoneCounts.entries
        .map((e) {
          final MapEntry(key: stone, value: count) = e;
          final nextStones = blink([stone]);
          return nextStones.stoneCount
            ..updateAll((key, value) => value * count);
        })
        .fold(<int, int>{}, (previousValue, element) {
          return element.entries.fold(previousValue, (stoneCount, entry) {
            final MapEntry(:key, value: count) = entry;
            stoneCount.update(
              key,
              (value) => value + count,
              ifAbsent: () => count,
            );
            return stoneCount;
          });
        });
  }
}

extension on int {
  int get digitCount {
    if (this ~/ 10 == 0) {
      return 1;
    }
    return 1 + (this ~/ 10).digitCount;
  }

  (int, int) get halves {
    final halfTen = pow(10, digitCount ~/ 2).toInt();
    return (this ~/ halfTen, this % halfTen);
  }
}

extension on List<int> {
  Map<int, int> get stoneCount {
    return fold(<int, int>{}, (previousValue, element) {
      previousValue.update(element, (value) => value + 1, ifAbsent: () => 1);
      return previousValue;
    });
  }
}
