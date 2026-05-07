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

  const supabaseUrl = 'https://zlvzjnvxoabvvsyurmxl.supabase.co';
  const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpsdnpqbnZ4b2FidnZzeXVybXhsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzczMzU5NTQsImV4cCI6MjA5MjkxMTk1NH0.XzorR0S5TMBHCEQJ3O47HU9ucbl1gPIF8BbI9Ov-25k';
  final supabaseEnabled = supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  // if (supabaseEnabled) {
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  // }

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
