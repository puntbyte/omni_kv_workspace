import '../../omni_kv.dart' show KvGateway;
import 'kv_gateway.dart' show KvGateway;
import 'kv_storage_codec.dart';

/// Base marker interface for anything that can be used by [KvGateway].
///
/// Capabilities implement this marker directly. Real storage adapters should
/// implement [KvAdapter] so they expose their storage codec.
abstract interface class KvCapability {}

/// Base interface for real storage adapters.
///
/// Capabilities describe behavior. An adapter describes a concrete storage
/// backend and owns the codec used to translate logical PolyKV keys/values to
/// backend storage keys/values.
abstract interface class KvAdapter implements KvCapability {
  KvStorageCodec get codec;
}

/// Optional runtime metadata. Compile-time capability interfaces still control
/// which methods autocomplete.
final class KvCapabilities {
  const KvCapabilities({
    this.readable = false,
    this.writable = false,
    this.removable = false,
    this.clearable = false,
    this.watchable = false,
    this.batch = false,
  });

  final bool readable;
  final bool writable;
  final bool removable;
  final bool clearable;
  final bool watchable;
  final bool batch;
}
