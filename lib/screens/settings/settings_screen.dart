import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messangerapp/bloc/auth/auth_bloc.dart';
import 'package:messangerapp/bloc/auth/auth_event.dart';
import 'package:messangerapp/bloc/auth/auth_state.dart';
import 'package:messangerapp/screens/auth/login/login_screen.dart';
import 'package:messangerapp/utils/navigation.dart';
import 'package:messangerapp/widgets/custom_button.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings'),
      ),
      body: BlocListener(
        bloc: BlocProvider.of<AuthBloc>(context),
        listener: (BuildContext context, AuthState state) {
          if (!state.isAuthenticated) {
            Navigation.toScreen(context, LoginScreen());
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CustomButton(
                  onTap: () {
                    BlocProvider.of<AuthBloc>(context)
                        .add(LogOutAuthenticationEvent());
                  },
                  title: 'Log Out',
                  textColor: Colors.white,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
