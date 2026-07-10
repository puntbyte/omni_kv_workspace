import 'package:omni_kv/omni_kv.dart';
import 'package:test/test.dart';

class TestKey<T> extends KvKey<T> {
  const TestKey(super.id, {required super.defaultValue, super.converter})
    : super(namespace: 'test');

  const TestKey.required(super.id, {super.converter}) : super.required(namespace: 'test');

  static const userName = TestKey<String>('user_name', defaultValue: 'Anonymous');
  static const score = TestKey<int>.required('score');
  static const theme = TestKey<String>('theme', defaultValue: 'system');
  static const volume = TestKey<double>.required('volume');
  static const enabled = TestKey<bool>.required('enabled');
  static const tags = TestKey<List<String>>('tags', defaultValue: <String>[]);

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

extension TestKeyGatewayX<TAdapter extends KvAdapter<dynamic>> on KvGateway<TAdapter> {
  KvEntry<T, TAdapter> test<T>(TestKey<T> key) => entry(key);
}

typedef CreateKvAdapter<TAdapter extends KvAdapter<dynamic>> = Future<TAdapter> Function();
typedef DisposeKvAdapter<TAdapter extends KvAdapter<dynamic>> = Future<void> Function(TAdapter adapter);

/// Runs common read/write/remove tests for any compatible adapter.
void runReadWriteKvAdapterTests<TAdapter extends ReadWriteKvAdapter<dynamic>>({
  required CreateKvAdapter<TAdapter> createAdapter,
  DisposeKvAdapter<TAdapter>? disposeAdapter,
}) {
  late TAdapter adapter;
  late KvGateway<TAdapter> gateway;

  setUp(() async {
    adapter = await createAdapter();
    gateway = KvGateway(adapter);
  });

  tearDown(() async {
    await disposeAdapter?.call(adapter);
  });

  test('reads defaults and writes typed values', () async {
    expect(await gateway.test(.userName).read(), 'Anonymous');
    expect(await gateway.test(.userName).exists(), isFalse);

    await gateway.test(.userName).write('Alice');
    await gateway.test(.score).write(42);

    expect(await gateway.test(.userName).read(), 'Alice');
    expect(await gateway.test(.score).read(), 42);
    expect(await gateway.test(.score).exists(), isTrue);
  });

  test('removes values', () async {
    await gateway.test(.theme).write('dark');
    await gateway.test(.theme).remove();
    expect(await gateway.test(.theme).exists(), isFalse);
    expect(await gateway.test(.theme).read(), 'system');
  });
}

/// Runs common clear tests for clear-capable adapters.
void runClearKvAdapterTests<TAdapter extends ReadWriteClearBatchKvAdapter<dynamic>>({
  required CreateKvAdapter<TAdapter> createAdapter,
  DisposeKvAdapter<TAdapter>? disposeAdapter,
}) {
  late TAdapter adapter;
  late KvGateway<TAdapter> gateway;

  setUp(() async {
    adapter = await createAdapter();
    gateway = KvGateway(adapter);
  });

  tearDown(() async {
    await disposeAdapter?.call(adapter);
  });

  test('clear removes adapter-owned values', () async {
    await gateway.test(.theme).write('dark');
    await gateway.test(.score).write(7);
    await gateway.clear(allowUnscoped: true);
    expect(await gateway.test(.theme).exists(), isFalse);
    expect(await gateway.test(.score).exists(), isFalse);
  });
}

/// Runs common batch tests for batch-capable adapters.
void runBatchKvAdapterTests<TAdapter extends ReadWriteClearBatchKvAdapter<dynamic>>({
  required CreateKvAdapter<TAdapter> createAdapter,
  DisposeKvAdapter<TAdapter>? disposeAdapter,
}) {
  late TAdapter adapter;
  late KvGateway<TAdapter> gateway;

  setUp(() async {
    adapter = await createAdapter();
    gateway = KvGateway(adapter);
  });

  tearDown(() async {
    await disposeAdapter?.call(adapter);
  });

  test('batch writes and removes in order', () async {
    await gateway.test(.theme).write('old');

    await gateway.batch((scope) async {
      await scope.test(.theme).remove();
      await scope.test(.score).write(99);
      await scope.test(.userName).write('Batch User');
    });

    expect(await gateway.test(.theme).exists(), isFalse);
    expect(await gateway.test(.score).read(), 99);
    expect(await gateway.test(.userName).read(), 'Batch User');
  });
}

/// Runs common watch tests for watch-capable adapters.
void runWatchKvAdapterTests<TAdapter extends FullKvAdapter<dynamic>>({
  required CreateKvAdapter<TAdapter> createAdapter,
  DisposeKvAdapter<TAdapter>? disposeAdapter,
}) {
  late TAdapter adapter;
  late KvGateway<TAdapter> gateway;

  setUp(() async {
    adapter = await createAdapter();
    gateway = KvGateway(adapter);
  });

  tearDown(() async {
    await disposeAdapter?.call(adapter);
  });

  test('watch emits updates and removes', () async {
    final expectation = expectLater(
      gateway.test(.score).watch().map((change) => change.value),
      emitsInOrder(<Object?>[1, 2, null]),
    );

    await Future<void>.delayed(const Duration(milliseconds: 10));
    await gateway.test(.score).write(1);
    await gateway.test(.score).write(2);
    await gateway.test(.score).remove();

    await expectation;
  });
}

/// Runs the full common suite for local/reactive adapters.
void runFullKvAdapterTests<TAdapter extends FullKvAdapter<dynamic>>({
  required CreateKvAdapter<TAdapter> createAdapter,
  DisposeKvAdapter<TAdapter>? disposeAdapter,
}) {
  runReadWriteKvAdapterTests<TAdapter>(
    createAdapter: createAdapter,
    disposeAdapter: disposeAdapter,
  );
  runClearKvAdapterTests<TAdapter>(
    createAdapter: createAdapter,
    disposeAdapter: disposeAdapter,
  );
  runBatchKvAdapterTests<TAdapter>(
    createAdapter: createAdapter,
    disposeAdapter: disposeAdapter,
  );
  runWatchKvAdapterTests<TAdapter>(
    createAdapter: createAdapter,
    disposeAdapter: disposeAdapter,
  );
}
