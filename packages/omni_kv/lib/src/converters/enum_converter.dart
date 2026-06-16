import '../core/kv_converter.dart';

sealed class EnumKvConverter<TEnum extends Enum> implements KvConverter<TEnum?, Object?> {
  const factory EnumKvConverter.toName(List<TEnum> values) = _EnumNameKvConverter<TEnum>;

  const factory EnumKvConverter.toIndex(List<TEnum> values) = _EnumIndexKvConverter<TEnum>;
}

final class _EnumNameKvConverter<TEnum extends Enum> implements EnumKvConverter<TEnum> {
  const _EnumNameKvConverter(this.values);

  final List<TEnum> values;

  @override
  String? encode(TEnum? value) => value?.name;

  @override
  TEnum? decode(Object? value) {
    if (value == null) return null;
    final name = value as String;
    return values.firstWhere((item) => item.name == name);
  }
}

final class _EnumIndexKvConverter<TEnum extends Enum> implements EnumKvConverter<TEnum> {
  const _EnumIndexKvConverter(this.values);

  final List<TEnum> values;

  @override
  int? encode(TEnum? value) => value?.index;

  @override
  TEnum? decode(Object? value) {
    if (value == null) return null;
    final index = switch (value) {
      final int integer => integer,
      final String string => int.parse(string),
      _ => throw FormatException('Expected enum index, got $value'),
    };
    return values[index];
  }
}
