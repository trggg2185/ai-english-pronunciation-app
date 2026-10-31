import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

abstract interface class AudioRecordingService {
  Future<void> startRecording();

  Future<String> stopRecording();

  Future<void> cancelRecording();

  Future<void> dispose();
}

class AudioRecorderService implements AudioRecordingService {
  AudioRecorderService({AudioRecorder? recorder})
    : _recorder = recorder ?? AudioRecorder();

  final AudioRecorder _recorder;
  bool _isDisposed = false;
  bool _operationInProgress = false;

  Future<bool> requestMicrophonePermission() {
    return _withExclusiveOperation(_recorder.hasPermission);
  }

  @override
  Future<void> startRecording() {
    return _withExclusiveOperation(() async {
      if (await _recorder.isRecording()) {
        throw StateError('A recording is already in progress.');
      }

      if (!await _recorder.hasPermission()) {
        throw const MicrophonePermissionDeniedException();
      }

      final directory = await getTemporaryDirectory();
      final filePath = path.join(
        directory.path,
        'pronunciation_${DateTime.now().microsecondsSinceEpoch}.wav',
      );

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 16000,
          numChannels: 1,
        ),
        path: filePath,
      );
    });
  }

  @override
  Future<String> stopRecording() {
    return _withExclusiveOperation(() async {
      if (!await _recorder.isRecording()) {
        throw StateError('There is no active recording to stop.');
      }

      final filePath = await _recorder.stop();
      if (filePath == null || filePath.isEmpty) {
        throw StateError(
          'The recording stopped without returning a file path.',
        );
      }

      return filePath;
    });
  }

  @override
  Future<void> cancelRecording() {
    return _withExclusiveOperation(() async {
      if (await _recorder.isRecording()) {
        await _recorder.cancel();
      }
    });
  }

  Future<bool> isRecording() {
    _ensureNotDisposed();
    return _recorder.isRecording();
  }

  @override
  Future<void> dispose() {
    return _withExclusiveOperation(() async {
      if (await _recorder.isRecording()) {
        await _recorder.cancel();
      }
      await _recorder.dispose();
      _isDisposed = true;
    });
  }

  Future<T> _withExclusiveOperation<T>(Future<T> Function() operation) async {
    _ensureNotDisposed();
    if (_operationInProgress) {
      throw StateError('Another recording operation is already in progress.');
    }

    _operationInProgress = true;
    try {
      return await operation();
    } finally {
      _operationInProgress = false;
    }
  }

  void _ensureNotDisposed() {
    if (_isDisposed) {
      throw StateError('AudioRecorderService has already been disposed.');
    }
  }
}

class MicrophonePermissionDeniedException implements Exception {
  const MicrophonePermissionDeniedException();

  @override
  String toString() =>
      'Microphone permission was denied. Allow microphone access to record audio.';
}
