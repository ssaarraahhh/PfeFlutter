import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Noti{
  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationsSettings = InitializationSettings(android: androidInitialize,);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings );
  }

  static Future showBigTextNotification({
    int id = 0,
    String title,
    String body,
    var payload,
    FlutterLocalNotificationsPlugin fln,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    const AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_name',
      '',
       // playSound: true,
      // sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(id, title, body, not);

  }


}