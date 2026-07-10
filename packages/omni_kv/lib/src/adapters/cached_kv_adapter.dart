import 'composite_kv_adapters.dart';
import '../core/kv_capability.dart';
import '../core/kv_codec.dart';
import '../models/kv_change.dart';
import '../models/kv_operation.dart';
import '../utilities/kv_exception.dart';

/// Cache write policy for [CachedKvAdapter].
enum CachedKvWritePolicy {
  /// Await both primary and persistent writes before completing.
  writeThrough,

  /// Await the primary cache and enqueue persistent writes to be flushed later.
  writeBehind,
}

/// Decorator that acts as a fast in-memory/reactive cache over a slower
/// persistent adapter.
///
/// The type signature is intentionally strict: [primary] must be a full
/// watch-capable adapter and [persistent] must be a read/write/clear/batch
/// adapter. This avoids runtime capability casts.
final class CachedKvAdapter
    implements FullKvAdapter<CachedKvCapability> {
  CachedKvAdapter({
    required this.primary,
    required this.persistent,
    this.writePolicy = CachedKvWritePolicy.writeBehind,
    this.onWriteBehindError,
  });

  final FullKvAdapter<dynamic> primary;
  final ReadWriteClearBatchKvAdapter<dynamic> persistent;
  final CachedKvWritePolicy writePolicy;
  final void Function(Object error, StackTrace stackTrace)? onWriteBehindError;

  final List<Future<void>> _pendingWrites = [];

  @override
  KvCodec get codec => persistent.codec;

  @override
  Future<Object?> read(String key) async {
    if (await primary.contains(key)) {
      return primary.read(key);
    }

    if (await persistent.contains(key)) {
      final diskValue = await persistent.read(key);
      await primary.write(key, diskValue);
      return diskValue;
    }

    return null;
  }

  @override
  Future<bool> contains(String key) async {
    if (await primary.contains(key)) return true;
    return persistent.contains(key);
  }

  @override
  Future<void> write(String key, Object? value) async {
    await primary.write(key, value);
    await _persist(() => persistent.write(key, value));
  }

  @override
  Future<void> remove(String key) async {
    await primary.remove(key);
    await _persist(() => persistent.remove(key));
  }

  @override
  Future<void> clear({bool allowUnscoped = false}) async {
    await primary.clear(allowUnscoped: allowUnscoped);
    await persistent.clear(allowUnscoped: allowUnscoped);
  }

  @override
  Future<void> batch(List<KvOperation> operations) async {
    await primary.batch(operations);
    await _persist(() => persistent.batch(operations));
  }

  /// Waits for queued write-behind operations to complete.
  Future<void> flush() async {
    while (_pendingWrites.isNotEmpty) {
      final writes = List<Future<void>>.of(_pendingWrites);
      _pendingWrites.clear();
      await Future.wait(writes);
    }
  }

  @override
  Stream<KvChange<Object?>> watch(String key) => primary.watch(key);

  @override
  Stream<KvChange<Object?>> watchAll([String? prefix]) => primary.watchAll(prefix);

  @override
  Future<void> close() async {
    await flush();
    await primary.close();
    await persistent.close();
  }

  Future<void> _persist(Future<void> Function() action) async {
    switch (writePolicy) {
      case CachedKvWritePolicy.writeThrough:
        await action();
      case CachedKvWritePolicy.writeBehind:
        final future = action().catchError((Object error, StackTrace stackTrace) {
          final handler = onWriteBehindError;
          if (handler != null) {
            handler(error, stackTrace);
            return;
          }
          throw WriteBehindKvException(
            'CachedKvAdapter persistent write failed.',
            cause: error,
          );
        });
        _pendingWrites.add(future);
    }
  }
}
