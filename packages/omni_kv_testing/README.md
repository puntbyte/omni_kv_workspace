# omni_kv_testing

Adapter conformance tests and shared test keys for OmniKV.

```dart
void main() {
  runFullKvAdapterTests(
    createAdapter: () async => MemoryKvAdapter(),
    disposeAdapter: (adapter) => adapter.close(),
  );
}
```
