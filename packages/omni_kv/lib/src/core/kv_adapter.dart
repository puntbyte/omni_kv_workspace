import 'kv_capability.dart';
import 'kv_codec.dart';

/// Base interface for real storage adapters.
///
/// [TCapability] describes the adapter's compile-time feature set. The adapter
/// owns the codec used to translate logical OmniKV keys and values to backend
/// storage keys and values.
abstract interface class KvAdapter<TCapability extends KvCapability> {
  KvCodec get codec;
}
