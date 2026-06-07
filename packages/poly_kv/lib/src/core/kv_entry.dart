import 'kv_adapter.dart';
import 'kv_gateway.dart';
import 'kv_key.dart';

final class KvEntry<T, A extends KvCapability> {
  const KvEntry(this.gateway, this.key);

  final KvGateway<A> gateway;
  final KvKey<T> key;
}
