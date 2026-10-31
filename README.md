# 🎙️ AI English Pronunciation App (Nhóm 6)
> **Dự án:** Ứng dụng di động luyện phát âm tiếng Anh chuẩn AI kết hợp rèn luyện kỷ luật học tập hàng ngày  
> **Nền tảng:** Flutter (Android/iOS)  
> **Nhóm thực hiện:** Nhóm 6  
> - **Nguyễn Thế Trưởng (Leader)**: Kiến trúc Core, Cơ sở dữ liệu & Hệ thống Thông báo (Notification)
> - **Phương Văn Đức**: Module Kỷ luật học tập, Streak, Thống kê & Mục tiêu hàng ngày
> - **Hàn Hoàng Hà**: Module Thu âm & Tích hợp AI / Thuật toán Chấm điểm âm vị (Phoneme Analysis)
> - **Nguyễn Đăng Đại**: Module Giao diện Phản hồi chi tiết (Feedback UI), Đề xuất bài tập & Kiểm thử (Testing)

---

## 📌 HƯỚNG DẪN DÀNH CHO AI ASSISTANT CỦA TỪNG THÀNH VIÊN
> 💡 **Lưu ý quan trọng cho AI Assistant khi nhận README này:**  
> - Mỗi thành viên làm việc độc lập trên **nhánh Git riêng** theo đúng định dạng `feature/<ten-thanh-vien>-<chuc-nang>`.
> - Không sửa trực tiếp file của thành viên khác trong thư mục `features/` khác.
> - Tuân thủ nghiêm ngặt các **Data Models & Contracts (Interfaces)** được định nghĩa ở mục 3.
> - Xây dựng Mock Service / Mock Data trước để kiểm thử độc lập module của mình mà không cần đợi thành viên khác hoàn thành.

---

## 1. 🏗️ KIẾN TRÚC DỰ ÁN & CẤU TRÚC THƯ MỤC

Dự án áp dụng kiến trúc **Feature-First / Clean Architecture thu gọn** nhằm đảm bảo tính độc lập tối đa:

```
ai-english-pronunciation-app/
├── android/
├── ios/
├── test/
│   ├── unit/
│   └── widget/
├── assets/
│   ├── audio/              # File âm thanh mẫu, phát âm chuẩn IPA
│   ├── images/
│   └── icons/
└── lib/
    ├── main.dart           # Điểm khởi chạy ứng dụng
    ├── core/               # Phụ trách: Nguyễn Thế Trưởng
    │   ├── constants/      # AppColors, AppStrings, AppConstants
    │   ├── theme/          # AppTheme, TextStyles
    │   ├── network/        # Dio / Http client base
    │   └── utils/          # Helper functions, DateFormatters
    │
    ├── data/               # Phụ trách: Nguyễn Thế Trưởng
    │   ├── local/          # SQLite (sqflite) / SharedPrefs / Hive
    │   │   ├── app_database.dart
    │   │   └── dao/        # UserDAO, PracticeHistoryDAO, StreakDAO
    │   └── models/         # Toàn bộ Shared Data Models (đọc kỹ Mục 3)
    │
    ├── features/
    │   ├── notifications/  # Phụ trách: Nguyễn Thế Trưởng
    │   │   ├── services/   # LocalNotificationService
    │   │   └── notification_scheduler.dart
    │   │
    │   ├── discipline/     # Phụ trách: Phương Văn Đức
    │   │   ├── controllers/# State management (StreakController, GoalController)
    │   │   ├── repositories/# Mock/Real DisciplineRepository
    │   │   └── screens/    # DashboardScreen, StreakScreen, GoalSettingScreen
    │   │
    │   ├── speech_ai/      # Phụ trách: Hàn Hoàng Hà
    │   │   ├── services/   # AudioRecorderService, Azure/Whisper/AI Speech Service
    │   │   ├── engine/     # PhonemeMatcher, Levenshtein/IPA Comparator
    │   │   └── screens/    # SpeechRecordingScreen, PronunciationTestScreen
    │   │
    │   └── feedback_exercise/ # Phụ trách: Nguyễn Đăng Đại
    │       ├── controllers/# FeedbackController, ExerciseController
    │       ├── widgets/    # PhonemeHighlighter, ScoreCardWidget, WaveformComparison
    │       └── screens/    # DetailedFeedbackScreen, RecommendedExerciseScreen
    │
    └── routes/             # AppRoutes, RouteGenerator
```

