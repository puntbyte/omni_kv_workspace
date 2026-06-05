import 'package:poly_kv/poly_kv.dart';

final class AuthKey<T> extends KvKey<T> {
  const AuthKey.required(super.name, {super.converter}) : super.required();

  const AuthKey.optional(super.name, {super.converter}) : super.optional();

  const AuthKey.withDefault(super.name, T super.defaultValue, {super.converter})
      : super.withDefault();

  static const token = AuthKey<String?>.optional('auth.token');

  static const userProfile = AuthKey<Map<String, Object?>?>.optional(
    'auth.user_profile',
    converter: JsonConverter.toObject(),
  );
}

extension AuthKvNamespace<A extends KvAdapter> on KvGateway<A> {
  KvEntry<T, A> auth<T>(AuthKey<T> key) => entry(key);
}
