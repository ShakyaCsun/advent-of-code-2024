import '../utils/index.dart';

class Day10 extends GenericDay {
  Day10() : super(10);

  @override
  Field<int> parseInput() {
    return Field(
      input.getPerLine().map((e) {
        return e.split('').map(int.parse).toList();
      }).toList(),
    );
  }

  @override
  int solvePart1() {
    final field = parseInput();
    final trailHeads = field.allPositions.where((position) {
      return field.getValueAtPosition(position) == 0;
    });
    return trailHeads.fold(0, (previousValue, trailHead) {
      return previousValue + getTrailHeadScore(field, trailHead).length;
    });
  }

  @override
  int solvePart2() {
    final field = parseInput();
    final trailHeads = field.allPositions.where((position) {
      return field.getValueAtPosition(position) == 0;
    });
    return trailHeads.fold(0, (previousValue, trailHead) {
      return previousValue + getTrailHeadScoreTwo(field, trailHead);
    });
  }

  Set<Position> getTrailHeadScore(Field<int> field, Position trailHead) {
    final currentHeight = field.getValueAtPosition(trailHead);
    if (currentHeight == 9) {
      return {trailHead};
    }
    final nextSteps = field.nextSteps(trailHead);
    return nextSteps.fold(<Position>{}, (previousValue, nextPosition) {
      return previousValue.union(getTrailHeadScore(field, nextPosition));
    });
  }

  int getTrailHeadScoreTwo(Field<int> field, Position trailHead) {
    final currentHeight = field.getValueAtPosition(trailHead);
    if (currentHeight == 9) {
      return 1;
    }
    final nextSteps = field.nextSteps(trailHead);
    return nextSteps.fold(0, (previousValue, nextPosition) {
      return previousValue + getTrailHeadScoreTwo(field, nextPosition);
    });
  }
}

extension on Field<int> {
  Iterable<Position> nextSteps(Position trailHead) {
    return Positions.adjacent.map((offset) => trailHead + offset).where((
      position,
    ) {
      return isOnField(position) &&
          getValueAtPosition(position) == getValueAtPosition(trailHead) + 1;
    });
  }
}
