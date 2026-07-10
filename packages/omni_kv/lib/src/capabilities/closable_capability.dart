import '../core/kv_adapter.dart';
import '../core/kv_capability.dart';
import '../core/kv_gateway.dart';

/// Adapter contract for releasing resources.
abstract interface class ClosableKvAdapter<TCapability extends ClosableKvCapability>
    implements KvAdapter<TCapability> {
  Future<void> close();
}

extension ClosableKvGatewayExtension<TAdapter extends ClosableKvAdapter<dynamic>>
    on KvGateway<TAdapter> {
  Future<void> close() => adapter.close();
}
