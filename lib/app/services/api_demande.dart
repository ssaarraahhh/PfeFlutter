import 'dart:convert';
import 'package:dronalms/app/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/demandeCongé.dart';

class ApiDemande {
  String apiUrl = '$URL/DemandeConges';

  Future<String> adddemande(Demandec demande, String justificatifUrl) async {
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
        "reponse": "en attente",
        "dateDebut": demande.dateDebut?.toIso8601String(),
        "dateFin": demande.dateFin?.toIso8601String(),
        "raison": demande.raison,
        "justificatif": justificatifUrl,
        "type": demande.type,
        "idEmploye": id
      };
      print(" \n demande.dateDebut \n");
      print(demande.dateDebut);
      print(demande.dateFin);
      print(demande.raison);
      print(justificatifUrl);
      print(demande.type);
      print(id);
      print(" \n demande.dateDebut \n");
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'content-type': 'application/json; charset=utf-8'},
          body: jsonEncode(jsonBody));
      if (response.statusCode == 201) {
        print("${response.statusCode} success");
        return "demande ajouté";
      } else {
        throw Exception('Failed ');
      }
    } catch (error) {
      print(error);
      return "Failed to add demande";
    }
  }

  Future<List<Demandec>> fetchDemandeByid(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final demandeJson = data as List<dynamic>;

      final demandes =
          demandeJson.map((json) => Demandec.fromJson(json)).toList();
      return demandes;
    } else {
      throw Exception('Failed to load demande');
    }
  }
}
