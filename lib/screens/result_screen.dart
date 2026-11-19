
import 'package:flutter/material.dart';

import '../models/classification_record.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.record,
  });

  final ClassificationRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPrediction = record.topPrediction;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Classification result'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 360,
                  minHeight: 120,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.memory(
                    record.imageBytes,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) {
                      return const Center(
                        child: Icon(Icons.broken_image, size: 60),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Icon(
                  Icons.source_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Source: ${record.source}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Classified: ${_formatDate(record.createdAt)}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),

            if (topPrediction != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOP PREDICTION',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        topPrediction.label,
                        style: theme.textTheme.headlineMedium,
                      ),
                      Text(
                        '${(topPrediction.confidence * 100).toStringAsFixed(1)}% confidence',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            Text(
              'All predictions',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            if (record.predictions.isEmpty)
              const Text('No predictions available.')
            else
              ...record.predictions.asMap().entries.map((entry) {
                final index = entry.key;
                final prediction = entry.value;
                final percentage = prediction.confidence * 100;
                final progress = prediction.confidence
                    .clamp(0.0, 1.0)
                    .toDouble();
                final isTop = index == 0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              prediction.label,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: isTop
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 9,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          color: isTop
                              ? theme.colorScheme.primary
                              : theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();

    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${twoDigits(local.day)}/${twoDigits(local.month)}/'
        '${local.year} ${twoDigits(local.hour)}:${twoDigits(local.minute)}';
  }
}
