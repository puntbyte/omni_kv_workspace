import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:poly_kv/poly_kv.dart';
import 'package:poly_kv_hive_ce/poly_kv_hive_ce.dart';
import 'package:test/test.dart';

import '../helpers/test_key_fixture.dart';

void main() {
  group('HiveCeKvAdapter', () {
    late Directory tempDir;
    late Box<Object?> box;
    late KvGateway<HiveCeKvAdapter> gateway;

    setUp(() async {
      tempDir = Directory.systemTemp.createTempSync('poly_kv_hive_test_');
      Hive.init(tempDir.path);
      box = await Hive.openBox<Object?>('test_box');
      gateway = KvGateway(HiveCeKvAdapter(box));
    });

    tearDown(() async {
      await Hive.close();
      if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
    });

    test('persists read and write operations', () async {
      await gateway.test(.theme).write('dark');
      expect(await gateway.test(.theme).read(), 'dark');
      expect(box.get('theme'), 'dark');
    });

    test('batch correctly updates and deletes', () async {
      await gateway.test(.theme).write('light');

      await gateway.batch([
        TestKey.theme.remove(),
        TestKey.volume.set(0.8),
      ]);

      expect(await gateway.test(.theme).exists(), isFalse);
      expect(await gateway.test(.volume).read(), 0.8);
    });

    test('clear empties the box', () async {
      await gateway.test(.theme).write('dark');
      await gateway.clear();
      expect(box.isEmpty, isTrue);
    });

    test('watch streams changes from the Hive Box', () async {
      final expectation = expectLater(
        gateway.test(.theme).watch().map((c) => c.value),
        emitsInOrder(['dark', null]),
      );

      await Future.delayed(const Duration(milliseconds: 50));
      await gateway.test(.theme).write('dark');

      await Future.delayed(const Duration(milliseconds: 50));
      await gateway.test(.theme).remove();

      await expectation;
    });
  });
}
