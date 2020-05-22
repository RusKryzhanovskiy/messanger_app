import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messangerapp/bloc/auth/auth_bloc.dart';
import 'package:messangerapp/bloc/auth/auth_event.dart';
import 'package:messangerapp/bloc/auth/auth_state.dart';
import 'package:messangerapp/screens/auth/signin/signin_screen.dart';
import 'package:messangerapp/screens/home/home_screen.dart';
import 'package:messangerapp/utils/navigation.dart';
import 'package:messangerapp/utils/regex_validator.dart';
import 'package:messangerapp/utils/ui_utils.dart';
import 'package:messangerapp/widgets/custom_button.dart';
import 'package:messangerapp/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode loginFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthBloc bloc;

  @override
  void initState() {
    bloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: bloc,
      listener: (BuildContext context, AuthState state) {
        if (state is AuthFailure) {
          WidgetUtils.showSnackbarWithScaffoldKey(
            scaffoldKey,
            context,
            state.error,
            type: SnackbarType.error,
          );
        } else if (!state.isLoading && state.isAuthenticated) {
          Navigation.toScreen(context, HomeScreen());
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        bloc: bloc,
        builder: (BuildContext context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Login'),
            ),
            key: scaffoldKey,
            body: getBody(state),
          );
        },
      ),
    );
  }

  Widget getBody(AuthState state) {
    if (state.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 12),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(text: 'Welcome in '),
                      TextSpan(
                        text: 'messanger',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      TextSpan(text: '!'),
                    ],
                  ),
                ),
              ),
              CustomTextField(
                hint: 'Login',
                focus: loginFocus,
                nextFocus: passwordFocus,
                controller: loginController,
                inputAction: TextInputAction.next,
                validator: (String value) {
                  if (Validator.isNotEmpty(value)) {
                    return null;
                  }
                  return 'Login can\'t be empty';
                },
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              CustomTextField(
                hint: 'Password',
                obscureText: true,
                focus: passwordFocus,
                controller: passwordController,
                padding: EdgeInsets.only(bottom: 40),
                validator: (String value) {
                  if (Validator.isPassword(value)) {
                    return null;
                  }
                  return 'Password must contain more than 8 symbols';
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please, enter your login and password and',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              CustomButton(
                title: 'Login',
                onTap: () {
                  bool isFieldsValid = formKey.currentState.validate();
                  if (isFieldsValid) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    bloc.add(LoginEvent(
                      login: loginController.text,
                      password: passwordController.text,
                    ));
                    passwordController.clear();
                  }
                },
                textColor: Colors.white,
                width: MediaQuery.of(context).size.width,
              ),
              Text(
                'or',
                style: Theme.of(context).textTheme.caption,
              ),
              CustomButton(
                title: 'Sign in',
                onTap: () {
                  Navigation.toScreen(context, SignInScreen());
                },
                textColor: Colors.white,
                width: MediaQuery.of(context).size.width,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'if you dont have account.',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
