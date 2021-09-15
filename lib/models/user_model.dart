import 'dart:convert';

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
  DateTime? createdAt;
  String? email;
  AccountState? state;
  DateTime? updatedAt;
  Sex? sex;

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
    this.createdAt,
    this.email,
    this.state,
    this.updatedAt,
    this.sex,
    this.phoneNumber,
    this.emailConfirm,
    this.postsList,
    this.entryQuizID,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'uid': id,
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
      'email': email,
      'state': 0,
      'sex': sex?.toString(),
    };
    if (entryQuizID != null) {
      map['entryQuizID'] = entryQuizID;
    }
    return map;
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
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
      state: AccountStateConvert.fromString(map['state']),
      updatedAt:
          map['updatedAt'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      sex: SexFromString().call(map['sex']),
      emailConfirm: map['emailConfirm'],
      postsList: List<String>.from(map['postsList'] ?? []),
      entryQuizID: map['entryQuizID'],
    );
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
