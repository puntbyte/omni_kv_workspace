import '../capabilities/watchable_capability.dart';

/// Represents a change to a key-value entry, emitted by adapters that
/// implement [WatchableKvCapability].
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

/// Emitted when a value is written or updated.
final class KvUpdateChange<T> extends KvChange<T> {
  const KvUpdateChange({
    required super.key,
    required super.value,
    required super.previousValue,
  });
}

/// Emitted when a value is removed.
final class KvRemoveChange<T> extends KvChange<T> {
  const KvRemoveChange({
    required super.key,
    required super.previousValue,
  }) : super(value: null);
}
