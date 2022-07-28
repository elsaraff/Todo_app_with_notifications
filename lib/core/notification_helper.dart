import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'utils.dart';

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    //to add bigPicture and largeIcon to notification

    final bigPicturePath = await Utils.downloadFile(
      'http://store-images.microsoft.com/image/apps.22333.9007199266251942.d218f486-6f90-4e8a-864a-410aa7d8b05d.a15d73d1-39a4-4821-ac98-41b2da32bc36',
      'bigPicture',
    );

    /*
     final largeIconPath = await Utils.downloadFile(
      'https://teferasmamaw.com/images/Todo-img.png',
      'largeIcon',
    );
    */

    final styleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      // largeIcon: FilePathAndroidBitmap(largeIconPath),
    );

    const sound =
        'sweet_notification.wav'; // android\app\src\main\res\raw\sweet_notification.wav

    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: styleInformation,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(sound.split('.').first),
      ),
      iOS: const IOSNotificationDetails(
        presentSound: true,
        //   sound: sound, //xcode needed
      ),
    );
  }

  static Future init({bool initScheduled = false}) async {
    const icon =
        'icon'; //android\app\src\main\res\drawable\app_icon.png //https://icons8.com/

    const android = AndroidInitializationSettings(icon);
    //const android = AndroidInitializationSettings('@mipmap/ic_launcher'); //If you don’t want add  notification icon
    const iOS = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    //when app is closed
    final details = await _notification.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotifications.add(details.payload);
    }

    await _notification.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  //Now for testing
  static Future showNotifications({
    required int id,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notification.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );

  // required DateTime scheduleTime
  static Future showScheduledNotifications({
    required int id,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduleTime,
  }) async =>
      _notification.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduleTime, tz.local),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

  //ScheduledDaily
  static Future showScheduledDailyNotifications({
    required int id,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduleTime,
  }) async {
    return _notification.zonedSchedule(
      id,
      title,
      body,
      _scheduleDaily(scheduleTime: scheduleTime),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime, //difference here
    );
  }

  static tz.TZDateTime _scheduleDaily({
    required DateTime scheduleTime,
  }) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      scheduleTime.year,
      scheduleTime.month,
      scheduleTime.day,
      scheduleTime.hour,
      scheduleTime.minute,
    );
    if (scheduled.isBefore(now)) {
      return scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static Future showScheduledWeeklyNotifications({
    required int id,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduleTime,
  }) async =>
      _notification.zonedSchedule(
        id,
        title,
        body,
        _scheduleWeekly(
          scheduleTime: scheduleTime,
          days: [scheduleTime.weekday], //can be more than day
        ),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents:
            DateTimeComponents.dateAndTime, //difference here
      );

  static tz.TZDateTime _scheduleWeekly({
    required DateTime scheduleTime,
    required List<int> days,
  }) {
    tz.TZDateTime scheduled = _scheduleDaily(scheduleTime: scheduleTime);
    while (!days.contains(scheduled.weekday)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static void cancel(int id) => _notification.cancel(id);
  static void cancelAll() => _notification.cancelAll();
}
