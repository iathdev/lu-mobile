import 'package:lu_mobile/features/ocr/data/models/ocr_result_model.dart';

/// Simulates an OCR scan result from the backend.
/// Mimics a photo of a textbook page with mixed confidence results.
OcrScanResult generateMockOcrResult() {
  return OcrScanResult(
    newItems: [
      OcrNewItem(hanzi: '图书馆', confidence: 0.96),
      OcrNewItem(hanzi: '作业', confidence: 0.93),
      OcrNewItem(hanzi: '考试', confidence: 0.91),
      OcrNewItem(hanzi: '教室', confidence: 0.89),
      OcrNewItem(hanzi: '黑板', confidence: 0.95),
      OcrNewItem(hanzi: '练习', confidence: 0.88),
    ],
    existingItems: const [
      OcrExistingItem(id: '6', hanzi: '学习', pinyin: 'xué xí', confidence: 0.98),
      OcrExistingItem(id: '9', hanzi: '老师', pinyin: 'lǎo shī', confidence: 0.97),
      OcrExistingItem(id: '10', hanzi: '学生', pinyin: 'xué shēng', confidence: 0.95),
    ],
    lowConfidenceItems: [
      OcrLowConfidenceItem(
        hanzi: '鑒',
        confidence: 0.62,
        candidates: ['鑒', '鑑', '監'],
      ),
      OcrLowConfidenceItem(
        hanzi: '藝',
        confidence: 0.58,
        candidates: ['藝', '蓺', '芸'],
      ),
    ],
    metadata: const OcrMetadata(
      engineUsed: 'google_vision',
      totalDetected: 11,
      processingTimeMs: 1847,
    ),
  );
}
