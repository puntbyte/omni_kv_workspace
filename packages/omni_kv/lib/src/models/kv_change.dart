sealed class KvChange<T> {
  const KvChange({
    required this.key,
    required this.value,
    required this.previousValue,
  });

  final String key;
  final T? value;
  final T? previousValue;
}

final class KvValueChanged<T> extends KvChange<T> {
  const KvValueChanged({
    required super.key,
    required super.value,
    required super.previousValue,
  });
}

final class KvValueRemoved<T> extends KvChange<T> {
  const KvValueRemoved({
    required super.key,
    required super.previousValue,
  }) : super(value: null);
}
