import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../provider/firebase_provider.dart';
import '../provider/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final fire = Provider.of<FireProvider>(context, listen: false);
    final textStyle = Theme.of(context).textTheme.headlineSmall;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).primaryTextTheme.displaySmall,
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              'Theme',
              style: textStyle,
            ),
            leading: Icon(
              theme.isDarkMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            trailing: Switch(
              value: !theme.isDarkMode,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (bool value) {
                theme.toggleTheme();
              },
            ),
          ),
          Expanded(child: Container()),
          ListTile(
            title: Text(
              'Sign Out',
              style: textStyle,
            ),
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onTap: () async {
              await fire.auth.signOut();
              if (context.mounted) {
                context.go('/');
              }
            },
          ),
        ],
      ),
    );
  }
}
