
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/classifier.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.imageBytes,
    required this.predictions,
    required this.source,
  });

  final Uint8List imageBytes;
  final List<Prediction> predictions;
  final String source;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.memory(
                    imageBytes,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Source: $source',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),
            Text(
              'Predictions',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            if (predictions.isEmpty)
              const Text('No predictions available.')
            else
              ...predictions.map((prediction) {
                final percentage = prediction.confidence * 100;
                final progress = prediction.confidence
                    .clamp(0.0, 1.0)
                    .toDouble();
                final isTop = prediction == predictions.first;

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
                                    : FontWeight.w500,
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
}
