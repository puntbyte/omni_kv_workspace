import '../core/kv_converter.dart';

/// A highly flexible converter that takes inline encode and decode callbacks.
/// This is the recommended way to store Dart 3 Records or custom classes.
final class InlineKvConverter<T, S> implements KvConverter<T?, Object?> {
  const InlineKvConverter({
    required this.onEncode,
    required this.onDecode,
  });

  final S Function(T value) onEncode;
  final T Function(Object? value) onDecode;

  @override
  Object? encode(T? value) => value == null ? null : onEncode(value);

  @override
  T? decode(Object? value) => value == null ? null : onDecode(value);
}
