import 'package:equatable/equatable.dart';

import '../utils/index.dart';

class Day14 extends GenericDay {
  Day14() : super(14);

  @override
  List<RobotData> parseInput() {
    return input.getPerLine().map(RobotData.fromLine).toList();
  }

  @override
  int solvePart1() {
    final robots = parseInput();
    const rows = 103;
    const cols = 101;
    final robotsAfter100 = List.filled(100, 0).fold(robots, (previousValue, _) {
      return previousValue.map((e) => e.next(rows, cols)).toList();
    });
    const horizontalMiddle = cols ~/ 2;
    const verticalMiddle = rows ~/ 2;
    return robotsAfter100
        .map((e) {
          return e.position;
        })
        .fold(<Quadrant, int>{}, (previousValue, position) {
          if (position.x == horizontalMiddle || position.y == verticalMiddle) {
            return previousValue;
          }
          final quadrant = switch (position) {
            (< horizontalMiddle, < verticalMiddle) => Quadrant.topLeft,
            (> horizontalMiddle, < verticalMiddle) => Quadrant.topRight,
            (< horizontalMiddle, > verticalMiddle) => Quadrant.bottomLeft,
            (> horizontalMiddle, > verticalMiddle) => Quadrant.bottomRight,

            (_, _) => throw StateError('equal cases should be handled already'),
          };
          previousValue.update(
            quadrant,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
          return previousValue;
        })
        .values
        .fold(1, (previousValue, element) {
          return previousValue * element;
        });
  }

  @override
  int solvePart2() {
    var robots = parseInput();
    const rows = 103;
    const cols = 101;
    var elapsedSeconds = 0;
    final repeatsAfter = robots.first.countWhenRepeats(rows, cols);
    print(repeatsAfter);
    while (elapsedSeconds < repeatsAfter) {
      elapsedSeconds++;
      robots = robots.map((e) => e.next(rows, cols)).toList();
      if (isChristmasTree(robots)) {
        final field = Field<String>(
          List.generate(rows, (y) {
            return List.generate(cols, (x) {
              if (robots.any((element) => element.position == (x, y))) {
                return '*';
              }
              return ' ';
            });
          }),
        );
        print(field);
        return elapsedSeconds;
      }
    }
    return 0;
  }
}

enum Quadrant { topLeft, topRight, bottomLeft, bottomRight }

class RobotData extends Equatable {
  const RobotData({required this.position, required this.velocity});

  factory RobotData.fromLine(String line) {
    final [pos, vel] = line.split(' ');
    final [px, py] = pos.split('=')[1].split(',').map(int.parse).toList();
    final [vx, vy] = vel.split('=')[1].split(',').map(int.parse).toList();
    return RobotData(position: (px, py), velocity: (vx, vy));
  }

  final Position position;
  final Position velocity;

  RobotData next(int rows, int cols) {
    var (nx, ny) = position + velocity;
    if (nx < 0) {
      nx = cols + nx;
    }
    if (ny < 0) {
      ny = rows + ny;
    }
    if (nx >= cols) {
      nx = nx - cols;
    }
    if (ny >= rows) {
      ny = ny - rows;
    }
    return RobotData(position: (nx, ny), velocity: velocity);
  }

  int countWhenRepeats(int rows, int cols) {
    // All the robots repeat their position after same seconds.
    // Not useful information but interesting and understandable decision.
    var count = 0;
    var next = RobotData(position: position, velocity: velocity);
    while (true) {
      count++;
      next = next.next(rows, cols);
      if (next == this) {
        return count;
      }
    }
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [position, velocity];
}

bool isChristmasTree(List<RobotData> robots) {
  final positions = {...robots.map((e) => e.position)};
  if (positions.any((position) {
    return positions.containsAll(
      List.generate(20, (index) => (position.x, position.y + index)),
    );
  })) {
    return true;
  }
  return false;
}
