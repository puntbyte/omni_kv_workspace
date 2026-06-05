# poly_kv

Pure Dart core APIs for PolyKV.

Includes:

- `KvKey<T>` typed keys
- `KvGateway<A>` storage gateway
- capability interfaces
- built-in converters
- exceptions
- `MemoryKvAdapter` for tests, demos, and temporary runtime state

```dart
import 'package:poly_kv/poly_kv.dart';

const launchCount = KvKey<int>.withDefault('launch_count', 0);

final kv = KvGateway(MemoryKvAdapter(prefix: 'example.'));
await kv.write(launchCount, 1);
final count = await kv.read(launchCount);
```
