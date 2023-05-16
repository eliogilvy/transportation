import 'package:flutter/material.dart';

class NavProvider extends ChangeNotifier {
  int currentIndex = 0;
  bool isMaps = true;

  List<Widget> destinations = const [
    NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.star), label: 'My routes'),
    NavigationDestination(icon: Icon(Icons.credit_card), label: 'Pay'),
    NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
  ];
}
