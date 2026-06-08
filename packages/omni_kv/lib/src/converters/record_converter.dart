import 'dart:convert';

import '../core/kv_converter.dart';

/// Converts a Dart 3 Record to and from a storable format.
sealed class RecordConverter<T extends Record> implements KvConverter<T?, Object?> {
  /// Stores the record as a JSON encoded String.
  /// (Highly recommended for SharedPreferences and SecureStorage).
  const factory RecordConverter.toJsonString({
    required Map<String, dynamic> Function(T record) toMap,
    required T Function(Map<String, dynamic> json) fromMap,
  }) = _RecordJsonStringConverter<T>;

  /// Stores the record as a raw Map.
  /// (Ideal for Hive and Memory adapters).
  const factory RecordConverter.toMap({
    required Map<String, dynamic> Function(T record) toMap,
    required T Function(Map<String, dynamic> map) fromMap,
  }) = _RecordMapConverter<T>;
}

final class _RecordJsonStringConverter<T extends Record> implements RecordConverter<T> {
  const _RecordJsonStringConverter({
    required Map<String, dynamic> Function(T record) toMap,
    required T Function(Map<String, dynamic> json) fromMap,
  }) : _toMap = toMap,
       _fromMap = fromMap;
  final Map<String, dynamic> Function(T record) _toMap;
  final T Function(Map<String, dynamic> json) _fromMap;

  @override
  String? encode(T? value) {
    if (value == null) return null;
    return jsonEncode(_toMap(value)); // Automatically handles the JSON conversion!
  }

  @override
  T? decode(Object? value) {
    if (value == null) return null;
    final map = jsonDecode(value as String) as Map<String, dynamic>;
    return _fromMap(map);
  }
}

final class _RecordMapConverter<T extends Record> implements RecordConverter<T> {
  const _RecordMapConverter({
    required Map<String, dynamic> Function(T record) toMap,
    required T Function(Map<String, dynamic> map) fromMap,
  }) : _toMap = toMap,
       _fromMap = fromMap;
  final Map<String, dynamic> Function(T record) _toMap;
  final T Function(Map<String, dynamic> map) _fromMap;

  @override
  Map<String, dynamic>? encode(T? value) {
    if (value == null) return null;
    return _toMap(value);
  }

  @override
  T? decode(Object? value) {
    if (value == null) return null;
    final map = (value as Map).cast<String, dynamic>();
    return _fromMap(map);
  }
}
