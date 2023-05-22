import 'package:flutter/material.dart';

class Task {
  final int id;
  final String description;
  final String titre;
  final DateTime dateDebut;
  final DateTime dateFin;
  final int intervalle;
  final String frequence;
  final String typeTache;
  final String periode;
  String etat;
  final int idEmploye;

  Task({
    this.id,
    this.description,
    this.titre,
    this.dateDebut,
    this.dateFin,
    this.intervalle,
    this.frequence,
    this.periode,
    this.etat,
    this.typeTache,
    this.idEmploye,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        id: json["id"],
        description: json["description"],
        titre: json["titre"],
        dateDebut: DateTime.parse(json['dateDebut']),
        dateFin: DateTime.parse(json['dateFin']),
        intervalle: json["intervalle"],
        frequence: json["frequence"],
        periode: json["periode"],
        etat: json["etat"],
        typeTache: json["typeTache"],
        idEmploye: json["idEmploye"]);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'titre': titre,
        'dateDebut': dateDebut.toIso8601String(),
        'dateFin': dateFin.toIso8601String(),
        'intervalle': intervalle,
        'frequence': frequence,
        'periode': periode,
        'etat': etat,
        'typeTache': typeTache,
        'idEmploye': idEmploye,
      };

  String toString() => toJson().toString();
}
