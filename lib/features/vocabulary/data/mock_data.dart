import 'package:lu_mobile/features/vocabulary/data/models/vocabulary_model.dart';

/// HSK level metadata for the grid.
class HskLevelInfo {
  final int level;
  final String stage;
  final int totalWords;
  final int totalCharacters;
  final String accessTier; // 'free' or 'pro'

  const HskLevelInfo({
    required this.level,
    required this.stage,
    required this.totalWords,
    required this.totalCharacters,
    required this.accessTier,
  });
}

const hskLevels = [
  HskLevelInfo(level: 1, stage: 'Elementary A1', totalWords: 300, totalCharacters: 246, accessTier: 'free'),
  HskLevelInfo(level: 2, stage: 'Elementary A1', totalWords: 500, totalCharacters: 424, accessTier: 'free'),
  HskLevelInfo(level: 3, stage: 'Elementary A2', totalWords: 1000, totalCharacters: 636, accessTier: 'free'),
  HskLevelInfo(level: 4, stage: 'Intermediate B1', totalWords: 2000, totalCharacters: 1096, accessTier: 'pro'),
  HskLevelInfo(level: 5, stage: 'Intermediate B1', totalWords: 3600, totalCharacters: 1527, accessTier: 'pro'),
  HskLevelInfo(level: 6, stage: 'Intermediate B2', totalWords: 5400, totalCharacters: 1940, accessTier: 'pro'),
  HskLevelInfo(level: 7, stage: 'Advanced C1', totalWords: 7000, totalCharacters: 2421, accessTier: 'pro'),
  HskLevelInfo(level: 8, stage: 'Advanced C1', totalWords: 9000, totalCharacters: 2753, accessTier: 'pro'),
  HskLevelInfo(level: 9, stage: 'Advanced C2', totalWords: 11000, totalCharacters: 3088, accessTier: 'pro'),
];

/// Mock vocabulary data for HSK 1 demo.
final mockHsk1Vocabularies = [
  const VocabularyListItem(id: '1', hanzi: '你好', pinyin: 'nǐ hǎo', meaningVi: 'xin chào', meaningEn: 'hello', hskLevel: 1),
  const VocabularyListItem(id: '2', hanzi: '谢谢', pinyin: 'xiè xie', meaningVi: 'cảm ơn', meaningEn: 'thank you', hskLevel: 1),
  const VocabularyListItem(id: '3', hanzi: '再见', pinyin: 'zài jiàn', meaningVi: 'tạm biệt', meaningEn: 'goodbye', hskLevel: 1),
  const VocabularyListItem(id: '4', hanzi: '对不起', pinyin: 'duì bu qǐ', meaningVi: 'xin lỗi', meaningEn: 'sorry', hskLevel: 1),
  const VocabularyListItem(id: '5', hanzi: '没关系', pinyin: 'méi guān xi', meaningVi: 'không sao', meaningEn: 'it\'s okay', hskLevel: 1),
  const VocabularyListItem(id: '6', hanzi: '学习', pinyin: 'xué xí', meaningVi: 'học tập', meaningEn: 'to study', hskLevel: 1),
  const VocabularyListItem(id: '7', hanzi: '中国', pinyin: 'zhōng guó', meaningVi: 'Trung Quốc', meaningEn: 'China', hskLevel: 1),
  const VocabularyListItem(id: '8', hanzi: '朋友', pinyin: 'péng you', meaningVi: 'bạn bè', meaningEn: 'friend', hskLevel: 1),
  const VocabularyListItem(id: '9', hanzi: '老师', pinyin: 'lǎo shī', meaningVi: 'giáo viên', meaningEn: 'teacher', hskLevel: 1),
  const VocabularyListItem(id: '10', hanzi: '学生', pinyin: 'xué shēng', meaningVi: 'học sinh', meaningEn: 'student', hskLevel: 1),
  const VocabularyListItem(id: '11', hanzi: '爸爸', pinyin: 'bà ba', meaningVi: 'bố', meaningEn: 'father', hskLevel: 1),
  const VocabularyListItem(id: '12', hanzi: '妈妈', pinyin: 'mā ma', meaningVi: 'mẹ', meaningEn: 'mother', hskLevel: 1),
  const VocabularyListItem(id: '13', hanzi: '吃', pinyin: 'chī', meaningVi: 'ăn', meaningEn: 'to eat', hskLevel: 1),
  const VocabularyListItem(id: '14', hanzi: '喝', pinyin: 'hē', meaningVi: 'uống', meaningEn: 'to drink', hskLevel: 1),
  const VocabularyListItem(id: '15', hanzi: '水', pinyin: 'shuǐ', meaningVi: 'nước', meaningEn: 'water', hskLevel: 1),
  const VocabularyListItem(id: '16', hanzi: '茶', pinyin: 'chá', meaningVi: 'trà', meaningEn: 'tea', hskLevel: 1),
  const VocabularyListItem(id: '17', hanzi: '大', pinyin: 'dà', meaningVi: 'lớn', meaningEn: 'big', hskLevel: 1),
  const VocabularyListItem(id: '18', hanzi: '小', pinyin: 'xiǎo', meaningVi: 'nhỏ', meaningEn: 'small', hskLevel: 1),
  const VocabularyListItem(id: '19', hanzi: '好', pinyin: 'hǎo', meaningVi: 'tốt', meaningEn: 'good', hskLevel: 1),
  const VocabularyListItem(id: '20', hanzi: '不', pinyin: 'bù', meaningVi: 'không', meaningEn: 'not', hskLevel: 1),
  const VocabularyListItem(id: '21', hanzi: '是', pinyin: 'shì', meaningVi: 'là', meaningEn: 'to be', hskLevel: 1),
  const VocabularyListItem(id: '22', hanzi: '我', pinyin: 'wǒ', meaningVi: 'tôi', meaningEn: 'I/me', hskLevel: 1),
  const VocabularyListItem(id: '23', hanzi: '你', pinyin: 'nǐ', meaningVi: 'bạn', meaningEn: 'you', hskLevel: 1),
  const VocabularyListItem(id: '24', hanzi: '他', pinyin: 'tā', meaningVi: 'anh ấy', meaningEn: 'he', hskLevel: 1),
  const VocabularyListItem(id: '25', hanzi: '她', pinyin: 'tā', meaningVi: 'cô ấy', meaningEn: 'she', hskLevel: 1),
];

