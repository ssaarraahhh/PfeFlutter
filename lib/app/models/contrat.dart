class Contrat {
  int id;
  String type;
  DateTime dateDebut;
  DateTime dateFin;
  double soldeConge;
  int idEmploye;

  Contrat({
    this.id,
    this.type,
    this.dateDebut,
    this.dateFin,
    this.soldeConge,
    this.idEmploye,
  });

  factory Contrat.fromJson(Map<String, dynamic> json) {
    return Contrat(
      id: json['id'],
      type: json['type'],
      dateDebut: DateTime.parse(json['dateDebut']),
      dateFin: DateTime.parse(json['dateFin']),
      soldeConge: json['soldeConge'].toDouble(),
      idEmploye: json['idEmploye'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'dateDebut': dateDebut?.toIso8601String(),
        'dateFin': dateFin?.toIso8601String(),
        'soldeConge': soldeConge,
        'idEmploye': idEmploye,
      };
  @override
  String toString() => toJson().toString();
}
