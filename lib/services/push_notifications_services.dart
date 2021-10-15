import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:get/instance_manager.dart';
import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/screens/received_interactions_screen.dart';
import 'package:knowme/screens/users_profile_screen.dart';
import '../main.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class PushNotificationsServices {
  PushNotificationsServices._();
  static final _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    await _messaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_onMessagingReceivedInBackground);
    FirebaseMessaging.onMessage.listen(_onMessageReceived);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessagingOpenApp);
    // final token = await _messaging.getToken();
    // print(token);
    final details = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    debugPrint('called debug  ${details?.payload} ${details?.didNotificationLaunchApp}');
    if ((details?.didNotificationLaunchApp ?? false)) {
      selectNotification(details?.payload);
    }
    await MyApp.initializationComplete.future;
    await _initializePushNotification();
    return;
  }

  static void _onMessagingOpenApp(RemoteMessage message) {
    final json = jsonDecode(message.data['data']);

    selectNotification(jsonEncode(json['payload']));
  }

  static void _onMessageReceived(RemoteMessage message, {bool inBackground = false}) {
    print('receive message');
    showNotification(message);
  }

  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  static _initializePushNotification() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      requestSoundPermission: true,
      requestAlertPermission: true,
      defaultPresentSound: true,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
        );
  }

  static Future selectNotification(String? payload) async {
    print('select Notification');
    if (payload == null) return;
    final data = jsonDecode(payload);
    final type = data['type'];
    if (type == 'message') {
      final userMap = data['user'];
      await MyApp.initializationComplete.future;
      await Get.find<SesssionController>().chatController.getRoomsCompleter.future;
      Get.find<SesssionController>().openChat(UserModel(
        id: userMap['uid'],
      ));
    }
    if (type == 'interaction_received') {
      await MyApp.initializationComplete.future;
      Get.to(() => ReceivedInteractionsScreen());
    }
    if (type == 'interaction_updated') {
      await MyApp.initializationComplete.future;
      Get.to(UsersProfileScreen(userModel: UserModel(id: data['uid'])));
    }
  }

  static Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {}

  static showNotification(RemoteMessage message) async {
    final data = jsonDecode(message.data['data']);
    final type = data['type'];
    if (type == 'message') _showMessageNotfication(payload: jsonEncode(data));

    if (type == 'interaction_received' || type == 'interaction_updated')
      _showInteractionsNotifications(payload: jsonEncode(data));
    if (type == 'payment_approved') {
      _showPaymentNotification(jsonEncode(data));
    }
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = Directory.systemTemp;
    final String filePath = '${directory.path}/$fileName';
    final response = await get(Uri.parse(url));
    final File file = await File(filePath).writeAsBytes(response.bodyBytes);

    return filePath;
  }

  static _showPaymentNotification(String payload) {
    final json = jsonDecode(payload);
    flutterLocalNotificationsPlugin.show(
        122,
        json['title'],
        json['body'],
        NotificationDetails(
            android: AndroidNotificationDetails(PAYMENT_ANDROID_NOTIFICATION_ID,
                PAYMENT_CHANNEL_NOTIFICATION_NAME, PAYMENT_CHANNEL_NOTIFICATION_DESCRIPTION)));
  }

  static _showInteractionsNotifications({
    required String payload,
  }) async {
    final data = jsonDecode(payload);
    final AndroidNotificationDetails androidSettings = AndroidNotificationDetails(
        MESSAGE_ANDROID_NOTIFICATION_ID,
        MESSAGE_CHANNEL_NOTIFICATION_NAME,
        MESSAGE_CHANNEL_NOTIFICATION_DESCRIPTION,
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        icon: '@drawable/ic_notification',
        styleInformation: BigTextStyleInformation(data['body'],
            contentTitle: data['title'], htmlFormatContent: true));

    final notificationDetails = NotificationDetails(
      android: androidSettings,
    );
    await flutterLocalNotificationsPlugin.show(data['id'], null, null, notificationDetails,
        payload: payload);
    await Get.find<SesssionController>().getReceivedInteractions();
  }

  static _showMessageNotfication({
    required String payload,
  }) async {
    final data = jsonDecode(payload);
    if (Get.currentRoute == '/ChatScreen') return;
    final title = data['title'];
    final userMap = data['user'];
    final profileImage = await _downloadAndSaveFile(userMap['profile_image'], 'profileImage');
    final id = int.parse(data['room']);
    final person = Person(
      key: userMap['uid'],
      name: userMap['name'],
      icon: BitmapFilePathAndroidIcon(profileImage),
    );
    final messages = List.from(data['message'])
        .map((e) => Message(e['text'], DateTime.parse(e['date_time']), person))
        .toList();

    final messaginInformation = MessagingStyleInformation(person, messages: messages);

    final AndroidNotificationDetails androidSettings = AndroidNotificationDetails(
      MESSAGE_ANDROID_NOTIFICATION_ID,
      MESSAGE_CHANNEL_NOTIFICATION_NAME,
      MESSAGE_CHANNEL_NOTIFICATION_DESCRIPTION,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      icon: '@drawable/ic_notification',
      category: 'msg',
      styleInformation: messaginInformation,
    );

    final notificationDetails = NotificationDetails(
      android: androidSettings,
    );
    await flutterLocalNotificationsPlugin.show(id, title, '', notificationDetails,
        payload: payload);
  }
}

Future<void> _onMessagingReceivedInBackground(RemoteMessage message) async {
  PushNotificationsServices._onMessageReceived(message);
}

const MESSAGE_ANDROID_NOTIFICATION_ID = '1';
const MESSAGE_CHANNEL_NOTIFICATION_NAME = 'message';
const MESSAGE_CHANNEL_NOTIFICATION_DESCRIPTION =
    'Usado para mostrar quando o usuário recebe uma mensagem';

const PAYMENT_ANDROID_NOTIFICATION_ID = '2';
const PAYMENT_CHANNEL_NOTIFICATION_NAME = 'pagamentos';
const PAYMENT_CHANNEL_NOTIFICATION_DESCRIPTION =
    'Usado para mostrar as interações de pagamentos com o usuário';
