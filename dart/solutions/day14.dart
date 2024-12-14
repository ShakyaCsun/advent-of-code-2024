import 'package:equatable/equatable.dart';

import '../utils/index.dart';

class Day14 extends GenericDay {
  Day14() : super(14);

  static const width = 101;
  static const height = 103;

  @override
  List<RobotData> parseInput() {
    return input.getPerLine().map(RobotData.fromLine).toList();
  }

  @override
  int solvePart1() {
    final robots = parseInput();
    return safetyFactor(robots, width: width, height: height);
  }

  @override
  int solvePart2() {
    final robots = parseInput();
    final repeatsAfter = robots.first.countWhenRepeats(width, height);
    int searchChristmasTree(int count) {
      if (count >= repeatsAfter) {
        // Cannot find Christmas Tree
        return -1;
      }
      final positions = robots.map((e) => e.move(width, height, count));
      if (positions.isChristmasTree) {
        print(positions.field(width, height));
        return count;
      }
      return searchChristmasTree(count + 1);
    }

    return searchChristmasTree(0);
  }

  int safetyFactor(
    List<RobotData> robots, {
    required int width,
    required int height,
    int seconds = 100,
  }) {
    final finalRobotPositions = robots.map<Position>(
      (robot) => robot.move(width, height, seconds),
    );
    final middleX = width ~/ 2;
    final middleY = height ~/ 2;
    final robotsInEachQuadrant = finalRobotPositions.fold(<Quadrant, int>{}, (
      previousValue,
      position,
    ) {
      final (x, y) = position;
      if (x == middleX || y == middleY) {
        return previousValue;
      }
      final isLeft = x < middleX;
      final isTop = y < middleY;
      final quadrant = switch ((isTop, isLeft)) {
        (true, true) => Quadrant.topLeft,
        (true, false) => Quadrant.topRight,
        (false, true) => Quadrant.bottomLeft,
        (false, false) => Quadrant.bottomRight,
      };
      previousValue.update(quadrant, (value) => value + 1, ifAbsent: () => 1);
      return previousValue;
    });
    return robotsInEachQuadrant.values.fold(
      1,
      (previousValue, robotCount) => previousValue * robotCount,
    );
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

  Position move(int width, int height, int seconds) {
    final (nx, ny) = position + velocity * seconds;
    return (nx % width, ny % height);
  }

  int countWhenRepeats(int width, int height) {
    // All the robots repeat their position after same seconds.
    // Not useful information but interesting and understandable decision.
    int moveCount(int count) {
      if (move(width, height, count) == position) {
        return count;
      }
      return moveCount(count + 1);
    }

    return moveCount(1);
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [position, velocity];
}

extension on Iterable<Position> {
  bool get isChristmasTree {
    final positions = {...this};
    return positions.any((position) {
      final (x, y) = position;
      return positions.containsAll(
        Iterable.generate(
          // Assuming that if robots make a vertical line of this height,
          // then it is a Christmas Tree arrangement.
          // For my input, any value from 9 to 33 works
          14, // Chose 14 because it's day 14
          (index) => (x, y + index),
        ),
      );
    });
  }

  // Used to print the tree for debug purpose
  // ignore: unused_element
  Field<String> field(int width, int height) {
    return Field(
      List.generate(
        height,
        (y) => List.generate(width, (x) {
          if (contains((x, y))) {
            return 'A';
          }
          return ' ';
        }),
      ),
    );
  }
}
