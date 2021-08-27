import 'dart:convert';

import 'package:flutter/foundation.dart';

enum Sex { NONE, MALE, FEMALE }

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

class UserModel {
  String? id;
  String? profileImage;
  String? bio;
  String? birthDay;
  String? completName;
  String? profileName;
  String? phoneNumber;
  String? uf;
  String? city;
  String? lat;
  String? lng;
  List<String>? followMe;
  List<String>? follow;
  DateTime? createdAt;
  String? email;
  AccountState? state;
  DateTime? updatedAt;
  Sex? sex;
  List<String>? sendIteractions;
  List<String>? receivedInteractions;
  UserContactsModel? contacts;
  bool? emailConfirm;
  List<String>? postsList;
  String? entryQuizID;
  bool profileComplet = true;
  UserModel({
    this.id,
    this.profileImage,
    this.bio,
    this.birthDay,
    this.completName,
    this.profileName,
    this.uf,
    this.city,
    this.lat,
    this.lng,
    this.followMe,
    this.follow,
    this.createdAt,
    this.email,
    this.state,
    this.updatedAt,
    this.sex,
    this.phoneNumber,
    this.sendIteractions,
    this.receivedInteractions,
    this.contacts,
    this.emailConfirm,
    this.postsList,
    this.entryQuizID,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profileImage': profileImage,
      'bio': bio,
      'birthDay': birthDay,
      'phoneNumber': phoneNumber,
      'completName': completName,
      'profileName': profileName,
      'uf': uf,
      'city': city,
      'lat': lat,
      'lng': lng,
      'followMe': followMe,
      'follow': follow,
      'createdAt': createdAt?.millisecond,
      'email': email,
      'state': state?.toString(),
      'updatedAt': updatedAt?.toString(),
      'sex': sex?.toString(),
      'sendIteractions': sendIteractions,
      'receivedInteractions': receivedInteractions,
      'contacts': contacts?.toMap(),
      'emailConfirm': emailConfirm,
      'postsList': postsList,
      'entryQuizID': entryQuizID,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
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
      followMe: List<String>.from(map['followMe'] ?? []),
      follow: List<String>.from(map['follow'] ?? []),
      createdAt:
          map['createdAt'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      email: map['email'],
      state: AccountStateConvert.fromString(map['state']),
      updatedAt:
          map['updatedAt'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      sex: SexFromString().call(map['sex']),
      sendIteractions: List<String>.from(map['sendIteractions'] ?? []),
      receivedInteractions: List<String>.from(map['receivedInteractions'] ?? []),
      contacts: UserContactsModel.fromMap(map['contacts'] ?? {}),
      emailConfirm: map['emailConfirm'],
      postsList: List<String>.from(map['postsList'] ?? []),
      entryQuizID: map['entryQuizID'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
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
