enum Sex { NONE, MALE, FEMALE }
enum SocialType { VK, OK, FB, GOOGLE, LINKEDIN, TWITTER }
enum AccountState { ACTIVE, BLOCK }

class UserModel {
  String id;
  String? profileImage;
  String? bio;
  String? birthDay;
  String completName;
  String profileName;
  String? uf;
  String? city;
  String? lat;
  String? lng;
  List<String> followMe;
  List<String> follow;
  DateTime createdAt;
  String email;
  AccountState state;
  DateTime? updatedAt;
  Sex sex;
  List<String> sendIteractions;
  List<String> receivedInteractions;
  UserContactsModel contacts;
  bool emailConfirm;
  List<String> postsList;
  String? entryQuizID;
  UserModel({
    required this.id,
    this.profileImage,
    this.bio,
    this.birthDay,
    required this.completName,
    required this.profileName,
    this.uf,
    this.city,
    this.lat,
    this.lng,
    required this.followMe,
    required this.follow,
    required this.createdAt,
    required this.email,
    required this.state,
    this.updatedAt,
    this.entryQuizID,
    required this.sex,
    required this.sendIteractions,
    required this.receivedInteractions,
    required this.contacts,
    required this.emailConfirm,
    required this.postsList,
  });
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
}
