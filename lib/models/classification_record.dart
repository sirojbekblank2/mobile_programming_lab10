
import 'dart:typed_data';

import '../services/classifier.dart';

class ClassificationRecord {
  const ClassificationRecord({
    required this.imageBytes,
    required this.predictions,
    required this.source,
    required this.createdAt,
  });

  final Uint8List imageBytes;
  final List<Prediction> predictions;
  final String source;
  final DateTime createdAt;

  Prediction? get topPrediction {
    if (predictions.isEmpty) return null;
    return predictions.first;
  }
}
