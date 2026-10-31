import 'dart:convert';
import 'phoneme_analysis.dart';

class PracticeSessionModel {
  final String id;
  final String sentenceOrWord;  // Câu hoặc từ được luyện
  final String standardIpa;     // Phiên âm chuẩn IPA (vd: /həˈloʊ/)
  final double score;           // Điểm tổng quát (0 - 100)
  final int durationSeconds;    // Thời gian luyện tập (giây)
  final DateTime practicedAt;
  final String audioRecordPath; // Đường dẫn file âm thanh đã thu
  final List<PhonemeAnalysis> phonemeResults; // Kết quả chi tiết từng âm vị

  PracticeSessionModel({
    required this.id,
    required this.sentenceOrWord,
    required this.standardIpa,
    required this.score,
    required this.durationSeconds,
    required this.practicedAt,
    required this.audioRecordPath,
    required this.phonemeResults,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'sentence_or_word': sentenceOrWord,
    'standard_ipa': standardIpa,
    'score': score,
    'duration_seconds': durationSeconds,
    'practiced_at': practicedAt.toIso8601String(),
    'audio_path': audioRecordPath,
    'phoneme_json': jsonEncode(phonemeResults.map((p) => p.toMap()).toList()),
  };

  factory PracticeSessionModel.fromMap(Map<String, dynamic> map) {
    List<PhonemeAnalysis> phonemes = [];
    if (map['phoneme_json'] != null) {
      try {
        final List<dynamic> list = jsonDecode(map['phoneme_json'] as String);
        phonemes = list.map((item) => PhonemeAnalysis.fromMap(item as Map<String, dynamic>)).toList();
      } catch (_) {}
    }

    return PracticeSessionModel(
      id: map['id'] as String,
      sentenceOrWord: map['sentence_or_word'] as String,
      standardIpa: map['standard_ipa'] as String? ?? '',
      score: (map['score'] as num).toDouble(),
      durationSeconds: map['duration_seconds'] as int? ?? 0,
      practicedAt: DateTime.parse(map['practiced_at'] as String),
      audioRecordPath: map['audio_path'] as String? ?? '',
      phonemeResults: phonemes,
    );
  }
}
