enum PhonemeStatus { correct, acceptable, wrong }

/// Model biểu diễn kết quả phân tích từng âm vị (Phoneme) trong phát âm
class PhonemeAnalysis {
  final String phoneme; // Âm vị (vd: 'θ', 'ð', 'i:', 's', 't')
  final double accuracyScore; // Điểm chính xác (0 - 100)
  final PhonemeStatus status; // Phân loại: correct, acceptable, wrong
  final String? suggestion; // Lời khuyên khẩu hình miệng / phát âm

  const PhonemeAnalysis({
    required this.phoneme,
    required this.accuracyScore,
    required this.status,
    this.suggestion,
  });

  bool get isCorrect => status == PhonemeStatus.correct;
  bool get isAcceptable => status == PhonemeStatus.acceptable;
  bool get isWrong => status == PhonemeStatus.wrong;

  Map<String, dynamic> toMap() => {
        'phoneme': phoneme,
        'accuracyScore': accuracyScore,
        'status': status.name,
        'suggestion': suggestion,
      };

  factory PhonemeAnalysis.fromMap(Map<String, dynamic> map) {
    return PhonemeAnalysis(
      phoneme: map['phoneme'] as String,
      accuracyScore: (map['accuracyScore'] as num).toDouble(),
      status: PhonemeStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => PhonemeStatus.wrong,
      ),
      suggestion: map['suggestion'] as String?,
    );
  }
}
