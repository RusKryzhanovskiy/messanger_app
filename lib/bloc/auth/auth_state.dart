import 'package:messangerapp/models/user_model.dart';
import 'package:meta/meta.dart';

@immutable
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final UserModel user;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated,
    this.user,
  });

  AuthState copyWith({
    bool isLoading,
    bool isAuthenticated,
    UserModel user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user??this.user,
    );
  }
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({@required this.error}) : super();

  @override
  String toString() => 'AuthFailure { error: $error }';
}
