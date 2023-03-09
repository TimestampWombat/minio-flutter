import 'package:quiver/collection.dart';
import 'package:collection/collection.dart';

extension MultimapX<K, V> on Multimap<K, V> {
  static Multimap<K, V> fromMap<K, V>(Map<K, V> map) {
    Multimap<K, V> multimap = Multimap();
    for (var entry in map.entries) {
      multimap.add(entry.key, entry.value);
    }
    return multimap;
  }

  bool equals(Multimap<K, V> other) =>
      MapEquality(values: UnorderedIterableEquality())
          .equals(asMap(), other.asMap());

  int get hash =>
      MapEquality(values: UnorderedIterableEquality()).hash(asMap());
}

class HashMultimap {
  HashMultimap._() {
    throw UnsupportedError("cannot initiate HashMultimap");
  }

  // TODO: extends Multimap
  static Multimap<K, V> create<K, V>() => Multimap<K, V>();
}

class Multimaps {
  Multimaps._() {
    throw UnsupportedError("cannot initiate Multimaps");
  }

  // TODO: extends Multimap
  static Multimap<K, V> unmodifiableMultimap<K, V>(Multimap<K, V> multimap) {
    return Multimap<K, V>()..addAll(multimap);
  }

  static Multimap<K, V> forMap<K, V>(Map<K, V> map) {
    Multimap<K, V> multimap = Multimap();
    map.forEach((key, value) {
      multimap.add(key, value);
    });

    return multimap;
  }
}
