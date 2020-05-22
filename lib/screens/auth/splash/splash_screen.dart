import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messangerapp/bloc/auth/auth_bloc.dart';
import 'package:messangerapp/bloc/auth/auth_event.dart';
import 'package:messangerapp/bloc/auth/auth_state.dart';
import 'package:messangerapp/screens/auth/login/login_screen.dart';
import 'package:messangerapp/screens/home/home_screen.dart';
import 'package:messangerapp/utils/navigation.dart';
import 'package:messangerapp/utils/ui_utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthBloc authBloc;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(CheckAuthenticationEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        bloc: authBloc,
        listener: (BuildContext context, AuthState state) {
          if (state is AuthFailure) {
            WidgetUtils.showSnackbar(
              context,
              state.error,
              type: SnackbarType.error,
            );
            Navigation.toScreenRemoveUntil(context, LoginScreen());
          } else if (!state.isLoading) {
            if (state.isAuthenticated) {
              Navigation.toScreenRemoveUntil(context, HomeScreen());
            } else {
              Navigation.toScreenRemoveUntil(context, LoginScreen());
            }
          }
        },
        child: Center(
          child: Text(
            'messanger',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
