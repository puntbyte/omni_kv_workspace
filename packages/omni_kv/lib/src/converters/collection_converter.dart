import '../core/kv_converter.dart';

/// A namespace for collection converters.
abstract final class CollectionKvConverter {
  /// Converts a List of items, applying the [elementConverter] to each item.
  static KvConverter<List<T>?, Object?> toList<T>(
    KvConverter<T?, Object?> elementConverter,
  ) => _ListKvConverter<T>(elementConverter);

  /// Converts a Set of items, safely storing them as a List in the database.
  static KvConverter<Set<T>?, Object?> toSet<T>(
    KvConverter<T?, Object?> elementConverter,
  ) => _SetKvConverter<T>(elementConverter);
}

final class _ListKvConverter<T> implements KvConverter<List<T>?, Object?> {
  const _ListKvConverter(this.elementConverter);

  final KvConverter<T?, Object?> elementConverter;

  @override
  Object? encode(List<T>? value) {
    if (value == null) return null;
    return value.map(elementConverter.encode).toList();
  }

  @override
  List<T>? decode(Object? value) {
    if (value == null) return null;
    final list = value as List;
    return list.map((e) => elementConverter.decode(e) as T).toList();
  }
}

final class _SetKvConverter<T> implements KvConverter<Set<T>?, Object?> {
  const _SetKvConverter(this.elementConverter);

  final KvConverter<T?, Object?> elementConverter;

  @override
  Object? encode(Set<T>? value) {
    if (value == null) return null;
    return value.map(elementConverter.encode).toList();
  }

  @override
  Set<T>? decode(Object? value) {
    if (value == null) return null;
    final list = value as List;
    return list.map((e) => elementConverter.decode(e) as T).toSet();
  }
}
