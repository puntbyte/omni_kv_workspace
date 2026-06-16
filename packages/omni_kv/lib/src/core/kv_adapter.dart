import '../../omni_kv.dart' show KvGateway;
import 'kv_capability.dart';
import 'kv_gateway.dart' show KvGateway;
import 'kv_codec.dart';

/// Base interface for real storage adapters.
///
/// Capabilities describe behavior. An adapter describes a concrete storage
/// backend and owns the codec used to translate logical PolyKV keys/values to
/// backend storage keys/values.
abstract interface class KvAdapter implements KvCapability {
  KvCodec get codec;
}
