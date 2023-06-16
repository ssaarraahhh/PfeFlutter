import 'dart:convert';

import 'package:StaffFlow/app/constants/constant.dart';
import 'package:http/http.dart';
import '../models/tasks.dart';
import 'package:http/http.dart' as http;

class apiTaches {
  String Url = "$URL/taches";
  Future<void> updatetache(int id, Task task) async {
    final Map<String, dynamic> data = {
      'id': id,
      'titre': task.titre,
      'description': task.description,
      'dateDebut': task.dateDebut.toIso8601String(),
      'dateFin': task.dateFin.toIso8601String(),
      'etat': task.etat,
      'idEmploye': task.idEmploye,
      'typeTache': task.typeTache,
      'frequence': task.frequence,
      'intervalle': task.intervalle,
      'periode': task.periode,
    };
    print(data);

    final Response response = await put(
      Uri.parse('$Url/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 204) {
      print("it was a success");
      // Return success message if response status code is 204
      return;
    } else {
      // Throw exception if response status code is not 204
      throw Exception('Failed to update task');
    }
  }
}
