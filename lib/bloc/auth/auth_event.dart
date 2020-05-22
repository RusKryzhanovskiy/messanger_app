import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthEvent extends Equatable {}

class CheckAuthenticationEvent extends AuthEvent {
  @override
  List<Object> get props => null;
}

class LoginEvent extends AuthEvent {
  final String login;
  final String password;

  LoginEvent({
    @required this.login,
    @required this.password,
  });

  @override
  List<Object> get props => [login, password];
}

class SignInEvent extends AuthEvent {
  final String login;
  final String password;
  final String mail;
  final int age;
  final String country;

  SignInEvent({
    @required this.login,
    @required this.password,
    @required this.mail,
    @required this.age,
    @required this.country,
  });

  @override
  List<Object> get props => [login, password, mail, age, country];
}
