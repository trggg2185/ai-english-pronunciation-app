import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/data/models/phoneme_analysis.dart';
import 'package:flutter_application_1/features/feedback_exercise/controllers/exercise_controller.dart';
import 'package:flutter_application_1/features/feedback_exercise/controllers/feedback_controller.dart';
import 'package:flutter_application_1/features/feedback_exercise/data/mock_feedback_data.dart';
import 'package:flutter_application_1/features/feedback_exercise/data/phoneme_guide_data.dart';
import 'package:flutter_application_1/features/feedback_exercise/services/exercise_recommendation_service.dart';

void main() {
  group('1. PhonemeAnalysis & PracticeSessionModel Unit Tests', () {
    test('PhonemeAnalysis getters & map serialization work correctly', () {
      const correct = PhonemeAnalysis(
        phoneme: 's',
        accuracyScore: 92.0,
        status: PhonemeStatus.correct,
      );
      expect(correct.isCorrect, isTrue);
      expect(correct.isWrong, isFalse);
      expect(correct.isAcceptable, isFalse);

      final map = correct.toMap();
      final restored = PhonemeAnalysis.fromMap(map);
      expect(restored.phoneme, 's');
      expect(restored.accuracyScore, 92.0);
      expect(restored.status, PhonemeStatus.correct);

      const wrong = PhonemeAnalysis(
        phoneme: 'θ',
        accuracyScore: 30.0,
        status: PhonemeStatus.wrong,
        suggestion: 'Dat luoi giua hai ham rang',
      );
      expect(wrong.isWrong, isTrue);
      expect(wrong.suggestion, isNotNull);
    });

    test('PracticeSessionModel filters phonemes and grades scores', () {
      final session = MockFeedbackData.badEndingSoundS;
      expect(session.score, 45.0);
      expect(session.scoreGrade, 'Cần luyện tập thêm');
      expect(session.wrongPhonemes.isNotEmpty, isTrue);

      // Verify that 's' is in wrongPhonemes
      final hasWrongS = session.wrongPhonemes.any((p) => p.phoneme == 's');
      expect(hasWrongS, isTrue);

      // Test good session
      final goodSession = MockFeedbackData.goodPronunciation;
      expect(goodSession.scoreGrade, 'Xuất sắc');
      expect(goodSession.wrongPhonemes.isEmpty, isTrue);
    });
  });

  group('2. ExerciseRecommendationService Unit Tests', () {
    test('Generates targeted recommendations for badEndingSoundS', () {
      final recommendations = ExerciseRecommendationService.recommendExercises(
        MockFeedbackData.badEndingSoundS,
      );

      expect(recommendations.isNotEmpty, isTrue);

      // Top recommendation should be 's' or high priority
      final topRec = recommendations.first;
      expect(topRec.priority, ExercisePriority.high);

      // Verify drill words count is at least 5
      final sRec = recommendations.firstWhere((r) => r.targetPhoneme == 's');
      expect(sRec.drillWords.length, greaterThanOrEqualTo(5));

      // Verify sample words include think, see, likes, books, etc.
      final wordList = sRec.drillWords.map((w) => w.word).toList();
      expect(wordList, contains('likes'));
      expect(wordList, contains('books'));
    });

    test('Generates targeted recommendations for badThSound', () {
      final recommendations = ExerciseRecommendationService.recommendExercises(
        MockFeedbackData.badThSound,
      );

      final thRec = recommendations.firstWhere((r) => r.targetPhoneme == 'θ');
      expect(thRec.priority, ExercisePriority.high);
      expect(thRec.lowestScore, lessThan(50.0));
      expect(thRec.drillWords.length, equals(5));

      final words = thRec.drillWords.map((w) => w.word).toList();
      expect(words, contains('think'));
      expect(words, contains('thank'));
      expect(words, contains('tooth'));
      expect(words, contains('birthday'));
      expect(words, contains('mouth'));
    });

    test('PhonemeGuideDatabase provides fallback guide for unknown phonemes', () {
      final guide = PhonemeGuideDatabase.getGuide('unknown_symbol');
      expect(guide.drillWords.isNotEmpty, isTrue);
      expect(guide.name, contains('unknown_symbol'));
    });
  });

  group('3. FeedbackController Unit Tests', () {
    test('Manages session state and switches session correctly', () {
      final controller = FeedbackController(
        initialSession: MockFeedbackData.badEndingSoundS,
      );

      expect(controller.currentSession.id, MockFeedbackData.badEndingSoundS.id);
      expect(controller.recommendations.isNotEmpty, isTrue);

      // Switch session
      controller.switchSession(MockFeedbackData.goodPronunciation);
      expect(controller.currentSession.id, MockFeedbackData.goodPronunciation.id);
      expect(controller.selectedPhoneme, isNull);

      controller.dispose();
    });

    test('Selects and clears phoneme', () {
      final controller = FeedbackController();
      final phoneme = MockFeedbackData.badEndingSoundS.phonemeResults.first;

      controller.selectPhoneme(phoneme);
      expect(controller.selectedPhoneme, equals(phoneme));

      controller.clearSelectedPhoneme();
      expect(controller.selectedPhoneme, isNull);

      controller.dispose();
    });

    test('Audio state transitions stop properly', () {
      final controller = FeedbackController();
      expect(controller.isPlaying, isFalse);

      controller.stopAudio();
      expect(controller.audioState, AudioPlayerState.stopped);
      expect(controller.audioProgress, 0.0);

      controller.dispose();
    });
  });

  group('4. ExerciseController Unit Tests', () {
    test('Navigates through drill words and computes scores', () {
      final rec = ExerciseRecommendationService.recommendExercises(
        MockFeedbackData.badThSound,
      ).first;

      final controller = ExerciseController(recommendation: rec);
      expect(controller.currentWordIndex, 0);
      expect(controller.currentWord.word, 'think');

      // Next word
      controller.nextWord();
      expect(controller.currentWordIndex, 1);
      expect(controller.currentWord.word, 'thank');

      // Select specific word
      controller.selectWord(3);
      expect(controller.currentWordIndex, 3);
      expect(controller.currentWord.word, 'tooth');

      // Average score with no scores yet
      expect(controller.averageDrillScore, 0.0);

      controller.dispose();
    });
  });
}
