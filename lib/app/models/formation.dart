class Formation1 {
  int id;
  String nom;
  String description;
  DateTime dateDepot;
  String fichier;
  String formation;

  int idCategorie;
  
  

  Formation1(
      {this.id,
      this.nom,
      this.description,
      this.dateDepot,
      this.fichier,
      this.formation,
      this.idCategorie});

  factory Formation1.fromJson(Map<String, dynamic> json) {
    return Formation1(
        id: json['id'],
        nom: json['nom'],
        description: json['description'],
        dateDepot: json['dateDepot'] != null
            ? DateTime.parse(json['dateDepot'])
            : null,
        fichier: json['fichier'],
        formation: json['formation'],
        idCategorie: json['idCategorie']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'description': description,
        'dateDepot': dateDepot?.toIso8601String(),
        'fichier': fichier,
        'formation': formation,
        'idCategorie': idCategorie
      };
  @override
  String toString() {
    return 'Formation{id: $id, nom: $nom, description: $description, dateDepot: $dateDepot, fichier: $fichier, formation: $formation, idCategorie: $idCategorie}';
  }
}
