import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/audio_recorder_service.dart';

class SpeechTestScreen extends StatefulWidget {
  const SpeechTestScreen({super.key, this.recorder})
    : _ownsRecorder = recorder == null;

  final AudioRecordingService? recorder;
  final bool _ownsRecorder;

  @override
  State<SpeechTestScreen> createState() => _SpeechTestScreenState();
}

class _SpeechTestScreenState extends State<SpeechTestScreen> {
  static const _sampleText = 'The quick brown fox jumps over the lazy dog';
  static const _sampleIpa =
      'ðə kwˈɪk bɹˈaʊn fˈɑks d͡ʒˈʌmps ˈoʊvɚ ðə lˈeɪzi dˈɔg';

  late final AudioRecordingService _recorder =
      widget.recorder ?? AudioRecorderService();
  DateTime? _recordingStartedAt;
  bool _isRecording = false;
  bool _isBusy = false;
  bool _hasResult = false;
  bool _releasedWhileStarting = false;
  String? _errorMessage;
  int? _recordingDurationSeconds;

  Future<void> _startRecording() async {
    if (_isBusy || _isRecording) return;
    _releasedWhileStarting = false;
    var started = false;

    setState(() {
      _isBusy = true;
      _errorMessage = null;
      _hasResult = false;
    });

    try {
      await _recorder.startRecording();
      if (!mounted) {
        await _recorder.cancelRecording();
        return;
      }
      setState(() {
        _isRecording = true;
        _recordingStartedAt = DateTime.now();
      });
      started = true;
    } catch (error) {
      if (mounted) setState(() => _errorMessage = error.toString());
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
    if (started && _releasedWhileStarting && mounted) {
      await _stopRecording();
    }
  }

  Future<void> _stopRecording() async {
    if (_isBusy) {
      _releasedWhileStarting = true;
      return;
    }
    if (!_isRecording) return;

    final startedAt = _recordingStartedAt;
    setState(() {
      _isBusy = true;
      _isRecording = false;
    });

    try {
      await _recorder.stopRecording();
      final durationSeconds = startedAt == null
          ? 0
          : DateTime.now().difference(startedAt).inSeconds;
      final response = <String, Object?>{
        'status': 'ai_unavailable',
        'audioRecorded': true,
        'referenceText': _sampleText,
        'standardIpa': _sampleIpa,
        'durationSeconds': durationSeconds,
        'overallScore': null,
        'message':
            'No ASR or AI analysis service is configured. No score was generated.',
      };
      debugPrint(const JsonEncoder.withIndent('  ').convert(response));

      if (mounted) {
        setState(() {
          _hasResult = true;
          _recordingDurationSeconds = durationSeconds;
        });
      }
    } catch (error) {
      if (mounted) setState(() => _errorMessage = error.toString());
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  @override
  void dispose() {
    if (widget._ownsRecorder) unawaited(_recorder.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('SpeechTestScreen')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: [
              Text(
                _sampleText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              SelectableText(
                '/$_sampleIpa/',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 32),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'AI/ASR chưa được cấu hình. Sau khi ghi âm, màn hình sẽ '
                    'báo rõ trạng thái và không tạo điểm giả.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onLongPressStart: (_) => unawaited(_startRecording()),
                  onLongPressEnd: (_) => unawaited(_stopRecording()),
                  child: Semantics(
                    button: true,
                    label: 'Nhấn và giữ để ghi âm, thả ra để dừng',
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 220,
                      height: 64,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _isRecording ? colors.error : colors.primary,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isBusy)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          else
                            Icon(
                              _isRecording ? Icons.mic : Icons.mic_none,
                              color: Colors.white,
                            ),
                          const SizedBox(width: 8),
                          Text(
                            _isBusy
                                ? 'Đang xử lý'
                                : _isRecording
                                ? 'Đang ghi âm'
                                : 'Nhấn và giữ',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Giữ nút để ghi âm, thả ra để dừng.',
                textAlign: TextAlign.center,
              ),
              if (_errorMessage case final message?) ...[
                const SizedBox(height: 24),
                SelectableText(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.error),
                ),
              ],
              if (_hasResult) ...[
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Điểm tổng quát: Chưa có',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Đã ghi âm ${_recordingDurationSeconds ?? 0} giây. '
                          'Chưa cấu hình ASR/AI nên chưa thể nhận dạng lời nói '
                          'hoặc tính điểm.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
