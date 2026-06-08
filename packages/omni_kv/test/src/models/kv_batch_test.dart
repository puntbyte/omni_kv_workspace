import 'package:omni_kv/poly_kv.dart';
import 'package:test/test.dart';

import '../../helpers/app_key_fixture.dart';

void main() {
  group('KvBatch', () {
    test('gateway batch collects ordered operations', () async {
      final collector = KvBatchCollectorAdapter();
      final gateway = KvGateway(collector);

      await gateway.write(AppKey.theme, 'light');
      await gateway.remove(AppKey.theme);

      expect(collector.operations, hasLength(2));
      expect(collector.operations[0], isA<KvBatchWrite>());
      expect(collector.operations[1], isA<KvBatchRemove>());
      expect(collector.operations[0].key, 'theme');
    });
  });
}
