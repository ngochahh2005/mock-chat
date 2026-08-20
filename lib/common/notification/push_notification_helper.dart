import 'package:base_bloc_3/import.dart';

@singleton
class PushNotificationHelper {
  late final FirebaseMessaging _firebaseMessaging;
  RemoteMessage? initMessage;
  String? pushToken;
  final Talker logger;

  PushNotificationHelper(this.logger);

  /// Call this method to initialize FCM at main.dart after Firebase.initializeApp()
  Future<void> initialize({
    Function(String)? handleNotificationOnTap,
  }) async {
    _firebaseMessaging = FirebaseMessaging.instance;
    await _fcmInitialization();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future _fcmInitialization() async {
    try {
      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        pushToken = token;
      });

      initMessage = await _firebaseMessaging.getInitialMessage();

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        logger.debug("Message: ${message.toMap()}");

        if (message.notification != null) {
          if (Platform.isAndroid) {
            getIt<LocalNotificationHelper>().showNotification(
              title: message.notification?.title ?? '',
              body: message.notification?.body ?? '',
              payload: jsonEncode(message.toMap()),
            );
          }
        }
      });
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        getIt<EventBus>().fire(
          OpenNotificationEvent(
            message,
          ),
        );
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<String?> getPushToken() async {
    pushToken ??= await _firebaseMessaging.getToken();
    logger.debug('fcm token: $pushToken');
    return pushToken;
  }

  Future<void> unSubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> deleteToken() async {
    pushToken = null;
    await _firebaseMessaging.deleteToken();
  }

  FirebaseMessaging getFirebaseInstance() {
    return _firebaseMessaging;
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage remoteMessage,
) async {
  if (kDebugMode) {
    print(
      'Handling a background message: ${remoteMessage.toMap()}',
    );
  }
}
