import '../utilities/kv_exception.dart';
import 'kv_converter.dart';

/// A typed key. The key carries the Dart value type [T].
///
/// Missing-value behavior is explicit:
///
/// ```dart
/// const launchCount = KvKey<int>.withDefault('launch_count', 0);
/// const token = KvKey<String>.required('auth_token');
/// const nickname = KvKey<String?>.optional('nickname');
/// ```
class KvKey<T> {
  /// Creates a key that throws [KvMissingValueException] when no value exists.
  const KvKey.required(
    this.name, {
    this.converter,
  }) : defaultValue = null,
       hasDefaultValue = false;

  /// Creates a key that returns `null` when no value exists.
  ///
  /// Use a nullable [T], for example `KvKey<String?>.optional('nickname')`.
  const KvKey.optional(
    this.name, {
    this.converter,
  }) : defaultValue = null,
       hasDefaultValue = true;

  /// Creates a key that returns [defaultValue] when no value exists.
  const KvKey.withDefault(
    this.name,
    this.defaultValue, {
    this.converter,
  }) : hasDefaultValue = true;

  final String name;
  final T? defaultValue;
  final bool hasDefaultValue;
  final KvConverter<T?, Object?>? converter;

  Object? encode(T value) {
    if (value == null) return null;
    final converter = this.converter;
    return converter == null ? value : converter.encode(value);
  }

  T decode(Object? value, {required bool isPresent}) {
    if (!isPresent) {
      if (hasDefaultValue) return defaultValue as T;
      throw KvMissingValueException(name);
    }

    if (value == null) return null as T;

    try {
      final converter = this.converter;
      return converter == null ? value as T : converter.decode(value) as T;
    } on Object catch (error) {
      throw KvTypeException('Failed to decode key "$name" as $T: $error');
    }
  }

  @override
  String toString() => 'KvKey<$T>($name)';
}
