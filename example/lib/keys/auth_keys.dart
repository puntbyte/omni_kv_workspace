import 'package:poly_kv/poly_kv.dart';

final class AuthKey<T> extends KvKey<T> {
  const AuthKey.required(super.name, {super.converter}) : super.required();

  const AuthKey.optional(super.name, {super.converter}) : super.optional();

  const AuthKey.withDefault(
    super.name,
    T super.defaultValue, {
    super.converter,
  }) : super.withDefault();

  static const token = AuthKey<String?>.optional('auth.token');

  static const userProfile = AuthKey<Map<String, Object?>?>.optional(
    'auth.user_profile',
    converter: JsonConverter.toObject(),
  );
}

extension AuthKvGatewayNamespace<A extends KvCapability> on KvGateway<A> {
  AuthKvScope<A> get auth => AuthKvScope<A>(this);
}

final class AuthKvScope<A extends KvCapability> {
  const AuthKvScope(this.gateway);

  final KvGateway<A> gateway;

  KvEntry<T, A> call<T>(AuthKey<T> key) => gateway.entry(key);
}

extension AuthKvScopeBatchExtension<A extends BatchableKvCapability> on AuthKvScope<A> {
  Future<void> batch(void Function(AuthKvBatchScope entry) build) {
    return gateway.batch((entry) => build(AuthKvBatchScope(entry)));
  }
}

final class AuthKvBatchScope {
  const AuthKvBatchScope(this.gateway);

  final KvGateway<KvBatchCollectorAdapter> gateway;

  KvEntry<T, KvBatchCollectorAdapter> call<T>(AuthKey<T> key) => gateway.entry(key);
}