### Công nghệ sử dụng:
- **Ngôn ngữ:** Dart (Flutter SDK >= 3.19.0)
- **State Management:** `provider` hoặc `flutter_riverpod` (linh hoạt, độc lập theo feature)
- **Cơ sở dữ liệu cục bộ:** `sqflite` + `shared_preferences`
- **Thu âm & Audio:** `record: ^5.1.2`, `audioplayers: ^6.0.0`
- **Thông báo cục bộ:** `flutter_local_notifications: ^17.0.0`, `timezone: ^0.9.2`
- **Xử lý AI / Speech:** REST API kết nối Azure Speech Pronunciation Assessment API (hoặc OpenAI Whisper API / Gemini 1.5 Flash Audio API), thuật toán đối sánh chuỗi âm vị (IPA Phoneme Alignment).

---

## 2. 🌿 QUY CHUẨN GIT VÀ NGUYÊN TẮC MERGE NHÁNH

### 2.1. Quy ước đặt tên nhánh
| Thành viên | Tên nhánh làm việc |
| :--- | :--- |
| **Nguyễn Thế Trưởng** | `feature/truong-core-db-notifications` |
| **Phương Văn Đức** | `feature/duc-discipline-streak-stats` |
| **Hàn Hoàng Hà** | `feature/ha-speech-recognition-ai` |
| **Nguyễn Đăng Đại** | `feature/dai-feedback-ui-exercises` |

### 2.2. Quy tắc Commit Git
Tuân thủ Conventional Commits:
- `feat: <nội dung>` (Thêm tính năng mới)
- `fix: <nội dung>` (Sửa lỗi)
- `refactor: <nội dung>` (Tái cấu trúc code)
- `test: <nội dung>` (Thêm hoặc sửa unit test)
- `docs: <nội dung>` (Cập nhật tài liệu)

### 2.3. Quy trình Merge độc lập
1. **Trưởng (Leader)** khởi tạo repo, đẩy base project lên nhánh `main` và `develop`.
2. Ba thành viên tạo nhánh cá nhân từ `develop`.
3. Mỗi thành viên triển khai code **chỉ trong thư mục feature của mình** và chỉ dùng interface chung từ `lib/data/models/`.
4. Khi hoàn thành: Tạo Pull Request (PR) vào `develop` -> Leader review code và giải quyết conflict nếu có.

---

## 3. 📄 HỢP ĐỒNG DỮ LIỆU & INTERFACE DÙNG CHUNG (SHARED CONTRACTS)

Tất cả thành viên code dựa trên các models và interface này để không bị xung đột:

### 3.1. Các Model Dữ Liệu (`lib/data/models/`)

