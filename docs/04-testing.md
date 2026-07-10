# 4. Testing adapters

`omni_kv_testing` provides reusable conformance tests.

```dart
void main() {
  group('Memory adapter conformance', () {
    runFullKvAdapterTests(
      createAdapter: () async => MemoryKvAdapter(),
      disposeAdapter: (adapter) => adapter.close(),
    );
  });
}
```
