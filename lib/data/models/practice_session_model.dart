import 'phoneme_analysis.dart';

class PracticeSessionModel {
  const PracticeSessionModel({
    required this.id,
    required this.sentenceOrWord,
    required this.standardIpa,
    required this.score,
    required this.durationSeconds,
    required this.practicedAt,
    required this.audioRecordPath,
    required this.phonemeResults,
    this.recognizedText,
    this.accuracyScore,
    this.fluencyScore,
    this.completenessScore,
  });

  final String id;
  final String sentenceOrWord;
  final String standardIpa;
  final double score;
  final int durationSeconds;
  final DateTime practicedAt;
  final String audioRecordPath;
  final List<PhonemeAnalysis> phonemeResults;
  final String? recognizedText;
  final double? accuracyScore;
  final double? fluencyScore;
  final double? completenessScore;
}
