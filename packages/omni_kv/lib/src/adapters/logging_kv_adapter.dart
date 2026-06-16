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

/// A decorator that wraps any [KvAdapter] and prints its operations to the console.
/// Invaluable for debugging disk reads and writes.
final class LoggingKvAdapter
    implements
        KvAdapter,
        ReadableKvCapability,
        WritableKvCapability,
        RemovableKvCapability,
        ClearableKvCapability,
        BatchableKvCapability,
        NamespaceWatchableKvCapability { // <-- UPDATED HERE
  const LoggingKvAdapter(
      this.delegate, {
        this.logger = print,
      });

  final KvAdapter delegate;
  final void Function(String message) logger;

  @override
  KvCodec get codec => delegate.codec;

  @override
  Future<Object?> read(String key) async {
    final value = await (delegate as ReadableKvCapability).read(key);
    logger('OmniKV [READ] $key -> $value');
    return value;
  }

  @override
  Future<bool> contains(String key) async {
    final result = await (delegate as ReadableKvCapability).contains(key);
    logger('OmniKV [CONTAINS] $key -> $result');
    return result;
  }

  @override
  Future<void> write(String key, Object? value) async {
    logger('OmniKV [WRITE] $key -> $value');
    await (delegate as WritableKvCapability).write(key, value);
  }

  @override
  Future<void> remove(String key) async {
    logger('OmniKV [REMOVE] $key');
    await (delegate as RemovableKvCapability).remove(key);
  }

  @override
  Future<void> clear() async {
    logger('OmniKV [CLEAR] Initiated');
    await (delegate as ClearableKvCapability).clear();
    logger('OmniKV [CLEAR] Completed');
  }

  @override
  Future<void> batch(List<KvOperation> operations) async {
    logger('OmniKV [BATCH] ${operations.length} operations');
    await (delegate as BatchableKvCapability).batch(operations);
  }

  @override
  Stream<KvChange<Object?>> watch(String key) {
    logger('OmniKV [WATCH] Subscribed to $key');
    return (delegate as WatchableKvCapability).watch(key);
  }

  @override
  Stream<KvChange<Object?>> watchAll([String? prefix]) {
    logger('OmniKV [WATCH_ALL] Subscribed to namespace: ${prefix ?? "global"}');
    return (delegate as NamespaceWatchableKvCapability).watchAll(prefix);
  }
}
