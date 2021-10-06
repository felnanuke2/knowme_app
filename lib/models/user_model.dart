import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:knowme/constants/constant_hive_ids.dart';
part 'user_model.g.dart';

@HiveType(typeId: SEX_HIVE_ID)
enum Sex {
  @HiveField(0)
  NONE,
  @HiveField(1)
  MALE,
  @HiveField(2)
  FEMALE
}

enum AccountState {
  ACTIVE,
  BLOCK,
}

class SexFromString {
  Sex? call(String? type) {
    try {
      return Sex.values.firstWhere((element) => element.toString() == type.toString());
    } catch (e) {
      return null;
    }
  }
}

class AccountStateConvert {
  static AccountState fromString(String? value) {
    if (value == AccountState.BLOCK.toString()) return AccountState.BLOCK;
    return AccountState.ACTIVE;
  }
}

@HiveType(typeId: USER_HIVE_ID)
class UserModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? profileImage;
  @HiveField(2)
  String? bio;
  @HiveField(3)
  String? birthDay;
  @HiveField(4)
  String? completName;
  @HiveField(5)
  String? profileName;
  @HiveField(6)
  String? phoneNumber;
  @HiveField(7)
  String? uf;
  @HiveField(8)
  String? city;
  @HiveField(9)
  String? lat;
  @HiveField(10)
  String? lng;
  @HiveField(11)
  DateTime? createdAt;
  @HiveField(12)
  String? email;
  @HiveField(13)
  int? state;
  @HiveField(14)
  DateTime? updatedAt;
  @HiveField(15)
  Sex? sex;

  @HiveField(16)
  UserContactsModel? contacts;
  @HiveField(17)
  bool? emailConfirm;
  @HiveField(18)
  List<String>? postsList;
  @HiveField(19)
  String? entryQuizID;
  @HiveField(20)
  bool profileComplet;
  double? distance;
  UserModel(
      {this.id,
      this.profileImage,
      this.bio,
      this.birthDay,
      this.completName,
      this.profileName,
      this.uf,
      this.city,
      this.lat,
      this.lng,
      this.createdAt,
      this.email,
      this.state,
      this.updatedAt,
      this.sex,
      this.phoneNumber,
      this.emailConfirm,
      this.postsList,
      this.entryQuizID,
      this.profileComplet = false,
      this.distance});

  Map<String, dynamic> toMap() {
    final map = {
      'uid': id,
      'profileImage': profileImage,
      'bio': bio,
      'birthDay': birthDay,
      'completName': completName,
      'profileName': profileName,
      'state': 0,
      'sex': sex?.toString(),
    };
    if (entryQuizID != null) {
      map['entry_quiz'] = entryQuizID;
    }
    return map;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['uid'],
        profileImage: map['profileImage'],
        bio: map['bio'],
        birthDay: map['birthDay'],
        completName: map['completName'],
        profileName: map['profileName'],
        uf: map['uf'],
        city: map['city'],
        lat: map['lat'],
        lng: map['lng'],
        phoneNumber: map['phoneNumber'],
        createdAt:
            map['createdAt'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
        email: map['email'],
        state: map['state'],
        updatedAt:
            map['updatedAt'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
        sex: SexFromString().call(map['sex']),
        emailConfirm: map['emailConfirm'],
        postsList: List<String>.from(map['postsList'] ?? []),
        entryQuizID: map['entryQuizID'] == null ? null : map['entryQuizID'].toString(),
        distance: map['distance'] == null ? null : (map['distance'] as num).toDouble());
  }

  String toJson() => json.encode(toMap());
}

class UserContactsModel {
  String? email;
  String? facebook;
  String? linkedin;
  String? phone;
  String? telegram;
  UserContactsModel({
    this.email,
    this.facebook,
    this.linkedin,
    this.phone,
    this.telegram,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'facebook': facebook,
      'linkedin': linkedin,
      'phone': phone,
      'telegram': telegram,
    };
  }

  factory UserContactsModel.fromMap(Map<String, dynamic> map) {
    return UserContactsModel(
      email: map['email'],
      facebook: map['facebook'],
      linkedin: map['linkedin'],
      phone: map['phone'],
      telegram: map['telegram'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserContactsModel.fromJson(String source) =>
      UserContactsModel.fromMap(json.decode(source));
}
