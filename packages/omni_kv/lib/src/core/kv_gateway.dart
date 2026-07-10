import 'kv_adapter.dart';
import 'kv_entry.dart';
import 'kv_key.dart';

/// Typed facade over a concrete OmniKV adapter.
///
/// The gateway intentionally exposes only [TAdapter]. The adapter itself carries
/// its capability profile, so public usage stays ergonomic while extension
/// methods remain compile-time gated by adapter contracts.
final class KvGateway<TAdapter extends KvAdapter<dynamic>> {
  const KvGateway(this.adapter);

  final TAdapter adapter;

  /// Fluent entry point, for example `kv(.theme)`.
  KvEntry<T, TAdapter> call<T>(KvKey<T> key) => entry(key);

  /// Standard entry point, for example `kv.entry(AppKeys.theme)`.
  KvEntry<T, TAdapter> entry<T>(KvKey<T> key) => KvEntry<T, TAdapter>(this, key);
}
