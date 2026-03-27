/// Mirrors Go backend OCRScanResponse
class OcrScanResult {
  final List<OcrNewItem> newItems;
  final List<OcrExistingItem> existingItems;
  final List<OcrLowConfidenceItem> lowConfidenceItems;
  final OcrMetadata metadata;

  const OcrScanResult({
    required this.newItems,
    required this.existingItems,
    required this.lowConfidenceItems,
    required this.metadata,
  });

  int get totalDetected => newItems.length + existingItems.length + lowConfidenceItems.length;

  factory OcrScanResult.fromJson(Map<String, dynamic> json) {
    return OcrScanResult(
      newItems: (json['new_items'] as List<dynamic>?)
              ?.map((e) => OcrNewItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      existingItems: (json['existing_items'] as List<dynamic>?)
              ?.map((e) => OcrExistingItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lowConfidenceItems: (json['low_confidence'] as List<dynamic>?)
              ?.map((e) => OcrLowConfidenceItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      metadata: OcrMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );
  }
}

class OcrNewItem {
  final String hanzi;
  final double confidence;
  final List<String> candidates;
  bool selected;

  OcrNewItem({
    required this.hanzi,
    required this.confidence,
    this.candidates = const [],
    this.selected = true,
  });

  factory OcrNewItem.fromJson(Map<String, dynamic> json) {
    return OcrNewItem(
      hanzi: json['hanzi'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      candidates: (json['candidates'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

class OcrExistingItem {
  final String id;
  final String hanzi;
  final String? pinyin;
  final double confidence;

  const OcrExistingItem({
    required this.id,
    required this.hanzi,
    this.pinyin,
    required this.confidence,
  });

  factory OcrExistingItem.fromJson(Map<String, dynamic> json) {
    return OcrExistingItem(
      id: json['id'] as String,
      hanzi: json['hanzi'] as String,
      pinyin: json['pinyin'] as String?,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }
}

class OcrLowConfidenceItem {
  final String hanzi;
  final double confidence;
  final List<String> candidates;
  String? selectedCandidate;
  bool selected;

  OcrLowConfidenceItem({
    required this.hanzi,
    required this.confidence,
    this.candidates = const [],
    this.selectedCandidate,
    this.selected = false,
  });

  factory OcrLowConfidenceItem.fromJson(Map<String, dynamic> json) {
    return OcrLowConfidenceItem(
      hanzi: json['hanzi'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      candidates: (json['candidates'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

class OcrMetadata {
  final String engineUsed;
  final int totalDetected;
  final int processingTimeMs;

  const OcrMetadata({
    required this.engineUsed,
    required this.totalDetected,
    required this.processingTimeMs,
  });

  factory OcrMetadata.fromJson(Map<String, dynamic> json) {
    return OcrMetadata(
      engineUsed: json['engine_used'] as String,
      totalDetected: json['total_detected'] as int,
      processingTimeMs: json['processing_time_ms'] as int,
    );
  }
}
