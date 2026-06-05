import '../core/kv_converter.dart';

sealed class UriConverter implements KvConverter<Uri?, Object?> {
  const factory UriConverter.toString() = _UriStringConverter;
}

final class _UriStringConverter implements UriConverter {
  const _UriStringConverter();

  @override
  String? encode(Uri? value) => value?.toString();

  @override
  Uri? decode(Object? value) => value == null ? null : Uri.parse(value as String);
}
