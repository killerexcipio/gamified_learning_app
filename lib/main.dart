import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'core/app_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  final cache = await Hive.openBox<dynamic>('rebelbase_demo_cache');

  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  final supabaseEnabled = supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  if (supabaseEnabled) {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  final repository = AppRepository(cache: cache, supabaseEnabled: supabaseEnabled);
  await repository.load();

  runApp(
    ProviderScope(
      overrides: [
        appRepositoryProvider.overrideWith((ref) => repository),
      ],
      child: const RebelBaseApp(),
    ),
  );
}
