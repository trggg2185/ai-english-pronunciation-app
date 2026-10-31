import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/local/database_repository.dart';
import '../../../data/local/i_database_repository.dart';
import '../../../data/local/mock_database_service.dart';
import '../../../data/models/phoneme_analysis.dart';
import '../../../data/models/practice_session_model.dart';
import '../../../data/models/streak_model.dart';
import '../../../data/models/user_model.dart';
import '../notification_scheduler.dart';
import '../services/local_notification_service.dart';

class DebugDbScreen extends StatefulWidget {
  const DebugDbScreen({super.key});

  @override
  State<DebugDbScreen> createState() => _DebugDbScreenState();
}

class _DebugDbScreenState extends State<DebugDbScreen> {
  late IDatabaseRepository _repository;
  final NotificationScheduler _scheduler = NotificationScheduler();
  bool _useMockDb = false;

  UserModel? _user;
  StreakModel? _streak;
  List<PracticeSessionModel> _history = [];
  bool _isLoading = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);

  @override
  void initState() {
    super.initState();
    _repository = DatabaseRepository();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    try {
      final user = await _repository.getUser();
      final streak = await _repository.getStreak();
      final history = await _repository.getPracticeHistory(limit: 50);
      final reminderTime = await _scheduler.getSavedReminderTime();

      if (!mounted) return;
      setState(() {
        _user = user;
        _streak = streak;
        _history = history;
        _reminderTime = reminderTime;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('[DebugDbScreen] Error loading data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _toggleDbMode(bool useMock) {
    setState(() {
      _useMockDb = useMock;
      _repository = useMock ? MockDatabaseService() : DatabaseRepository();
    });
    _loadAllData();
  }

  Future<void> _insertMockSession() async {
    final newSession = PracticeSessionModel(
      id: const Uuid().v4(),
      sentenceOrWord: 'Good morning everyone',
      standardIpa: '/ɡʊd ˈmɔːrnɪŋ ˈevriwʌn/',
      score: 85.0 + (DateTime.now().second % 15),
      durationSeconds: 30,
      practicedAt: DateTime.now(),
      audioRecordPath: '/data/audio/sample_${DateTime.now().millisecondsSinceEpoch}.wav',
      phonemeResults: [
        PhonemeAnalysis(phoneme: 'ɡ', accuracyScore: 90, status: PhonemeStatus.correct),
        PhonemeAnalysis(phoneme: 'ʊ', accuracyScore: 85, status: PhonemeStatus.correct),
        PhonemeAnalysis(phoneme: 'd', accuracyScore: 88, status: PhonemeStatus.correct),
        PhonemeAnalysis(phoneme: 'm', accuracyScore: 92, status: PhonemeStatus.correct),
        PhonemeAnalysis(phoneme: 'ɔːr', accuracyScore: 75, status: PhonemeStatus.acceptable),
        PhonemeAnalysis(phoneme: 'n', accuracyScore: 90, status: PhonemeStatus.correct),
        PhonemeAnalysis(phoneme: 'ɪ', accuracyScore: 82, status: PhonemeStatus.correct),
        PhonemeAnalysis(phoneme: 'ŋ', accuracyScore: 45, status: PhonemeStatus.wrong, suggestion: 'Hạ thấp cuống lưỡi chạm vào ngạc mềm'),
      ],
    );

    await _repository.savePracticeSession(newSession);

    // Update streak mock count
    if (_streak != null) {
      final todayStr = DateFormatter.toYmd(DateTime.now());
      final List<String> dates = List.from(_streak!.activeDates);
      if (!dates.contains(todayStr)) {
        dates.add(todayStr);
      }
      final updatedStreak = StreakModel(
        currentStreak: _streak!.currentStreak + 1,
        longestStreak: (_streak!.currentStreak + 1 > _streak!.longestStreak)
            ? _streak!.currentStreak + 1
            : _streak!.longestStreak,
        lastPracticeDate: DateTime.now(),
        activeDates: dates,
      );
      await _repository.saveStreak(updatedStreak);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã thêm 1 bản ghi luyện tập giả lập vào Database!')),
    );

    _loadAllData();
  }

  Future<void> _deleteSession(String id) async {
    await _repository.deletePracticeSession(id);
    _loadAllData();
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null && mounted) {
      setState(() => _reminderTime = picked);
      await _scheduler.updateDailyReminder(picked);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã đặt thông báo hàng ngày lúc ${picked.format(context)}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin / Core & Database Test'),
        actions: [
          Row(
            children: [
              Text(_useMockDb ? 'Mock DB' : 'SQLite', style: const TextStyle(fontSize: 12)),
              Switch(
                value: _useMockDb,
                onChanged: _toggleDbMode,
              ),
            ],
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAllData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 16),
                  _buildNotificationSection(),
                  const SizedBox(height: 16),
                  _buildStreakCard(),
                  const SizedBox(height: 16),
                  _buildHistoryHeader(),
                  const SizedBox(height: 8),
                  _buildHistoryList(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _user?.name ?? 'Nguyễn Thế Trưởng (Leader)',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        _user?.email ?? 'truong.nt@example.com',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_user?.dailyTargetMinutes ?? 15} phút/ngày',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.notifications_active, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'Hệ Thống Thông Báo (YC 6)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.shield_outlined),
                    label: const Text('Xin Quyền'),
                    onPressed: () async {
                      final granted = await LocalNotificationService.instance.requestPermissions();
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Quyền thông báo: ${granted ? "Đã cấp" : "Chưa cấp"}')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text('Bắn Test'),
                    onPressed: () async {
                      await LocalNotificationService.instance.showInstantNotification(
                        id: 99,
                        title: AppStrings.dailyReminderTitle,
                        body: 'Thử nghiệm thông báo thành công từ Nguyễn Thế Trưởng!',
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.timer),
                    label: const Text('Hẹn 5 giây'),
                    onPressed: () async {
                      await LocalNotificationService.instance.scheduleNotificationInSeconds(
                        id: 98,
                        seconds: 5,
                        title: 'Thông báo sau 5 giây ⏰',
                        body: 'Nhắc nhở học phát âm tiếng Anh đã kích hoạt chuẩn xác!',
                      );
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã hẹn thông báo sau 5 giây! Hãy khóa máy hoặc ẩn app để kiểm tra.')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                    icon: const Icon(Icons.alarm),
                    label: Text(_reminderTime.format(context)),
                    onPressed: _pickReminderTime,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard() {
    return Card(
      color: AppColors.streakBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.local_fire_department, color: AppColors.fireActive, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_streak?.currentStreak ?? 0} Ngày Liên Tiếp (Streak)',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.fireActive),
                  ),
                  Text(
                    'Kỷ lục: ${_streak?.longestStreak ?? 0} ngày | Ngày gần nhất: ${_streak?.lastPracticeDate != null ? DateFormatter.toDisplay(_streak!.lastPracticeDate!) : "Chưa có"}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Lịch sử luyện tập (${_history.length})',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        ElevatedButton.icon(
          onPressed: _insertMockSession,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Thêm bản ghi test'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            textStyle: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    if (_history.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: const Text(
          'Chưa có dữ liệu lịch sử nào trong SQLite.\nHãy bấm "Thêm bản ghi test" ở trên!',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _history.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final session = _history[index];
        final isHigh = session.score >= 80;
        final isMedium = session.score >= 50 && session.score < 80;
        final scoreColor = isHigh ? AppColors.correct : (isMedium ? AppColors.acceptable : AppColors.wrong);

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: scoreColor.withAlpha(38),
              child: Text(
                session.score.toStringAsFixed(0),
                style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(session.sentenceOrWord, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.standardIpa, style: const TextStyle(color: AppColors.primary, fontSize: 12)),
                Text(
                  '${DateFormatter.toDisplay(session.practicedAt)} • ${session.durationSeconds}s • ${session.phonemeResults.length} âm vị',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => _deleteSession(session.id),
            ),
          ),
        );
      },
    );
  }
}
