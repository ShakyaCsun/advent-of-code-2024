import 'package:equatable/equatable.dart';
import 'package:trotter/trotter.dart';

import '../utils/index.dart';

class Day21 extends GenericDay {
  Day21() : super(21);

  @override
  List<String> parseInput() {
    return input.getPerLine();
  }

  @override
  int solvePart1() {
    final codes = parseInput();
    final cache = <CacheKey, int>{};
    return codes.fold(0, (previousValue, code) {
      final inputDirections = inputsFor(code);
      final minSequenceLength =
          inputDirections
              .map((directions) => computeLength(directions, cache: cache))
              .min;
      final numericPart = int.parse(code.replaceAll('A', ''));
      return previousValue + numericPart * minSequenceLength;
    });
  }

  @override
  int solvePart2() {
    final codes = parseInput();
    final cache = <CacheKey, int>{};
    return codes.fold(0, (previousValue, code) {
      final inputDirections = inputsFor(code);
      // print('$code: $inputDirections');
      final minSequenceLength =
          inputDirections
              .map(
                (directions) =>
                    computeLength(directions, cache: cache, depth: 25),
              )
              .min;
      final numericPart = int.parse(code.replaceAll('A', ''));
      return previousValue + numericPart * minSequenceLength;
    });
  }

  int computeLength(
    List<DirectionalKey> directions, {
    required Map<CacheKey, int> cache,
    int depth = 2,
  }) {
    final cacheKey = CacheKey(directions: directions, depth: depth);
    if (cache.containsKey(cacheKey)) {
      return cache[cacheKey]!;
    }
    final pairs = [DirectionalKey.activate, ...directions].adjacentPairs;
    final length = pairs.fold(0, (previousValue, element) {
      final (start, goal) = element;
      return previousValue +
          switch (depth) {
            <= 1 => stepsForKeypad(start, goal).first.length,
            _ =>
              stepsForKeypad(start, goal).map((directions) {
                return computeLength(
                  directions,
                  cache: cache,
                  depth: depth - 1,
                );
              }).min,
          };
    });
    cache[cacheKey] = length;
    return length;
  }

  /// Returns all optimal ways to enter given [code] using a Directional Keypad
  List<List<DirectionalKey>> inputsFor(String code) {
    return <NumericKey>[
      NumericKey.activate,
      ...code.split('').map(NumericKey.fromLabel),
    ].adjacentPairs.fold<List<List<DirectionalKey>>>(const [[]], (
      previousValue,
      element,
    ) {
      final (start, goal) = element;
      return previousValue.expand((previousDirections) {
        return stepsForKeypad(
          start,
          goal,
          useDirectional: false,
        ).map((directions) => [...previousDirections, ...directions]);
      }).toList();
    });
  }

  /// Returns list of possible [DirectionalKey] sequence to go from [start] to
  /// [goal].
  ///
  /// When [useDirectional] is `true`, [DirectionalKey] is used to check valid
  /// [Position]s, otherwise [NumericKey] is used.
  /// Defaults to `true`
  List<List<DirectionalKey>> stepsForKeypad(
    KeyPad start,
    KeyPad goal, {
    bool useDirectional = true,
  }) {
    if (start == goal) {
      return [
        [DirectionalKey.activate],
      ];
    }
    final (x, y) = goal.position - start.position;

    final leftRight = List.filled(
      x.abs(),
      x > 0 ? DirectionalKey.right : DirectionalKey.left,
    );
    final upDown = List.filled(
      y.abs(),
      y > 0 ? DirectionalKey.down : DirectionalKey.up,
    );
    if (leftRight.isEmpty) {
      return [
        [...upDown, DirectionalKey.activate],
      ];
    }
    if (upDown.isEmpty) {
      return [
        [...leftRight, DirectionalKey.activate],
      ];
    }

    bool validDirections(List<DirectionalKey> directions) {
      return followDirections(directions, start.position).none(
        (position) =>
            (useDirectional
                ? DirectionalKey.fromPosition(position)
                : NumericKey.fromPosition(position)) ==
            null,
      );
    }

    final directionSet = [...leftRight, ...upDown];
    return [
      ...directionSet.permutations
          .where(validDirections)
          .map((directions) => [...directions, DirectionalKey.activate]),
    ];
  }

  List<Position> followDirections(
    List<DirectionalKey> directions,
    Position start,
  ) {
    return directions.fold<List<Position>>([], (previousValue, direction) {
      final previousPosition = previousValue.lastOrNull ?? start;
      return switch (direction) {
        DirectionalKey.up => [
          ...previousValue,
          previousPosition + Positions.top,
        ],
        DirectionalKey.activate => previousValue,
        DirectionalKey.left => [
          ...previousValue,
          previousPosition + Positions.left,
        ],
        DirectionalKey.down => [
          ...previousValue,
          previousPosition + Positions.bottom,
        ],
        DirectionalKey.right => [
          ...previousValue,
          previousPosition + Positions.right,
        ],
      };
    });
  }
}

enum DirectionalKey implements KeyPad {
  up('^', (1, 0)),
  activate('A', (2, 0)),
  left('<', (0, 1)),
  down('v', (1, 1)),
  right('>', (2, 1));

  const DirectionalKey(this.label, this.position);

  factory DirectionalKey.fromLabel(String label) {
    return DirectionalKey.values.firstWhere(
      (element) => element.label == label,
    );
  }

  static DirectionalKey? fromPosition(Position position) {
    return DirectionalKey.values.firstWhereOrNull(
      (element) => element.position == position,
    );
  }

  @override
  String toString() {
    return label;
  }

  @override
  final String label;
  @override
  final Position position;
}

enum NumericKey implements KeyPad {
  seven('7', (0, 0)),
  eight('8', (1, 0)),
  nine('9', (2, 0)),
  four('4', (0, 1)),
  five('5', (1, 1)),
  six('6', (2, 1)),
  one('1', (0, 2)),
  two('2', (1, 2)),
  three('3', (2, 2)),
  zero('0', (1, 3)),
  activate('A', (2, 3));

  const NumericKey(this.label, this.position);

  factory NumericKey.fromLabel(String label) {
    return NumericKey.values.firstWhere((element) => element.label == label);
  }

  static NumericKey? fromPosition(Position position) {
    return NumericKey.values.firstWhereOrNull(
      (element) => element.position == position,
    );
  }

  @override
  String toString() {
    return label;
  }

  @override
  final String label;
  @override
  final Position position;
}

abstract class KeyPad {
  const KeyPad(this.label, this.position);

  final String label;
  final Position position;
}

extension PermutationList<T> on List<T> {
  List<List<T>> get permutations {
    final length = this.length;
    return EqualitySet.from(
      ListEquality<T>(),
      Permutations(
        length,
        List.generate(length, (index) => index),
      )().map((e) => e.map(elementAt).toList()),
    ).toList();
  }
}

class CacheKey extends Equatable {
  const CacheKey({required this.directions, required this.depth});

  final List<DirectionalKey> directions;
  final int depth;

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [depth, directions];
}
