import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../data/models/phoneme_analysis.dart';
import '../../../data/models/practice_session_model.dart';
import '../data/mock_feedback_data.dart';
import '../services/exercise_recommendation_service.dart';

enum AudioPlayerState { stopped, playingNative, playingUser }

/// Controller quản lý trạng thái hiển thị giao diện chấm điểm chi tiết
class FeedbackController extends ChangeNotifier {
  PracticeSessionModel _currentSession;
  PhonemeAnalysis? _selectedPhoneme;
  AudioPlayerState _audioState = AudioPlayerState.stopped;
  double _audioProgress = 0.0;
  Timer? _playbackTimer;

  List<PhonemeExerciseRecommendation> _recommendations = [];

  FeedbackController({PracticeSessionModel? initialSession})
      : _currentSession = initialSession ?? MockFeedbackData.badEndingSoundS {
    _refreshRecommendations();
  }

  // Getters
  PracticeSessionModel get currentSession => _currentSession;
  PhonemeAnalysis? get selectedPhoneme => _selectedPhoneme;
  AudioPlayerState get audioState => _audioState;
  double get audioProgress => _audioProgress;
  bool get isPlaying => _audioState != AudioPlayerState.stopped;
  bool get isPlayingNative => _audioState == AudioPlayerState.playingNative;
  bool get isPlayingUser => _audioState == AudioPlayerState.playingUser;
  List<PhonemeExerciseRecommendation> get recommendations => _recommendations;

  /// Đổi phiên luyện tập (Dùng để test các kịch bản Mock khác nhau)
  void switchSession(PracticeSessionModel newSession) {
    stopAudio();
    _currentSession = newSession;
    _selectedPhoneme = null;
    _refreshRecommendations();
    notifyListeners();
  }

  /// Chọn một âm vị để xem chi tiết khẩu hình và nghe âm mẫu
  void selectPhoneme(PhonemeAnalysis phoneme) {
    if (_selectedPhoneme == phoneme) {
      _selectedPhoneme = null;
    } else {
      _selectedPhoneme = phoneme;
    }
    notifyListeners();
  }

  void clearSelectedPhoneme() {
    _selectedPhoneme = null;
    notifyListeners();
  }

  /// Phát âm thanh chuẩn bản ngữ (Native Speaker Audio)
  void playNativeAudio({VoidCallback? onComplete}) {
    stopAudio();
    _audioState = AudioPlayerState.playingNative;
    _audioProgress = 0.0;
    notifyListeners();

    _startSimulatedPlayback(durationSec: _currentSession.durationSeconds, onDone: onComplete);
  }

  /// Phát lại đoạn âm thanh người dùng vừa thu âm
  void playUserAudio({VoidCallback? onComplete}) {
    stopAudio();
    _audioState = AudioPlayerState.playingUser;
    _audioProgress = 0.0;
    notifyListeners();

    _startSimulatedPlayback(durationSec: _currentSession.durationSeconds, onDone: onComplete);
  }

  /// Dừng phát âm thanh
  void stopAudio() {
    _playbackTimer?.cancel();
    _playbackTimer = null;
    _audioState = AudioPlayerState.stopped;
    _audioProgress = 0.0;
    notifyListeners();
  }

  void _startSimulatedPlayback({required int durationSec, VoidCallback? onDone}) {
    final effectiveSec = durationSec > 0 ? durationSec : 3;
    final totalSteps = effectiveSec * 20; // 50ms per step
    int currentStep = 0;

    _playbackTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      currentStep++;
      _audioProgress = (currentStep / totalSteps).clamp(0.0, 1.0);
      if (currentStep >= totalSteps) {
        stopAudio();
        onDone?.call();
      } else {
        notifyListeners();
      }
    });
  }

  void _refreshRecommendations() {
    _recommendations = ExerciseRecommendationService.recommendExercises(_currentSession);
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }
}

