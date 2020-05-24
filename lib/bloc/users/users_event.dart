import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:messangerapp/models/user_model.dart';

abstract class UsersEvent extends Equatable {
  UsersEvent({List props = const []}) : super();
}

class LoadInitialUsersData extends UsersEvent {
  final String currentUserId;

  LoadInitialUsersData(this.currentUserId);

  @override
  List<Object> get props => null;
}

class UpdateUserList extends UsersEvent {
  final List<UserModel> users;

  UpdateUserList(this.users);

  @override
  List<Object> get props => <Object>[users];
}

class UpdateAccountInformation extends UsersEvent {
  final UserModel user;
  final File newAvatar;

  UpdateAccountInformation({this.user, this.newAvatar});

  @override
  List<Object> get props => <Object>[user, newAvatar];
}
