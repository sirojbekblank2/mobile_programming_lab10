
import 'package:flutter_test/flutter_test.dart';
import 'package:tm_classifier/services/classifier.dart';

void main() {
  group('Prediction', () {
    test('stores label and confidence correctly', () {
      const prediction = Prediction('Persian cat', 0.95);

      expect(prediction.label, 'Persian cat');
      expect(prediction.confidence, 0.95);
    });

    test('accepts zero confidence', () {
      const prediction = Prediction('Bird', 0.0);

      expect(prediction.label, 'Bird');
      expect(prediction.confidence, 0.0);
    });

    test('accepts full confidence', () {
      const prediction = Prediction('Hand', 1.0);

      expect(prediction.label, 'Hand');
      expect(prediction.confidence, 1.0);
    });
  });
}
