import 'package:StaffFlow/app/models/contrat.dart';
import 'package:StaffFlow/app/models/demandeCong%C3%A9.dart';
import 'package:StaffFlow/app/models/magasin.dart';
import 'package:StaffFlow/app/models/tasks.dart';

enum Erole { ouvrier, responsable }

class Employe {
  int id;
  String cin;
  String nom;
  String prenom;
  String dateNaissance;
  String fonction;
  String image;
  String adresse;
  String email;
  String numTel;
  List<Task> taches;
  List<Demandec> demandes;
  Contrat contrat;
 // int idContrat;
  Magasin magasin;
  int idMagasin;
  Erole role;
  String color;
  bool autorisation;
  String password;

  Employe(
      {this.id,
      this.cin,
      this.nom,
      this.prenom,
      this.dateNaissance,
      this.fonction,
      this.image,
      this.adresse,
      this.email,
      this.numTel,
      this.taches,
      this.demandes,
      this.contrat,
    //  this.idContrat,
      this.role,
      this.color,
      this.idMagasin,
      this.magasin,
      this.autorisation,
      this.password, idContrat});

  factory Employe.fromJson(Map<String, dynamic> json) {
    return Employe(
      id: json['id'],
      cin: json['cin'],
      nom: json['nom'],
      prenom: json['prenom'],
      dateNaissance: json['dateNaissance'],
      adresse: json["adresse"],
      email: json["email"],
      fonction: json["fonction"],
      image: json["image"],
      numTel: json["numTel"],
      idContrat: json["idContrat"],
      role: Erole.values[json['role']], // use a helper method to parse the role string
      color: json["color"],
      autorisation: json["autorisation"],
      password: json["password"],
      contrat:
          json['contrat'] != null ? Contrat.fromJson(json['contrat']) : null,
      taches: List<Task>.from(json['taches'].map((x) => Task.fromJson(x))),
      demandes: List<Demandec>.from(
          json['demandes'].map((x) => Demandec.fromJson(x))),
      magasin:
          json['magasin'] != null ? Magasin.fromJson(json['magasin']) : null,
      idMagasin: json['idMagasin'],
    );
  }
  static Erole _parseRole(String value) {
    switch (value) {
      case 'ouvrier':
        return Erole.ouvrier;
      case 'responsable':
        return Erole.responsable;
      default:
        throw ArgumentError('Invalid role value: $value');
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cin': cin,
        'nom': nom,
        'prenom': prenom,
        'dateNaissance': dateNaissance,
        'fonction': fonction,
        'image': image,
        'adresse': adresse,
        'email': email,
        'numTel': numTel,
        'taches': List<dynamic>.from(taches.map((x) => x.toJson())),
        'demandes': List<dynamic>.from(demandes.map((x) => x.toJson())),
        'contrat': contrat?.toJson(),
        // 'idContrat': idContrat,
        'magasin': magasin?.toJson(),
        'idMagasin': idMagasin,
        'role': role.index,
         'color': color,
         'autorisation': autorisation,
         'password': password,
        
      };

   String toString() {
    return 'Employe { id: $id, cin: $cin, nom: $nom, prenom: $prenom, dateNaissance: $dateNaissance, '
        'fonction: $fonction, image: $image, adresse: $adresse, email: $email, numTel: $numTel, '
        'taches: $taches, demandes: $demandes, contrat: $contrat, magasin: $magasin, '
        'idMagasin: $idMagasin, role: $role, color: $color, autorisation: $autorisation, password: $password }';
  }
}
