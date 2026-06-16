import 'kv_capability.dart';
import 'kv_entry.dart';
import 'kv_key.dart';

final class KvGateway<A extends KvCapability> {
  const KvGateway(this.adapter);

  final A adapter;

  /// Fluent entry point utilizing Dart 3.10 call shorthand `prefs(.theme)`.
  KvEntry<T, A> call<T>(KvKey<T> key) => entry(key);

  /// Standard entry point `prefs.entry(AppKey.theme)`.
  KvEntry<T, A> entry<T>(KvKey<T> key) => KvEntry<T, A>(this, key);
}
