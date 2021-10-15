import 'dart:convert';

import 'package:knowme/models/user_model.dart';

class ChatRoomModel {
  int? id;
  final DateTime created_at;
  final int status;
  final UserModel user_a;
  final UserModel user_b;
  ChatRoomModel({
    required this.id,
    required this.created_at,
    required this.status,
    required this.user_a,
    required this.user_b,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': created_at.millisecondsSinceEpoch,
      'status': status,
      'user_a': user_a.toMap(),
      'user_b': user_b.toMap(),
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      id: map['id'],
      created_at: DateTime.parse(map['created_at']),
      status: map['status'],
      user_a: UserModel.fromMap(map['user_a']),
      user_b: UserModel.fromMap(map['user_b']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoomModel.fromJson(String source) => ChatRoomModel.fromMap(json.decode(source));
}
