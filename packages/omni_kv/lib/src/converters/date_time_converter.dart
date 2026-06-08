import '../core/kv_converter.dart';

sealed class DateTimeConverter implements KvConverter<DateTime?, Object?> {
  const factory DateTimeConverter.toIsoString() = _DateTimeIsoStringConverter;

  const factory DateTimeConverter.toMilliseconds() = _DateTimeMillisecondsConverter;
}

final class _DateTimeIsoStringConverter implements DateTimeConverter {
  const _DateTimeIsoStringConverter();

  @override
  String? encode(DateTime? value) => value?.toIso8601String();

  @override
  DateTime? decode(Object? value) => switch (value) {
    null => null,
    final DateTime dateTime => dateTime,
    final String string => DateTime.parse(string),
    _ => throw FormatException('Expected ISO-8601 DateTime string, got $value'),
  };
}

final class _DateTimeMillisecondsConverter implements DateTimeConverter {
  const _DateTimeMillisecondsConverter();

  @override
  int? encode(DateTime? value) => value?.millisecondsSinceEpoch;

  @override
  DateTime? decode(Object? value) => switch (value) {
    null => null,
    final DateTime dateTime => dateTime,
    final int milliseconds => DateTime.fromMillisecondsSinceEpoch(milliseconds),
    final num milliseconds => DateTime.fromMillisecondsSinceEpoch(milliseconds.toInt()),
    final String string => DateTime.fromMillisecondsSinceEpoch(int.parse(string)),
    _ => throw FormatException('Expected DateTime milliseconds, got $value'),
  };
}
