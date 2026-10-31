import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  LocalNotificationService._internal();
  static final LocalNotificationService instance = LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Khởi tạo Notification Plugin và Timezone
  Future<void> initialize() async {
    if (_isInitialized) return;

    // 1. Cấu hình Timezone
    tz.initializeTimeZones();
    // Default to Asia/Ho_Chi_Minh or UTC
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
    } catch (_) {
      tz.setLocalLocation(tz.local);
    }

    // 2. Cấu hình Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // 3. Cấu hình iOS / Darwin
    const DarwinInitializationSettings darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('[Notification] User clicked notification: ${response.payload}');
      },
    );

    _isInitialized = true;
  }

  /// Yêu cầu cấp quyền hiển thị thông báo (Android 13+ và iOS)
  Future<bool> requestPermissions() async {
    if (kIsWeb) return false;

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted = await androidImplementation?.requestNotificationsPermission();
      return granted ?? false;
    } else if (Platform.isIOS) {
      final bool? granted = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return granted ?? false;
    }
    return true;
  }

  /// Chi tiết cấu hình kênh thông báo Android (Android Notification Channel)
  NotificationDetails _createNotificationDetails({
    String channelId = 'daily_reminder_channel',
    String channelName = 'Nhắc nhở học tập hàng ngày',
    String channelDescription = 'Kênh gửi thông báo nhắc bạn luyện phát âm và giữ streak',
    Importance importance = Importance.max,
    Priority priority = Priority.high,
  }) {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: importance,
      priority: priority,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return NotificationDetails(android: androidDetails, iOS: darwinDetails);
  }

  /// Hiển thị thông báo ngay lập tức (Dùng để test)
  Future<void> showInstantNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    await _notificationsPlugin.show(
      id,
      title,
      body,
      _createNotificationDetails(),
      payload: payload,
    );
  }

  /// Lên lịch thông báo sau một số giây (Dùng để test hẹn giờ)
  Future<void> scheduleNotificationInSeconds({
    int id = 1,
    required int seconds,
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) await initialize();

    final scheduledDate = tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds));

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      _createNotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Lên lịch thông báo lặp lại hàng ngày vào khung giờ cố định
  Future<void> scheduleDailyReminder({
    int id = 100,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) await initialize();

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Nếu thời gian hôm nay đã qua, đặt sang ngày hôm sau
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      _createNotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Lặp lại hàng ngày theo giờ
    );
  }

  /// Hủy một thông báo theo ID
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// Hủy tất cả thông báo
  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
