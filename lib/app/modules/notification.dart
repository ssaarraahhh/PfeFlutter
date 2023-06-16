// import 'package:flutter/material.dart';
// import 'package:signalr_client/signalr_client.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class MyWidget extends StatefulWidget {
//   @override
//   _MyWidgetState createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<MyWidget> {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   int _selectedIndex = 0;
//   final serverUrl = "http://192.168.1.14:5179/notificationHub";
//   HubConnection hubConnection;
//   @override
//   void initState() {
//     super.initState();

//     startSignalRConnection();
//   }

//   @override
//   void dispose() {
//     hubConnection.stop();
//     super.dispose();
//   }

//   void startSignalRConnection() async {
//     hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
//     hubConnection.start();
//     hubConnection.onclose((error) {
//       print("connection close");
//     });

//     hubConnection.on('transferData', (data) {
//       // Do something when the 'eventName' event is triggered
//       _showNotification(data.toString());
//       print('eventName was triggered with parameters: $data');
//     });
//     await hubConnection.start();
//   }

//   Future<void> _showNotification(String data) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails('channel_id', 'channel_name', "",
//             importance: Importance.max,
//             priority: Priority.high,
//             ticker: 'ticker');
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//         0, 'New Message', '$data!', platformChannelSpecifics,
//         payload: 'item x');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         // Your widget code here
//         );
//   }
// }
