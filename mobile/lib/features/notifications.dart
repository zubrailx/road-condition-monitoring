import 'package:get_it/get_it.dart';
import 'package:mobile/gateway/notifications.dart';

Future showNotification({id=0, required String title, required String body, String? payload}) {
  return GetIt.I<NotificationsGatewayImpl>().showNotification(id: id, title: title, body: body, payload: payload);
}
