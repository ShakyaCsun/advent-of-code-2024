import 'dart:convert';

import 'package:quiver/collection.dart';

import '../utils/index.dart';

class Day05 extends GenericDay {
  Day05() : super(5);

  @override
  PrintQueueInput parseInput() {
    final split = input.getBy('\n\n');
    const splitter = LineSplitter();
    final rules = splitter.convert(split[0]).map(
      (e) {
        final [a, b, ...] = e.split('|');
        return (int.parse(a), int.parse(b));
      },
    ).toList();
    final pages = splitter.convert(split[1]).map(
      (e) {
        return e.split(',').map(int.parse).toList();
      },
    ).toList();
    return PrintQueueInput(orderRules: rules, pagesToProduce: pages);
  }

  @override
  int solvePart1() {
    final printQueue = parseInput();
    return printQueue.pagesToProduce.map(
      (pages) {
        final sortedPages = [...pages].sortedByCompare(
          (element) => element,
          (a, b) {
            return comparePageNumber(a, b, printQueue);
          },
        );
        if (listsEqual(pages, sortedPages)) {
          return pages.middlePageNumber;
        }
        return 0;
      },
    ).fold(
      0,
      (previousValue, element) => previousValue + element,
    );
  }

  @override
  int solvePart2() {
    final printQueue = parseInput();
    return printQueue.pagesToProduce.map(
      (pages) {
        final sortedPages = [...pages].sortedByCompare(
          (element) => element,
          (a, b) {
            return comparePageNumber(a, b, printQueue);
          },
        );
        if (!listsEqual(pages, sortedPages)) {
          return sortedPages.middlePageNumber;
        }
        return 0;
      },
    ).fold(
      0,
      (previousValue, element) => previousValue + element,
    );
  }
}

class PrintQueueInput {
  PrintQueueInput({required this.orderRules, required this.pagesToProduce});

  final List<(int, int)> orderRules;
  final List<List<int>> pagesToProduce;

  Set<int> get pagesWithRules {
    return orderRules
        .expand<int>(
          (element) => [element.$1, element.$2],
        )
        .toSet();
  }
}

extension on List<int> {
  int get middlePageNumber {
    final middle = length ~/ 2;
    return this[middle];
  }
}

int comparePageNumber(int a, int b, PrintQueueInput input) {
  final ruleSet = input.pagesWithRules;
  final orderRules = input.orderRules;
  if (ruleSet.contains(a)) {
    if (ruleSet.contains(b)) {
      if (orderRules.contains((a, b))) {
        return -1;
      }
      if (orderRules.contains((b, a))) {
        return 1;
      }
    }
  }
  return 0;
}
