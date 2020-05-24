import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:messangerapp/bloc/auth/auth_bloc.dart';
import 'package:messangerapp/screens/home/home_event.dart';
import 'package:messangerapp/screens/home/home_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final AuthBloc _authBloc;

  HomeScreenBloc(this._authBloc);

  @override
  HomeScreenState get initialState => HomeScreenState();

  @override
  Stream<HomeScreenState> mapEventToState(HomeScreenEvent event) async* {
    if (event is LoadHomeScreenData) {
      yield* _loadInitialData();
    }
  }

  Stream<HomeScreenState> _loadInitialData() async* {
    try {
      yield state.copyWith(isLoading: true);
      await Future.delayed(Duration(seconds: 1));
      yield state.copyWith(
        isLoading: false,
        currentUser: _authBloc.state.user,
      );
    } catch (error) {
      yield HomeScreenFailure(error: error);
    }
  }
}
