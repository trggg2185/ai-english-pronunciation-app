enum PhonemeStatus { correct, acceptable, wrong }

class PhonemeAnalysis {
  final String phoneme;       // Âm vị (vd: 'θ', 'ð', 'i:')
  final double accuracyScore; // 0 - 100
  final PhonemeStatus status; // Phân loại đánh giá
  final String? suggestion;   // Lời khuyên khẩu hình miệng/phát âm

  PhonemeAnalysis({
    required this.phoneme,
    required this.accuracyScore,
    required this.status,
    this.suggestion,
  });

  Map<String, dynamic> toMap() => {
    'phoneme': phoneme,
    'accuracyScore': accuracyScore,
    'status': status.name,
    'suggestion': suggestion,
  };

  factory PhonemeAnalysis.fromMap(Map<String, dynamic> map) {
    return PhonemeAnalysis(
      phoneme: map['phoneme'] as String? ?? '',
      accuracyScore: (map['accuracyScore'] as num?)?.toDouble() ?? 0.0,
      status: PhonemeStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => PhonemeStatus.acceptable,
      ),
      suggestion: map['suggestion'] as String?,
    );
  }
}
