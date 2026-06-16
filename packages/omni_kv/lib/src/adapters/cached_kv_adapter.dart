import 'dart:async';

import '../capabilities/batchable_capability.dart';
import '../capabilities/clearable_capability.dart';
import '../capabilities/readable_capability.dart';
import '../capabilities/removable_capability.dart';
import '../capabilities/watchable_capability.dart';
import '../capabilities/writable_capability.dart';
import '../core/kv_adapter.dart';
import '../core/kv_codec.dart';
import '../models/kv_change.dart';
import '../models/kv_operation.dart';
import 'memory_kv_adapter.dart';

/// Decorator that acts as an in-memory "hot" cache over a slower persistent adapter
/// (like SecureStorage).
///
/// Reads return instantly from memory. Writes update memory instantly and trigger
/// an unawaited asynchronous write to the persistent adapter.
final class CachedKvAdapter
    implements
        KvAdapter,
        ReadableKvCapability,
        WritableKvCapability,
        RemovableKvCapability,
        ClearableKvCapability,
        BatchableKvCapability,
        NamespaceWatchableKvCapability {
  // <-- UPDATED HERE
  const CachedKvAdapter({
    required this.primary,
    required this.persistent,
  });

  /// The fast cache layer (e.g. [MemoryKvAdapter]).
  final KvAdapter primary;

  /// The slow underlying layer (e.g. [SecureStorageKvAdapter]).
  final KvAdapter persistent;

  @override
  KvCodec get codec => persistent.codec;

  @override
  Future<Object?> read(String key) async {
    final cache = primary as ReadableKvCapability;
    final disk = persistent as ReadableKvCapability;

    if (await cache.contains(key)) {
      return cache.read(key);
    }

    if (await disk.contains(key)) {
      final diskValue = await disk.read(key);
      // Hydrate the fast cache for the next time
      await (primary as WritableKvCapability).write(key, diskValue);
      return diskValue;
    }

    return null;
  }

  @override
  Future<bool> contains(String key) async {
    if (await (primary as ReadableKvCapability).contains(key)) return true;
    return (persistent as ReadableKvCapability).contains(key);
  }

  @override
  Future<void> write(String key, Object? value) async {
    // Write to fast cache and await it so UI updates immediately
    await (primary as WritableKvCapability).write(key, value);

    // Fire and forget to persistent storage
    unawaited((persistent as WritableKvCapability).write(key, value));
  }

  @override
  Future<void> remove(String key) async {
    await (primary as RemovableKvCapability).remove(key);
    unawaited((persistent as RemovableKvCapability).remove(key));
  }

  @override
  Future<void> clear() async {
    await (primary as ClearableKvCapability).clear();
    await (persistent as ClearableKvCapability).clear();
  }

  @override
  Future<void> batch(List<KvOperation> operations) async {
    await (primary as BatchableKvCapability).batch(operations);
    unawaited((persistent as BatchableKvCapability).batch(operations));
  }

  @override
  Stream<KvChange<Object?>> watch(String key) {
    // Streams are sourced strictly from the fast primary adapter.
    return (primary as WatchableKvCapability).watch(key);
  }

  @override
  Stream<KvChange<Object?>> watchAll([String? prefix]) {
    // Streams are sourced strictly from the fast primary adapter.
    return (primary as NamespaceWatchableKvCapability).watchAll(prefix);
  }
}
