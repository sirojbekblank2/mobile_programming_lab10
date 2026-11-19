
import 'package:flutter/material.dart';

import '../services/classifier.dart';
import '../services/history_service.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'model_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({
    super.key,
    required this.classifier,
    required this.history,
  });

  final Classifier classifier;
  final HistoryService history;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        classifier: widget.classifier,
        history: widget.history,
      ),
      HistoryScreen(history: widget.history),
      ModelScreen(classifier: widget.classifier),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.memory_outlined),
            selectedIcon: Icon(Icons.memory),
            label: 'Model',
          ),
        ],
      ),
    );
  }
}
