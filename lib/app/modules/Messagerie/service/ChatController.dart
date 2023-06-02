import 'dart:convert';
import 'package:dronalms/app/modules/Messagerie/models/Chat.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ChatController extends GetxController{
  Stream<List<ChatModel>> getAllNotification(int into ) async* {
    print(into);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('personId');
    String intFrom = token.replaceAll('"', '');
    String url='https://10.0.2.2:7062/Notification/get?intTo=$into&intFrom=$intFrom';

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
    const String apiUrl = 'https://10.0.2.2:7062/Notification';
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