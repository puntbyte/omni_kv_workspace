import 'package:poly_kv/poly_kv.dart';

enum AppTheme { system, light, dark }

final class AppKey<T> extends KvKey<T> {
  const AppKey.required(super.name, {super.converter}) : super.required();

  const AppKey.optional(super.name, {super.converter}) : super.optional();

  const AppKey.withDefault(
    super.name,
    T super.defaultValue, {
    super.converter,
  }) : super.withDefault();

  static const theme = AppKey<AppTheme>.withDefault(
    'app.theme',
    AppTheme.system,
    converter: EnumConverter.toName(AppTheme.values),
  );

  static const launchCount = AppKey<int>.withDefault('app.launch_count', 0);

  static const userName = AppKey<String?>.optional('app.user_name');

  static const lastOpenedAt = AppKey<DateTime?>.optional(
    'app.last_opened_at',
    converter: DateTimeConverter.toIsoString(),
  );

  static const profile = AppKey<Map<String, Object?>?>.optional(
    'app.profile',
    converter: JsonConverter.toObject(),
  );
}

extension AppKvGatewayNamespace<A extends KvCapability> on KvGateway<A> {
  AppKvScope<A> get app => AppKvScope<A>(this);
}

final class AppKvScope<A extends KvCapability> {
  const AppKvScope(this.gateway);

  final KvGateway<A> gateway;

  KvEntry<T, A> call<T>(AppKey<T> key) => gateway.entry(key);
}

extension AppKvScopeBatchExtension<A extends BatchableKvCapability> on AppKvScope<A> {
  Future<void> batch(void Function(AppKvBatchScope entry) build) {
    return gateway.batch((entry) => build(AppKvBatchScope(entry)));
  }
}

final class AppKvBatchScope {
  const AppKvBatchScope(this.gateway);

  final KvGateway<KvBatchCollectorAdapter> gateway;

  KvEntry<T, KvBatchCollectorAdapter> call<T>(AppKey<T> key) => gateway.entry(key);
}
