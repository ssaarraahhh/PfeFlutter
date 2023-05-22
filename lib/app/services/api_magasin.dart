import 'dart:convert';
import 'package:dronalms/app/constants/constant.dart';
import 'package:dronalms/app/models/magasin.dart';
import 'package:http/http.dart' as http;

class ApiMagasin {
  String Url = "$URL/Magasins";
  Future<Magasin> fetchmagasinById(int id) async {
    final response = await http.get(Uri.parse('$Url/$id'));
    if (response.statusCode == 200) {
      print(Magasin.fromJson(json.decode(response.body)));
      return Magasin.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }
}
