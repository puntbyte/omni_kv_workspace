import 'kv_adapter.dart';
import 'kv_gateway.dart';
import 'kv_key.dart';

final class KvEntry<T, TAdapter extends KvAdapter<dynamic>> {
  const KvEntry(this.gateway, this.key);

  final KvGateway<TAdapter> gateway;
  final KvKey<T> key;
}
