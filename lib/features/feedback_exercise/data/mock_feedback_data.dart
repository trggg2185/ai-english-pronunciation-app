import '../../../data/models/phoneme_analysis.dart';
import '../../../data/models/practice_session_model.dart';

/// Dữ liệu giả lập (Mock Data) theo đúng yêu cầu kiểm thử độc lập của Nguyễn Đăng Đại
class MockFeedbackData {
  /// 1. Trường hợp phát âm chuẩn (Điểm cao: 92/100)
  static final PracticeSessionModel goodPronunciation = PracticeSessionModel(
    id: 'session_mock_good_001',
    sentenceOrWord: 'Good morning, how are you today?',
    standardIpa: '/ɡʊd ˈmɔːrnɪŋ haʊ ɑːr juː təˈdeɪ/',
    score: 92.5,
    durationSeconds: 4,
    practicedAt: DateTime.now().subtract(const Duration(minutes: 5)),
    audioRecordPath: 'assets/audio/mock_user_good.wav',
    phonemeResults: const [
      // Good /ɡʊd/
      PhonemeAnalysis(phoneme: 'ɡ', accuracyScore: 95.0, status: PhonemeStatus.correct),
      PhonemeAnalysis(phoneme: 'ʊ', accuracyScore: 92.0, status: PhonemeStatus.correct),
      PhonemeAnalysis(phoneme: 'd', accuracyScore: 90.0, status: PhonemeStatus.correct),
      // morning /ˈmɔːrnɪŋ/
      PhonemeAnalysis(phoneme: 'm', accuracyScore: 98.0, status: PhonemeStatus.correct),
      PhonemeAnalysis(phoneme: 'ɔːr', accuracyScore: 89.0, status: PhonemeStatus.correct),
      PhonemeAnalysis(phoneme: 'n', accuracyScore: 94.0, status: PhonemeStatus.correct),
      PhonemeAnalysis(phoneme: 'ɪ', accuracyScore: 91.0, status: PhonemeStatus.correct),
      PhonemeAnalysis(phoneme: 'ŋ', accuracyScore: 93.0, status: PhonemeStatus.correct),
      // how /haʊ/
      PhonemeAnalysis(phoneme: 'h', accuracyScore: 96.0, status: PhonemeStatus.correct),
      PhonemeAnalysis(phoneme: 'aʊ', accuracyScore: 94.0, status: PhonemeStatus.correct),
      // are /ɑːr/
      PhonemeAnalysis(phoneme: 'ɑːr', accuracyScore: 92.0, status: PhonemeStatus.correct),
      // you /juː/
      PhonemeAnalysis(phoneme: 'j', accuracyScore: 95.0, status: PhonemeStatus.correct),
      PhonemeAnalysis(phoneme: 'uː', accuracyScore: 93.0, status: PhonemeStatus.correct),
      // today /təˈdeɪ/
      PhonemeAnalysis(phoneme: 't', accuracyScore: 88.0, status: PhonemeStatus.correct),
      PhonemeAnalysis(phoneme: 'ə', accuracyScore: 90.0, status: PhonemeStatus.correct),
      PhonemeAnalysis(phoneme: 'd', accuracyScore: 92.0, status: PhonemeStatus.correct),
      PhonemeAnalysis(phoneme: 'eɪ', accuracyScore: 94.0, status: PhonemeStatus.correct),
    ],
  );

