import 'dart:async';

import '../core/kv_adapter.dart';
import '../core/kv_gateway.dart';
import '../models/kv_batch.dart';
import 'removable.dart';
import 'writable.dart';

/// Capability for grouped ordered writes/removes.
///
/// Batch execution is ordered. It does not guarantee atomic rollback unless a
/// specific adapter documents that behavior.
abstract mixin class BatchableKvCapability implements KvCapability {
  Future<void> batch(List<KvBatchOperation> operations);
}

/// Reusable sequential batch behavior for adapters that already support writes
/// and removals.
///
/// This is not transactional. Operations run in order. If one operation fails,
/// earlier operations are not automatically rolled back.
mixin SequentialKvBatchCapability
    implements BatchableKvCapability, WritableKvCapability, RemovableKvCapability {
  @override
  Future<void> write(String key, Object? value);

  @override
  Future<void> remove(String key);

  @override
  Future<void> batch(List<KvBatchOperation> operations) async {
    for (final operation in operations) {
      switch (operation) {
        case KvBatchWrite(:final key, :final value):
          await write(key, value);
        case KvBatchRemove(:final key):
          await remove(key);
      }
    }
  }
}

/// Collects batch operations through the normal fluent entry API.
final class KvBatchCollectorAdapter implements WritableKvCapability, RemovableKvCapability {
  KvBatchCollectorAdapter();

  final List<KvBatchOperation> _operations = [];

  List<KvBatchOperation> get operations {
    return List<KvBatchOperation>.unmodifiable(_operations);
  }

  @override
  Future<void> write(String key, Object? value) {
    if (value == null) {
      _operations.add(KvBatchRemove(key));
    } else {
      _operations.add(KvBatchWrite(key, value));
    }

    return Future<void>.value();
  }

  @override
  Future<void> remove(String key) {
    _operations.add(KvBatchRemove(key));
    return Future<void>.value();
  }
}

extension BatchableKvGatewayExtension<A extends BatchableKvCapability> on KvGateway<A> {
  Future<void> batch(
    FutureOr<void> Function(KvGateway<KvBatchCollectorAdapter> entry) build,
  ) async {
    final collector = KvBatchCollectorAdapter();
    await build(KvGateway<KvBatchCollectorAdapter>(collector));
    return adapter.batch(collector.operations);
  }
}
