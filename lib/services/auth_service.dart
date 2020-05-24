import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messangerapp/models/user_model.dart';

class AuthService {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserModel> findUser({String email, String phone}) async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection('users').getDocuments();
    UserModel user = snapshot.documents
        .map((DocumentSnapshot doc) => UserModel.fromMap(doc.data))
        .singleWhere((UserModel user) {
      if (email != null) {
        return email == user.email;
      } else if (phone != null) {
        return phone == user.phone;
      } else {
        return false;
      }
    }, orElse: () => null);
    return user;
  }

  Stream<List<UserModel>> allUsers() {
    return Firestore.instance.collection('users').snapshots().map(
        (QuerySnapshot querySnapshot) => querySnapshot.documents
            .map((DocumentSnapshot doc) => UserModel.fromMap(doc.data)));
  }

  Future<UserModel> currentUser() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    UserModel user;
    if (firebaseUser != null) {
      if (firebaseUser.email.isNotEmpty) {
        user = await findUser(email: firebaseUser.email);
      } else if (firebaseUser.phoneNumber.isNotEmpty) {
        user = await findUser(phone: firebaseUser.phoneNumber);
      }
    }
    return user;
  }

  Future<UserModel> loginWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser firebaseUser =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("signed in " + firebaseUser.displayName);
      UserModel user = await currentUser();
      if (user != null) {
        return user;
      } else {
        UserModel user = UserModel(
          id: firebaseUser.uid,
          name: firebaseUser.displayName,
          avatarUrl: firebaseUser.photoUrl,
          email: firebaseUser.email,
        );
        await saveUser(user);
        return user;
      }
    } catch (e, s) {
      print('loginWithGoogle error: $e, $s');
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel> signInWithEmail(String email, String password) async {
    FirebaseUser firebaseUser;
    try {
      firebaseUser = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on PlatformException catch (e, s) {
      print('signInWithEmail error: $e, $s');
      if (e.code == 'ERROR_WRONG_PASSWORD') {
        throw Exception("Invalid Password");
      }
      throw Exception(e.message);
    }
    if (firebaseUser != null) {
      print('Firebase user: $firebaseUser');
      UserModel user = await currentUser();
      if (user == null) {
        UserModel user = UserModel(
          id: firebaseUser.uid,
          avatarUrl: firebaseUser.photoUrl,
          email: firebaseUser.email,
        );
        await saveUser(user);
        return user;
      } else {
        return user;
      }
    } else {
      return Future.error('No user');
    }
  }

  Future<bool> saveUser(UserModel user) async {
    try {
      await Firestore.instance
          .collection('users')
          .document(user.id)
          .setData(user.toMap());
      return true;
    } catch (e, s) {
      print('saveUser: $e, $s');
      return false;
    }
  }

  Future<UserModel> signUpWithEmail(
    String email,
    String password,
    int age,
    String country,
    String name,
  ) async {
    FirebaseUser firebaseUser;
    try {
      firebaseUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on PlatformException catch (e, s) {
      print('signupWithEmail error: $e, $s');
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        throw Exception(
            "The email address is already in use by another account.");
      }
      throw Exception(e.message);
    }
    if (firebaseUser != null) {
      print('Firebase user: $firebaseUser');
      UserModel user = await currentUser();
      if (user == null) {
        UserModel user = UserModel(
            id: firebaseUser.uid,
            country: country,
            age: age,
            name: name,
            avatarUrl: firebaseUser.photoUrl,
            email: firebaseUser.email);
        await saveUser(user);
        return user;
      } else {
        return user;
      }
    } else {
      throw Exception("current is user is null");
    }
  }

  Future<bool> forgotPassword(String email) async {
    var auth = FirebaseAuth.instance;
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_NETWORK_REQUEST_FAILED') {
        throw Exception();
      } else if (e.code == 'ERROR_USER_NOT_FOUND') {
        throw Exception();
      } else {
        throw Exception(e.message);
      }
    } catch (ex) {
      throw Exception(ex.toString());
    }
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<UserModel> getUser() async {
    FirebaseUser currentUser = await _firebaseAuth.currentUser();
    UserModel user = UserModel(
      id: currentUser.uid,
      avatarUrl: currentUser.photoUrl,
      name: currentUser.displayName,
      email: currentUser.email,
    );
    return user;
  }
}
