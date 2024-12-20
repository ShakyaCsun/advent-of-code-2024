import '../utils/index.dart';

class Day08 extends GenericDay {
  Day08() : super(8);

  @override
  Field<String> parseInput() {
    return StringField.fromInput(input);
  }

  @override
  int solvePart1() {
    final field = parseInput();
    final antinodeLocations =
        field.nodeLocations.values
            .map((positions) {
              final pairs = positions.allPairs;
              return pairs.expand((positionPair) {
                return positionPair.antiNodes;
              });
            })
            .expand((element) => element)
            .where(field.isOnField)
            .toSet();
    return antinodeLocations.length;
  }

  @override
  int solvePart2() {
    final field = parseInput();
    final maxCount = field.height;
    final antinodeLocations =
        field.nodeLocations.values
            .map((positions) {
              final pairs = positions.allPairs;
              return pairs.expand((positionPair) {
                return positionPair.antiNodesTwo(field.isOnField, maxCount);
              });
            })
            .expand((element) => element)
            .toSet();
    return antinodeLocations.length;
  }
}

extension PositionPairX on (Position, Position) {
  Set<Position> get antiNodes {
    final (a, b) = this;
    return {a + (a - b), b + (b - a)};
  }

  Set<Position> antiNodesTwo(
    bool Function(Position value) testPosition,
    int count,
  ) {
    final (a, b) = this;
    final difference = a - b;
    return {
      ...List.generate(count, (_) => a)
          .mapIndexed((i, e) {
            return e + difference * i;
          })
          .takeWhile(testPosition),
      ...List.generate(count, (_) => b)
          .mapIndexed((i, e) {
            return e - difference * i;
          })
          .takeWhile(testPosition),
    };
  }
}

extension IterablePairX<T> on Iterable<T> {
  /// Adjacent Pairs of this [Iterable]
  Iterable<(T, T)> get adjacentPairs {
    return take(length - 1).mapIndexed((index, element) {
      return (element, elementAt(index + 1));
    });
  }

  /// All Pair combinations possible for this [Iterable]
  Iterable<(T, T)> get allPairs {
    if (length < 2) {
      return {};
    }
    final first = this.first;
    return {...skip(1).map((e) => (first, e)), ...skip(1).allPairs};
  }
}

extension on Field<String> {
  Map<String, List<Position>> get nodeLocations {
    return allPositions.fold(<String, List<Position>>{}, (
      previousValue,
      position,
    ) {
      final node = getValueAtPosition(position);
      if (node == '.') {
        return previousValue;
      }
      previousValue.update(
        node,
        (value) => [...value, position],
        ifAbsent: () => [position],
      );
      return previousValue;
    });
  }
}
