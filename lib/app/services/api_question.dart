import 'dart:convert';
import 'package:dronalms/app/constants/constant.dart';
import 'package:dronalms/app/models/question.dart';
import 'package:http/http.dart' as http;

class ApiQuestion {
  String apiUrl = '$URL/Questions';

  Future<List<Question>> fetchQuestionByid(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final questionJson = data as List<dynamic>;

      final questions =
          questionJson.map((json) => Question.fromJson(json)).toList();
      return questions;
    } else {
      throw Exception('Failed to load question');
    }
  }

  Future<List<Question>> fetchQuestion() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final questionJson = data as List<dynamic>;

      final questions =
          questionJson.map((json) => Question.fromJson(json)).toList();
      return questions;
    } else {
      throw Exception('Failed to load test');
    }
  }
}
