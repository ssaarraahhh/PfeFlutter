import 'dart:convert';
import 'dart:io';
import 'package:StaffFlow/app/models/notification.dart';

import 'package:StaffFlow/app/constants/app_string_constants.dart';
import 'package:StaffFlow/app/constants/constant.dart';
import 'package:StaffFlow/app/modules/Messagerie/service/Notif.dart';
import 'package:StaffFlow/app/modules/Messagerie/views/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_client/signalr_client.dart';

import 'app/routes/app_pages.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DronaLMS());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    HttpClient client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}

class DronaLMS extends StatefulWidget {
  DronaLMS({Key key}) : super(key: key);

  static final HubConnection hubConnection =
      HubConnectionBuilder().withUrl("$URL1/notificationHub").build();

  @override
  _DronaLMSState createState() => _DronaLMSState();
}

class _DronaLMSState extends State<DronaLMS> {
  final serverUrl = "$URL1/notif";

  HubConnection hubConnection1;
  final List<String> messages = [];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Notification1 notification;
  List<String> notificationList = [];

  @override
  void initState() {
    super.initState();
    startSignalRConnection();
    startConnection();

    initializeLocalNotifications();
    DronaLMS.hubConnection.on("sendMsgResponse", onReceiveMessage);
    Noti.initialize(flutterLocalNotificationsPlugin);
  }

  void startConnection() async {
    await DronaLMS.hubConnection.start();
    print('SignalR connection established. You are connected.aaaaaaaaa');
    //   await DronaLMS.hubConnection.start();
    print(DronaLMS.hubConnection.state);
    //   print('done');
  }

  void onReceiveMessage(List<Object> result) {
    setState(() {
      messages.add("${result[1]}");
      print("print this liste : ${messages.toString()}");
      Noti.showBigTextNotification(
        id: 1,
        title: "Nouveau message",
        body: messages.last,
        fln: flutterLocalNotificationsPlugin,
      );
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  void startSignalRConnection() async {
    hubConnection1 = HubConnectionBuilder().withUrl(serverUrl).build();
    hubConnection1.onclose((error) {
      print("Connection closed");
    });

    hubConnection1.on('SendNotification', (data) async {
      Map<String, dynamic> notificationData = data[0];
      String notificationText = notificationData['notifi'];
      setState(() {
        notificationList.add(notificationText);
      });
      print(notificationText);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print(token);

      final Map<String, dynamic> decodedToken = json.decode(
          ascii.decode(base64.decode(base64.normalize(token.split(".")[1]))));

      print(decodedToken);
      final String sid = decodedToken[
          'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid'];
      print(sid);
      int id = int.parse(sid);
      if (data[1] == id) {
        _showNotification(notificationText);
      }
      //print('eventName was triggered with parameters: $data');
    });

    try {
      await hubConnection1.start();
      print('SignalR connection established.');
    } catch (error) {
      print('SignalR connection error: $error');
    }
  }

  Future<void> initializeLocalNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String data) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('channel_id', 'channel_name', '',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Nouvelle Notification',
      data,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return FutureBuilder(
          future: getToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: LmsAppConstants.APP_NAME,
                initialRoute: snapshot.data,
                getPages: AppPages.routes,
                theme: ThemeData.light()
                    .copyWith(scaffoldBackgroundColor: Colors.white),
              );
            } else {
              // Handle loading state
              return Container();
            }
          },
        );
      },
    );
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      final Map<String, dynamic> decodedToken = json.decode(
          ascii.decode(base64.decode(base64.normalize(token.split(".")[1]))));
      final expirationTimestamp = decodedToken['exp'];
      final expirationDate =
          DateTime.fromMillisecondsSinceEpoch(expirationTimestamp * 1000);
      final currentDate = DateTime.now();
      // print(expirationDate);
      // print(currentDate);
      if (expirationDate.isAfter(currentDate)) {
        return Routes.LMS_DASHBOARD;
      } else {
        return Routes.AUTH;
      }
    } else {
      return Routes.AUTH;
    }
  }
}
