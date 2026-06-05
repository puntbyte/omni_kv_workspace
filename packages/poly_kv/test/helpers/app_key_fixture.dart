import 'package:poly_kv/poly_kv.dart';

class AppKey<T> extends KvKey<T> {
  const AppKey.required(super.name, {super.converter}) : super.required();

  const AppKey.optional(super.name, {super.converter}) : super.optional();

  const AppKey.withDefault(super.name, T super.defaultValue, {super.converter})
    : super.withDefault();

  static const theme = AppKey<String>.withDefault('theme', 'dark');
}

extension AppKeyGatewayX<A extends KvAdapter> on KvGateway<A> {
  KvEntry<T, A> app<T>(AppKey<T> key) => entry(key);
}
