import 'package:flutter/material.dart';
import 'package:signalr_client/signalr_client.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  HubConnection hubConnection;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    initialNotification();
    startSignalRConnection();
  }

  @override
  void dispose() {
    hubConnection.stop();
    super.dispose();
  }

  initialNotification() async{
    WidgetsFlutterBinding.ensureInitialized();
    // Initialize the settings for Android
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void startSignalRConnection() async {
    hubConnection = HubConnectionBuilder().withUrl('https://db0d-196-225-30-66.eu.ngrok.io/Hub').build();
    await hubConnection.start();
    hubConnection.on('transferData', (data) {
      // Do something when the 'eventName' event is triggered
      _showNotification(data.toString());
      print('eventName was triggered with parameters: $data');
    });
  }

  Future<void> _showNotification(String data) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('channel_id', 'channel_name' ,"", importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'New Message', '$data!', platformChannelSpecifics,
        payload: 'item x');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Your widget code here
    );
  }
}
