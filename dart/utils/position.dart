typedef Position = (int x, int y);

extension PositionOperatorX on Position {
  Position operator *(int multiplier) {
    return ($1 * multiplier, $2 * multiplier);
  }

  Position operator +(Position other) {
    final (x, y) = this;
    final (otherX, otherY) = other;
    return (x + otherX, y + otherY);
  }

  Position operator -(Position other) {
    final (x, y) = this;
    final (otherX, otherY) = other;
    return (x - otherX, y - otherY);
  }

  int get x => $1;
  int get y => $2;

  /// (y, x)
  Position get inverse => (y, x);

  int distanceSquare(Position other) {
    final (x, y) = other - this;
    return x * x + y * y;
  }

  /// Manhattan or Taxicab distance
  ///
  /// |x1 - x2| + |y1 - y2|
  int manhattanDistance(Position other) {
    final (x, y) = other - this;
    return x.abs() + y.abs();
  }
}

abstract class Positions {
  const Positions._();

  static const topLeft = (-1, -1);
  static const top = (0, -1);
  static const topRight = (1, -1);
  static const right = (1, 0);
  static const bottomRight = (1, 1);
  static const bottom = (0, 1);
  static const bottomLeft = (-1, 1);
  static const left = (-1, 0);

  static const neighbours = <Position>{
    topLeft,
    top,
    topRight,
    right,
    bottomRight,
    bottom,
    bottomLeft,
    left,
  };

  static const diagonals = <Position>{
    topLeft,
    topRight,
    bottomRight,
    bottomLeft,
  };

  static const adjacent = <Position>{top, right, bottom, left};
}
