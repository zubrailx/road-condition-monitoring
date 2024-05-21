import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

// TODO: add function to repeat notification when it is not visible
class NotificationsGatewayImpl {
  final FlutterLocalNotificationsPlugin plugin;
  late final NotificationDetails details;

  NotificationsGatewayImpl({required this.plugin}) {
    const androidDetails = AndroidNotificationDetails(
        'ru_zubrailx_monitoring_id', 'monitoring_channel',
        importance: Importance.max, priority: Priority.high);
    const iosDetails = DarwinNotificationDetails();
    details =
        const NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  Future showNotification(
      {id = 0,
      required String title,
      required String body,
      String? payload}) async {
    GetIt.I<Talker>().debug(await plugin.getActiveNotifications());
    return plugin.show(id, title, body, details, payload: payload);
  }
}