  /// 2. Trường hợp phát âm sai âm đuôi 's' (45 điểm - Báo động đỏ)
  static final PracticeSessionModel badEndingSoundS = PracticeSessionModel(
    id: 'session_mock_bad_s_002',
    sentenceOrWord: 'She likes books and cats',
    standardIpa: '/ʃiː laɪks bʊks ænd kæts/',
    score: 45.0,
    durationSeconds: 3,
    practicedAt: DateTime.now().subtract(const Duration(minutes: 15)),
    audioRecordPath: 'assets/audio/mock_user_bad_s.wav',
    phonemeResults: const [
      // She /ʃiː/
      PhonemeAnalysis(
        phoneme: 'ʃ',
        accuracyScore: 88.0,
        status: PhonemeStatus.correct,
      ),
      PhonemeAnalysis(
        phoneme: 'iː',
        accuracyScore: 85.0,
        status: PhonemeStatus.correct,
      ),
      // likes /laɪks/ -> Bỏ quên âm đuôi 's'
      PhonemeAnalysis(
        phoneme: 'l',
        accuracyScore: 90.0,
        status: PhonemeStatus.correct,
      ),
      PhonemeAnalysis(
        phoneme: 'aɪ',
        accuracyScore: 86.0,
        status: PhonemeStatus.correct,
      ),
      PhonemeAnalysis(
        phoneme: 'k',
        accuracyScore: 65.0,
        status: PhonemeStatus.acceptable,
        suggestion: 'Bật âm /k/ dứt khoát hơn trước khi nối sang /s/.',
      ),
      PhonemeAnalysis(
        phoneme: 's',
        accuracyScore: 20.0,
        status: PhonemeStatus.wrong,
        suggestion: 'Bạn bị nuốt âm đuôi /s/. Khép nhẹ hai hàm răng, mỉm cười nhẹ và đẩy luồng hơi xì qua kẽ răng.',
      ),
      // books /bʊks/ -> Mất âm 's'
      PhonemeAnalysis(
        phoneme: 'b',
        accuracyScore: 92.0,
        status: PhonemeStatus.correct,
      ),
      PhonemeAnalysis(
        phoneme: 'ʊ',
        accuracyScore: 78.0,
        status: PhonemeStatus.acceptable,
        suggestion: 'Âm /ʊ/ ngắn, thả lỏng môi hơn.',
      ),
      PhonemeAnalysis(
        phoneme: 'k',
        accuracyScore: 70.0,
        status: PhonemeStatus.acceptable,
      ),
      PhonemeAnalysis(
        phoneme: 's',
        accuracyScore: 15.0,
        status: PhonemeStatus.wrong,
        suggestion: 'Thiếu âm kết thúc /s/. Âm đuôi cực kỳ quan trọng để phân biệt số nhiều trong tiếng Anh.',
      ),
      // and /ænd/
      PhonemeAnalysis(
        phoneme: 'æ',
        accuracyScore: 82.0,
        status: PhonemeStatus.correct,
      ),
      PhonemeAnalysis(
        phoneme: 'n',
        accuracyScore: 85.0,
        status: PhonemeStatus.correct,
      ),
      PhonemeAnalysis(
        phoneme: 'd',
        accuracyScore: 40.0,
        status: PhonemeStatus.wrong,
        suggestion: 'Âm /d/ ở cuối từ bị yếu hoặc rơi âm.',
      ),
      // cats /kæts/ -> Nuốt âm 'ts'
      PhonemeAnalysis(
        phoneme: 'k',
        accuracyScore: 88.0,
        status: PhonemeStatus.correct,
      ),
      PhonemeAnalysis(
        phoneme: 'æ',
        accuracyScore: 75.0,
        status: PhonemeStatus.acceptable,
      ),
      PhonemeAnalysis(
        phoneme: 't',
        accuracyScore: 60.0,
        status: PhonemeStatus.acceptable,
      ),
      PhonemeAnalysis(
        phoneme: 's',
        accuracyScore: 18.0,
        status: PhonemeStatus.wrong,
        suggestion: 'Tổ hợp phụ âm /ts/: chặn đầu lưỡi ở chân răng trên rồi xì hơi ra âm /s/.',
      ),
    ],
  );

