import '../utils/index.dart';

class Day22 extends GenericDay {
  Day22() : super(22);

  @override
  List<int> parseInput() {
    return input.getPerLine().map(int.parse).toList(growable: false);
  }

  @override
  int solvePart1() {
    return parseInput().fold(0, (previousValue, element) {
      return previousValue + generateSecret(element, 2000);
    });
  }

  @override
  int solvePart2() {
    final numbers = parseInput();
    final sequences = numbers.map(sequencesOfPositiveChange).toList();
    final allSequencesWithCount = sequences.fold(
      <(int, int, int, int), int>{},
      (previousValue, priceChangeMap) {
        return priceChangeMap.keys.fold(previousValue, (
          previousValue,
          sequence,
        ) {
          previousValue.update(
            sequence,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
          return previousValue;
        });
      },
    );
    final bananas = allSequencesWithCount.entries
        .sorted((a, b) => b.value.compareTo(a.value))
        // Take the 22 most recurring sequences in the day 22 of Advent of Code
        .take(22)
        .map((entry) {
          final MapEntry(key: sequence, value: count) = entry;

          final bananaCount = sequences.fold(0, (
            previousValue,
            priceChangeMap,
          ) {
            return previousValue + (priceChangeMap[sequence] ?? 0);
          });
          // print(
          //   'Price change $sequence common in $count buyers gives us '
          //   '$bananaCount bananas',
          // );
          return bananaCount;
        });
    return bananas.max;
  }

  static const pruner = 16777216;

  int generateSecret(int secret, int after) {
    var current = secret;
    for (var i = 0; i < after; i++) {
      current = nextSecret(current);
    }
    return current;
  }

  int nextSecret(int secret) {
    var next = secret;
    next = ((next * 64) ^ next) % pruner;
    next = ((next ~/ 32) ^ next) % pruner;
    next = ((next * 2048) ^ next) % pruner;
    return next;
  }

  /// Sequence of 4 price changes that improves the price
  Map<(int, int, int, int), int> sequencesOfPositiveChange(int secret) {
    final allPricesWithChange = <(int, int)>[];
    var current = secret;
    for (var i = 0; i < 2000; i++) {
      final previousPrice = current % 10;
      current = nextSecret(current);
      final newPrice = current % 10;
      allPricesWithChange.add((newPrice, newPrice - previousPrice));
    }
    final positiveSequence = <(int, int, int, int), int>{};

    for (final (i, (price, change)) in allPricesWithChange.skip(3).indexed) {
      final index = i + 3;
      if (change >= 0) {
        final [
          (_, changeOne),
          (_, changeTwo),
          (_, changeThree),
        ] = allPricesWithChange.sublist(i, index);
        final totalChange = changeOne + changeTwo + changeThree + change;
        if (totalChange > 0) {
          final tuple = (changeOne, changeTwo, changeThree, change);
          positiveSequence.putIfAbsent(tuple, () => price);
        }
      }
    }

    return positiveSequence;
  }
}
