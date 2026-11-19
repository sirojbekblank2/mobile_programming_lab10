
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/classification_record.dart';
import '../services/classifier.dart';
import '../services/history_service.dart';
import '../services/image_sources.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.classifier,
    required this.history,
  });

  final Classifier classifier;
  final HistoryService history;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImageSources _sources = ImageSources();
  final TextEditingController _urlController = TextEditingController();

  bool _isLoading = false;
  double? _downloadProgress;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _handleImage(
    Future<Uint8List?> Function() imageOperation,
    String source,
  ) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _downloadProgress = null;
    });

    try {
      final bytes = await imageOperation();

      if (!mounted) return;

      if (bytes == null) return;

      await _classifyAndOpen(bytes, source);
    } catch (e) {
      if (mounted) {
        _showError(e);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _downloadProgress = null;
        });
      }
    }
  }

  Future<void> _classifyAndOpen(
    Uint8List bytes,
    String source,
  ) async {
    final predictions = widget.classifier.classify(bytes);

    if (predictions.isEmpty) {
      throw Exception('The model returned no predictions.');
    }

    final record = ClassificationRecord(
      imageBytes: bytes,
      predictions: predictions,
      source: source,
      createdAt: DateTime.now(),
    );

    widget.history.add(record);

    if (!mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResultScreen(record: record),
      ),
    );
  }

  Future<void> _showUrlDialog() async {
    _urlController.clear();

    final url = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Download image'),
          content: TextField(
            controller: _urlController,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              hintText: 'https://example.com/image.jpg',
              labelText: 'Image URL',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  _urlController.text.trim(),
                );
              },
              child: const Text('Download'),
            ),
          ],
        );
      },
    );

    if (url == null || url.isEmpty || !mounted) return;

    await _handleImage(
      () async {
        return _sources.fromUrl(
          url,
          onProgress: (progress) {
            if (mounted) {
              setState(() {
                _downloadProgress = progress;
              });
            }
          },
        );
      },
      'URL',
    );
  }

  void _showError(Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $error'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final latest = widget.history.records.isEmpty
        ? null
        : widget.history.records.first;

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
              onTap: _isLoading
                  ? null
                  : () => _handleImage(
                        _sources.fromCamera,
                        'Camera',
                      ),
            ),
            const SizedBox(height: 12),

            _SourceCard(
              icon: Icons.photo_library_outlined,
              title: 'Choose from gallery',
              subtitle: 'Select an existing image',
              onTap: _isLoading
                  ? null
                  : () => _handleImage(
                        _sources.fromGallery,
                        'Gallery',
                      ),
            ),
            const SizedBox(height: 12),

            _SourceCard(
              icon: Icons.link,
              title: 'Download image',
              subtitle: 'Enter an image URL',
              onTap: _isLoading ? null : _showUrlDialog,
            ),

            if (_isLoading) ...[
              const SizedBox(height: 24),
              const Center(
                child: Text('Processing image...'),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: _downloadProgress,
              ),
              if (_downloadProgress != null) ...[
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    '${(_downloadProgress! * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ],

            const SizedBox(height: 32),
            Text(
              'Your latest activity',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 14),

            if (latest == null)
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
              )
            else
              Card(
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      latest.imageBytes,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    latest.topPrediction?.label ?? 'Unknown',
                  ),
                  subtitle: Text(
  '${latest.source} • '
  '${((latest.topPrediction?.confidence ?? 0) * 100).toStringAsFixed(1)}%',
),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ResultScreen(record: latest),
                      ),
                    );
                  },
                ),
              ),
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
  final VoidCallback? onTap;

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
