
import 'package:flutter/material.dart';

import '../services/history_service.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    super.key,
    required this.history,
  });

  final HistoryService history;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final records = widget.history.records;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          if (records.isNotEmpty)
            IconButton(
              tooltip: 'Clear history',
              icon: const Icon(Icons.delete_outline),
              onPressed: _confirmClear,
            ),
        ],
      ),
      body: records.isEmpty
          ? _buildEmptyState(context)
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final record = records[index];
                final prediction = record.topPrediction;

                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(
                        record.imageBytes,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) {
                          return const SizedBox(
                            width: 64,
                            height: 64,
                            child: Icon(Icons.broken_image),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      prediction?.label ?? 'Unknown',
                      style: theme.textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      '${record.source} • '
                      '${((prediction?.confidence ?? 0) * 100).toStringAsFixed(1)}%'
                      '\n${_formatDate(record.createdAt)}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ResultScreen(record: record),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history,
                size: 48,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Nothing here yet',
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Your previous image classifications will appear here.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmClear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear history?'),
          content: const Text(
            'This will remove all classification records from this session.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      setState(widget.history.clear);
    }
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();

    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${twoDigits(local.day)}/${twoDigits(local.month)}/'
        '${local.year} ${twoDigits(local.hour)}:${twoDigits(local.minute)}';
  }
}
