import 'package:messangerapp/models/user_model.dart';

class UsersState {
  final bool isLoading;
  final String currentUserId;
  final List<UserModel> users;

  UsersState({
    this.isLoading = false,
    this.users,
    this.currentUserId,
  });

  UsersState copyWith({
    bool isLoading,
    List<UserModel> users,
    String currentUserId,
  }) {
    return UsersState(
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }

  UserModel get currentUser =>
      users.firstWhere((element) => element.id == currentUserId);
}

class UsersSuccessState extends UsersState {}

class UsersFailureState extends UsersState {
  @override
  String toString() => 'UsersFailure';
}
