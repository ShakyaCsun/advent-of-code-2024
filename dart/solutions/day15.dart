import 'dart:convert';

import '../utils/index.dart';

class Day15 extends GenericDay {
  Day15() : super(15);

  @override
  (Field<String>, List<Position>) parseInput() {
    final [field, moves, ...] = input.asString.split('\n\n');
    final inputField = Field(
      const LineSplitter()
          .convert(field)
          .map((line) => line.split('').toList())
          .toList(),
    );
    final robotMoves =
        const LineSplitter().convert(moves).join().split('').map((e) {
          return switch (e) {
            '>' => Positions.right,
            '<' => Positions.left,
            '^' => Positions.top,
            'v' => Positions.bottom,
            _ => (0, 0),
          };
        }).toList();
    return (inputField, robotMoves);
  }

  @override
  int solvePart1() {
    final (field, moves) = parseInput();
    var start = field.firstPositionOf('@');
    for (final move in moves) {
      start = field.followMove(start, move);
    }
    return field.sumOfGps;
  }

  @override
  int solvePart2() {
    final (field, moves) = parseInput();
    final scaledField = field.scaleUp;

    var start = scaledField.firstPositionOf('@');
    for (final move in moves) {
      start = scaledField.followMoveScaled(start, move);
    }
    return scaledField.sumOfGpsTwo;
  }
}

extension on Field<String> {
  Position followMove(Position start, Position direction) {
    final nextPosition = start + direction;
    if (direction == (0, 0)) {
      return start;
    }
    if (isOnField(nextPosition)) {
      switch (getValueAtPosition(nextPosition)) {
        case '#':
          return start;
        case '.':
          setValueAtPosition(start, '.');
          setValueAtPosition(nextPosition, '@');
          return nextPosition;
        case 'O':
          var next = nextPosition + direction;
          while (getValueAtPosition(next) == 'O') {
            next = next + direction;
          }
          if (getValueAtPosition(next) == '.') {
            setValueAtPosition(next, 'O');
            setValueAtPosition(start, '.');
            setValueAtPosition(nextPosition, '@');
            return nextPosition;
          }
          return start;
      }
    }
    return start;
  }

  int get sumOfGps {
    return allPositions
        .where((position) => getValueAtPosition(position) == 'O')
        .fold(0, (previousValue, position) {
          final (x, y) = position;
          return previousValue + y * 100 + x;
        });
  }

  int get sumOfGpsTwo {
    return allPositions
        .where((position) => getValueAtPosition(position) == '[')
        .fold(0, (previousValue, position) {
          final (x, y) = position;
          return previousValue + y * 100 + x;
        });
  }

  Field<String> get scaleUp {
    return Field(
      field.map((row) {
        return row.expand((element) {
          return switch (element) {
            '#' => ['#', '#'],
            '.' => ['.', '.'],
            'O' => ['[', ']'],
            '@' => ['@', '.'],
            _ => throw StateError('$element is not valid'),
          };
        }).toList();
      }).toList(),
    );
  }

  Position followMoveScaled(Position start, Position direction) {
    final nextPosition = start + direction;
    if (direction == (0, 0)) {
      return start;
    }
    if (isOnField(nextPosition)) {
      switch (getValueAtPosition(nextPosition)) {
        case '#':
          return start;
        case '.':
          setValueAtPosition(start, '.');
          setValueAtPosition(nextPosition, '@');
          return nextPosition;
        case '[' || ']':
          final boxPairPosition =
              getValueAtPosition(nextPosition) == '[' ? (1, 0) : (-1, 0);
          final seen = {nextPosition, nextPosition + boxPairPosition};
          var toPush = {nextPosition, nextPosition + boxPairPosition};
          var afterPush = toPush.map((e) => e + direction);
          while (!afterPush.every(
            (position) => getValueAtPosition(position) == '.',
          )) {
            if (afterPush.any(
              (element) => getValueAtPosition(element) == '#',
            )) {
              return start;
            }
            toPush = afterPush
                .expand<Position>((position) {
                  final value = getValueAtPosition(position);
                  if (value == '[') {
                    return [position, position + (1, 0)];
                  }
                  if (value == ']') {
                    return [position, position + (-1, 0)];
                  }
                  return [];
                })
                .toSet()
                .difference(toPush);
            seen.addAll(toPush);
            afterPush = toPush.map((e) => e + direction);
          }
          final fieldCopy = copy();
          for (final position in seen) {
            setValueAtPosition(position, '.');
          }
          for (final position in seen) {
            setValueAtPosition(
              position + direction,
              fieldCopy.getValueAtPosition(position),
            );
          }
          setValueAtPosition(start, '.');
          setValueAtPosition(nextPosition, '@');
          return nextPosition;
      }
    }
    return start;
  }
}
