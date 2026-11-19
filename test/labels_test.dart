
import 'package:flutter_test/flutter_test.dart';
import 'package:tm_classifier/services/classifier.dart';

void main() {
  group('parseLabels', () {
    test('parses normal labels', () {
      final result = parseLabels(
        '0 Local Cat\n'
        '1 Mixed Breed\n'
        '2 Persian cat\n'
        '3 Bird\n'
        '4 Sirojbek\n'
        '5 Hand\n',
      );

      expect(result, [
        'Local Cat',
        'Mixed Breed',
        'Persian cat',
        'Bird',
        'Sirojbek',
        'Hand',
      ]);
    });

    test('handles Windows line endings and spaces', () {
      final result = parseLabels(
        '0 Local Cat\r\n'
        '1 Mixed Breed\r\n'
        '2 Persian cat\r\n'
        '3 Bird\r\n'
        '4 Sirojbek\r\n'
        '5 Hand\r\n\r\n',
      );

      expect(result, [
        'Local Cat',
        'Mixed Breed',
        'Persian cat',
        'Bird',
        'Sirojbek',
        'Hand',
      ]);
    });
  });
}
