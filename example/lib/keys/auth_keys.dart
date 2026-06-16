import 'package:omni_kv/omni_kv.dart';

final class AuthKey<T> extends KvKey<T> {
  const AuthKey(super.id, {required super.defaultValue, super.converter}): super(namespace: 'auth');

  const AuthKey.required(super.id, {super.converter}) : super.required(namespace: 'auth');

  static const token = AuthKey<String?>('token', defaultValue: null);

  static const userProfile = AuthKey<Map<String, Object?>?>(
    'user_profile',
    defaultValue: null,
    converter: JsonKvConverter.toObject(),
  );
}

extension AuthKvGatewayNamespace<A extends KvCapability> on KvGateway<A> {
  KvEntry<T, A> auth<T>(AuthKey<T> key) => entry(key);
}