```dart
// lib/data/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final int dailyTargetMinutes; // Mục tiêu học tập hàng ngày (phút)
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.dailyTargetMinutes = 15,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'dailyTargetMinutes': dailyTargetMinutes,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'],
    name: map['name'],
    email: map['email'],
    dailyTargetMinutes: map['dailyTargetMinutes'] ?? 15,
    createdAt: DateTime.parse(map['createdAt']),
  );
}

// lib/data/models/streak_model.dart
class StreakModel {
  final int currentStreak;      // Chuỗi ngày hiện tại
  final int longestStreak;      // Kỷ lục streak dài nhất
  final DateTime? lastPracticeDate; // Ngày luyện tập gần nhất
  final List<String> activeDates; // Danh sách 'yyyy-MM-dd' đã hoàn thành

  StreakModel({
    required this.currentStreak,
    required this.longestStreak,
    this.lastPracticeDate,
    required this.activeDates,
  });
}

// lib/data/models/practice_session_model.dart
class PracticeSessionModel {
  final String id;
  final String sentenceOrWord;  // Câu hoặc từ được luyện
  final String standardIpa;     // Phiên âm chuẩn IPA (vd: /həˈloʊ/)
  final double score;           // Điểm tổng quát (0 - 100)
  final int durationSeconds;    // Thời gian luyện tập (giây)
  final DateTime practicedAt;
  final String audioRecordPath; // Đường dẫn file âm thanh đã thu
  final List<PhonemeAnalysis> phonemeResults; // Kết quả chi tiết từng âm vị

  PracticeSessionModel({
    required this.id,
    required this.sentenceOrWord,
    required this.standardIpa,
    required this.score,
    required this.durationSeconds,
    required this.practicedAt,
    required this.audioRecordPath,
    required this.phonemeResults,
  });
}

// lib/data/models/phoneme_analysis.dart
enum PhonemeStatus { correct, acceptable, wrong }

class PhonemeAnalysis {
  final String phoneme;         // Âm vị (vd: 'θ', 'ð', 'i:')
  final double accuracyScore;   // 0 - 100
  final PhonemeStatus status;   // Phân loại đánh giá
  final String? suggestion;     // Lời khuyên khẩu hình miệng/phát âm

  PhonemeAnalysis({
    required this.phoneme,
    required this.accuracyScore,
    required this.status,
    this.suggestion,
  });
}
```

---

## 4. 📋 PHÂN CÔNG NHIỆM VỤ CHI TIẾT (TASK BREAKDOWN)

---

### 👤 THÀNH VIÊN 1: NGUYỄN THẾ TRƯỞNG (LEADER)
* **Nhánh:** `feature/truong-core-db-notifications`
* **Trách nhiệm chính:** Kiến trúc khung ứng dụng, Cơ sở dữ liệu SQLite, Hệ thống Thông báo nhắc nhở & Quản lý người dùng.
* **Tương ứng yêu cầu:** **Yêu cầu 1** và **Yêu cầu 6 (phần thông báo)**.

#### 🎯 Nhiệm vụ cụ thể:
1. **Khởi tạo Project & Cấu hình Android:**
   - Tạo cấu trúc thư mục chuẩn như mục 1.
   - Thêm các dependency vào `pubspec.yaml`:
     `sqflite`, `path`, `flutter_local_notifications`, `timezone`, `shared_preferences`.
   - Cấu hình quyền Android trong `android/app/src/main/AndroidManifest.xml`:
     - `POST_NOTIFICATIONS`
     - `RECORD_AUDIO`
     - `RECEIVE_BOOT_COMPLETED`
     - `SCHEDULE_EXACT_ALARM`
2. **Thiết kế & Xây dựng Cơ sở dữ liệu (Database Layer):**
   - Viết `AppDatabase` sử dụng `sqflite`:
     - Bảng `users`: `id`, `name`, `email`, `daily_target_minutes`, `created_at`
     - Bảng `practice_history`: `id`, `sentence_or_word`, `standard_ipa`, `score`, `duration_seconds`, `audio_path`, `practiced_at`, `phoneme_json`
     - Bảng `user_streaks`: `current_streak`, `longest_streak`, `last_practice_date`, `active_dates_json`
   - Cung cấp các hàm CRUD thông qua Repository pattern:
     - `savePracticeSession(PracticeSessionModel session)`
     - `getPracticeHistory({int limit, int offset})`
     - `getStreakInfo()`, `updateStreak(...)`
3. **Xây dựng Hệ thống Thông báo nhắc nhở (`NotificationService`):**
   - Khởi tạo `FlutterLocalNotificationsPlugin`.
   - Viết hàm `scheduleDailyReminder({required TimeOfDay reminderTime, required String title, required String body})`.
   - Viết hàm xử lý khi ứng dụng bị tắt hoặc khởi động lại thiết bị (Broadcast Receiver `timezone`).
4. **Viết Mock Database Service** để chia sẻ cho các thành viên khác dùng tạm trước khi hoàn thiện DB SQLite.

