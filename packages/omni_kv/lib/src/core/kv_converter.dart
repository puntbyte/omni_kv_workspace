import 'kv_key.dart';

/// Converts between the Dart value type [T] and the adapter storage value type [S].
///
/// Built-in converters accept nullable values so the same converter can be used
/// by both `KvKey<T>` and `KvKey<T?>`. PolyKV never calls a converter for a
/// missing value; missing/default handling is owned by [KvKey].
abstract interface class KvConverter<T, S> {
  S encode(T value);

  T decode(Object? value);
}
