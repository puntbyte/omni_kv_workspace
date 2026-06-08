import 'package:omni_kv/poly_kv.dart';

final class AuthKey<T> extends KvKey<T> {
  const AuthKey(super.name, {required super.defaultValue, super.converter});

  const AuthKey.required(super.name, {super.converter}) : super.required();

  static const token = AuthKey<String?>('auth.token', defaultValue: null);

  static const userProfile = AuthKey<Map<String, Object?>?>(
    'auth.user_profile',
    defaultValue: null,
    converter: JsonConverter.toObject(),
  );
}

extension AuthKvGatewayNamespace<A extends KvCapability> on KvGateway<A> {
  KvEntry<T, A> auth<T>(AuthKey<T> key) => entry(key);
}
