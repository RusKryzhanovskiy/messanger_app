import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String displayName;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String phoneNumber;
  final String photoUrl;
  final String uid;

  const User({
    this.displayName,
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.phoneNumber,
    this.photoUrl,
    this.uid,
  });

  factory User.fromFirebaseUser(FirebaseUser firebaseUser) {
    String firstName = firebaseUser?.displayName?.split(' ')?.first;
    String lastName = firebaseUser?.displayName?.split(' ')?.last;
    String username = firebaseUser?.email?.split('@')?.first;

    return User(
      displayName: firebaseUser.displayName,
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: firebaseUser.email,
      phoneNumber: firebaseUser.phoneNumber,
      photoUrl: firebaseUser.photoUrl,
      uid: firebaseUser.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': this.displayName,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'email': this.email,
      'username': this.username,
      'phoneNumber': this.phoneNumber,
      'photoUrl': this.photoUrl,
      'uid': this.uid,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return new User(
      displayName: map['displayName'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      phoneNumber: map['phoneNumber'] as String,
      photoUrl: map['photoUrl'] as String,
      uid: map['uid'] as String,
    );
  }
}
