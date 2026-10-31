import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import 'services/local_notification_service.dart';

class NotificationScheduler {
  static const String _prefReminderHourKey = 'daily_reminder_hour';
  static const String _prefReminderMinuteKey = 'daily_reminder_minute';
  static const String _prefReminderEnabledKey = 'daily_reminder_enabled';

  final LocalNotificationService _notificationService;

  NotificationScheduler({LocalNotificationService? service})
      : _notificationService = service ?? LocalNotificationService.instance;

  /// Đọc cài đặt giờ thông báo của người dùng
  Future<TimeOfDay> getSavedReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt(_prefReminderHourKey) ?? AppConstants.defaultReminderHour;
    final minute = prefs.getInt(_prefReminderMinuteKey) ?? AppConstants.defaultReminderMinute;
    return TimeOfDay(hour: hour, minute: minute);
  }

  /// Kiểm tra thông báo có đang bật không
  Future<bool> isReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefReminderEnabledKey) ?? true;
  }

  /// Cập nhật giờ thông báo hàng ngày và lên lịch lại
  Future<void> updateDailyReminder(TimeOfDay time, {bool enabled = true}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefReminderHourKey, time.hour);
    await prefs.setInt(_prefReminderMinuteKey, time.minute);
    await prefs.setBool(_prefReminderEnabledKey, enabled);

    if (enabled) {
      await _notificationService.scheduleDailyReminder(
        id: 100,
        hour: time.hour,
        minute: time.minute,
        title: AppStrings.dailyReminderTitle,
        body: AppStrings.dailyReminderBody,
      );
    } else {
      await _notificationService.cancelNotification(100);
    }
  }
}
