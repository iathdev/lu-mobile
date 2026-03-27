/// Mirrors Go backend VocabularyListResponse
class VocabularyListItem {
  final String id;
  final String hanzi;
  final String? pinyin;
  final String? meaningVi;
  final String? meaningEn;
  final int? hskLevel;

  const VocabularyListItem({
    required this.id,
    required this.hanzi,
    this.pinyin,
    this.meaningVi,
    this.meaningEn,
    this.hskLevel,
  });

  factory VocabularyListItem.fromJson(Map<String, dynamic> json) {
    return VocabularyListItem(
      id: json['id'] as String,
      hanzi: json['hanzi'] as String,
      pinyin: json['pinyin'] as String?,
      meaningVi: json['meaning_vi'] as String?,
      meaningEn: json['meaning_en'] as String?,
      hskLevel: json['hsk_level'] as int?,
    );
  }
}

/// Mirrors Go backend VocabularyDetailResponse
class VocabularyDetail {
  final String id;
  final String hanzi;
  final String? pinyin;
  final String? meaningVi;
  final String? meaningEn;
  final int? hskLevel;
  final String? audioUrl;
  final List<ExampleDto> examples;
  final List<String> radicals;
  final int? strokeCount;
  final String? strokeDataUrl;
  final bool recognitionOnly;
  final int? frequencyRank;
  final List<TopicDto> topics;
  final List<GrammarPointDto> grammarPoints;
  final String? createdAt;

  const VocabularyDetail({
    required this.id,
    required this.hanzi,
    this.pinyin,
    this.meaningVi,
    this.meaningEn,
    this.hskLevel,
    this.audioUrl,
    this.examples = const [],
    this.radicals = const [],
    this.strokeCount,
    this.strokeDataUrl,
    this.recognitionOnly = false,
    this.frequencyRank,
    this.topics = const [],
    this.grammarPoints = const [],
    this.createdAt,
  });

  factory VocabularyDetail.fromJson(Map<String, dynamic> json) {
    return VocabularyDetail(
      id: json['id'] as String,
      hanzi: json['hanzi'] as String,
      pinyin: json['pinyin'] as String?,
      meaningVi: json['meaning_vi'] as String?,
      meaningEn: json['meaning_en'] as String?,
      hskLevel: json['hsk_level'] as int?,
      audioUrl: json['audio_url'] as String?,
      examples: (json['examples'] as List<dynamic>?)
              ?.map((e) => ExampleDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      radicals: (json['radicals'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      strokeCount: json['stroke_count'] as int?,
      strokeDataUrl: json['stroke_data_url'] as String?,
      recognitionOnly: json['recognition_only'] as bool? ?? false,
      frequencyRank: json['frequency_rank'] as int?,
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => TopicDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      grammarPoints: (json['grammar_points'] as List<dynamic>?)
              ?.map((e) => GrammarPointDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['created_at'] as String?,
    );
  }
}

class ExampleDto {
  final String sentenceCn;
  final String? sentenceVi;
  final String? audioUrl;

  const ExampleDto({
    required this.sentenceCn,
    this.sentenceVi,
    this.audioUrl,
  });

  factory ExampleDto.fromJson(Map<String, dynamic> json) {
    return ExampleDto(
      sentenceCn: json['sentence_cn'] as String,
      sentenceVi: json['sentence_vi'] as String?,
      audioUrl: json['audio_url'] as String?,
    );
  }
}

class TopicDto {
  final String id;
  final String slug;
  final String? nameCn;
  final String? nameVi;
  final String? nameEn;

  const TopicDto({
    required this.id,
    required this.slug,
    this.nameCn,
    this.nameVi,
    this.nameEn,
  });

  factory TopicDto.fromJson(Map<String, dynamic> json) {
    return TopicDto(
      id: json['id'] as String,
      slug: json['slug'] as String,
      nameCn: json['name_cn'] as String?,
      nameVi: json['name_vi'] as String?,
      nameEn: json['name_en'] as String?,
    );
  }
}

class GrammarPointDto {
  final String id;
  final String code;
  final String pattern;
  final String? exampleCn;
  final String? exampleVi;
  final String? rule;
  final String? commonMistake;
  final int? hskLevel;

  const GrammarPointDto({
    required this.id,
    required this.code,
    required this.pattern,
    this.exampleCn,
    this.exampleVi,
    this.rule,
    this.commonMistake,
    this.hskLevel,
  });

  factory GrammarPointDto.fromJson(Map<String, dynamic> json) {
    return GrammarPointDto(
      id: json['id'] as String,
      code: json['code'] as String,
      pattern: json['pattern'] as String,
      exampleCn: json['example_cn'] as String?,
      exampleVi: json['example_vi'] as String?,
      rule: json['rule'] as String?,
      commonMistake: json['common_mistake'] as String?,
      hskLevel: json['hsk_level'] as int?,
    );
  }
}
