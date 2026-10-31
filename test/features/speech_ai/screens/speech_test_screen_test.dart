import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/features/speech_ai/screens/speech_test_screen.dart';
import 'package:flutter_application_1/features/speech_ai/services/audio_recorder_service.dart';

void main() {
  testWidgets('shows the sample sentence and IPA', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: SpeechTestScreen(recorder: _FakeAudioRecorder())),
    );

    expect(find.text('SpeechTestScreen'), findsOneWidget);
    expect(
      find.text('The quick brown fox jumps over the lazy dog'),
      findsOneWidget,
    );
    expect(
      find.text('/ðə kwˈɪk bɹˈaʊn fˈɑks d͡ʒˈʌmps ˈoʊvɚ ðə lˈeɪzi dˈɔg/'),
      findsOneWidget,
    );
    expect(find.textContaining('không tạo điểm giả'), findsOneWidget);
  });

  testWidgets(
    'holds to record and releases to stop without inventing a score',
    (tester) async {
      final recorder = _FakeAudioRecorder();
      await tester.pumpWidget(
        MaterialApp(home: SpeechTestScreen(recorder: recorder)),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(GestureDetector)),
      );
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();

      expect(recorder.startCalls, 1);
      expect(find.text('Đang ghi âm'), findsOneWidget);

      await gesture.up();
      await tester.pump();
      await tester.pump();

      expect(recorder.stopCalls, 1);
      expect(find.text('Điểm tổng quát: Chưa có'), findsOneWidget);
    },
  );
}

class _FakeAudioRecorder implements AudioRecordingService {
  int startCalls = 0;
  int stopCalls = 0;

  @override
  Future<void> startRecording() async {
    startCalls++;
  }

  @override
  Future<String> stopRecording() async {
    stopCalls++;
    return 'test-recording.wav';
  }

  @override
  Future<void> cancelRecording() async {}

  @override
  Future<void> dispose() async {}
}
