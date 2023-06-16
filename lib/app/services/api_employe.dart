import 'dart:convert';

import 'package:StaffFlow/app/constants/constant.dart';
import 'package:StaffFlow/app/models/contrat.dart';
import 'package:StaffFlow/app/models/demandeCong%C3%A9.dart';
import 'package:StaffFlow/app/models/employe.dart';
import 'package:StaffFlow/app/models/login.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import '../models/tasks.dart';

class ApiEmploye {
  String Url = "$URL/Employes";


  Future<List<Task>> fetchtasks() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);

    final Map<String, dynamic> decodedToken = json.decode(
        ascii.decode(base64.decode(base64.normalize(token.split(".")[1]))));

    print(decodedToken);
    final String sid = decodedToken[
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid'];
    print(sid);
    int id = int.parse(sid);

    final response = await http.get(Uri.parse('$Url/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final tachesJson = data['taches'] as List<dynamic>;
      print(tachesJson);
      final taches = tachesJson.map((json) => Task.fromJson(json)).toList();
      print(taches);
      return taches;
    } else {
      throw Exception('Failed to load taches');
    }
  }

  Future<Employe> fetchEmployeById() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);

    final Map<String, dynamic> decodedToken = json.decode(
        ascii.decode(base64.decode(base64.normalize(token.split(".")[1]))));

    print(decodedToken);
    final String sid = decodedToken[
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid'];
    print(sid);
    int id = int.parse(sid);

    final response = await http.get(Uri.parse('$Url/$id'));
    if (response.statusCode == 200) {
      print("jee l emp");
      print(response);
      print(Employe.fromJson(json.decode(response.body)));

      return Employe.fromJson(json.decode(response.body));
    } else {
      print("sorry dear");
      return null;
    }
  }







Future<Employe> fetchEmployeById1(int id) async {
    
    final response = await http.get(Uri.parse('$Url/$id'));
    if (response.statusCode == 200) {
      print("jee l emp");
      print(response);
      print(Employe.fromJson(json.decode(response.body)));

      return Employe.fromJson(json.decode(response.body));
    } else {
      print("sorry dear");
      return null;
    }
  }


  Future<void> login(Login login) async {
    final url = Uri.parse('$Url/login');
    final headers = {'Content-Type': 'application/json', 'accept': '*/*'};
    final jsonBody = {"email": login.email, "password": login.password};
    print(login.email);
    try {
      final response =
          await http.post(url, headers: headers, body: jsonEncode(jsonBody));
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', jsonEncode(responseBody.toString()));
        print(responseBody); //convert responseBody to JSON string
        // Do something with the response body
      } else {
        print("Something went wrong. Status code: ${response.statusCode}");
        // Handle the error
      }
    } catch (error) {
      print("Error occurred: $error");
      // Handle the error
    }
  }

  Future<List<Demandec>> fetchDemande() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);

    final Map<String, dynamic> decodedToken = json.decode(
        ascii.decode(base64.decode(base64.normalize(token.split(".")[1]))));

    print(decodedToken);
    final String sid = decodedToken[
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid'];
    print(sid);
    int id = int.parse(sid);

    final response = await http.get(Uri.parse('$Url/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final demandeJson = data['demandes'] as List<dynamic>;

      final demandes =
          demandeJson.map((json) => Demandec.fromJson(json)).toList();
      return demandes;
    } else {
      throw Exception('Failed to load taches');
    }
  }

  Future<Contrat> fetchContrat() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);

    final Map<String, dynamic> decodedToken = json.decode(
        ascii.decode(base64.decode(base64.normalize(token.split(".")[1]))));

    print(decodedToken);
    final String sid = decodedToken[
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid'];
    print(sid);
    int id = int.parse(sid);
    final response = await http.get(Uri.parse('$Url/$id'));
    print("eeee");
    if (response.statusCode == 200) {
      print(response.statusCode);
      final data = jsonDecode(response.body);
      print(data);
      final contratJson = data['contrat'];
      print("aaaaaaaaaa$contratJson");
      final contrat = Contrat.fromJson(contratJson);
      print(contrat);
      return contrat;
    } else {
      throw Exception('Failed to load contrat');
    }
  }

  Future<String> updateEmploye(Employe employe) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print(token);

      final Map<String, dynamic> decodedToken = json.decode(
          ascii.decode(base64.decode(base64.normalize(token.split(".")[1]))));

      print(decodedToken);
      final String sid = decodedToken[
          'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid'];
      print(sid);
      int id = int.parse(sid);

      Map jsonBody = {
        'id': employe.id,
        'cin': employe.cin,
        'nom': employe.nom,
        'prenom': employe.prenom,
        'dateNaissance': employe.dateNaissance,
        'adresse': employe.adresse,
        'email': employe.email,
        'fonction': employe.fonction,
        'image': employe.image,
        'numTel': employe.numTel,
        'contrat': employe.contrat,
        'taches': employe.taches,
        'demandes': employe.demandes,
        'magasin': employe.magasin,
        'idMagasin': employe.idMagasin,
        'role': employe.role.index,
        // 'idContrat': employe.idContrat,
        "color": employe.color,
        'autorisation': employe.autorisation,
        'password': employe.password
      };

      print(employe.id);
      print(employe.password);
      print(employe.image);
      final response = await http.put(Uri.parse("$Url/$id"),
          headers: {'content-type': 'application/json; charset=utf-8'},
          body: jsonEncode(jsonBody));
      print(response.statusCode);
      if (response.statusCode == 204) {
        print("${response.statusCode} pppp2");
        return "updated succesfulyy";
      } else {
        throw Exception('Failed ');
      }
    } catch (e) {
      // Handle any exceptions that might occur during the request.
      print('An error occurred: $e');
      return 'Failed to update employe: $e';
    }
  }

  Future<String> putEmploye(Employe employe, bool change) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print(token);

      final Map<String, dynamic> decodedToken = json.decode(
          ascii.decode(base64.decode(base64.normalize(token.split(".")[1]))));

      print(decodedToken);
      final String sid = decodedToken[
          'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid'];
      print(sid);
      int id = int.parse(sid);
      Map<String, dynamic> jsonBody = {
        'id': employe.id,
        'cin': employe.cin,
        'nom': employe.nom,
        'prenom': employe.prenom,
        'dateNaissance': employe.dateNaissance,
        'adresse': employe.adresse,
        'email': employe.email,
        'fonction': employe.fonction,
        'image': employe.image,
        'numTel': employe.numTel,
        'contrat': employe.contrat,
        'taches': employe.taches,
        'demandes': employe.demandes,
        'magasin': employe.magasin,
        'idMagasin': employe.idMagasin,
        'role': employe.role.index,
        "color": employe.color,
        'autorisation': employe.autorisation,
        'password': employe.password
      };

      print(employe.id);
      print(employe.password);
      print(employe.image);
      String url = "$Url/$id?change=${change.toString()}";
      final response = await http.put(
        Uri.parse(url),
        headers: {'content-type': 'application/json; charset=utf-8'},
        body: jsonEncode(jsonBody),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print("${response.statusCode} pppp2");
        return "updated successfully";
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      // Handle any exceptions that might occur during the request.
      print('An error occurred: $e');
      return 'Failed to update employe: $e';
    }
  }

  Future<bool> testPassword(int id, String password) async {
    final url = Uri.parse('$Url/test');
    final body = jsonEncode({'id': id, 'pass': password});
    final response = await http.post(
      url,
      body: body,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final bol = jsonResponse['bol'];
      print(bol);
      return bol;
    } else {
      throw Exception(
          'Failed to test password. Status code: ${response.statusCode}');
    }
  }
}
