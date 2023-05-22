import 'dart:convert';
import 'package:dronalms/app/constants/constant.dart';
import 'package:dronalms/app/models/enonceTest.dart';

import 'package:http/http.dart' as http;

class ApiTest {
  String apiUrl = '$URL/EnonceTests';

  Future<List<EnonceTest>> fetchEnonceByid(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final enonceeJson = data as List<dynamic>;

      final enoncees =
          enonceeJson.map((json) => EnonceTest.fromJson(json)).toList();
      return enoncees;
    } else {
      throw Exception('Failed to load test');
    }
  }

  Future<List<EnonceTest>> fetchEnonce() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      final enonceeJson = data as List<dynamic>;

      final enoncees =
          enonceeJson.map((json) => EnonceTest.fromJson(json)).toList();
      return enoncees;
    } else {
      throw Exception('Failed to load test');
    }
  }
}
