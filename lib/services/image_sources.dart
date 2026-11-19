
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageSources {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> fromCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );

    if (image == null) return null;
    return image.readAsBytes();
  }

  Future<Uint8List?> fromGallery() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (image == null) return null;
    return image.readAsBytes();
  }

  Future<Uint8List> fromUrl(
    String url, {
    void Function(double progress)? onProgress,
  }) async {
    final uri = Uri.tryParse(url.trim());

    if (uri == null ||
        !uri.hasScheme ||
        !['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty) {
      throw const FormatException('Please enter a valid image URL.');
    }

    final client = http.Client();

    try {
      final request = http.Request('GET', uri);

      final response = await client
          .send(request)
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        throw Exception(
          'Download failed. HTTP status: ${response.statusCode}',
        );
      }

      final contentType = response.headers['content-type'] ?? '';

      if (!contentType.toLowerCase().startsWith('image/')) {
        throw const FormatException(
          'This URL does not point to an image.',
        );
      }

      final totalBytes = response.contentLength;
      final builder = BytesBuilder();
      var receivedBytes = 0;

      await for (final chunk in response.stream.timeout(
        const Duration(seconds: 20),
      )) {
        builder.add(chunk);
        receivedBytes += chunk.length;

        if (totalBytes != null && totalBytes > 0) {
          onProgress?.call(receivedBytes / totalBytes);
        }
      }

      final bytes = builder.takeBytes();

      if (bytes.isEmpty) {
        throw const FormatException('The downloaded image is empty.');
      }

      onProgress?.call(1.0);
      return bytes;
    } finally {
      client.close();
    }
  }
}
