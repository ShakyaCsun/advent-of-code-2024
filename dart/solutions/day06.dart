import '../utils/index.dart';

class Day06 extends GenericDay {
  Day06() : super(6);

  @override
  Field<String> parseInput() {
    final grid = input.getPerLine().map(
      (line) {
        return line.split('');
      },
    ).toList();
    return Field(grid);
  }

  @override
  int solvePart1() {
    final field = parseInput();
    final startPosition = field.allPositions.firstWhere(
      (element) => field.getValueAtPosition(element) == '^',
    );

    return travelField(field, Direction.up, startPosition).length;
  }

  @override
  int solvePart2() {
    final field = parseInput();
    final startPosition = field.allPositions.firstWhere(
      (element) => field.getValueAtPosition(element) == '^',
    );

    final path = travelField(field, Direction.up, startPosition);
    return path.difference({startPosition}).fold(
      0,
      (previousValue, position) {
        final newField = field.copy()..setValueAtPosition(position, '#');
        if (travelingInLoop(newField, Direction.up, startPosition, const {})) {
          return previousValue + 1;
        }
        return previousValue;
      },
    );
  }

  Set<Position> travelField(
    Field<String> field,
    Direction direction,
    Position startPosition,
  ) {
    final nextPosition = startPosition + direction.offset;
    if (field.isOnField(nextPosition)) {
      final next = field.getValueAtPosition(nextPosition);
      if (next == '#') {
        return travelField(field, direction.turnRight(), startPosition);
      } else {
        return {
          startPosition,
          ...travelField(field, direction, nextPosition),
        };
      }
    }
    return {startPosition};
  }

  bool travelingInLoop(
    Field<String> field,
    Direction direction,
    Position startPosition,
    Set<(Position, Direction)> knownRightTurns,
  ) {
    final nextPosition = startPosition + direction.offset;

    if (field.isOnField(nextPosition)) {
      final next = field.getValueAtPosition(nextPosition);
      if (next == '#') {
        final rightTurn = (startPosition, direction.turnRight());
        if (knownRightTurns.contains(rightTurn)) {
          return true;
        }
        return travelingInLoop(
          field,
          direction.turnRight(),
          startPosition,
          {...knownRightTurns, rightTurn},
        );
      }
      return travelingInLoop(
        field,
        direction,
        nextPosition,
        knownRightTurns,
      );
    }
    return false;
  }
}

enum Direction {
  up('^'),
  down('v'),
  left('<'),
  right('>');

  const Direction(this.symbol);

  final String symbol;

  Direction turnRight() {
    return switch (this) {
      Direction.up => Direction.right,
      Direction.down => Direction.left,
      Direction.left => Direction.up,
      Direction.right => Direction.down,
    };
  }

  Position get offset {
    return switch (this) {
      Direction.up => Positions.top,
      Direction.down => Positions.bottom,
      Direction.left => Positions.left,
      Direction.right => Positions.right,
    };
  }
}
