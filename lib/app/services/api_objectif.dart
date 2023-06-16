import 'dart:convert';
import 'dart:io';


import 'package:StaffFlow/app/constants/constant.dart';
import 'package:StaffFlow/app/models/objectif.dart';
import 'package:http/http.dart' as http;

import '../models/tasks.dart';

class ApiObjectif {
  String Url = "$URL/Objectifs";

  Future<List<Objectif>> fetchObjectif() async {
    final response = await http.get(Uri.parse(Url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final objectifs = data.map((e) => Objectif.fromJson(e)).toList();
      return objectifs;
    } else {
      throw Exception('Failed to load objectifs');
    }
  }
}
