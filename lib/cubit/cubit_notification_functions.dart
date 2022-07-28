import '../core/notification_helper.dart';

class CubitNotifications {
  static void createOnceNotification({
    required int id,
    required String title,
    required DateTime scheduleTime,
    required String remind,
  }) {
    Duration remindBefore = remind == '10 min before'
        ? const Duration(minutes: 10)
        : remind == '30 min before'
            ? const Duration(minutes: 30)
            : remind == '1 hour before'
                ? const Duration(hours: 1)
                : const Duration(days: 1);

    NotificationHelper.showScheduledNotifications(
      id: id,
      title: 'It\'s $remind',
      body: title,
      payload: id.toString(),
      scheduleTime: scheduleTime.subtract(remindBefore),
    );
  }

  static void createDailyNotification({
    required int id,
    required String title,
    required DateTime scheduleTime,
    required String remind,
  }) {
    Duration remindBefore = remind == '10 min before'
        ? const Duration(minutes: 10)
        : remind == '30 min before'
            ? const Duration(minutes: 30)
            : remind == '1 hour before'
                ? const Duration(hours: 1)
                : const Duration(days: 1);

    NotificationHelper.showScheduledDailyNotifications(
      id: id,
      title: 'It\'s $remind',
      body: title,
      payload: id.toString(),
      scheduleTime: scheduleTime.subtract(remindBefore),
    );
  }

  static void createWeeklyNotification({
    required int id,
    required String title,
    required DateTime scheduleTime,
    required String remind,
  }) {
    Duration remindBefore = remind == '10 min before'
        ? const Duration(minutes: 10)
        : remind == '30 min before'
            ? const Duration(minutes: 30)
            : remind == '1 hour before'
                ? const Duration(hours: 1)
                : const Duration(days: 1);

    NotificationHelper.showScheduledWeeklyNotifications(
      id: id,
      title: 'It\'s $remind',
      body: title,
      payload: id.toString(),
      scheduleTime: scheduleTime.subtract(remindBefore),
    );
  }

  static void deleteNotification({
    required int id,
  }) {
    NotificationHelper.cancel(id);
  }
}
