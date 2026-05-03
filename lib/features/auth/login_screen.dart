import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = TextEditingController(text: 'rezaur@example.com');
    final password = TextEditingController(text: 'demo-password');
    return Scaffold(
      backgroundColor: RbColors.darkShell,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.hexagon_outlined, color: RbColors.accent, size: 58),
                    const SizedBox(height: 12),
                    Text('rebelbase', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 8),
                    const Text('Demo login for the Flutter Android app.', textAlign: TextAlign.center, style: TextStyle(color: RbColors.muted)),
                    const SizedBox(height: 22),
                    TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
                    const SizedBox(height: 10),
                    TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
                    const SizedBox(height: 16),
                    FilledButton(onPressed: () => context.go('/'), child: const Text('Log in')),
                    TextButton(onPressed: () => context.go('/signup'), child: const Text('Create account')),
                    TextButton(onPressed: () => context.go('/invite/stu-sol-C3H7-DEMO'), child: const Text('Open demo invite')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
