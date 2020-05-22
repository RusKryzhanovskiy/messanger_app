import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messangerapp/bloc/auth/auth_bloc.dart';
import 'package:messangerapp/bloc/auth/auth_event.dart';
import 'package:messangerapp/bloc/auth/auth_state.dart';
import 'package:messangerapp/screens/home/home_screen.dart';
import 'package:messangerapp/utils/navigation.dart';
import 'package:messangerapp/utils/regex_validator.dart';
import 'package:messangerapp/utils/ui_utils.dart';
import 'package:messangerapp/widgets/custom_button.dart';
import 'package:messangerapp/widgets/custom_text_field.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController loginController = TextEditingController();
  final FocusNode loginNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordNode = FocusNode();
  final TextEditingController mailController = TextEditingController();
  final FocusNode mailNode = FocusNode();
  final TextEditingController ageController = TextEditingController();
  final FocusNode ageNode = FocusNode();
  final TextEditingController countryController = TextEditingController();
  final FocusNode countryNode = FocusNode();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
          WidgetUtils.showSnackbar(
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
          return Scaffold(key: scaffoldKey, body: getBody(state));
        },
      ),
    );
  }

  Widget getBody(AuthState state) {
    if (state.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: 'Create your personal '),
                    TextSpan(
                      text: 'messanger',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    TextSpan(text: '.'),
                  ],
                ),
              ),
              CustomTextField(
                hint: 'Login',
                focus: loginNode,
                inputAction: TextInputAction.next,
                controller: loginController,
                nextFocus: passwordNode,
                padding: EdgeInsets.only(bottom: 12, top: 20),
              ),
              CustomTextField(
                hint: 'Password',
                focus: passwordNode,
                nextFocus: mailNode,
                obscureText: true,
                inputAction: TextInputAction.next,
                controller: passwordController,
                validator: (String value) {
                  if (Validator.isPassword(value)) {
                    return null;
                  }
                  return 'Password must contain more than 8 symbols';
                },
                padding: EdgeInsets.only(bottom: 12),
              ),
              CustomTextField(
                hint: 'E-Mail',
                focus: mailNode,
                nextFocus: ageNode,
                inputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
                controller: mailController,
                validator: (String value) {
                  if (Validator.isEmail(value)) {
                    return null;
                  }
                  return 'Enter existing e-mail address';
                },
                padding: EdgeInsets.only(bottom: 12),
              ),
              CustomTextField(
                hint: 'Age',
                focus: ageNode,
                inputAction: TextInputAction.next,
                nextFocus: countryNode,
                inputType: TextInputType.number,
                controller: ageController,
                validator: (String value) {
                  if (Validator.isAge(value)) {
                    double age = double.tryParse(value);
                    if (age <= 5) {
                      return 'You must be older than 5 years';
                    }
                    return null;
                  }
                  return 'Enter existing e-mail address';
                },
                formatter: [LengthLimitingTextInputFormatter(2)],
                padding: EdgeInsets.only(bottom: 12),
              ),
              CustomTextField(
                hint: 'Country',
                focus: countryNode,
                inputAction: TextInputAction.done,
                controller: countryController,
                padding: EdgeInsets.only(bottom: 12),
              ),
              CustomButton(
                title: 'Create account',
                onTap: () {
                  bool isFieldsValid = formKey.currentState.validate();
                  if (isFieldsValid) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    bloc.add(SignInEvent(
                      login: loginController.text,
                      password: passwordController.text,
                      age: int.tryParse(ageController.text),
                      mail: mailController.text,
                      country: countryController.text,
                    ));
                  }
                },
                textColor: Colors.white,
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
