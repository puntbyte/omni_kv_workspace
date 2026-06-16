import '../core/kv_converter.dart';

sealed class UriKvConverter implements KvConverter<Uri?, Object?> {
  const factory UriKvConverter.toString() = _UriStringConverter;
}

final class _UriStringConverter implements UriKvConverter {
  const _UriStringConverter();

  @override
  String? encode(Uri? value) => value?.toString();

  @override
  Uri? decode(Object? value) => value == null ? null : Uri.parse(value as String);
}
