import 'dart:async';

import '../core/kv_capability.dart';
import '../core/kv_gateway.dart';
import '../models/kv_operation.dart';
import 'removable_capability.dart';
import 'writable_capability.dart';

/// Capability for grouped ordered writes/removes.
///
/// Batch execution is ordered. It does not guarantee atomic rollback unless a
/// specific adapter documents that behavior.
abstract mixin class BatchableKvCapability implements KvCapability {
  Future<void> batch(List<KvOperation> operations);
}

/// Reusable sequential batch behavior for adapters that already support writes
/// and removals.
mixin SequentialKvBatchCapability
    implements BatchableKvCapability, WritableKvCapability, RemovableKvCapability {
  @override
  Future<void> write(String key, Object? value);

  @override
  Future<void> remove(String key);

  @override
  Future<void> batch(List<KvOperation> operations) async {
    for (final operation in operations) {
      switch (operation) {
        case KvWriteOperation(:final key, :final value):
          await write(key, value);
        case KvRemoveOperation(:final key):
          await remove(key);
      }
    }
  }
}

/// Collects operations through the normal fluent entry API without executing them.
final class KvOperationRecorder implements WritableKvCapability, RemovableKvCapability {
  KvOperationRecorder();

  final List<KvOperation> _operations = [];

  List<KvOperation> get operations {
    return List<KvOperation>.unmodifiable(_operations);
  }

  @override
  Future<void> write(String key, Object? value) {
    if (value == null) {
      _operations.add(KvRemoveOperation(key));
    } else {
      _operations.add(KvWriteOperation(key, value));
    }

    return Future<void>.value();
  }

  @override
  Future<void> remove(String key) {
    _operations.add(KvRemoveOperation(key));
    return Future<void>.value();
  }
}

/// A restricted gateway scope that only permits write and remove operations.
typedef KvBatchScope = KvGateway<KvOperationRecorder>;

extension BatchableKvGatewayExtension<A extends BatchableKvCapability> on KvGateway<A> {
  /// Executes a sequence of write and remove operations as a single batch.
  Future<void> batch(
    FutureOr<void> Function(KvBatchScope scope) build,
  ) async {
    final recorder = KvOperationRecorder();
    await build(KvBatchScope(recorder));
    return adapter.batch(recorder.operations);
  }
}
