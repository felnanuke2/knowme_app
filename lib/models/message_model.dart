import 'dart:convert';

class MessageModel {
  MessageModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.roomId,
    required this.type,
    required this.text,
    this.src,
    required this.createdBy,
    required this.status,
  });

  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int roomId;
  final int type;
  final String text;
  String? src;
  final String createdBy;
  final int status;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'roomId': roomId,
      'type': type,
      'text': text,
      'createdBy': createdBy,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
        id: map['id'] is int ? map['id'] : int.parse(map['id']),
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']),
        roomId: map['room_id'] is int ? map['room_id'] : int.parse(map['room_id']),
        type: map['type'],
        text: map['text'],
        createdBy: map['created_by'],
        status: map['status']);
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) => MessageModel.fromMap(json.decode(source));
}
