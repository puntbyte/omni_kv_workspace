import 'package:omni_kv/omni_kv.dart';

class AppKey<T> extends KvKey<T> {
  const AppKey(super.name, {required super.defaultValue, super.converter});

  const AppKey.required(super.name, {super.converter}) : super.required();

  static const theme = AppKey<String>('theme', defaultValue: 'dark');
}

extension AppKeyGatewayX<A extends KvCapability> on KvGateway<A> {
  KvEntry<T, A> app<T>(AppKey<T> key) => entry(key);
}
