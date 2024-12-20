import '../utils/index.dart';

class Day20 extends GenericDay {
  Day20() : super(20);

  @override
  Field<String> parseInput() {
    return StringField.fromInput(input);
  }

  @override
  int solvePart1() {
    return cheatsCount();
  }

  @override
  int solvePart2() {
    return cheatsCount(active: 20);
  }

  /// The number of cheats that exist which meet given constraints.
  ///
  /// [saveTarget] represents the amount of steps/picoseconds that the cheat
  /// needs to save. Defaults to 100 for both step 1 and 2.
  /// Use 1 for example part 1 and 50 for example part 2
  ///
  /// [active] represents the amount of steps/picoseconds up to which the cheat
  /// can stay active for.
  int cheatsCount({int saveTarget = 100, int active = 2}) {
    final path = getPath();
    return path.foldIndexed(0, (currentIndex, cheats, currentPosition) {
      // If we want to save x steps/picoseconds, we have to skip to the position
      // that is at least x + 2 indices ahead of currentIndex.
      // This is because we will take at least 2 steps to cheat our way
      // in the best path.
      final minimumIndexToSkip = saveTarget + 2;
      final validCheats =
          path.skip(currentIndex + minimumIndexToSkip).whereIndexed((
            index,
            position,
          ) {
            // We can skip to this position in manhattan distance using cheats
            final minimumSteps = currentPosition.manhattanDistance(position);
            if (minimumSteps <= active) {
              /// The steps required to reach [position] from [currentPosition]
              /// in original best path.
              final originalSteps = minimumIndexToSkip + index;
              // The steps/picoseconds that is saved after using cheat
              final savedSteps = originalSteps - minimumSteps;
              return savedSteps >= saveTarget;
            }
            return false;
          }).length;
      return cheats + validCheats;
    });
  }

  List<Position> getPath() {
    final field = parseInput();
    final start = field.firstPositionOf('S');
    final end = field.firstPositionOf('E');
    return reconstructPath(searchPathAStar(field, start: start, end: end), end);
  }

  List<Position> reconstructPath(
    Map<Position, Position> previous,
    Position goal,
  ) {
    final path = <Position>[];
    Position? previousPosition = goal;
    while (previousPosition != null) {
      path.add(previousPosition);
      previousPosition = previous[previousPosition];
    }
    return path;
  }

  Map<Position, Position> searchPathAStar(
    Field<String> field, {
    required Position start,
    required Position end,
  }) {
    final max = field.width * field.height + 1;
    final bestCost = {start: 0};
    final queue = PriorityQueue<Position>(
      (p0, p1) => bestCost
          .getValue(p0, ifAbsent: max)
          .compareTo(bestCost.getValue(p1, ifAbsent: max)),
    )..add(start);
    final previous = <Position, Position>{};
    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      if (current == end) {
        return previous;
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
          previous[neighbor] = current;
          bestCost[neighbor] = neighborCost;
          if (!queue.contains(neighbor)) {
            queue.add(neighbor);
          }
        }
      }
    }
    return previous;
  }
}
