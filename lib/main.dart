
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'services/classifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final classifier = await Classifier.load();

    final bytes = await rootBundle.load('assets/model/sample.jpg');

    final predictions = classifier.classify(
      bytes.buffer.asUint8List(),
    );

    debugPrint('--- MODEL PREDICTIONS ---');

    for (final prediction in predictions) {
      debugPrint(
        '${prediction.label}: '
        '${(prediction.confidence * 100).toStringAsFixed(1)}%',
      );
    }

    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Model loaded and tested successfully!'),
          ),
        ),
      ),
    );
  } catch (e) {
    debugPrint('CLASSIFIER ERROR: $e');

    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Classifier error: $e'),
          ),
        ),
      ),
    );
  }
}
