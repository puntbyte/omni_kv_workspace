import 'package:poly_kv/poly_kv.dart';

enum AppTheme { system, light, dark }

final class AppKey<T> extends KvKey<T> {
  const AppKey.required(super.name, {super.converter}) : super.required();

  const AppKey.optional(super.name, {super.converter}) : super.optional();

  const AppKey.withDefault(super.name, T super.defaultValue, {super.converter})
    : super.withDefault();

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

extension AppKvNamespace<A extends KvAdapter> on KvGateway<A> {
  KvEntry<T, A> app<T>(AppKey<T> key) => entry(key);
}

extension AuthKvNamespace<A extends KvAdapter> on KvGateway<A> {
  KvEntry<T, A> auth<T>(AuthKey<T> key) => entry(key);
}
