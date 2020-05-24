import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:messangerapp/bloc/auth/auth_event.dart';
import 'package:messangerapp/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
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
    }
  }

  Stream<AuthState> _checkAuthentication() async* {
    yield state.copyWith(isLoading: true);
    try {
      await Future.delayed(Duration(seconds: 2));
      yield state.copyWith(isLoading: false, isAuthenticated: false);
    } catch (error) {
      yield AuthFailure(error: error);
    }
  }

  Stream<AuthState> _login(LoginEvent event) async* {
    yield state.copyWith(isLoading: true);
    try {
      await Future.delayed(Duration(seconds: 2));
      yield state.copyWith(isLoading: false, isAuthenticated: true);
//      yield AuthFailure(error: 'Invalid login or password');
    } catch (error) {
      yield AuthFailure(error: error);
    }
  }

  Stream<AuthState> _signIn(SignInEvent event) async* {
    yield state.copyWith(isLoading: true);
    try {
      await Future.delayed(Duration(seconds: 2));
//      yield state.copyWith(isLoading: false, isAuthenticated: false);
      yield AuthFailure(error: '');
    } catch (error) {
      yield AuthFailure(error: error);
    }
  }
}
