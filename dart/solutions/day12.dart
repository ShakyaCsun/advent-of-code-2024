import '../utils/index.dart';

class Day12 extends GenericDay {
  Day12() : super(12);

  @override
  Field<String> parseInput() {
    return StringField.fromInput(input);
  }

  @override
  int solvePart1() {
    final field = parseInput();
    return field.areas.fold(0, (previousValue, area) {
      return previousValue + area.length * area.perimeter;
    });
  }

  @override
  int solvePart2() {
    final field = parseInput();
    return field.areas.fold(0, (previousValue, area) {
      return previousValue + area.length * area.numberOfSides(field);
    });
  }
}

extension on Field<String> {
  List<Set<Position>> get areas {
    final knownPositions = <Position>{};
    return allPositions.fold(<Set<Position>>[], (previousValue, position) {
      if (knownPositions.add(position)) {
        final area = areaOf(position, {});
        knownPositions.addAll(area);
        return [...previousValue, area];
      }
      return previousValue;
    });
  }

  Set<Position> areaOf(Position position, Set<Position> area) {
    final plant = getValueAtPosition(position);
    final next = Positions.adjacent
        .map((e) => position + e)
        .where(
          (element) =>
              isOnField(element) &&
              getValueAtPosition(element) == plant &&
              !area.contains(element),
        );
    return next.fold({...area, position, ...next}, (
      previousValue,
      nextPosition,
    ) {
      return previousValue.union(areaOf(nextPosition, previousValue));
    });
  }
}

extension on Iterable<Position> {
  int get perimeter {
    return fold(0, (previousValue, position) {
      return previousValue +
          4 -
          where((element) => position.distanceSquare(element) == 1).length;
    });
  }

  int numberOfSides(Field<String> field) {
    final plant = field.getValueAtPosition(first);

    Iterable<Position> generatePositions({
      required Position start,
      required Position direction,
      required bool Function(Position newPosition) condition,
    }) sync* {
      final newPosition = start + direction;
      if (condition(newPosition)) {
        yield newPosition;
        yield* generatePositions(
          start: newPosition,
          direction: direction,
          condition: condition,
        );
      }
    }

    return Positions.adjacent
        .map<int>((direction) {
          // Positions where they don't have the same plant on given direction
          final pointsOnEdgeOfDirection = map(
            (position) => position + direction,
          ).where((position) {
            return switch (field.isOnField(position)) {
              true => field.getValueAtPosition(position) != plant,
              false => true,
            };
          });

          final seenPoints = <Position>{};
          return pointsOnEdgeOfDirection.fold(0, (previousValue, edgePosition) {
            if (seenPoints.contains(edgePosition)) {
              return previousValue;
            }
            final toLeft = direction.inverse;
            final toRight = direction.inverse * -1;
            // Positions connected to each other forming a single side.
            final directionSide = [toLeft, toRight].expand<Position>((
              direction,
            ) {
              return generatePositions(
                start: edgePosition,
                direction: direction,
                condition: pointsOnEdgeOfDirection.contains,
              );
            });
            seenPoints.addAll(directionSide);
            return previousValue + 1;
          });
        })
        .fold(0, (previousValue, element) {
          return previousValue + element;
        });
  }
}
