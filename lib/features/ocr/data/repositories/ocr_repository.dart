import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:lu_mobile/core/constants/api_constants.dart';
import 'package:lu_mobile/core/network/api_client.dart';
import 'package:lu_mobile/features/ocr/data/models/ocr_result_model.dart';

class OcrRepository {
  final ApiClient _client;

  OcrRepository(this._client);

  /// Upload image and run OCR scan.
  /// Sends multipart/form-data: image file + type + language.
  Future<OcrScanResult> scan({
    required Uint8List imageBytes,
    required String fileName,
    String type = 'auto',
    String language = 'zh',
  }) async {
    final formData = FormData.fromMap({
      'image': MultipartFile.fromBytes(
        imageBytes,
        filename: fileName,
      ),
      'type': type,
      'language': language,
    });

    return _client.postMultipart<OcrScanResult>(
      ApiConstants.ocrScan,
      formData: formData,
      decoder: (d) => OcrScanResult.fromJson(d as Map<String, dynamic>),
    );
  }
}
