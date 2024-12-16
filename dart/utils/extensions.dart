extension MapExtension<K, V> on Map<K, V> {
  V getValue(K key, {required V ifAbsent}) {
    return this[key] ?? ifAbsent;
  }
}
