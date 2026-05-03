import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class RebelBaseApp extends StatelessWidget {
  const RebelBaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'RebelBase Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
