import '../core/kv_adapter.dart';
import '../core/kv_gateway.dart';

/// Adapter capability for clearing values controlled by the adapter.
///
/// Scoped adapters should only clear values inside their configured scope.
abstract interface class ClearableKvAdapter implements KvAdapter {
  const ClearableKvAdapter();

  Future<void> clear();
}

extension ClearableKvGatewayExtension<A extends ClearableKvAdapter> on KvGateway<A> {
  Future<void> clear() => adapter.clear();
}
