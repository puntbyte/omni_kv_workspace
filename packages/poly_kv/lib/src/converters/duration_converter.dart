import '../core/kv_converter.dart';

sealed class DurationConverter implements KvConverter<Duration?, Object?> {
  const factory DurationConverter.toMilliseconds() = _DurationMillisecondsConverter;
}

final class _DurationMillisecondsConverter implements DurationConverter {
  const _DurationMillisecondsConverter();

  @override
  int? encode(Duration? value) => value?.inMilliseconds;

  @override
  Duration? decode(Object? value) => switch (value) {
    null => null,
    final int milliseconds => Duration(milliseconds: milliseconds),
    final num milliseconds => Duration(milliseconds: milliseconds.toInt()),
    final String string => Duration(milliseconds: int.parse(string)),
    _ => throw FormatException('Expected duration milliseconds, got $value'),
  };
}
