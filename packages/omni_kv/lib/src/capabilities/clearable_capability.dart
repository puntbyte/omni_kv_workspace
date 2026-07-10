import '../core/kv_adapter.dart';
import '../core/kv_capability.dart';
import '../core/kv_gateway.dart';
import '../utilities/kv_exception.dart';

/// Adapter contract for clearing values controlled by an adapter.
///
/// Implementations should clear only keys owned by their codec. Unscoped clears
/// are dangerous for persistent stores and should require explicit opt-in.
abstract interface class ClearKvAdapter<TCapability extends ClearKvCapability>
    implements KvAdapter<TCapability> {
  Future<void> clear({bool allowUnscoped = false});
}

extension ClearKvGatewayExtension<TAdapter extends ClearKvAdapter<dynamic>> on KvGateway<TAdapter> {
  Future<void> clear({bool allowUnscoped = false}) {
    return adapter.clear(allowUnscoped: allowUnscoped);
  }
}

void ensureScopedClearAllowed({
  required bool isScoped,
  required bool allowUnscoped,
  required String adapterName,
}) {
  if (isScoped || allowUnscoped) return;

  throw UnsafeClearKvException(
    '$adapterName.clear() would clear an unscoped storage backend. '
    'Configure a codec prefix or pass allowUnscoped: true deliberately.',
  );
}
