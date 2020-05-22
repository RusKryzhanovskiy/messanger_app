import 'package:meta/meta.dart';

@immutable
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated,
  });

  AuthState copyWith({
    bool isLoading,
    bool isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({@required this.error}) : super();

  @override
  String toString() => 'AuthFailure { error: $error }';
}
