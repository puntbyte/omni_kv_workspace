import '../core/kv_gateway.dart';
import 'batchable_capability.dart';
import 'clearable_capability.dart';
import 'closable_capability.dart';
import '../adapters/composite_kv_adapters.dart';
import 'readable_capability.dart';
import 'watchable_capability.dart';
import 'writable_capability.dart';

/// Gateway constrained to read-capable adapters.
typedef ReadKvGateway<TAdapter extends ReadKvAdapter<dynamic>> = KvGateway<TAdapter>;

/// Gateway constrained to write-capable adapters.
typedef WriteKvGateway<TAdapter extends WriteKvAdapter<dynamic>> = KvGateway<TAdapter>;

/// Gateway constrained to read/write/remove adapters.
typedef ReadWriteKvGateway<TAdapter extends ReadWriteKvAdapter<dynamic>> = KvGateway<TAdapter>;

/// Gateway constrained to clear-capable adapters.
typedef ClearKvGateway<TAdapter extends ClearKvAdapter<dynamic>> = KvGateway<TAdapter>;

/// Gateway constrained to watch-capable adapters.
typedef WatchKvGateway<TAdapter extends WatchKvAdapter<dynamic>> = KvGateway<TAdapter>;

/// Gateway constrained to batch-capable adapters.
typedef BatchKvGateway<TAdapter extends BatchKvAdapter<dynamic>> = KvGateway<TAdapter>;

/// Gateway constrained to close-capable adapters.
typedef CloseKvGateway<TAdapter extends ClosableKvAdapter<dynamic>> = KvGateway<TAdapter>;

/// Gateway constrained to full local/reactive adapters.
typedef FullKvGateway<TAdapter extends FullKvAdapter<dynamic>> = KvGateway<TAdapter>;
