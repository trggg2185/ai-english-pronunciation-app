import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/data/models/phoneme_analysis.dart';
import 'package:flutter_application_1/data/models/practice_session_model.dart';
import 'package:flutter_application_1/features/speech_ai/engine/english_text_to_ipa.dart';
import 'package:flutter_application_1/features/speech_ai/engine/phoneme_matcher.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const matcher = PhonemeMatcher();

  PracticeSessionModel analyze(String standardIpa, String recognizedIpa) {
    return matcher.analyze(
      referenceText: 'The quick brown fox',
      standardIpa: standardIpa,
      recognizedIpa: recognizedIpa,
      audioRecordPath: 'recording.wav',
      durationSeconds: 3,
      id: 'test-session',
      practicedAt: DateTime.utc(2026),
    );
  }

  group('PhonemeMatcher', () {
    test(
      'converts transcript text to IPA before Levenshtein comparison',
      () async {
        final session = await matcher.analyzeText(
          referenceText: 'quick',
          standardIpa: '/kwɪk/',
          recognizedText: 'Quick!',
          textToIpa: EnglishTextToIpa(),
          audioRecordPath: 'recording.wav',
          durationSeconds: 2,
        );

        expect(session.recognizedText, 'Quick!');
        expect(session.score, 100);
        expect(session.phonemeResults.map((item) => item.phoneme), [
          'k',
          'w',
          'ɪ',
          'k',
        ]);
      },
    );

    test('returns a perfect score for equivalent IPA notation', () {
      final session = analyze('/ðə kwɪk/', '[ðə kwɪk]');

      expect(session.score, 100);
      expect(session.accuracyScore, 100);
      expect(session.recognizedText, '[ðə kwɪk]');
      expect(session.phonemeResults.map((item) => item.phoneme), [
        'ð',
        'ə',
        'k',
        'w',
        'ɪ',
        'k',
      ]);
      expect(
        session.phonemeResults.every(
          (item) =>
              item.status == PhonemeStatus.correct &&
              item.granularity == PhonemeAnalysisGranularity.phoneme,
        ),
        isTrue,
      );
    });

    test('supports the sample sentence IPA sequence', () {
      const sampleIpa = '/ðə kwɪk braʊn fɑks dʒʌmps ˈoʊvər ðə ˈleɪzi dɔɡ/';
      final session = analyze(sampleIpa, sampleIpa);

      expect(session.score, 100);
      expect(
        session.phonemeResults.every(
          (item) => item.status == PhonemeStatus.correct,
        ),
        isTrue,
      );
    });

    test('counts a substitution as a Levenshtein edit', () {
      final session = analyze('/p/', '/b/');

      expect(session.score, 0);
      expect(session.phonemeResults.single.accuracyScore, 0);
      expect(session.phonemeResults.single.status, PhonemeStatus.wrong);
      expect(session.phonemeResults.single.suggestion, contains('/b/'));
    });

    test('classifies phonemes with exact Levenshtein matches', () {
      final session = analyze('/p t θ/', '/p d k/');

      expect(session.phonemeResults.map((item) => item.status), [
        PhonemeStatus.correct,
        PhonemeStatus.wrong,
        PhonemeStatus.wrong,
      ]);
      expect(session.phonemeResults.map((item) => item.accuracyScore), [
        100,
        0,
        0,
      ]);
      expect(session.score, closeTo(33.33, 0.01));
    });

    test('penalizes omitted and extra phonemes', () {
      final omitted = analyze('/k æ t/', '/k t/');
      final extra = analyze('/k t/', '/k ə t/');

      expect(omitted.phonemeResults[1].status, PhonemeStatus.wrong);
      expect(omitted.score, closeTo(66.67, 0.01));
      expect(extra.score, closeTo(66.67, 0.01));
    });

    test('keeps IPA affricates joined when tied', () {
      final session = analyze('/t͡ʃ/', '/t͡ʃ/');

      expect(session.phonemeResults, hasLength(1));
      expect(session.phonemeResults.single.phoneme, 't͡ʃ');
      expect(session.score, 100);
    });

    test('counts vowel length mismatch as a phoneme substitution', () {
      final session = analyze('/iː/', '/i/');

      expect(session.phonemeResults, hasLength(1));
      expect(session.phonemeResults.single.accuracyScore, 0);
      expect(session.phonemeResults.single.status, PhonemeStatus.wrong);
    });

    test('rejects empty reference IPA and negative duration', () {
      expect(() => analyze('', '/p/'), throwsArgumentError);
      expect(
        () => matcher.analyze(
          referenceText: 'word',
          standardIpa: '/wɜːd/',
          recognizedIpa: '/wɜːd/',
          audioRecordPath: 'recording.wav',
          durationSeconds: -1,
        ),
        throwsArgumentError,
      );
    });
  });
}
