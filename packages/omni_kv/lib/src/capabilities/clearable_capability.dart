import '../core/kv_capability.dart';
import '../core/kv_gateway.dart';

/// Capability for clearing values controlled by the implementation.
///
/// Scoped adapters should only clear values inside their configured scope.
abstract mixin class ClearableKvCapability implements KvCapability {
  Future<void> clear();
}

extension ClearableKvGatewayExtension<A extends ClearableKvCapability> on KvGateway<A> {
  Future<void> clear() => adapter.clear();
}
