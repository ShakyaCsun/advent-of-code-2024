import 'dart:math';

import 'package:equatable/equatable.dart';

import '../utils/index.dart';

class Day17 extends GenericDay {
  Day17() : super(17);

  @override
  Program parseInput() {
    return Program.parse(input.getPerLine());
  }

  @override
  int solvePart1() {
    final solution = parseInput().getCompleteOutput();
    print('Actual solution for Day 17 Part 1: $solution');
    return 0;
  }

  @override
  int solvePart2() {
    final inputProgram = parseInput();
    final instructions = inputProgram.instructions;

    /// Hard-coded output of program specific to my input for given [a]
    int output(int a) {
      final a1 = (a % 8) ^ 1;
      return (a1 ^ 5) ^ (a ~/ pow(2, a1)) % 8;
    }

    var possibleA = {0};
    for (final instruction in instructions.reversed) {
      final nextAs = <int>{};
      for (final a in possibleA.map((e) => e * 8)) {
        final a1 = a + 8;

        for (var i = a; i < a1; i++) {
          if (output(i) == instruction) {
            nextAs.add(i);
          }
        }
      }
      possibleA = {...nextAs};
    }

    // for (final a in possibleA) {
    //   print(inputProgram.copyWith(registerA: a).getCompleteOutput());
    // }

    return possibleA.min;
  }
}

class Program extends Equatable {
  const Program({
    required this.registerA,
    required this.registerB,
    required this.registerC,
    required this.instructions,
    this.instructionPointer = 0,
    this.outputs = const [],
  });

  factory Program.parse(List<String> lines) {
    final [a, b, c, _, program] = lines;
    int getInt(String line) {
      return int.parse(line.split(': ')[1]);
    }

    final instructions =
        program.split(': ').last.split(',').map(int.parse).toList();

    return Program(
      registerA: getInt(a),
      registerB: getInt(b),
      registerC: getInt(c),
      instructions: instructions,
    );
  }

  final int registerA;
  final int registerB;
  final int registerC;
  final List<int> instructions;
  final int instructionPointer;
  final List<int> outputs;

  String getCompleteOutput() {
    var program = this;
    while (!program.completed) {
      program = program.performInstruction();
    }
    return program.outputs.join(',');
  }

  Program copyWith({
    int? registerA,
    int? registerB,
    int? registerC,
    List<int>? instructions,
    int? instructionPointer,
  }) {
    return Program(
      registerA: registerA ?? this.registerA,
      registerB: registerB ?? this.registerB,
      registerC: registerC ?? this.registerC,
      instructions: instructions ?? this.instructions,
      instructionPointer: instructionPointer ?? this.instructionPointer,
      outputs: [...outputs],
    );
  }

  Program addOutput(int output) {
    return Program(
      registerA: registerA,
      registerB: registerB,
      registerC: registerC,
      instructions: instructions,
      instructionPointer: instructionPointer,
      outputs: [...outputs, output],
    );
  }

  Program updatePointer() {
    if (completed) {
      return copyWith();
    }
    return copyWith(instructionPointer: instructionPointer + 2);
  }

  bool get completed => instructionPointer == instructions.length;

  Program performInstruction() {
    final [opcode, operand, ...] = instructions.sublist(instructionPointer);
    final comboOperand = switch (operand) {
      final value when value >= 0 && value < 4 => value,
      4 => registerA,
      5 => registerB,
      6 => registerC,
      _ => throw StateError('Unknown Operand $operand'),
    };
    switch (opcode) {
      case 0:
        final adv = registerA ~/ pow(2, comboOperand);
        return copyWith(registerA: adv).updatePointer();
      case 1:
        final xor = registerB ^ operand;
        return copyWith(registerB: xor).updatePointer();
      case 2:
        final modulo = comboOperand % 8;
        return copyWith(registerB: modulo).updatePointer();
      case 3:
        if (registerA == 0) {
          return updatePointer();
        }
        return copyWith(instructionPointer: operand);
      case 4:
        final xor = registerB ^ registerC;
        return copyWith(registerB: xor).updatePointer();
      case 5:
        final modulo = comboOperand % 8;
        return updatePointer().addOutput(modulo);
      case 6:
        final adv = registerA ~/ pow(2, comboOperand);
        return copyWith(registerB: adv).updatePointer();
      case 7:
        final adv = registerA ~/ pow(2, comboOperand);
        return copyWith(registerC: adv).updatePointer();
    }
    return copyWith();
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    registerA,
    registerB,
    registerC,
    instructions,
    instructionPointer,
    outputs,
  ];
}
