import 'dart:convert';

import 'package:dronalms/app/constants/constant.dart';
import 'package:dronalms/app/models/formation.dart';
import 'package:http/http.dart' as http;

class ApiFormation {
  String Url = "$URL/Formations";

  Future<List<Formation>> fetchFormations() async {
    final response = await http.get(Uri.parse(Url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final cat = data.map((e) => Formation.fromJson(e)).toList();

      print(cat);
      return cat;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Formation>> fetchFormationById(int id) async {
    final response = await http.get(Uri.parse('$Url/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final cat = data.map((e) => Formation.fromJson(e)).toList();

      print(cat);
      return cat;
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