#### 🧪 Hướng dẫn kiểm thử độc lập:
- Tạo một trang `lib/features/notifications/screens/debug_db_screen.dart` để:
  - Bấm nút tạo bản ghi lịch sử giả lập và query hiển thị ra `ListView`.
  - Bấm nút "Test Thông Báo Sau 5 Giây" để kiểm tra notification hiển thị trên thanh trạng thái Android.

---

### 👤 THÀNH VIÊN 2: PHƯƠNG VĂN ĐỨC
* **Nhánh:** `feature/duc-discipline-streak-stats`
* **Trách nhiệm chính:** Kỷ luật học tập, Chuỗi ngày học liên tục (Streak), Thống kê thời gian và Đặt mục tiêu hàng ngày.
* **Tương ứng yêu cầu:** **Yêu cầu 2** và **Yêu cầu 6 (phần giao diện tiến độ)**.

#### 🎯 Nhiệm vụ cụ thể:
1. **Thuật toán tính toán Streak & Kỷ luật:**
   - Viết class `StreakCalculator`:
     - Nếu học viên học hôm nay (hoặc hoàn thành đủ bài học hôm nay) -> `currentStreak = currentStreak + 1` (nếu hôm qua đã học), hoặc giữ nguyên nếu hôm nay đã điểm danh rồi.
     - Nếu ngày học cuối cùng cách hôm nay > 1 ngày -> reset `currentStreak = 1`.
     - Cập nhật `longestStreak = max(longestStreak, currentStreak)`.
2. **Thống kê tiến độ học tập (Learning Statistics):**
   - Thống kê tổng số phút học trong ngày / tuần / tháng.
   - Thống kê biểu đồ điểm số phát âm trung bình theo tuần (sử dụng package `fl_chart` hoặc custom widget vẽ thanh tiến độ).
   - Tỷ lệ đạt mục tiêu hàng ngày (VD: mục tiêu 15 phút, đã học 10 phút -> 66%).
3. **Xây dựng Giao diện người dùng (Screens & Widgets):**
   - **`DashboardScreen` / `DisciplineView`**:
     - Widget ngọn lửa Streak động (lửa cháy cam rực rỡ khi duy trì streak, lửa xám khi mất streak).
     - Lịch chuỗi ngày dạng chấm tròn (Weekly/Monthly dot calendar) hiển thị các ngày đã hoàn thành.
     - Đồng hồ đếm thời gian học hôm nay và thanh tiến độ đạt mục tiêu.
   - **`GoalSettingBottomSheet`**:
     - Cho phép chọn mục tiêu: 5 phút / 10 phút / 15 phút / 30 phút mỗi ngày.
     - Cài đặt giờ muốn nhận thông báo nhắc nhở (gọi sang hàm của Trưởng).

#### 🧪 Hướng dẫn kiểm thử độc lập:
- Tạo `MockDisciplineRepository` trả về `StreakModel` và dữ liệu thống kê giả lập 7 ngày qua.
- Chạy trực tiếp `DisciplineView` trong `main.dart` để quan sát UI streak, đổi ngày giả định để xem streak có tự động reset hay tăng lên chính xác không.

---

### 👤 THÀNH VIÊN 3: HÀN HOÀNG HÀ
* **Nhánh:** `feature/ha-speech-recognition-ai`
* **Trách nhiệm chính:** Thu âm giọng nói người dùng, tích hợp API AI nhận dạng & Phân tích so sánh âm vị (Phoneme Comparison).
* **Tương ứng yêu cầu:** **Yêu cầu 3** và **Yêu cầu 4**.

#### 🎯 Nhiệm vụ cụ thể:
1. **Module Thu âm & Xử lý Âm thanh (`AudioRecorderService`):**
   - Sử dụng package `record` để ghi âm chuẩn định dạng `.wav` hoặc `.m4a` (tần số lấy mẫu 16000Hz, mono để tối ưu cho AI nhận dạng giọng nói).
   - Viết các hàm: `startRecording()`, `stopRecording() -> Future<String filePath>`, `isRecording()`, `cancelRecording()`.
   - Quản lý cấp quyền micro (Microphone Permission).
