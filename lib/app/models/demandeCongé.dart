import 'dart:core';

import 'package:flutter/material.dart';

class Demandec {
  int id;
  String reponse;
  DateTime dateDebut;
  DateTime dateFin;
  String raison;
  String justificatif;
  String type;
  int idEmploye;

  Demandec({
    this.id,
    this.reponse,
    this.dateDebut,
    this.dateFin,
    this.raison,
    this.justificatif,
    this.type,
    this.idEmploye,
  });

  factory Demandec.fromJson(Map<String, dynamic> json) {
    return Demandec(
      id: json['id'],
      reponse: json['reponse'],
      dateDebut: DateTime.parse(json['dateDebut']),
      dateFin: DateTime.parse(json['dateFin']),
      raison: json['raison'],
      justificatif: json['justificatif'],
      type: json['type'],
      idEmploye: json['idEmploye'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'reponse': reponse,
        'dateDebut': dateDebut?.toIso8601String(),
        'dateFin': dateFin?.toIso8601String(),
        'raison': raison,
        'justificatif': justificatif,
        'type': type,
        'idEmploye': idEmploye,
      };

  @override
  String toString() => toJson().toString();
}
