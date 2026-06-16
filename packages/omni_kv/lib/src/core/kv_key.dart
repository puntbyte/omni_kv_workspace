import '../utilities/kv_exception.dart';
import 'kv_converter.dart';

class KvKey<T> {
  const KvKey(
    this.id, {
    required this.defaultValue,
    this.namespace,
    this.converter,
  }) : hasDefaultValue = true;

  const KvKey.required(
    this.id, {
    this.namespace,
    this.converter,
  }) : defaultValue = null,
       hasDefaultValue = false;

  final String id;
  final String? namespace;
  final T? defaultValue;
  final bool hasDefaultValue;
  final KvConverter<T?, Object?>? converter;

  /// The fully qualified name of the key (e.g. "app.launch_count")
  String get name => namespace != null && namespace!.isNotEmpty ? '$namespace.$id' : id;

  Object? encode(T value) {
    if (value == null) return null;
    final converter = this.converter;
    return converter == null ? value : converter.encode(value);
  }

  T decode(Object? value, {required bool isPresent}) {
    if (!isPresent) {
      if (hasDefaultValue) return defaultValue as T;
      throw MissingValueKvException(name);
    }

    if (value == null) return null as T;

    try {
      final converter = this.converter;
      return converter == null ? value as T : converter.decode(value) as T;
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(
        TypeKvException(
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