2. **Tích hợp API Nhận dạng giọng nói & Đánh giá phát âm bằng AI:**
   - **Cách 1 (Khuyến nghị chuẩn công nghiệp):** Sử dụng **Azure Speech Service - Pronunciation Assessment API**.
     - Gửi file âm thanh + chuỗi văn bản tham chiếu (Reference Text).
     - Nhận về: `AccuracyScore`, `FluencyScore`, `CompletenessScore`, `PronScore` và danh sách chi tiết từng từ, từng âm vị (`Phonemes`).
   - **Cách 2 (Sử dụng AI LLM/Whisper):**
     - Dùng OpenAI Whisper API hoặc Gemini Flash Multimodal để chuyển giọng nói thành text kèm timestamp/phoneme mapping.
   - **Cách 3 (Thuật toán cục bộ Fallback):**
     - Chuyển văn bản chuẩn sang IPA (sử dụng thư viện/từ điển IPA offline).
     - Chuyển văn bản người dùng nói sang IPA -> Dùng thuật toán Levenshtein Distance trên mảng Phonemes để xác định âm đúng/sai.
3. **Phân tích kết quả ra Model chuẩn:**
   - Chuyển đổi toàn bộ phản hồi từ AI thành object `PracticeSessionModel` và `List<PhonemeAnalysis>` (đã định nghĩa ở mục 3).
   - Đảm bảo trả ra điểm từ 0 - 100 và phân loại rõ `correct` (xanh), `acceptable` (vàng), `wrong` (đỏ).

#### 🧪 Hướng dẫn kiểm thử độc lập:
- Tạo màn hình `SpeechTestScreen` độc lập với:
  - Một câu mẫu: `"The quick brown fox jumps over the lazy dog"` (kèm phiên âm IPA).
  - Nút bấm giữ để ghi âm và thả ra để dừng.
  - Sau khi dừng, in log JSON phản hồi từ AI ra Console và hiển thị điểm tổng quát lên màn hình để xác nhận pipeline AI hoạt động ổn định.

---

### 👤 THÀNH VIÊN 4: NGUYỄN ĐĂNG ĐẠI
* **Nhánh:** `feature/dai-feedback-ui-exercises`
* **Trách nhiệm chính:** Giao diện chấm điểm chi tiết, trực quan hóa âm vị phát âm sai, gợi ý bài tập cải thiện và kế hoạch kiểm thử đa giọng nói.
* **Tương ứng yêu cầu:** **Yêu cầu 5** và **Yêu cầu 7**.

#### 🎯 Nhiệm vụ cụ thể:
1. **Module Giao diện Phản hồi Chấm điểm chi tiết (`DetailedFeedbackScreen`):**
   - **Bảng điểm trực quan:** Hiển thị Điểm phát âm tổng quát (vòng tròn tiến độ lớn với màu sắc: Xanh lá >= 80, Vàng >= 50, Đỏ < 50).
   - **Hiển thị Âm vị trực quan (Phoneme Visualizer):**
     - Hiển thị từng từ và chuỗi IPA của từ đó.
     - Đánh dấu màu nổi bật từng âm vị:
       - 🟢 Xanh lá: Phát âm chuẩn xác.
       - 🟡 Màu vàng: Chấp nhận được, cần rõ âm hơn.
       - 🔴 Màu đỏ: Phát âm sai hẳn hoặc bị nuốt âm (omit).
     - Cho phép người dùng chạm (tap) vào âm vị bị sai để:
       - Nghe lại phát âm của chính mình tại đoạn âm đó.
       - Nghe âm mẫu chuẩn IPA từ file âm thanh chuẩn.
       - Đọc hướng dẫn khẩu hình (VD: *"Âm /θ/: Đặt đầu lưỡi giữa hai hàm răng và thổi hơi nhẹ"*).
2. **Module Đề xuất bài tập cải thiện (`ExerciseRecommendationService`):**
   - Dựa trên danh sách các âm vị bị đánh dấu đỏ từ kết quả của Hà:
     - Tạo thuật toán gợi ý: Nếu sai âm `/θ/` -> Đề xuất danh sách 5 từ luyện tập chuyên sâu cho âm đó (VD: *think, thank, tooth, birthday, mouth*).
   - Màn hình bài tập khắc phục nhanh: Bấm "Luyện ngay âm này" để chuyển sang luyện tập từng từ đơn.
