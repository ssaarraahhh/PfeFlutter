import 'dart:convert';

import 'package:StaffFlow/app/constants/constant.dart';
import 'package:StaffFlow/app/models/categorie.dart';

import 'package:http/http.dart' as http;

class ApiCategorie {
  String Url = "$URL/Categories";

  Future<List<Categorie>> fetchCategories() async {
    final response = await http.get(Uri.parse(Url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final cat = data.map((e) => Categorie.fromJson(e)).toList();

      print(cat);
      return cat;
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
