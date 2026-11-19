
import 'package:flutter/material.dart';

import '../services/classifier.dart';

class ModelScreen extends StatelessWidget {
  const ModelScreen({
    super.key,
    required this.classifier,
  });

  final Classifier classifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Model information'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.memory,
                        color: theme.colorScheme.primary,
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Model details',
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _InfoRow(
                    label: 'Model file',
                    value: 'model_unquant.tflite',
                  ),
                  _InfoRow(
                    label: 'Input size',
                    value: '${Classifier.inputSize} × '
                        '${Classifier.inputSize}',
                  ),
                  _InfoRow(
                    label: 'Number of classes',
                    value: '${classifier.labels.length}',
                  ),
                  const _InfoRow(
                    label: 'Processing',
                    value: 'On-device',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Recognized classes',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ...classifier.labels.asMap().entries.map((entry) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    '${entry.key + 1}',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(entry.value),
              ),
            );
          }),
          const SizedBox(height: 28),
          Text(
            'Design reference',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          const Card(
            child: ListTile(
              leading: Icon(Icons.palette_outlined),
              title: Text('Material 3 Design Kit'),
              subtitle: Text('Google'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
