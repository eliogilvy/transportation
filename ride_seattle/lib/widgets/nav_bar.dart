import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/nav_provider.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context, listen: true);
    final iconColor = Theme.of(context).colorScheme.onPrimaryContainer;
    final destinations = [
      NavigationDestination(
          icon: Icon(
            Icons.home,
            color: iconColor,
          ),
          label: 'Home'),
      NavigationDestination(
          icon: Icon(
            Icons.star,
            color: iconColor,
          ),
          label: 'My routes'),
      NavigationDestination(
          icon: Icon(
            Icons.credit_card,
            color: iconColor,
          ),
          label: 'Pay'),
      NavigationDestination(
          icon: Icon(
            Icons.settings,
            color: iconColor,
          ),
          label: 'Settings'),
    ];
    return NavigationBar(
      destinations: destinations,
      selectedIndex: navProvider.currentIndex,
      onDestinationSelected: (value) {
        navProvider.currentIndex = value;
        navProvider.isMaps = value == 0;
      },
      shadowColor: Theme.of(context).colorScheme.surface,
      elevation: 10,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
    );
  }
}
