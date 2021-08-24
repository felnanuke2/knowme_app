import 'dart:convert';

class UfModel {
  String sigla;
  String nome;
  List<String> cidades;
  UfModel({
    required this.sigla,
    required this.nome,
    required this.cidades,
  });

  Map<String, dynamic> toMap() {
    return {
      'sigla': sigla,
      'nome': nome,
    };
  }

  factory UfModel.fromMap(Map<String, dynamic> map) {
    return UfModel(
      sigla: map['sigla'],
      nome: map['nome'],
      cidades: List<String>.from(map['cidades']),
    );
  }
}
