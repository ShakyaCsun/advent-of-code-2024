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
      (element) =>
          field.getValueAtPosition(element) != '.' &&
          field.getValueAtPosition(element) != '#',
    );
    final start = field.getValueAtPosition(startPosition);
    final direction = switch (start) {
      '^' => Direction.up,
      '>' => Direction.right,
      '<' => Direction.left,
      'v' => Direction.down,
      _ => throw StateError('$start is wrong'),
    };

    return travelField(field, direction, startPosition).length;
  }

  @override
  int solvePart2() {
    final field = parseInput();
    final startPosition = field.allPositions.firstWhere(
      (element) =>
          field.getValueAtPosition(element) != '.' &&
          field.getValueAtPosition(element) != '#',
    );
    final start = field.getValueAtPosition(startPosition);
    final direction = switch (start) {
      '^' => Direction.up,
      '>' => Direction.right,
      '<' => Direction.left,
      'v' => Direction.down,
      _ => throw StateError('$start is wrong'),
    };

    final path = travelField(field, direction, startPosition);
    var possibleSolutions = 0;
    for (final position in path.difference({startPosition})) {
      final newField = field.copy()..setValueAtPosition(position, '#');
      if (travelingInLoop(newField, direction, startPosition, {})) {
        possibleSolutions++;
      }
    }
    return possibleSolutions;
  }

  Set<Position> travelField(
    Field<String> field,
    Direction direction,
    Position startPosition,
  ) {
    final nextPosition = switch (direction) {
      Direction.up => startPosition + Positions.top,
      Direction.down => startPosition + Positions.bottom,
      Direction.left => startPosition + Positions.left,
      Direction.right => startPosition + Positions.right,
    };
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
    Set<(Position, Direction)> knownPositions,
  ) {
    final nextPosition = switch (direction) {
      Direction.up => startPosition + Positions.top,
      Direction.down => startPosition + Positions.bottom,
      Direction.left => startPosition + Positions.left,
      Direction.right => startPosition + Positions.right,
    };
    if (field.isOnField(nextPosition)) {
      final next = field.getValueAtPosition(nextPosition);
      if (next == '#') {
        return travelingInLoop(
          field,
          direction.turnRight(),
          startPosition,
          knownPositions..add((startPosition, direction.turnRight())),
        );
      } else {
        final nextInstruction = (nextPosition, direction);
        if (knownPositions.contains(nextInstruction)) {
          return true;
        }
        return travelingInLoop(
          field,
          direction,
          nextPosition,
          knownPositions..add(nextInstruction),
        );
      }
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
}
