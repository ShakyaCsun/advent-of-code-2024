import '../utils/index.dart';

class Day23 extends GenericDay {
  Day23() : super(23);

  @override
  Map<String, Set<String>> parseInput() {
    return input.getPerLine().fold(<String, Set<String>>{}, (
      previousValue,
      line,
    ) {
      final [one, two] = line.split('-');
      return previousValue
        ..update(one, (value) => {...value, two}, ifAbsent: () => {two})
        ..update(two, (value) => {...value, one}, ifAbsent: () => {one});
    });
  }

  @override
  int solvePart1() {
    final connections = parseInput();
    final Set<Set<String>> possibleLanWithChief = EqualitySet.from(
      const SetEquality<String>(),
      connections.keys
          .where((element) => element.startsWith('t'))
          .expand<Set<String>>((chiefComputer) {
            final edges = connections[chiefComputer]!;
            final threeConnectedComputers = <Set<String>>[];
            for (final (index, computer) in edges.indexed) {
              for (final otherComputer in edges.skip(index + 1)) {
                if (connections[computer]?.contains(otherComputer) ?? false) {
                  threeConnectedComputers.add({
                    chiefComputer,
                    computer,
                    otherComputer,
                  });
                }
              }
            }
            return threeConnectedComputers;
          }),
    );
    return possibleLanWithChief.length;
  }

  @override
  String solvePart2() {
    final connections = parseInput();
    final interconnectedComputers = EqualitySet(const ListEquality<String>());

    for (final MapEntry(key: computer, value: connectedComputers)
        in connections.entries) {
      var interconnection = <String>{...connectedComputers, computer};
      for (final connectedComputer in connectedComputers) {
        final other = <String>{
          ...?connections[connectedComputer],
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
