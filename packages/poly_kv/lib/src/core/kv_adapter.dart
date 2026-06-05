/// Base marker interface for all PolyKV adapters.
abstract interface class KvAdapter {}

/// Optional runtime metadata. Compile-time capability interfaces still control
/// which methods autocomplete.
final class KvCapabilities {
  const KvCapabilities({
    this.readable = false,
    this.writable = false,
    this.removable = false,
    this.clearable = false,
    this.watchable = false,
    this.batch = false,
  });

  final bool readable;
  final bool writable;
  final bool removable;
  final bool clearable;
  final bool watchable;
  final bool batch;
}
