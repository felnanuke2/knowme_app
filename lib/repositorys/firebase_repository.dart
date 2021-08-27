import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:knowme/constants/firebase_collections.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/models/entry_quiz_model.dart';
import 'package:http/http.dart' as http;

class FirebaseRepository implements DbRepositoryInterface {
  @override
  Future<Uint8List?> getImageBytesFromURL({required String url}) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) return response.bodyBytes;
    return null;
  }

  @override
  Future<String?> createUser(UserModel userModel) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection(FirebaseCollections.USERS)
          .doc(userModel.id)
          .set(userModel.toMap());
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  @override
  Future<String?> createQuiz(EntryQuizModel entryQuizModel, UserModel userModel,
      {String? quizId}) async {
    final map = entryQuizModel.toMap();
    if (quizId != null) map.remove('answeredBy');
    try {
      String quizID = '';
      if (quizId == null) {
        var ref = FirebaseFirestore.instance.collection(FirebaseCollections.ENTRY_QUIZ).doc(quizId);
        await ref.set(map);
        quizID = ref.id;
      } else {
        var ref = FirebaseFirestore.instance.collection(FirebaseCollections.ENTRY_QUIZ).doc(quizId);

        ref.update(map);
        quizID = ref.id;
      }
      userModel.entryQuizID = quizID;
      updateUser(userModel);
    } catch (e) {}
  }

  @override
  Future<String?> deletImage(String imageUrl) async {
    try {
      FirebaseStorage.instance.refFromURL(imageUrl).delete();
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  @override
  Future<EntryQuizModel?> getQuiz(String quizId) async {
    var response = await FirebaseFirestore.instance
        .collection(FirebaseCollections.ENTRY_QUIZ)
        .doc(quizId)
        .get();
    return EntryQuizModel.fromMap(response.data()!, response.id);
  }

  @override
  Future<UserModel?> getUserCurrentUser(String id) async {
    // try {
    var response =
        await FirebaseFirestore.instance.collection(FirebaseCollections.USERS).doc(id).get();
    if (response.exists) return UserModel.fromMap(response.data()!);
    // } catch (e) {
    //   print(e.toString());
    // }
    return null;
  }

  @override
  Future<String?> upLoadImage({required Uint8List imageByte, required String userID}) async {
    try {
      final reference = FirebaseStorage.instance.ref('/$userID/profile/${DateTime.now()}');
      await reference.putData(imageByte, SettableMetadata(contentType: 'image/png'));
      return await reference.getDownloadURL();
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  @override
  Future<String?> updateQuiz(EntryQuizModel entryQuizModel) {
    // TODO: implement updateQuiz
    throw UnimplementedError();
  }

  @override
  Future<String?> updateUser(UserModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollections.USERS)
          .doc(user.id)
          .update(user.toMap());
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
