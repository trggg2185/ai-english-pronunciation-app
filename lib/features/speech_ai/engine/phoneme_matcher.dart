import '../../../data/models/phoneme_analysis.dart';
import '../../../data/models/practice_session_model.dart';
import 'english_text_to_ipa.dart';

class PhonemeMatcher {
  const PhonemeMatcher();

  Future<PracticeSessionModel> analyzeText({
    required String referenceText,
    required String standardIpa,
    required String recognizedText,
    required EnglishTextToIpa textToIpa,
    required String audioRecordPath,
    required int durationSeconds,
    DateTime? practicedAt,
    String? id,
  }) async {
    final recognizedIpa = await textToIpa.convert(recognizedText);
    return analyze(
      referenceText: referenceText,
      standardIpa: standardIpa,
      recognizedIpa: recognizedIpa,
      recognizedText: recognizedText,
      audioRecordPath: audioRecordPath,
      durationSeconds: durationSeconds,
      practicedAt: practicedAt,
      id: id,
    );
  }

  PracticeSessionModel analyze({
    required String referenceText,
    required String standardIpa,
    required String recognizedIpa,
    required String audioRecordPath,
    required int durationSeconds,
    String? recognizedText,
    DateTime? practicedAt,
    String? id,
  }) {
    if (referenceText.trim().isEmpty) {
      throw ArgumentError.value(
        referenceText,
        'referenceText',
        'Must not be empty.',
      );
    }
    if (durationSeconds < 0) {
      throw ArgumentError.value(
        durationSeconds,
        'durationSeconds',
        'Must not be negative.',
      );
    }

    final reference = _tokenize(standardIpa);
    final recognized = _tokenize(recognizedIpa);
    if (reference.isEmpty) {
      throw ArgumentError.value(
        standardIpa,
        'standardIpa',
        'Must contain at least one IPA phoneme.',
      );
    }

    final alignment = _align(reference, recognized);
    final analyses = <PhonemeAnalysis>[];
    for (var index = 0; index < reference.length; index++) {
      final recognizedIndex = alignment.recognizedIndexForReference[index];
      final matches =
          recognizedIndex != null &&
          reference[index] == recognized[recognizedIndex];
      analyses.add(
        PhonemeAnalysis(
          phoneme: reference[index],
          accuracyScore: matches ? 100 : 0,
          status: matches ? PhonemeStatus.correct : PhonemeStatus.wrong,
          granularity: PhonemeAnalysisGranularity.phoneme,
          suggestion: recognizedIndex == null
              ? 'Âm vị này bị bỏ sót.'
              : matches
              ? null
              : 'Âm vị nhận dạng được: /${recognized[recognizedIndex]}/.',
        ),
      );
    }

    final denominator = reference.length > recognized.length
        ? reference.length
        : recognized.length;
    final score = denominator == 0
        ? 100.0
        : ((denominator - alignment.distance) * 100 / denominator)
              .clamp(0, 100)
              .toDouble();

    return PracticeSessionModel(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      sentenceOrWord: referenceText,
      standardIpa: standardIpa,
      score: score,
      durationSeconds: durationSeconds,
      practicedAt: practicedAt ?? DateTime.now(),
      audioRecordPath: audioRecordPath,
      phonemeResults: List.unmodifiable(analyses),
      recognizedText: recognizedText ?? recognizedIpa,
      accuracyScore: score,
    );
  }

  List<String> _tokenize(String ipa) {
    final tokens = <String>[];
    var tieBarPending = false;
    for (final rune in ipa.runes) {
      if (_isIgnored(rune)) continue;
      if (_isTieBar(rune)) {
        tieBarPending = tokens.isNotEmpty;
        continue;
      }
      if (_isLengthMark(rune) || _isModifierLetter(rune)) {
        if (tokens.isNotEmpty) {
          tokens[tokens.length - 1] += String.fromCharCode(rune);
        }
        continue;
      }
      if (_isCombiningMark(rune)) {
        if (tokens.isNotEmpty) {
          tokens[tokens.length - 1] += String.fromCharCode(rune);
        }
        continue;
      }

      final symbol = String.fromCharCode(rune);
      if (tieBarPending && tokens.isNotEmpty) {
        tokens[tokens.length - 1] += '\u0361$symbol';
      } else {
        tokens.add(symbol);
      }
      tieBarPending = false;
    }

    return _mergeDiphthongs(
      tokens.map((token) => token.replaceAll('ɡ', 'g')).toList(),
    );
  }

