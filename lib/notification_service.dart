import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  static final NotificationService _notificationService = NotificationService
      ._internal();
  static final _notifications = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static Future showNotifications({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async => _notifications.show(id, title, body, _notificationDetails(), payload: payload);

  static NotificationDetails? _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          'channel id',
          'channel name',
        channelDescription: 'channel description',
        importance: Importance.max
      ),
      iOS: IOSNotificationDetails()
    );
  }

}