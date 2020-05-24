import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:messangerapp/bloc/users/users_event.dart';
import 'package:messangerapp/bloc/users/users_state.dart';
import 'package:messangerapp/models/user_model.dart';
import 'package:messangerapp/services/user_service.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersService _usersApiService = UsersService();
  StreamSubscription usersSubscription;

  @override
  UsersState get initialState => UsersState();

  @override
  Stream<UsersState> mapEventToState(UsersEvent event) async* {
    if (event is LoadInitialUsersData) {
      yield* _loadData(event.currentUserId);
    } else if (event is UpdateUserList) {
      yield state.copyWith(users: event.users, isLoading: false);
    } else if (event is UpdateAccountInformation) {
      yield* _updateUserInfo(event.user, event.newAvatar);
    }
  }

  Stream<UsersState> _loadData(String currentUserId) async* {
    yield state.copyWith(isLoading: true, currentUserId: currentUserId);

    try {
      usersSubscription?.cancel();
      usersSubscription =
          _usersApiService.users().listen((List<UserModel> users) {
        add(UpdateUserList(users));
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Stream<UsersState> _updateUserInfo(UserModel user, File newAvatar) async* {
    try {
      yield state.copyWith(isLoading: true);
      await _usersApiService.updateAccountInfo(user, user.id, newAvatar);
      yield state.copyWith(isLoading: false);
      yield UsersSuccessState();
    } on Exception catch (e) {
      yield UsersFailureState();
    }
  }
}
