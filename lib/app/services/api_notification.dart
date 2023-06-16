

import 'dart:convert';

import 'package:StaffFlow/app/constants/constant.dart';
import 'package:StaffFlow/app/models/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiNotification {
  



  String Url = "$URL/Notifications";




Future<List<Notification1>> fetchNotifications() async {
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
  final response = await http.get(Uri.parse('$Url/$id'));
  if (response.statusCode == 200) {
    print("Successfully fetched notifications");
    final List<dynamic> notificationJsonList = json.decode(response.body);
    final notifications = notificationJsonList
        .map((json) => Notification1.fromJson(json))
        .toList();

    // Order the notifications by ID in descending order
    notifications.sort((a, b) => b.id.compareTo(a.id));

    return notifications;
  } else {
    print("Failed to fetch notifications");
    return [];
  }
}




}
