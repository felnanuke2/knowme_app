import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String id;
  String postedBy;

  ///0 for videos and 1 for image
  int mediaType;
  String src;
  List<String> viewedBy;
  String description;
  DateTime createAt;
  DateTime? updateAt;

  PostModel({
    required this.id,
    required this.postedBy,
    required this.mediaType,
    required this.src,
    required this.viewedBy,
    required this.description,
    required this.createAt,
    this.updateAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postedBy': postedBy,
      'mediaType': mediaType,
      'src': src,
      'viewedBy': viewedBy,
      'description': description,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map, String id) {
    return PostModel(
      id: map['id'],
      postedBy: map['postedBy'],
      mediaType: map['mediaType'],
      src: map['src'],
      viewedBy: List<String>.from(map['viewedBy']),
      description: map['description'],
      createAt: (map['createAt'] as Timestamp).toDate(),
      updateAt: map['updateAt'] == null ? null : (map['updateAt'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());
}
