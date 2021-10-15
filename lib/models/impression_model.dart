import 'dart:convert';

import 'package:knowme/models/user_model.dart';

class ImpressionModel {
  final String user_uid;
  final int impressions_id;
  final String profile_image;
  final int quiz_id;
  final Sex sex;
  final String profileName;
  ImpressionModel({
    required this.user_uid,
    required this.impressions_id,
    required this.profile_image,
    required this.quiz_id,
    required this.sex,
    required this.profileName,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_uid': user_uid,
      'impressions_id': impressions_id,
      'profile_image': profile_image,
      'quiz_id': quiz_id,
    };
  }

  factory ImpressionModel.fromMap(Map<String, dynamic> map) {
    return ImpressionModel(
      profileName: map['profile_name'],
      sex: SexFromString().call(map['sex'])!,
      user_uid: map['user_uid'],
      impressions_id: map['impressions_id'],
      profile_image: map['profile_image'],
      quiz_id: map['quiz_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ImpressionModel.fromJson(String source) => ImpressionModel.fromMap(json.decode(source));
}
