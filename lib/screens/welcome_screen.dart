
import 'package:flutter/material.dart';

import '../services/classifier.dart';
import '../services/history_service.dart';
import 'main_navigation.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.classifier,
    required this.history,
  });

  final Classifier classifier;
  final HistoryService history;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.center_focus_strong,
                    size: 34,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Object Lens',
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  'Discover what is in your pictures using '
                  'an AI model running directly on your device.',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                Text(
                  'WHAT CAN IT RECOGNIZE?',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: classifier.labels.map((label) {
                    return Chip(
                      avatar: const Icon(
                        Icons.check_circle_outline,
                        size: 18,
                      ),
                      label: Text(label),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => MainNavigation(
                            classifier: classifier,
                            history: history,
                          ),
                        ),
                      );
                    },
                    child: const Text('Get started'),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'On-device image recognition',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
