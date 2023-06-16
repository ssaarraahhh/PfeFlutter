import 'package:StaffFlow/app/models/formation.dart';

class Categorie {
  int id;
  String nom;
  String photo;
  List<Formation1> formations;

  Categorie({this.id, this.nom, this.photo, this.formations});

  factory Categorie.fromJson(Map<String, dynamic> json) {
    List<Formation1> formations = [];
    if (json['formations'] != null) {
      formations = List<Formation1>.from(
          json['formations'].map((x) => Formation1.fromJson(x)));
    }
    return Categorie(
      id: json['id'],
      nom: json['nom'],
      photo: json['photo'],
      formations: formations,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'photo': photo,
        'formations': List<dynamic>.from(formations.map((x) => x.toJson())),
      };
  @override
  String toString() {
    return 'Categorie{id: $id, nom: $nom, photo: $photo, formations: $formations}';
  }
}
