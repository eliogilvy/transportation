import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/firebase_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fire = Provider.of<FireProvider>(context);
    final user = fire.auth.currentUser!.displayName;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          Text('Hello, $user!', style: Theme.of(context).primaryTextTheme.bodyLarge),
        ],
      ),
    );
  }
}
