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
    return printQueue.pagesToProduce.fold(
      0,
      (previousValue, pages) {
        final sortedPages = pages.sorted(
          printQueue.comparePageNumber,
        );
        if (listsEqual(pages, sortedPages)) {
          return previousValue + pages.middlePageNumber;
        }
        return previousValue;
      },
    );
  }

  @override
  int solvePart2() {
    final printQueue = parseInput();
    return printQueue.pagesToProduce.fold(
      0,
      (previousValue, pages) {
        final sortedPages = pages.sorted(
          printQueue.comparePageNumber,
        );
        if (!listsEqual(pages, sortedPages)) {
          return previousValue + sortedPages.middlePageNumber;
        }
        return previousValue + 0;
      },
    );
  }
}

class PrintQueueInput {
  PrintQueueInput({required this.orderRules, required this.pagesToProduce});

  final List<(int, int)> orderRules;
  final List<List<int>> pagesToProduce;

  late final Set<int> _pagesWithRules = orderRules
      .expand<int>(
        (element) => [element.$1, element.$2],
      )
      .toSet();

  int comparePageNumber(int a, int b) {
    final ruleSet = _pagesWithRules;
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
}

extension on List<int> {
  int get middlePageNumber {
    final middle = length ~/ 2;
    return this[middle];
  }
}
