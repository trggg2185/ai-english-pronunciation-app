import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/phoneme_guide_data.dart';
import '../services/exercise_recommendation_service.dart';

enum DrillRecordingState { idle, recording, evaluating, completed }

/// Controller quản lý màn hình bài tập khắc phục nhanh từng âm vị
class ExerciseController extends ChangeNotifier {
  final PhonemeExerciseRecommendation recommendation;
  int _currentWordIndex = 0;
  DrillRecordingState _recordingState = DrillRecordingState.idle;
  double? _lastScore;
  final Map<int, double> _wordScores = {};
  bool _isPlayingAudio = false;
  Timer? _recordingTimer;

  ExerciseController({required this.recommendation});

  int get currentWordIndex => _currentWordIndex;
  DrillRecordingState get recordingState => _recordingState;
  double? get lastScore => _lastScore;
  Map<int, double> get wordScores => _wordScores;
  bool get isPlayingAudio => _isPlayingAudio;
  bool get isAllCompleted => _wordScores.length == recommendation.drillWords.length;

  DrillWord get currentWord =>
      recommendation.drillWords[_currentWordIndex.clamp(0, recommendation.drillWords.length - 1)];

  double get averageDrillScore {
    if (_wordScores.isEmpty) return 0.0;
    final total = _wordScores.values.reduce((a, b) => a + b);
    return total / _wordScores.length;
  }

  /// Chọn từ vựng cụ thể trong danh sách 5 từ
  void selectWord(int index) {
    if (index >= 0 && index < recommendation.drillWords.length) {
      _currentWordIndex = index;
      _recordingState = DrillRecordingState.idle;
      _lastScore = _wordScores[index];
      notifyListeners();
    }
  }

  /// Chuyển sang từ tiếp theo
  void nextWord() {
    if (_currentWordIndex < recommendation.drillWords.length - 1) {
      selectWord(_currentWordIndex + 1);
    }
  }

  /// Quay lại từ trước
  void previousWord() {
    if (_currentWordIndex > 0) {
      selectWord(_currentWordIndex - 1);
    }
  }

  /// Phát âm thanh mẫu của từ vựng hiện tại
  void playWordSample() {
    _isPlayingAudio = true;
    notifyListeners();

    // Mô phỏng phát âm mẫu trong 1.5 giây
    Future.delayed(const Duration(milliseconds: 1500), () {
      _isPlayingAudio = false;
      notifyListeners();
    });
  }

  /// Bắt đầu ghi âm từ vựng
  void startRecording() {
    _recordingState = DrillRecordingState.recording;
    notifyListeners();

    // Tự động dừng sau 2.5 giây nếu người dùng không bấm dừng
    _recordingTimer?.cancel();
    _recordingTimer = Timer(const Duration(milliseconds: 2500), () {
      stopAndEvaluateRecording();
    });
  }

  /// Dừng ghi âm và chấm điểm AI mô phỏng
  void stopAndEvaluateRecording() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
    _recordingState = DrillRecordingState.evaluating;
    notifyListeners();

    // Giả lập AI phân tích âm vị (khoảng 1.2s)
    Future.delayed(const Duration(milliseconds: 1200), () {
      // Giả lập điểm số tiến bộ vượt bậc sau khi học khẩu hình (85 - 98)
      final simulatedScore = 85.0 + (_currentWordIndex * 3 % 14);
      _lastScore = simulatedScore;
      _wordScores[_currentWordIndex] = simulatedScore;
      _recordingState = DrillRecordingState.completed;
      notifyListeners();
    });
  }

  /// Làm lại từ hiện tại
  void retryCurrentWord() {
    _recordingState = DrillRecordingState.idle;
    _lastScore = null;
    _wordScores.remove(_currentWordIndex);
    notifyListeners();
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    super.dispose();
  }
}