  /// 3. Trường hợp phát âm sai âm 'th' /θ/ và /ð/ (60 điểm - Cần cải thiện)
  static final PracticeSessionModel badThSound = PracticeSessionModel(
    id: 'session_mock_bad_th_003',
    sentenceOrWord: 'Think through three thousand things',
    standardIpa: '/θɪŋk θruː θriː ˈθaʊznd θɪŋz/',
    score: 60.0,
    durationSeconds: 5,
    practicedAt: DateTime.now().subtract(const Duration(minutes: 30)),
    audioRecordPath: 'assets/audio/mock_user_bad_th.wav',
    phonemeResults: const [
      // Think /θɪŋk/
      PhonemeAnalysis(
        phoneme: 'θ',
        accuracyScore: 32.0,
        status: PhonemeStatus.wrong,
        suggestion: 'Bạn đang phát âm thành âm /t/ hoặc /s/. Đặt đầu lưỡi nhẹ giữa hai hàm răng và đẩy luồng hơi êm ra ngoài.',
      ),
      PhonemeAnalysis(phoneme: 'ɪ', accuracyScore: 85.0, status: PhonemeStatus.correct),
      PhonemeAnalysis(phoneme: 'ŋ', accuracyScore: 88.0, status: PhonemeStatus.correct),
      PhonemeAnalysis(phoneme: 'k', accuracyScore: 84.0, status: PhonemeStatus.correct),
      // through /θruː/
      PhonemeAnalysis(
        phoneme: 'θ',
        accuracyScore: 28.0,
        status: PhonemeStatus.wrong,
        suggestion: 'Âm /θ/: Không cắn chặt răng vào lưỡi, chỉ chạm nhẹ đầu lưỡi và thổi hơi.',
      ),
      PhonemeAnalysis(phoneme: 'r', accuracyScore: 72.0, status: PhonemeStatus.acceptable),
      PhonemeAnalysis(phoneme: 'uː', accuracyScore: 90.0, status: PhonemeStatus.correct),
      // three /θriː/
      PhonemeAnalysis(
        phoneme: 'θ',
        accuracyScore: 40.0,
        status: PhonemeStatus.wrong,
        suggestion: 'Đầu lưỡi lộ ra ngoài khoảng 2mm giữa hai hàm răng khi phát âm /θ/.',
      ),
      PhonemeAnalysis(phoneme: 'r', accuracyScore: 75.0, status: PhonemeStatus.acceptable),
      PhonemeAnalysis(phoneme: 'iː', accuracyScore: 92.0, status: PhonemeStatus.correct),
      // thousand /ˈθaʊznd/
      PhonemeAnalysis(
        phoneme: 'θ',
        accuracyScore: 35.0,
        status: PhonemeStatus.wrong,
        suggestion: 'Âm /θ/ vô thanh, dây thanh quản không rung.',
      ),
      PhonemeAnalysis(phoneme: 'aʊ', accuracyScore: 88.0, status: PhonemeStatus.correct),
      PhonemeAnalysis(
        phoneme: 'z',
        accuracyScore: 68.0,
        status: PhonemeStatus.acceptable,
        suggestion: 'Âm /z/ cần rung nhẹ dây thanh quản (hữu thanh).',
      ),
      PhonemeAnalysis(phoneme: 'n', accuracyScore: 85.0, status: PhonemeStatus.correct),
      PhonemeAnalysis(phoneme: 'd', accuracyScore: 70.0, status: PhonemeStatus.acceptable),
      // things /θɪŋz/
      PhonemeAnalysis(
        phoneme: 'θ',
        accuracyScore: 38.0,
        status: PhonemeStatus.wrong,
        suggestion: 'Hãy luyện tập đặt lưỡi trước gương để nhìn rõ vị trí đầu lưỡi.',
      ),
      PhonemeAnalysis(phoneme: 'ɪ', accuracyScore: 86.0, status: PhonemeStatus.correct),
      PhonemeAnalysis(phoneme: 'ŋ', accuracyScore: 90.0, status: PhonemeStatus.correct),
      PhonemeAnalysis(
        phoneme: 'z',
        accuracyScore: 62.0,
        status: PhonemeStatus.acceptable,
        suggestion: 'Âm kết thúc /z/ bị yếu.',
      ),
    ],
  );

  /// Danh sách toàn bộ kịch bản Mock để chuyển đổi linh hoạt khi kiểm thử UI
  static final List<PracticeSessionModel> allMockSessions = [
    badEndingSoundS,
    badThSound,
    goodPronunciation,
  ];
}
