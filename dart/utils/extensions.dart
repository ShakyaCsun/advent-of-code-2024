import 'package:collection/collection.dart';

extension MapExtension<K, V> on Map<K, V> {
  V getValue(K key, {required V ifAbsent}) {
    return this[key] ?? ifAbsent;
  }
}

enum Part { one, two }

extension IterablePairX<T> on Iterable<T> {
  /// Adjacent Pairs of this [Iterable]
  Iterable<(T, T)> get adjacentPairs {
    return take(length - 1).mapIndexed((index, element) {
      return (element, elementAt(index + 1));
    });
  }

  /// All Pair combinations possible for this [Iterable]
  Iterable<(T, T)> get allPairs {
    if (length < 2) {
      return {};
    }
    final first = this.first;
    return {...skip(1).map((e) => (first, e)), ...skip(1).allPairs};
  }
}
