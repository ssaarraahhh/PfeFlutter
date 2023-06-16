// import 'package:StaffFlow/app/constants/constant.dart';
// import 'package:StaffFlow/app/modules/Messagerie/service/Notif.dart';
// import 'package:StaffFlow/app/modules/Messagerie/views/HomeScreen.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'dart:io';
// import 'package:signalr_client/signalr_client.dart';

// import 'app/models/employe.dart';

// void main() {
//   HttpOverrides.global = new MyHttpOverrides();
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext context) {
//     HttpClient client = super.createHttpClient(context);
//     client.badCertificateCallback =
//         (X509Certificate cert, String host, int port) => true;
//     return client;
//   }
// }

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   static Employe userData;

//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;
//   static final hubConnection =
//       HubConnectionBuilder().withUrl("$URL1/notificationHub").build();

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final List<String> messages = [];

//   void onReceiveMessage(List<Object> result) {
//     setState(() {
//       messages.add("${result[1]}");
//       print("print this liste : ${messages.toString()}");
//       Noti.showBigTextNotification(
//         id: 1,
//         title: "Nouveau message",
//         body: messages.last,
//         fln: flutterLocalNotificationsPlugin,
//       );
//       Navigator.of(context)
//           .push(MaterialPageRoute(builder: (context) => HomeScreen()));
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     MyHomePage.hubConnection.on("sendMsgResponse", onReceiveMessage);
//     Noti.initialize(flutterLocalNotificationsPlugin);
//     startConnection();
//   }

//   void startConnection() async {
//     await MyHomePage.hubConnection.start();
//     print(MyHomePage.hubConnection.state);
//     print('done');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: HomeScreen());
//   }
// }
