import 'dart:convert';

import 'package:StaffFlow/app/constants/constant.dart';
import 'package:StaffFlow/app/modules/Messagerie/models/Conversation.dart';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class ConversationController extends GetxController {
  RxList<dynamic> messages = [].obs;

  Future<List<ConvHist>> getHistorique() async {
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
    
    String url = '$URL/Message/get/user/message/last?intTo=$intFrom';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      final chat = data.map((json) => ConvHist.fromJson(json)).toList();
      return chat;
    } else {
      throw Exception('Failed to load historique');
    }
  }

  Future<void> deleteConversation(int intTo, int intFrom) async {
    var response = await http.delete(Uri.parse(
        '$URL/Message/get/user/message?intTo=$intTo&intFrom=$intFrom'));

    if (response.statusCode == 200) {
      print('Conversation deleted successfully');
    } else {
      print('Failed to delete conversation');
    }
  }

  Future<void> onReceiveMessage(List<Object> result) {
    final rxString = RxString(result[1]);

    print(rxString);
    messages.add(rxString.value);
    print("print this liste : ${messages.toString()}");
    update();
  }
}
