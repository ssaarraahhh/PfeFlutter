import 'dart:convert';
import 'package:StaffFlow/app/constants/constant.dart';
import 'package:StaffFlow/app/modules/Messagerie/models/Chat.dart';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ChatController extends GetxController{
  Stream<List<ChatModel>> getAllNotification(int into ) async* {
    print(into);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);

    final Map<String, dynamic> decodedToken = json.decode(
        ascii.decode(base64.decode(base64.normalize(token.split(".")[1]))));

    print(decodedToken);
    final String sid = decodedToken[
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid'];
    print(sid);
    int intFrom = int.parse(sid);
    // String intFrom = token.replaceAll('"', '');
    String url='$URL/Message/get?intTo=$into&intFrom=$intFrom';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      final chat = data.map((json) => ChatModel.fromJson(json)).toList();
      print(chat);
      yield chat;
    } else {
      throw Exception('Failed to load users');
    }
  }
  Future<void> createChat(ChatModel chat) async {
    const String apiUrl = '$URL/Message';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(chat.toJson()),
      );

      if (response.statusCode == 200) {
        print('Chat created successfully');
      } else {
        print('Failed to create chat: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating chat: $e');
    }
  }

}