3. **Kế hoạch Kiểm thử & Đánh giá Đa giọng nói (Multi-user & Accent Testing Plan):**
   - Chuẩn bị bộ dữ liệu mẫu (Test Dataset) gồm ít nhất 5 người dùng thử nghiệm:
     - Giọng miền Bắc, miền Trung, miền Nam (Việt Nam).
     - Người mới bắt đầu (Beginner) vs Người có nền tảng (Intermediate).
   - Lập bảng ma trận kiểm thử (Test Matrix) ghi lại: Người test, Âm tiết, Điểm AI chấm, Lỗi thực tế và Nhận xét độ trễ (Latency).
   - Viết các bài Widget Test và Unit Test cho module hiển thị phản hồi.

#### 🧪 Hướng dẫn kiểm thử độc lập:
- Tạo `MockFeedbackData` với các trường hợp mẫu (phát âm chuẩn 90 điểm, phát âm sai âm đuôi 's' 45 điểm, phát âm sai âm 'th' 60 điểm).
- Mở thẳng màn hình `DetailedFeedbackScreen(session: MockFeedbackData.badPronunciation)` để kiểm tra các thẻ màu, popup khẩu hình và danh sách bài tập gợi ý.

---

## 5. 🔄 BẢNG MA TRẬN PHỤ THUỘC & CÁCH PHỐI HỢP KHÔNG XUNG ĐỘT

| Thành viên | Cần gì từ thành viên khác? | Giải pháp độc lập (Mocking Strategy) |
| :--- | :--- | :--- |
| **Trưởng** | Không phụ thuộc | Tự định nghĩa Schema SQLite và cung cấp `MockAppDatabase` cho nhóm. |
| **Đức** | Dữ liệu phiên học từ DB để tính Streak & Biểu đồ | Dùng `MockPracticeHistory` tạo danh sách 7 ngày học mẫu để hoàn thiện UI. |
| **Hà** | Model kết quả để trả về dữ liệu | Dùng thẳng `PracticeSessionModel` tại mục 3, không đụng chạm đến code của người khác. |
| **Đại** | Kết quả phân tích từ Hà để render UI | Dùng `MockPhonemeAnalysis` giả lập kết quả chấm điểm để vẽ UI feedback. |

---

## 6. 🚀 HƯỚNG DẪN BẮT ĐẦU DỰ ÁN CHO TỪNG THÀNH VIÊN

### Bước 1: Khởi tạo và Clone Repo
```bash
# Clone repository về máy
git clone <url-repository-cua-nhom>
cd ai-english-pronunciation-app

# Cài đặt các thư viện cần thiết
flutter pub get
```

### Bước 2: Tạo nhánh cá nhân theo phân công
```bash
# Nguyễn Thế Trưởng:
git checkout -b feature/truong-core-db-notifications

# Phương Văn Đức:
git checkout -b feature/duc-discipline-streak-stats

# Hàn Hoàng Hà:
git checkout -b feature/ha-speech-recognition-ai

# Nguyễn Đăng Đại:
git checkout -b feature/dai-feedback-ui-exercises
```

### Bước 3: Đưa README này vào ngữ cảnh của AI
Khi mở AI (Cursor / Copilot / Gemini / ChatGPT), hãy gõ câu lệnh sau:
> *"Tôi là [Tên thành viên]. Hãy đọc kỹ phân công nhiệm vụ của tôi trong file README.md, tuân thủ đúng Shared Models tại mục 3 và tạo code độc lập trong thư mục được phân công. Hãy bắt đầu từ việc tạo các file mock để có thể chạy thử nghiệm được ngay."*

### Bước 4: Kiểm thử và Ghép nối (Integration)
Vào tuần cuối trước hạn nộp:
1. Leader tạo nhánh `integration-test`.
2. Lần lượt merge các nhánh `feature` vào `integration-test`.
3. Thay thế các `MockService` bằng các Service thật đã hoàn thiện.
4. Chạy kiểm thử trên thiết bị thật Android.
