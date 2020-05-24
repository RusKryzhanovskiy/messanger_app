import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messangerapp/bloc/auth/auth_event.dart';
import 'package:messangerapp/bloc/auth/auth_state.dart';
import 'package:messangerapp/models/user_model.dart';
import 'package:messangerapp/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService();

  @override
  AuthState get initialState => AuthState(
        isLoading: true,
        isAuthenticated: false,
      );

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is CheckAuthenticationEvent) {
      yield* _checkAuthentication();
    } else if (event is LoginEvent) {
      yield* _login(event);
    } else if (event is SignInEvent) {
      yield* _signIn(event);
    } else if (event is LogOutAuthenticationEvent) {
      yield* _logOut();
    }
  }

  Stream<AuthState> _checkAuthentication() async* {
    yield state.copyWith(isLoading: true);
    try {
      UserModel user = await _authService.currentUser();
      yield state.copyWith(
        isLoading: false,
        isAuthenticated: user != null,
        user: user,
      );
    } catch (error) {
      yield AuthFailure(error: error);
    }
  }

  Stream<AuthState> _login(LoginEvent event) async* {
    yield state.copyWith(isLoading: true);
    try {
      UserModel user =
          await _authService.signInWithEmail(event.login, event.password);
      yield state.copyWith(isLoading: false, isAuthenticated: true, user: user);
    } catch (error) {
      yield AuthFailure(error: 'Invalid login or password');
    }
  }

  Stream<AuthState> _signIn(SignInEvent event) async* {
    yield state.copyWith(isLoading: true);
    try {
      UserModel user = await _authService.signUpWithEmail(
        event.mail,
        event.password,
        event.age,
        event.country,
        event.name,
      );
      yield state.copyWith(isLoading: false, isAuthenticated: true, user: user);
    } catch (error) {
      yield AuthFailure(error: error);
    }
  }

  Stream<AuthState> _logOut() async* {
    await _authService.logout();
    yield AuthState(isLoading: false, isAuthenticated: false);
  }
}
