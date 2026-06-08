import 'package:omni_kv/omni_kv.dart';
import 'package:test/test.dart';

import '../../helpers/test_key_fixture.dart';

void main() {
  group('MemoryKvAdapter', () {
    late MemoryKvAdapter adapter;
    late KvGateway<MemoryKvAdapter> gateway;

    setUp(() {
      adapter = MemoryKvAdapter();
      gateway = KvGateway(adapter);
    });

    test('read, write, contains, remove', () async {
      expect(await gateway.test(.userName).read(), 'Anonymous'); // Default
      expect(await gateway.test(.userName).exists(), isFalse);

      await gateway.test(.userName).write('Alice');
      expect(await gateway.test(.userName).read(), 'Alice');
      expect(await gateway.test(.userName).exists(), isTrue);

      await gateway.test(.userName).remove();
      expect(await gateway.test(.userName).exists(), isFalse);
    });

    test('batch performs updates', () async {
      await gateway.batch((entry) async {
        await entry.test(TestKey.userName).write('Bob');
        await entry.test(TestKey.score).write(100);
      });

      expect(await gateway.test(.userName).read(), 'Bob');
      expect(await gateway.test(.score).read(), 100);

      await gateway.batch((entry) async {
        await entry.test(TestKey.score).remove();
      });

      expect(await gateway.test(.score).exists(), isFalse);
    });

    test('clear removes all keys', () async {
      await gateway.test(.userName).write('Charlie');
      await gateway.test(.score).write(50);

      await gateway.clear();

      expect(adapter.values, isEmpty);
      expect(await gateway.test(.userName).exists(), isFalse);
    });

    test('watch emits changes', () async {
      final expectation = expectLater(
        gateway.test(.score).watch().map((c) => c.value),
        emitsInOrder([10, 20, null]),
      );

      await gateway.test(.score).write(10);
      await gateway.test(.score).write(20);
      await gateway.test(.score).remove();

      await expectation;
    });
  });
}
