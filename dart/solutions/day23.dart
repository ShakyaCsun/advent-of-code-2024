import 'package:equatable/equatable.dart';

import '../utils/index.dart';

class Day23 extends GenericDay {
  Day23() : super(23);

  @override
  List<Connection> parseInput() {
    return [...input.getPerLine().map(Connection.fromLine)];
  }

  @override
  int solvePart1() {
    final connections = parseInput();
    final chiefCanBeAt = EqualitySet.from(
      const SetEquality<Connection>(),
      connections
          .where((element) => element.canHaveChief)
          .allPairs
          .expand<Set<Connection>>((element) {
            final (cOne, cTwo) = element;
            final connected = cOne.connectedTo(cTwo);
            if (connected != null && connections.contains(connected)) {
              return [
                {cOne, cTwo, connected},
              ];
            }
            return [];
          }),
    );
    return chiefCanBeAt.length;
  }

  @override
  int solvePart2() {
    print('Answer for Day 23 Part 2: ${largestLan()}');

    return 0;
  }

  String largestLan() {
    final connections = parseInput();
    final computersConnections = connections.fold(<String, Set<String>>{}, (
      previousValue,
      element,
    ) {
      final Connection(:one, :two) = element;
      previousValue
        ..update(one, (value) => {...value, two}, ifAbsent: () => {two})
        ..update(two, (value) => {...value, one}, ifAbsent: () => {one});
      return previousValue;
    });
    final interconnectedComputers = EqualitySet(const ListEquality<String>());

    for (final MapEntry(key: computer, value: connectedComputers)
        in computersConnections.entries) {
      var interconnection = <String>{...connectedComputers, computer};
      for (final connectedComputer in connectedComputers) {
        final other = <String>{
          ...?computersConnections[connectedComputer],
          connectedComputer,
        };
        if (interconnection.intersection(other).length == 1) {
          continue;
        }
        interconnection = interconnection.intersection(other);
      }
      interconnectedComputers.add(interconnection.sorted());
    }
    return interconnectedComputers
        .sorted((a, b) => b.length.compareTo(a.length))
        .first
        .join(',');
  }
}

class Connection extends Equatable {
  const Connection(this.one, this.two);

  factory Connection.fromLine(String line) {
    final [one, two] = line.split('-');
    return Connection(one, two).normalized();
  }

  final String one;
  final String two;

  Connection normalized() {
    if (one.compareTo(two) > 0) {
      return Connection(two, one);
    }
    return Connection(one, two);
  }

  Connection? connectedTo(Connection other) {
    final Connection(one: otherOne, two: otherTwo) = other;
    final set = {one, two};
    final otherSet = {otherOne, otherTwo};
    final differenceSet = set
        .difference(otherSet)
        .union(otherSet.difference(set));
    if (differenceSet.toList() case [final a, final b]) {
      return Connection(a, b).normalized();
    }
    return null;
  }

  bool hasComputer(String computer) {
    return one == computer || two == computer;
  }

  bool get canHaveChief => one.startsWith('t') || two.startsWith('t');

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [one, two];
}
