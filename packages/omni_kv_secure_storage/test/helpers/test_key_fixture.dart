import 'package:omni_kv/omni_kv.dart';

class TestKey<T> extends KvKey<T> {
  const TestKey(super.name, {required super.defaultValue, super.converter});

  const TestKey.required(super.name, {super.converter}) : super.required();

  static const userName = TestKey<String>('user_name', defaultValue: 'Anonymous');
  static const score = TestKey<int>.required('score');

  static const theme = TestKey<String>('theme', defaultValue: 'system');
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

extension TestKeyGatewayX<A extends KvCapability> on KvGateway<A> {
  KvEntry<T, A> test<T>(TestKey<T> key) => entry(key);
}
