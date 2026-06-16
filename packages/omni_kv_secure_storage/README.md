# OmniKV: Secure Storage

[![pub package](https://img.shields.io/pub/v/omni_kv_secure_storage.svg)](https://pub.dev/packages/omni_kv_secure_storage)

The official `flutter_secure_storage` adapter for [OmniKV](https://pub.dev/packages/omni_kv). 
Perfect for securely storing auth tokens, API keys, and sensitive user data.

## Installation

You must install both the adapter and the underlying storage package:

```bash
flutter pub add omni_kv omni_kv_secure_storage flutter_secure_storage
```

## Quick Start & The Fast Cache Pattern

`flutter_secure_storage` can be notoriously slow because it interacts with the Android Keystore and
iOS Keychain. To achieve **instant synchronous reads** and add **stream support**, we highly
recommend wrapping it in OmniKV's built-in `CachedKvAdapter`:

```dart
import 'package:omni_kv/omni_kv.dart';
import 'package:omni_kv_secure_storage/omni_kv_secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  const storage = FlutterSecureStorage();
  
  // Wrap the slow secure storage in an instant memory cache!
  final kv = KvGateway(
    CachedKvAdapter(
      primary: MemoryKvAdapter(),
      persistent: SecureStorageKvAdapter(
        storage,
        codec: const SecureStorageKvCodec(prefix: 'my_app.secure.'),
      ),
    ),
  );

  // You can now read instantly, and even stream secure keys!
  // kv.auth(.token).watch().listen(...);
}
```

## Features & Limitations

- **Automatic Serialization:** `flutter_secure_storage` only accepts Strings natively. This adapter
  will automatically `jsonEncode` and `jsonDecode` non-string primitives (like integers or maps) for
  you.
- **Platform Behavior:** All platform-specific secure storage rules are provided by the underlying
  plugin.
- **Scoped Clearing:** If you provide a `prefix` to the codec, calling `kv.clear()` will **only**
  remove secure-storage keys that start with that prefix.

For full documentation on how to define keys and use the fluent API, see
the [core OmniKV package](https://pub.dev/packages/omni_kv).
