import 'package:dronalms/app/models/objectif.dart';

import 'employe.dart';

class Magasin {
  final int id;
  final String nom;
  final String lieu;
  final String ouverture;
  final String fermeture;
  final String image;

  final List<Employe> employes;
  final List<Objectif> objectifs;

  Magasin(
      {this.id,
      this.nom,
      this.lieu,
      this.ouverture,
      this.fermeture,
      this.image,
      this.employes,
      this.objectifs});

  factory Magasin.fromJson(Map<String, dynamic> json) {
    return Magasin(
      id: json['id'],
      nom: json['nom'],
      lieu: json['lieu'],
      ouverture: json['ouverture'],
      fermeture: json['fermeture'],
      image: json['image'],
      // employes:
      //     List<Employe>.from(json['Employes'].map((x) => Employe.fromJson(x))),
      // objectifs: List<Objectif>.from(
      //     json['Objectifs'].map((x) => Objectif.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'lieu': lieu,
      'ouverture': ouverture,
      'fermeture': fermeture,
      'image': image,
      //'Employes': employes?.map((e) => e.toJson()).toList(),
      // 'Objectifs': objectifs?.map((o) => o.toJson()).toList(),
    };
  }

  @override
  String toString() => toJson().toString();
}
