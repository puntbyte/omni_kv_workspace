import '../core/kv_adapter.dart';
import '../core/kv_gateway.dart';
import '../models/kv_batch.dart';

/// Adapter capability for writing/removing multiple values in one operation.
///
/// This is a convenience bulk operation. It does not guarantee atomic storage
/// transactions unless a specific adapter documents that behavior.
abstract interface class BatchableKvAdapter implements KvAdapter {
  const BatchableKvAdapter();

  Future<void> batch(List<KvRawWrite> writes);
}

extension BatchableGatewayExtension<A extends BatchableKvAdapter> on KvGateway<A> {
  Future<void> batch(List<KvWrite> writes) {
    return adapter.batch([
      for (final write in writes) write.toRaw(),
    ]);
  }
}
