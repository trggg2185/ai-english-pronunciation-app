enum PhonemeStatus { correct, acceptable, wrong }

enum PhonemeAnalysisGranularity { phoneme, word }

class PhonemeAnalysis {
  const PhonemeAnalysis({
    required this.phoneme,
    required this.accuracyScore,
    required this.status,
    this.granularity = PhonemeAnalysisGranularity.phoneme,
    this.suggestion,
  });

  final String phoneme;
  final double accuracyScore;
  final PhonemeStatus status;
  final PhonemeAnalysisGranularity granularity;
  final String? suggestion;
}
