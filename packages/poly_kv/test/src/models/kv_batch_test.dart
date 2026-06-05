import 'package:poly_kv/poly_kv.dart';
import 'package:test/test.dart';

void main() {
  group('KvBatch', () {
    const key = KvKey<String>.required('username');

    test('KvKey extension generates correct KvWrite', () {
      final setOp = key.set('Alice');
      expect(setOp.key, key);
      expect(setOp.value, 'Alice');

      final removeOp = key.remove();
      expect(removeOp.key, key);
    });

    test('toRaw converts to adapter-friendly types', () {
      final setOp = key.set('Alice').toRaw() as KvRawSet;
      expect(setOp.key, 'username');
      expect(setOp.value, 'Alice');

      final removeOp = key.remove().toRaw() as KvRawRemove;
      expect(removeOp.key, 'username');
    });
  });
}
