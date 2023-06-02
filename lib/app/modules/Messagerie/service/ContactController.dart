import 'dart:convert';
import 'package:dronalms/app/models/employe.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ContactController extends GetxController{
  static List<Employe> user  ;


  Future<List<Employe>> getAllUsers() async {
    final response = await http.get(Uri.parse('https://10.0.2.2:7062/User'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      final users = data.map((json) => Employe.fromJson(json)).toList();

      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

}