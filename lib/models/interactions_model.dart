import 'dart:convert';

class InteractionsModel {
  String id;

  /// 0 is await 1 is accepted and 2 is refused
  int status;
  String fromUser;
  String toUser;
  DateTime createdAt;
  DateTime? updatedAt;
  Map<String, String> answers;
  InteractionsModel({
    required this.id,
    required this.status,
    required this.fromUser,
    required this.toUser,
    required this.createdAt,
    this.updatedAt,
    required this.answers,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'fromUser': fromUser,
      'toUser': toUser,
      'answers': answers,
    };
  }

  factory InteractionsModel.fromMap(Map<String, dynamic> map) {
    return InteractionsModel(
      id: map['id'],
      status: map['status'],
      fromUser: map['fromUser'],
      toUser: map['toUser'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      answers: Map<String, String>.from(map['answers']),
    );
  }

  String toJson() => json.encode(toMap());

  factory InteractionsModel.fromJson(String source) =>
      InteractionsModel.fromMap(json.decode(source));
}
