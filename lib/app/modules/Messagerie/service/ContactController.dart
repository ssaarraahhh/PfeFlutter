import 'dart:convert';
import 'package:StaffFlow/app/constants/constant.dart';
import 'package:StaffFlow/app/models/employe.dart';
import 'package:StaffFlow/app/modules/Messagerie/models/Message.dart';
import 'package:StaffFlow/app/modules/Messagerie/models/User.Model.dart';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactController extends GetxController {
  static List<Users> user;

  Future<List<Users>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);

    final Map<String, dynamic> decodedToken = json.decode(
      ascii.decode(base64.decode(base64.normalize(token.split(".")[1]))),
    );

    print(decodedToken);
    final String sid = decodedToken[
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid'];
    print(sid);
    int id = int.parse(sid);

    final response = await http.get(Uri.parse('$URL/Users'));
    if (response.statusCode == 200) {
      print("A1");
      final List<dynamic> data = jsonDecode(response.body);
      print(data);
      final users = data.map((json) => Users.fromJson(json)).toList();
      print("A2: $users");

      // Filter the users where the ID is not equal to the specified ID
      final filteredUsers = users.where((user) => user.id != id).toList();

      // Print the filtered users to the terminal
      for (var user in filteredUsers) {
        print(user);
      }

      return filteredUsers;
    } else {
      throw Exception('Failed to load users');
    }
  }
}
