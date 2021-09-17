import 'dart:convert';

import 'package:knowme/models/user_model.dart';

class InteractionsModel {
  String id;

  /// 0 is await 1 is accepted and 2 is refused
  int status;
  String fromUser;
  String toUser;
  DateTime createdAt;
  DateTime? updatedAt;
  Map<String, String> answers;
  UserModel? user;
  InteractionsModel({
    required this.id,
    required this.status,
    required this.fromUser,
    required this.toUser,
    required this.createdAt,
    this.updatedAt,
    this.user,
    required this.answers,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'from_user': fromUser,
      'to_user': toUser,
      'answers': answers,
    };
  }

  factory InteractionsModel.fromMap(Map<String, dynamic> map) {
    return InteractionsModel(
        id: map['id'].toString(),
        status: map['status'],
        fromUser: map['from_user'],
        toUser: map['to_user'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.tryParse(map['updated_at']),
        answers: Map<String, String>.from(map['answers']),
        user: map['users'] == null ? null : UserModel.fromMap(map['users']));
  }

  String toJson() => json.encode(toMap());

  factory InteractionsModel.fromJson(String source) =>
      InteractionsModel.fromMap(json.decode(source));
}
