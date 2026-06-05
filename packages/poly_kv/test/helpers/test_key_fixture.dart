import 'package:poly_kv/poly_kv.dart';

/// A unified collection of keys used across all adapter tests.
class TestKey<T> extends KvKey<T> {
  const TestKey.required(super.name, {super.converter}) : super.required();

  const TestKey.optional(super.name, {super.converter}) : super.optional();

  const TestKey.withDefault(super.name, T super.defaultValue, {super.converter})
    : super.withDefault();

  static const userName = TestKey<String>.withDefault('user_name', 'Anonymous');
  static const score = TestKey<int>.required('score');

  static const theme = TestKey<String>.withDefault('theme', 'system');
  static const volume = TestKey<double>.required('volume');

  static const stringVal = TestKey<String>.required('str_val');
  static const intVal = TestKey<int>.required('int_val');
  static const doubleVal = TestKey<double>.required('double_val');
  static const boolVal = TestKey<bool>.required('bool_val');
  static const listVal = TestKey<List<String>>.required('list_val');
  static const mapVal = TestKey<Map<String, dynamic>>.required('map_val');

  static const token = TestKey<String>.required('token');
  static const pinCode = TestKey<int>.required('pin_code');
  static const metadata = TestKey<Map<String, dynamic>>.required('metadata');
}

extension TestKeyGatewayX<A extends KvAdapter> on KvGateway<A> {
  KvEntry<T, A> test<T>(TestKey<T> key) => entry(key);
}