/// Mock detail data for demo.
const mockVocabularyDetail = VocabularyDetail(
  id: '6',
  hanzi: '学习',
  pinyin: 'xué xí',
  meaningVi: 'học tập',
  meaningEn: 'to study',
  hskLevel: 1,
  strokeCount: 11,
  radicals: ['子', '冖', '习'],
  recognitionOnly: true,
  frequencyRank: 42,
  examples: [
    ExampleDto(sentenceCn: '我每天学习中文。', sentenceVi: 'Tôi mỗi ngày học tiếng Trung.'),
    ExampleDto(sentenceCn: '他在大学学习。', sentenceVi: 'Anh ấy học ở đại học.'),
    ExampleDto(sentenceCn: '学习让人进步。', sentenceVi: 'Học tập giúp người ta tiến bộ.'),
  ],
  topics: [
    TopicDto(id: 't1', slug: 'education', nameCn: '学习教育', nameVi: 'Giáo dục', nameEn: 'Education'),
  ],
  grammarPoints: [
    GrammarPointDto(
      id: 'gp1',
      code: 'gp_sv',
      pattern: 'S + V + O',
      exampleCn: '我学习中文。',
      exampleVi: 'Tôi học tiếng Trung.',
      rule: 'Câu trần thuật cơ bản: Chủ ngữ + Động từ + Tân ngữ',
      hskLevel: 1,
    ),
  ],
);

/// Get mock detail for any vocabulary by id
VocabularyDetail getMockDetail(String id) {
  final item = mockHsk1Vocabularies.where((v) => v.id == id).firstOrNull;
  if (item == null) return mockVocabularyDetail;

  return VocabularyDetail(
    id: item.id,
    hanzi: item.hanzi,
    pinyin: item.pinyin,
    meaningVi: item.meaningVi,
    meaningEn: item.meaningEn,
    hskLevel: item.hskLevel,
    strokeCount: item.hanzi.length * 5,
    radicals: item.hanzi.split(''),
    examples: [
      ExampleDto(
        sentenceCn: '我喜欢${item.hanzi}。',
        sentenceVi: 'Tôi thích ${item.meaningVi}.',
      ),
    ],
    topics: const [
      TopicDto(id: 't1', slug: 'daily-life', nameCn: '日常生活', nameVi: 'Cuộc sống hằng ngày', nameEn: 'Daily Life'),
    ],
    grammarPoints: const [],
  );
}
