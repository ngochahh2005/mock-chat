import 'package:firebase_messaging/firebase_messaging.dart';

class OpenNotificationEvent {
  final RemoteMessage remoteMessage;

  OpenNotificationEvent(this.remoteMessage);
}
