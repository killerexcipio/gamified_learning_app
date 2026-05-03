import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const TextField(decoration: InputDecoration(labelText: 'Full name')),
          const SizedBox(height: 10),
          const TextField(decoration: InputDecoration(labelText: 'Email')),
          const SizedBox(height: 10),
          const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password')),
          const SizedBox(height: 10),
          const TextField(decoration: InputDecoration(labelText: 'Invite code or link token')),
          const SizedBox(height: 16),
          FilledButton(onPressed: () => context.go('/'), child: const Text('Create demo account')),
        ],
      ),
    );
  }
}
