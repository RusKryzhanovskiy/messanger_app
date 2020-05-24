import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:common_lib/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:messangerapp/models/user_model.dart';

class AuthProvider {
  GoogleSignIn _googleSignIn;
  FirebaseAuth _auth;

  AuthProvider({GoogleSignIn googleSignIn, FirebaseAuth auth}) {
    this._googleSignIn = googleSignIn ?? GoogleSignIn();
    this._auth = auth ?? FirebaseAuth.instance;
  }

  Future<User> signUpWithEmailAndPassword(String email, String password) async {
    FirebaseUser firebaseUser = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    print('signUpWithEmailAndPassword Firebase user: $firebaseUser');

    User user = await getUserFromFirestore(firebaseUser.uid);
    if (user == null) {
      await saveUserToFirestore(User.fromFirebaseUser(firebaseUser));
      return User.fromFirebaseUser(firebaseUser);
    }
    return user;
  }

  Future<User> loginWithEmailAndPassword(String email, String password) async {
    FirebaseUser firebaseUser;
    try {
      firebaseUser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print('loginWithEmailAndPassword Firebase user: $firebaseUser');
      User user = await getUserFromFirestore(firebaseUser.uid);
      if (user == null) {
        await saveUserToFirestore(User.fromFirebaseUser(firebaseUser));
        user = await getUserFromFirestore(firebaseUser.uid);
      }
      return user;
    } catch (e, stacktrace) {
      print('loginWithEmailAndPassword: error: $e, stacktrace: $stacktrace');
      return Future.error(e);
    }
  }

  Future<User> loginWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser firebaseUser =
          await _auth.signInWithCredential(credential);
      print('Firebase user: $firebaseUser');
      User user = await getUserFromFirestore(firebaseUser.uid);
      if (user == null) {
        await saveUserToFirestore(User.fromFirebaseUser(firebaseUser));
        user = await getUserFromFirestore(firebaseUser.uid);
      }
      return user;
    } catch (e, stacktrace) {
      print('loginWithGoogle: error: $e, stacktrace: $stacktrace');
      return Future.error(e);
    }
  }

//  Future<User> loginWithFacebook() async {
//    final FirebaseAuth auth = FirebaseAuth.instance;
//    final FacebookLogin facebookLogin = FacebookLogin();
//    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
//    final FacebookLoginResult result = await facebookLogin.logIn(['email']);
//    print('Facebook login result: ${result.status}');
//    switch (result.status) {
//      case FacebookLoginStatus.loggedIn:
//        {
//          try {
//            final AuthCredential credential =
//                FacebookAuthProvider.getCredential(
//                    accessToken: result.accessToken.token);
//
//            FirebaseUser firebaseUser;
//            try {
//              firebaseUser = (await auth.signInWithCredential(credential)).user;
//              print('Firebase user: $firebaseUser');
//            } on PlatformException catch (e) {
//              print('ERROR!! $e');
//              return Future.error(e.message);
//            }
//            String accessToken = result.accessToken.token;
//            var graphResponse = await http.get(
//                'https://graph.facebook.com/v3.3/me?fields=id,name,first_name,'
//                'last_name,email,picture&access_token=$accessToken');
//            var profile = json.decode(graphResponse.body);
//            print('facebook profile: $profile');
//            User user = await getUserFromFirestore(firebaseUser.uid);
//            if (user == null) {
//              await saveUserToFirestore(User.fromFirebaseUser(firebaseUser));
//              user = await getUserFromFirestore(firebaseUser.uid);
//            }
//            return user;
//          } catch (e, stacktrace) {
//            print('loginWithFacebook: error: $e, stacktrace: $stacktrace');
//            return Future.error(e);
//          }
//        }
//        break;
//      case FacebookLoginStatus.error:
//        return Future.error(result.errorMessage);
//      case FacebookLoginStatus.cancelledByUser:
//        await facebookLogin.logOut();
//        break;
//    }
//
//    return Future.error('Unknown error');
//  }

  Future logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e, stacktrace) {
      print('logout: error: $e, stacktrace: $stacktrace');
      return Future.error(e);
    }
  }

  Future saveUserToFirestore(User user) {
    try {
      return Firestore.instance
          .collection('users')
          .document(user.uid)
          .setData(user.toMap());
    } catch (e, stacktrace) {
      print('saveUserToFirestore: error: $e, stacktrace: $stacktrace');
      return Future.error(e);
    }
  }

  Future<User> getUserFromFirestore(String firebaseUid) async {
    DocumentSnapshot doc = await Firestore.instance
        .collection('users')
        .document(firebaseUid)
        .get();
    if (doc.data == null) return null;
    return User.fromMap(doc.data);
  }
}
