import '../utils/index.dart';

class Day04 extends GenericDay {
  Day04() : super(4);

  @override
  Field<String> parseInput() {
    return StringField.fromInput(input);
  }

  @override
  int solvePart1() {
    List<List<Position>> possibleMasPositions(Position xPosition) {
      return Positions.neighbours
          .map(
            (offset) => [for (var i = 1; i < 4; i++) (offset * i) + xPosition],
          )
          .toList();
    }

    final puzzle = parseInput();
    return puzzle.allPositions
        .where((position) => puzzle.getValueAtPosition(position) == 'X')
        .map((position) {
          final masPositions = possibleMasPositions(position)
            ..retainWhere((element) => element.every(puzzle.isOnField));
          return masPositions
              .where((e) => e.map(puzzle.getValueAtPosition).join() == 'MAS')
              .length;
        })
        .fold(0, (previousValue, element) => previousValue + element);
  }

  @override
  int solvePart2() {
    final puzzle = parseInput();
    return puzzle.allPositions
        .where((position) => puzzle.getValueAtPosition(position) == 'A')
        .where((position) {
          final diagonals =
              Positions.diagonals.map((offset) => offset + position).toList();
          if (diagonals.every(puzzle.isOnField)) {
            final topLeft = puzzle.getValueAtPosition(
              position + Positions.topLeft,
            );
            final topRight = puzzle.getValueAtPosition(
              position + Positions.topRight,
            );
            final bottomLeft = puzzle.getValueAtPosition(
              position + Positions.bottomLeft,
            );
            final bottomRight = puzzle.getValueAtPosition(
              position + Positions.bottomRight,
            );
            if (topLeft == 'M' && bottomRight == 'S' ||
                topLeft == 'S' && bottomRight == 'M') {
              return topRight == 'M' && bottomLeft == 'S' ||
                  topRight == 'S' && bottomLeft == 'M';
            }
          }
          return false;
        })
        .length;
  }
}
