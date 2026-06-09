import 'dart:convert';

import '../core/kv_converter.dart';

/// Converts a custom Dart class to and from a storable format.
sealed class ModelConverter<T> implements KvConverter<T?, Object?> {
  /// Stores the class as a JSON encoded String.
  /// (Highly recommended for SharedPreferences and SecureStorage).
  const factory ModelConverter.toJsonString({
    required Map<String, dynamic> Function(T model) toMap,
    required T Function(Map<String, dynamic> json) fromMap,
  }) = _ModelJsonStringConverter<T>;

  /// Stores the class as a raw Map.
  /// (Ideal for Hive and Memory adapters).
  const factory ModelConverter.toMap({
    required Map<String, dynamic> Function(T model) toMap,
    required T Function(Map<String, dynamic> map) fromMap,
  }) = _ModelMapConverter<T>;
}

final class _ModelJsonStringConverter<T> implements ModelConverter<T> {
  const _ModelJsonStringConverter({
    required Map<String, dynamic> Function(T model) toMap,
    required T Function(Map<String, dynamic> json) fromMap,
  }) : _toMap = toMap,
       _fromMap = fromMap;
  final Map<String, dynamic> Function(T model) _toMap;
  final T Function(Map<String, dynamic> json) _fromMap;

  @override
  String? encode(T? value) {
    if (value == null) return null;
    return jsonEncode(_toMap(value));
  }

  @override
  T? decode(Object? value) {
    if (value == null) return null;
    final map = jsonDecode(value as String) as Map<String, dynamic>;
    return _fromMap(map);
  }
}

final class _ModelMapConverter<T> implements ModelConverter<T> {
  const _ModelMapConverter({
    required Map<String, dynamic> Function(T model) toMap,
    required T Function(Map<String, dynamic> map) fromMap,
  }) : _toMap = toMap,
       _fromMap = fromMap;
  final Map<String, dynamic> Function(T model) _toMap;
  final T Function(Map<String, dynamic> map) _fromMap;

  @override
  Map<String, dynamic>? encode(T? value) {
    if (value == null) return null;
    return _toMap(value);
  }

  @override
  T? decode(Object? value) {
    if (value == null) return null;
    final map = (value as Map<dynamic, dynamic>).cast<String, dynamic>();
    return _fromMap(map);
  }
}
