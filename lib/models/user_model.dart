enum Sex { NONE, MALE, FEMALE }
enum SocialType { VK, OK, FB, GOOGLE, LINKEDIN, TWITTER }
enum AccountState { ACTIVE, BLOCK }

class UserModel {
  final String id;
  final String? profileImage;
  final String? bio;
  final String? birthDay;
  final String completName;
  final String profileName;
  final String? uf;
  final String? city;
  final String? lat;
  final String? lng;
  final List<String> followMe;
  final List<String> follow;
  final DateTime createdAt;
  final String email;
  final AccountState state;
  final DateTime? updatedAt;
  final Sex sex;
  final List<String> sendIteractions;
  final List<String> receivedInteractions;
  final UserContactsModel contacts;
  final bool emailConfirm;
  final List<String> postsList;
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
  final String? email;
  final String? facebook;
  final String? linkedin;
  final String? phone;
  final String? telegram;
  UserContactsModel({
    this.email,
    this.facebook,
    this.linkedin,
    this.phone,
    this.telegram,
  });
}
