import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:omni_kv/omni_kv.dart';
import 'package:omni_kv_secure_storage/omni_kv_secure_storage.dart';
import 'package:omni_kv_shared_preferences/omni_kv_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'keys/app_keys.dart';
import 'keys/auth_keys.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PolyKvExampleApp());
}

class PolyKvExampleApp extends StatelessWidget {
  const PolyKvExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PolyKV Example',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
      home: const PolyKvHomePage(),
    );
  }
}

class PolyKvHomePage extends StatefulWidget {
  const PolyKvHomePage({super.key});

  @override
  State<PolyKvHomePage> createState() => _PolyKvHomePageState();
}

class _PolyKvHomePageState extends State<PolyKvHomePage> {
  late final KvGateway<MemoryKvAdapter> _memoryKv;
  late final Future<_Stores> _storesFuture;

  @override
  void initState() {
    super.initState();
    _memoryKv = KvGateway(
      MemoryKvAdapter(
        codec: const MemoryKvCodec(prefix: 'example.'),
      ),
    );
    _storesFuture = _openStores();
  }

  Future<_Stores> _openStores() async {
    final preferences = await SharedPreferences.getInstance();
    final sharedKv = KvGateway(
      SharedPreferencesKvAdapter(
        preferences,
        codec: const SharedPreferencesKvCodec(prefix: 'poly_kv.example.'),
      ),
    );
    const secureKv = KvGateway(
      SecureStorageKvAdapter(
        FlutterSecureStorage(),
        codec: SecureStorageKvCodec(prefix: 'poly_kv.example.'),
      ),
    );
    return _Stores(sharedKv: sharedKv, secureKv: secureKv);
  }

  Future<void> _runDemo(_Stores stores) async {
    await _memoryKv.app(.theme).write(AppTheme.dark);

    final currentCount = await stores.sharedKv.app(.launchCount).read();
    await stores.sharedKv.app(.launchCount).write(currentCount + 1);
    await stores.sharedKv.app(.lastOpenedAt).write(DateTime.now());

    await stores.secureKv.auth(.token).write('secure-token');
    await stores.secureKv.auth(.userProfile).write({'id': 42, 'role': 'owner'});

    setState(() {});
  }

  Future<void> _clearDemo(_Stores stores) async {
    await _memoryKv.clear();
    await stores.sharedKv.clear();
    await stores.secureKv.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_Stores>(
      future: _storesFuture,
      builder: (context, snapshot) {
        final stores = snapshot.data;

        return Scaffold(
          appBar: AppBar(title: const Text('PolyKV Example')),
          body: stores == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _ValueCard(
                      title: 'Memory theme',
                      value: _memoryKv.app(.theme).read(),
                    ),
                    _ValueCard(
                      title: 'SharedPreferences launch count',
                      value: stores.sharedKv.app(.launchCount).read(),
                    ),
                    _ValueCard(
                      title: 'SharedPreferences last opened',
                      value: stores.sharedKv.app(.lastOpenedAt).read(),
                    ),
                    _ValueCard(
                      title: 'SecureStorage token',
                      value: stores.secureKv.auth(.token).read(),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => _runDemo(stores),
                      child: const Text('Run demo writes'),
                    ),
                    OutlinedButton(
                      onPressed: () => _clearDemo(stores),
                      child: const Text('Clear scoped values'),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

final class _Stores {
  const _Stores({required this.sharedKv, required this.secureKv});

  final KvGateway<SharedPreferencesKvAdapter> sharedKv;
  final KvGateway<SecureStorageKvAdapter> secureKv;
}

class _ValueCard<T> extends StatelessWidget {
  const _ValueCard({required this.title, required this.value});

  final String title;
  final Future<T> value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<T>(
          future: value,
          builder: (context, snapshot) {
            final text = snapshot.hasData ? '${snapshot.data}' : 'No value';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(text),
              ],
            );
          },
        ),
      ),
    );
  }
}
