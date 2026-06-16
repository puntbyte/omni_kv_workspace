import 'kv_adapter.dart';
import 'kv_gateway.dart';

/// Base marker interface for anything that can be used by [KvGateway].
///
/// Capabilities implement this marker directly. Real storage adapters should
/// implement [KvAdapter] so they expose their storage codec.
abstract interface class KvCapability {}
