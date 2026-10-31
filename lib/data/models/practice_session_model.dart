import 'phoneme_analysis.dart';

/// Model biểu diễn phiên luyện tập phát âm của người dùng
class PracticeSessionModel {
  final String id;
  final String sentenceOrWord; // Câu hoặc từ được luyện
  final String standardIpa; // Phiên âm chuẩn IPA (vd: /həˈloʊ/)
  final double score; // Điểm tổng quát (0 - 100)
  final int durationSeconds; // Thời gian luyện tập (giây)
  final DateTime practicedAt;
  final String audioRecordPath; // Đường dẫn file âm thanh đã thu
  final List<PhonemeAnalysis> phonemeResults; // Kết quả chi tiết từng âm vị

  const PracticeSessionModel({
    required this.id,
    required this.sentenceOrWord,
    required this.standardIpa,
    required this.score,
    required this.durationSeconds,
    required this.practicedAt,
    required this.audioRecordPath,
    required this.phonemeResults,
  });

  /// Danh sách các âm vị bị sai cần cải thiện
  List<PhonemeAnalysis> get wrongPhonemes =>
      phonemeResults.where((p) => p.isWrong).toList();

  /// Danh sách các âm vị ở mức chấp nhận được
  List<PhonemeAnalysis> get acceptablePhonemes =>
      phonemeResults.where((p) => p.isAcceptable).toList();

  /// Danh sách các âm vị đạt chuẩn
  List<PhonemeAnalysis> get correctPhonemes =>
      phonemeResults.where((p) => p.isCorrect).toList();

  /// Đánh giá chất lượng tổng thể dựa trên điểm số
  String get scoreGrade {
    if (score >= 80) return 'Xuất sắc';
    if (score >= 50) return 'Cần cải thiện';
    return 'Cần luyện tập thêm';
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'sentenceOrWord': sentenceOrWord,
        'standardIpa': standardIpa,
        'score': score,
        'durationSeconds': durationSeconds,
        'practicedAt': practicedAt.toIso8601String(),
        'audioRecordPath': audioRecordPath,
        'phonemeResults': phonemeResults.map((p) => p.toMap()).toList(),
      };

  factory PracticeSessionModel.fromMap(Map<String, dynamic> map) {
    return PracticeSessionModel(
      id: map['id'] as String,
      sentenceOrWord: map['sentenceOrWord'] as String,
      standardIpa: map['standardIpa'] as String,
      score: (map['score'] as num).toDouble(),
      durationSeconds: (map['durationSeconds'] as num).toInt(),
      practicedAt: DateTime.parse(map['practicedAt'] as String),
      audioRecordPath: map['audioRecordPath'] as String,
      phonemeResults: (map['phonemeResults'] as List<dynamic>)
          .map((item) => PhonemeAnalysis.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

