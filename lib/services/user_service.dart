import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:messangerapp/models/user_model.dart';
import 'package:path/path.dart';

class UsersService {
  final CollectionReference userInstance =
      Firestore.instance.collection('users');

  Stream<List<UserModel>> users() {
    return userInstance.snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.documents.map((DocumentSnapshot doc) {
        UserModel user = UserModel.fromMap(doc.data);
        return user.copyWith(id: doc.documentID);
      }).toList();
    });
  }

  Future updateAccountInfo(UserModel user, String userId, File avatar) async {
    String userAvatar = user.avatarUrl;
    if (avatar != null) {
      String fileName = '${DateTime.now().millisecond}${basename(avatar.path)}';
      StorageReference ref = FirebaseStorage.instance.ref().child('avatars');
      await ref.child(userAvatar).delete();
      await ref.child(fileName).putFile(avatar).onComplete;
      userAvatar = fileName;
    }
    user.avatarUrl = userAvatar;
    return userInstance.document(userId).updateData(user.toMap());
  }
}
