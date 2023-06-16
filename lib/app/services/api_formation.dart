import 'dart:convert';

import 'package:StaffFlow/app/constants/constant.dart';
import 'package:StaffFlow/app/models/formation.dart';
import 'package:http/http.dart' as http;

class ApiFormation {
  String Url = "$URL/Formations";

  Future<List<Formation1>> fetchFormations() async {
    final response = await http.get(Uri.parse(Url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final cat = data.map((e) => Formation1.fromJson(e)).toList();

      print(cat);
      return cat;
    } else {
      throw Exception('Failed to load formations');
    }
  }

  Future<List<Formation1>> fetchFormationById(int id) async {
    final response = await http.get(Uri.parse('$Url/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final cat = data.map((e) => Formation1.fromJson(e)).toList();

      print(cat);
      return cat;
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
