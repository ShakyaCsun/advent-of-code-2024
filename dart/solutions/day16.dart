import '../utils/index.dart';

class Day16 extends GenericDay {
  Day16() : super(16);

  @override
  Field<String> parseInput() {
    return StringField.fromInput(input);
  }

  @override
  int solvePart1() {
    final field = parseInput();
    final startPosition = field.firstPositionOf('S');
    final endPosition = field.firstPositionOf('E');
    return solveMazeOne(field, startPosition, endPosition);
  }

  @override
  int solvePart2() {
    final field = parseInput();
    return solveMazeTwo(field);
  }

  int solveMazeOne(Field<String> maze, Position start, Position end) {
    final seenPositions = {start};

    final queue = PriorityQueue<(Position, Position, int)>((p0, p1) {
      final (_, _, cost0) = p0;
      final (_, _, cost1) = p1;
      return cost0.compareTo(cost1);
    })..add((start, Positions.right, 0));

    while (queue.isNotEmpty) {
      final (current, direction, cost) = queue.removeFirst();
      if (current == end) {
        return cost;
      }
      for (final adjacentDirection in Positions.adjacent) {
        if (adjacentDirection == direction * -1) {
          continue;
        }
        final nextPosition = current + adjacentDirection;
        if (maze.isOnField(nextPosition) &&
            maze.getValueAtPosition(nextPosition) != '#' &&
            seenPositions.add(nextPosition)) {
          if (adjacentDirection == direction) {
            queue.add((nextPosition, adjacentDirection, cost + 1));
          } else {
            queue.add((nextPosition, adjacentDirection, cost + 1001));
          }
        }
      }
    }
    return -1;
  }

  int solveMazeTwo(Field<String> field) {
    final start = field.firstPositionOf('S');
    final end = field.firstPositionOf('E');
    final knownLowestCosts = {
      // Facing East
      (start, Positions.right): 0,
    };

    final previous = <(Position, Position), Set<(Position, Position)>>{};

    final queue = PriorityQueue<(Position, Position, int)>((p0, p1) {
      final (_, _, cost0) = p0;
      final (_, _, cost1) = p1;
      return cost0.compareTo(cost1);
    })..add((start, Positions.right, 0));

    final bestCost = solveMazeOne(field, start, end);
    while (queue.isNotEmpty) {
      final (current, direction, cost) = queue.removeFirst();
      if (cost > bestCost) {
        break;
      }
      final currentKey = (current, direction);
      for (final adjacentDirection in Positions.adjacent) {
        if (adjacentDirection == direction * -1) {
          continue;
        }
        final nextPosition = current + adjacentDirection;
        if (field.isOnField(nextPosition) &&
            field.getValueAtPosition(nextPosition) != '#') {
          final nextCost = switch (adjacentDirection == direction) {
            true => cost + 1,
            false => cost + 1001,
          };
          final nextKey = (nextPosition, adjacentDirection);
          final lowestCost = knownLowestCosts.getValue(
            nextKey,
            ifAbsent: bestCost + 1,
          );
          if (nextCost > lowestCost) {
            continue;
          }
          knownLowestCosts[nextKey] = nextCost;

          previous.update(
            nextKey,
            (value) => {...value, currentKey},
            ifAbsent: () => {currentKey},
          );
          queue.add((nextPosition, adjacentDirection, nextCost));
        }
      }
    }

    Set<Position> findPositionsInPath() {
      final state = QueueList<(Position, Position)>.from(
        previous.keys.where((element) {
          final (position, direction) = element;
          return position == end;
        }).toSet(),
      );
      final seen = <(Position, Position)>{...state};
      while (state.isNotEmpty) {
        final key = state.removeFirst();
        for (final element in previous.getValue(key, ifAbsent: {})) {
          if (seen.add(element)) {
            state.add(element);
          }
        }
      }
      return {
        ...seen.map((e) {
          final (position, _) = e;
          return position;
        }),
      };
    }

    return findPositionsInPath().length;
  }
}
