import 'dart:convert';
import 'package:knowme/models/user_model.dart';

class PostModel {
  UserModel? userModel;
  String id;
  String postedBy;

  ///0 for videos and 1 for image
  int mediaType;
  String src;
  List<String> viewedBy;
  String description;
  DateTime createAt;
  String? thumbnail;
  DateTime? updateAt;

  PostModel(
      {required this.id,
      required this.postedBy,
      required this.mediaType,
      required this.src,
      required this.viewedBy,
      required this.description,
      required this.createAt,
      this.updateAt,
      this.thumbnail});

  Map<String, dynamic> toMap() {
    return {
      'posted_by': postedBy,
      'media_type': mediaType,
      'src': src,
      'description': description,
      'thumbnail': thumbnail
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
        id: map['id'].toString(),
        postedBy: map['posted_by'],
        mediaType: map['media_type'],
        src: map['src'],
        viewedBy: List<String>.from(map['viewed_by'] ?? []),
        description: map['description'],
        createAt: DateTime.parse(map['created_at']),
        updateAt: map['update_at'] == null ? null : DateTime.parse(map['updated_at']),
        thumbnail: map['thumbnail']);
  }

  String toJson() => json.encode(toMap());
}
