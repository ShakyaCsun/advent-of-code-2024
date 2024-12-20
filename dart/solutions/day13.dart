import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../utils/index.dart';

class Day13 extends GenericDay {
  Day13() : super(13);

  @override
  List<ClawMachine> parseInput() {
    return input.asString.split('\n\n').map(ClawMachine.fromInput).toList();
  }

  @override
  int solvePart1() {
    final machines = parseInput();
    return machines.fold(0, (previousValue, machine) {
      return previousValue + machine.requiredTokens;
    });
  }

  @override
  int solvePart2() {
    final machines = parseInput();
    return machines.fold(0, (previousValue, machine) {
      return previousValue + machine.withStep2Prize().requiredTokens;
    });
  }
}

class ClawMachine extends Equatable {
  const ClawMachine({
    required this.buttonA,
    required this.buttonB,
    required this.prize,
  });

  factory ClawMachine.fromInput(String input) {
    final [a, b, prize, ...] = const LineSplitter().convert(input);
    final ay = a.split('Y+')[1];
    final by = b.split('Y+')[1];
    final ax = a.split('+')[1].split(',')[0];
    final bx = b.split('+')[1].split(',')[0];
    final prizeSplit = prize.split('=');
    final prizeX = prizeSplit[1].split(',')[0];
    final prizeY = prizeSplit[2];

    return ClawMachine(
      buttonA: (int.parse(ax), int.parse(ay)),
      buttonB: (int.parse(bx), int.parse(by)),
      prize: (int.parse(prizeX), int.parse(prizeY)),
    );
  }

  final Position buttonA;
  final Position buttonB;
  final Position prize;

  (double aPresses, double bPresses) solve() {
    final (aX, aY) = buttonA;
    final (bX, bY) = buttonB;
    final (pX, pY) = prize;
    // Equation 1: aPresses * aX + bPresses * bX = pX
    // Equation 2: aPresses * aY + bPresses * bY = pY
    // From Eq1: aPresses = (pX - bPresses * bX) / aX
    // Substitute aPresses from Eq1 in Eq2 to calculate bPresses
    final aPresses = (pY * bX - pX * bY) / (aY * bX - aX * bY);
    final bPresses = (pY * aX - pX * aY) / (aX * bY - bX * aY);
    return (aPresses, bPresses);
  }

  int get requiredTokens {
    final (aPresses, bPresses) = solve();
    if (aPresses.roundToDouble() == aPresses &&
        bPresses.roundToDouble() == bPresses) {
      return aPresses.toInt() * 3 + bPresses.toInt();
    }
    return 0;
  }

  ClawMachine withStep2Prize() {
    return ClawMachine(
      buttonA: buttonA,
      buttonB: buttonB,
      prize: prize + (10000000000000, 10000000000000),
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [buttonA, buttonB, prize];
}
