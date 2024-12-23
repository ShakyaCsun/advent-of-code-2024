import '../utils/index.dart';

class Day18 extends GenericDay {
  Day18() : super(18);

  @override
  Iterable<Position> parseInput() {
    return input.getPerLine().map((e) {
      final [x, y, ...] = e.split(',').map(int.parse).toList();
      return (x, y);
    });
  }

  Field<String> get partOneField {
    final field = Field<String>(
      List.generate(71, (index) {
        return List.generate(71, (index) {
          return '.';
        });
      }),
    );
    void changeField(Position position) {
      field.setValueAtPosition(position, '#');
    }

    parseInput().take(1024).forEach(changeField);
    return field.copy();
  }

  @override
  int solvePart1() {
    final field = partOneField;

    return getSteps(field);
  }

  String solve(int fieldSize, int initialFall, {Part part = Part.one}) {
    final allObstacles = parseInput();
    final obstaclePositions = allObstacles.take(initialFall).toList();
    final field = Field<String>(
      List.generate(fieldSize, (y) {
        return List.generate(fieldSize, (x) {
          if (obstaclePositions.remove((x, y))) {
            return '#';
          }
          return '.';
        });
      }),
    );
    if (part == Part.one) {
      return getSteps(field, end: (fieldSize - 1, fieldSize - 1)).toString();
    }
    for (final position in allObstacles.skip(initialFall)) {
      field.setValueAtPosition(position, '#');
      if (getSteps(field, end: (fieldSize - 1, fieldSize - 1)) == -1) {
        final (x, y) = position;
        return '$x,$y';
      }
    }
    return 'Cannot solve part 2';
  }

  @override
  String solvePart2() {
    return solve(71, 1024, part: Part.two);
  }

  int getSteps(
    Field<String> field, {
    Position start = (0, 0),
    Position end = (70, 70),
  }) {
    final max = field.width * field.height + 1;
    final bestCost = {start: 0};
    final queue = PriorityQueue<Position>(
      (p0, p1) => bestCost
          .getValue(p0, ifAbsent: max)
          .compareTo(bestCost.getValue(p1, ifAbsent: max)),
    )..add(start);
    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      if (current == end) {
        return bestCost[current]!;
      }
      for (final neighbor in Positions.adjacent
          .map((offset) => current + offset)
          .where(
            (position) =>
                field.isOnField(position) &&
                field.getValueAtPosition(position) != '#',
          )) {
        final neighborCost = bestCost[current]! + 1;
        if (neighborCost < bestCost.getValue(neighbor, ifAbsent: max)) {
          bestCost[neighbor] = neighborCost;
          if (!queue.contains(neighbor)) {
            queue.add(neighbor);
          }
        }
      }
    }
    return -1;
  }
}
