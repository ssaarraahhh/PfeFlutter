class Objectif {
  int id;
  String but;
  DateTime dateDebut;
  DateTime dateFin;
  int idMagasin;

  Objectif({
     this.id,
     this.but,
     this.dateDebut,
     this.dateFin,
     this.idMagasin,
  });

  factory Objectif.fromJson(Map<String, dynamic> json) {
    return Objectif(
      id: json['id'],
      but: json['but'],
      dateDebut: DateTime.parse(json['dateDebut']),
      dateFin: DateTime.parse(json['dateFin']),
      idMagasin: json['idMagasin'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'but': but,
        'dateDebut': dateDebut.toIso8601String(),
        'dateFin': dateFin.toIso8601String(),
        'idMagasin': idMagasin
      };

  @override
  String toString() => toJson().toString();
}
