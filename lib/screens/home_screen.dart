
import 'package:flutter/material.dart';

import '../services/classifier.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.classifier,
  });

  final Classifier classifier;

  void showComingSoon(BuildContext context, String source) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$source will be available in Part 5.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Object Lens'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What would you like to identify?',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose an image source to get started.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),

            _SourceCard(
              icon: Icons.camera_alt_outlined,
              title: 'Take a photo',
              subtitle: 'Use your device camera',
              onTap: () => showComingSoon(context, 'Camera'),
            ),
            const SizedBox(height: 12),

            _SourceCard(
              icon: Icons.photo_library_outlined,
              title: 'Choose from gallery',
              subtitle: 'Select an existing image',
              onTap: () => showComingSoon(context, 'Gallery'),
            ),
            const SizedBox(height: 12),

            _SourceCard(
              icon: Icons.link,
              title: 'Download image',
              subtitle: 'Enter an image URL',
              onTap: () => showComingSoon(context, 'URL download'),
            ),

            const SizedBox(height: 32),
            Text(
              'Your latest activity',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 14),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.image_search_outlined,
                      size: 36,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No results yet',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your classifications will appear here.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(subtitle, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
