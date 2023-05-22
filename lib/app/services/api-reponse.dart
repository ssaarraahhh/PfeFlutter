import 'dart:convert';
import 'package:dronalms/app/constants/constant.dart';
import 'package:dronalms/app/models/question.dart';
import 'package:dronalms/app/models/reponse.dart';
import 'package:http/http.dart' as http;

class ApiReponse {
  String apiUrl = '$URL/Reponses';

  Future<List<Reponse>> fetchReponseByid(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final reponseJson = data as List<dynamic>;

      final reponses =
          reponseJson.map((json) =>Reponse.fromJson(json)).toList();
      return reponses;
    } else {
      throw Exception('Failed to load reponse');
    }
  }


  Future<List<Reponse>> fetchReponse() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final reponseJson = data as List<dynamic>;

      final reponses =
          reponseJson.map((json) => Reponse.fromJson(json)).toList();
      return reponses;
    } else {
      throw Exception('Failed to load test');
    }
  }

}
