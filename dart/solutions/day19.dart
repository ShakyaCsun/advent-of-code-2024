import '../utils/index.dart';

class Day19 extends GenericDay {
  Day19() : super(19);

  @override
  (List<String>, List<String>) parseInput() {
    final [availableTowels, _, ...targets] = input.getPerLine();
    final towelList = availableTowels.split(', ').toList();
    return (towelList, targets);
  }

  @override
  int solvePart1() {
    final (patterns, targets) = parseInput();
    final singleLengthTowels =
        patterns.where((element) => element.length == 1).toList();
    final patternLengthMap = {
      for (final pattern in patterns) pattern: pattern.length,
    };
    bool canCreate(String target, Map<String, bool> memo) {
      if (memo.containsKey(target)) {
        return memo[target]!;
      }
      if (patterns.contains(target)) {
        memo[target] = true;
        return true;
      }
      if (target.split('').every(singleLengthTowels.contains)) {
        memo[target] = true;
        return true;
      }
      final targetLength = target.length;
      final partialMatches = patternLengthMap.entries.where((element) {
        final MapEntry(key: pattern, value: length) = element;

        return length <= targetLength && target.substring(0, length) == pattern;
      });
      for (final match in partialMatches) {
        final MapEntry(key: pattern, value: length) = match;
        final result = canCreate(target.substring(length), memo);
        if (result) {
          memo[target] = true;
          return true;
        }
      }
      memo[target] = false;
      return false;
    }

    final cache = <String, bool>{};
    return targets.where((target) => canCreate(target, cache)).length;
  }

  @override
  int solvePart2() {
    final (patterns, targets) = parseInput();
    final patternLengthMap = {
      for (final pattern in patterns) pattern: pattern.length,
    };
    int howCreate(String target, Map<String, int> memo) {
      if (memo.containsKey(target)) {
        return memo[target]!;
      }
      final targetLength = target.length;
      if (targetLength == 0) {
        return 1;
      }
      final partialMatches = patternLengthMap.entries.where((element) {
        final MapEntry(key: pattern, value: length) = element;

        return length <= targetLength && target.substring(0, length) == pattern;
      });
      var waysToCreate = 0;
      for (final MapEntry(value: length) in partialMatches) {
        final result = howCreate(target.substring(length), memo);
        waysToCreate += result;
      }
      memo[target] = waysToCreate;
      return waysToCreate;
    }

    final cache = <String, int>{};
    return targets.map((target) => howCreate(target, cache)).fold(0, (
      previousValue,
      element,
    ) {
      return previousValue + element;
    });
  }
}