  List<String> _mergeDiphthongs(List<String> segments) {
    const diphthongs = {'aɪ', 'aʊ', 'eɪ', 'oʊ', 'ɔɪ'};
    final phonemes = <String>[];
    for (var index = 0; index < segments.length; index++) {
      if (index + 1 < segments.length) {
        final pair = '${segments[index]}${segments[index + 1]}';
        if (diphthongs.contains(pair)) {
          phonemes.add(pair);
          index++;
          continue;
        }
      }
      phonemes.add(segments[index]);
    }
    return phonemes;
  }

  _Alignment _align(List<String> reference, List<String> recognized) {
    final distances = List.generate(
      reference.length + 1,
      (_) => List<int>.filled(recognized.length + 1, 0),
    );
    for (var i = 0; i <= reference.length; i++) {
      distances[i][0] = i;
    }
    for (var j = 0; j <= recognized.length; j++) {
      distances[0][j] = j;
    }
    for (var i = 1; i <= reference.length; i++) {
      for (var j = 1; j <= recognized.length; j++) {
        final substitutionCost = reference[i - 1] == recognized[j - 1] ? 0 : 1;
        distances[i][j] = _minimum(
          distances[i - 1][j] + 1,
          distances[i][j - 1] + 1,
          distances[i - 1][j - 1] + substitutionCost,
        );
      }
    }

    final recognizedIndexForReference = List<int?>.filled(
      reference.length,
      null,
    );
    var i = reference.length;
    var j = recognized.length;
    while (i > 0 || j > 0) {
      if (i > 0 &&
          j > 0 &&
          distances[i][j] ==
              distances[i - 1][j - 1] +
                  (reference[i - 1] == recognized[j - 1] ? 0 : 1)) {
        recognizedIndexForReference[i - 1] = j - 1;
        i--;
        j--;
      } else if (i > 0 && distances[i][j] == distances[i - 1][j] + 1) {
        i--;
      } else {
        j--;
      }
    }
    return _Alignment(
      recognizedIndexForReference,
      distances[reference.length][recognized.length],
    );
  }

  int _minimum(int first, int second, int third) {
    if (first < second) return first < third ? first : third;
    return second < third ? second : third;
  }

  bool _isIgnored(int rune) =>
      rune == 0x002F ||
      rune == 0x005B ||
      rune == 0x005D ||
      rune == 0x0020 ||
      rune == 0x0009 ||
      rune == 0x000A ||
      rune == 0x000D ||
      rune == 0x002E ||
      rune == 0x007C ||
      rune == 0x02C8 ||
      rune == 0x02CC;

  bool _isTieBar(int rune) => rune == 0x0361 || rune == 0x035C;

  bool _isLengthMark(int rune) => rune == 0x02D0 || rune == 0x02D1;

  bool _isModifierLetter(int rune) =>
      rune == 0x02B0 || rune == 0x02B2 || rune == 0x02B7;

  bool _isCombiningMark(int rune) =>
      (rune >= 0x0300 && rune <= 0x036F) ||
      (rune >= 0x1AB0 && rune <= 0x1AFF) ||
      (rune >= 0x1DC0 && rune <= 0x1DFF) ||
      (rune >= 0x20D0 && rune <= 0x20FF) ||
      (rune >= 0xFE20 && rune <= 0xFE2F);
}

class _Alignment {
  const _Alignment(this.recognizedIndexForReference, this.distance);

  final List<int?> recognizedIndexForReference;
  final int distance;
}
