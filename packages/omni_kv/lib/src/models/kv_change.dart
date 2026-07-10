import '../capabilities/watchable_capability.dart';

/// Represents a change to a key-value entry, emitted by adapters that
/// implement [WatchKvAdapter].
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
final class UpdateKvChange<T> extends KvChange<T> {
  const UpdateKvChange({
    required super.key,
    required super.value,
    required super.previousValue,
  });
}

/// Emitted when a value is removed.
final class RemoveKvChange<T> extends KvChange<T> {
  const RemoveKvChange({
    required super.key,
    required super.previousValue,
  }) : super(value: null);
}
