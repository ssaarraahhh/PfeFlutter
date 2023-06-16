import 'dart:convert';

import 'package:StaffFlow/app/constants/constant.dart';
import 'package:StaffFlow/app/models/employe.dart';
import 'package:StaffFlow/app/modules/Messagerie/models/Message.dart';
import 'package:StaffFlow/app/modules/Messagerie/models/User.Model.dart';
import 'package:StaffFlow/main.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_client/signalr_client.dart';
import 'package:http/http.dart' as http;



class ControllerHub extends GetxController {
  List<Users> x = [];
  static List<Users> userData = [];
  static List<Object> usersOn = [];
  String msg;

  bool isAuthenticated = false;
  static List<String> nameOL = [];

  void setX() async {
    x = onlineUsers;

    if (DronaLMS.hubConnection.state == HubConnectionState.Connected) {
      print("aalech");
      await getOnlineUsersInv();
      print("taadet");
    }
    await getOnlineUsersLis();

    update();
  }

  static List<Users> onlineUsers = [];

  String extractConnId(dynamic user) {
    if (user is List && user.isNotEmpty) {
      Map<String, dynamic> userData = user[0];
      if (userData.containsKey('connId')) {
        return userData['connId'].toString();
      }
    }
    return null; // Return null if connId is not found or user is invalid
  }

  Future<void> authMe(String person, String pass) async {
    var personInfo = [
      {
        'email': person,
        'password': pass,
      }
    ];

    if (personInfo != null) {
      DronaLMS.hubConnection.on('authMeResponseSuccess', (user) async {
        print(
            'Authentication success. User: ${extractConnId(user).toString()}');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('connId', jsonEncode(extractConnId(user)));

        // Handle success response here
      });

      DronaLMS.hubConnection.on('authMeResponseFail', (response) {
        print('Authentication failed. Response: $response');

        // Handle failure response here
      });

      DronaLMS.hubConnection.on('authMeResponseSuccess2', (token) async {
        print('Authentication success. Token: $token');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', jsonEncode(token.toString()));
        // Handle success response with token here
      });

      await DronaLMS.hubConnection.invoke('authMe', args: personInfo);
    } else {
      print('Error: personInfo is null.');
    }
  }

  Future<String> getUserId(String userName, String password) async {
    final url = Uri.parse("$URL/Users/id?email=$userName&password=$password");
    final response = await http.get(url);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('personId', response.body);
    if (response.statusCode == 200) {
      print("hh");
      print("response.body${response.body}");
      return response.body;
    } else {
      throw Exception('Failed to get user ID.');
    }
  }

  Future<void> getOnlineUsersInv() async {
    await DronaLMS.hubConnection
        .invoke('getOnlineUsers')
        .catchError((err) => print(err));
    print("gjjjj");
  }

  Future<List<Users>>getOnlineUsersLis() async {
    DronaLMS.hubConnection.on('getOnlineUsersResponse', (arguments) {
      print("jj${arguments[0]}");
      onlineUsers = List<Map<String, dynamic>>.from(arguments[0])
          .map((json) => Users.fromJson(json))
          .toList();
      nameOL.clear();
      print("onlineeeeee$onlineUsers");
      onlineUsers.forEach((e) {
        nameOL.add(e.nom);
      });
      print("aaaaaaaaaaaonline$nameOL");
    });

    update();
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);

    final Map<String, dynamic> decodedToken = json.decode(
        ascii.decode(base64.decode(base64.normalize(token.split(".")[1]))));

    print(decodedToken);
    final String sid = decodedToken[
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid'];
    print(sid);
    final List<Object> PersonId = [sid];
    //  int id = int.parse(sid);
    await DronaLMS.hubConnection
        .invoke("logOut", args: PersonId)
        .catchError((err) => print(err));
  }
}
