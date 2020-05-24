import 'package:messangerapp/models/user_model.dart';
import 'package:meta/meta.dart';

@immutable
class HomeScreenState {
  final bool isLoading;
  final UserModel currentUser;

  HomeScreenState({
    this.isLoading = false,
    this.currentUser,
  });

  HomeScreenState copyWith({
    bool isLoading,
    UserModel currentUser,
  }) {
    return HomeScreenState(
      isLoading: isLoading ?? this.isLoading,
      currentUser: currentUser??this.currentUser,
    );
  }
}

class HomeScreenFailure extends HomeScreenState {
  final String error;

  HomeScreenFailure({@required this.error}) : super();

  @override
  String toString() => 'HomeScreenFailure { error: $error }';
}
