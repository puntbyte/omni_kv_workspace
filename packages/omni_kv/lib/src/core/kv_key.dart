import '../utilities/kv_exception.dart';
import 'kv_converter.dart';

/// A typed key. The key carries the Dart value type [T].
///
/// Missing-value behavior is explicit:
///
/// ```dart
/// const launchCount = KvKey<int>('launch_count', defaultValue: 0);
/// const nickname = KvKey<String?>('nickname', defaultValue: null);
/// const token = KvKey<String>.required('auth_token');
/// ```
class KvKey<T> {
  /// Creates a key that returns [defaultValue] when no value exists.
  ///
  /// To return `null` when no value exists, use a nullable [T] and provide `null`
  /// as the default value. For example: `KvKey<String?>('nickname', defaultValue: null)`.
  const KvKey(
    this.name, {
    required this.defaultValue,
    this.converter,
  }) : hasDefaultValue = true;

  /// Creates a key that throws [KvMissingValueException] when no value exists.
  const KvKey.required(
    this.name, {
    this.converter,
  }) : defaultValue = null,
       hasDefaultValue = false;

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
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(
        KvTypeException(
          'Failed to decode key "$name" as $T.',
          cause: error,
        ),
        stackTrace,
      );
    }
  }

  @override
  String toString() => 'KvKey<$T>($name)';
}
