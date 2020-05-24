import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messangerapp/bloc/auth/auth_bloc.dart';
import 'package:messangerapp/bloc/users/users_bloc.dart';
import 'package:messangerapp/bloc/users/users_event.dart';
import 'package:messangerapp/bloc/users/users_state.dart';
import 'package:messangerapp/models/user_model.dart';
import 'package:messangerapp/screens/settings/settings_screen.dart';
import 'package:messangerapp/utils/navigation.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  UsersBloc usersBloc;

  @override
  void initState() {
    usersBloc = BlocProvider.of<UsersBloc>(context);
    usersBloc.add(LoadInitialUsersData(
      BlocProvider.of<AuthBloc>(context).state.user.id,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Messages'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              Navigation.toScreen(context, SettingsScreen());
            },
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: BlocBuilder(
        bloc: usersBloc,
        builder: (BuildContext context, UsersState usersState) {
          if (usersState.isLoading) {
            return Container();
          }
          return getBody(usersState);
        },
      ),
    );
  }

  Widget getBody(UsersState state) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 12),
      itemCount: state.users.length,
      itemBuilder: (BuildContext context, int index) {
        UserModel user = state.users[index];
        return ListTile(
          onTap: () {},
          leading: user.avatarUrl == null
              ? null
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(user.avatarUrl),
                ),
          title: Text(
            state.currentUser.email == user.email
                ? 'Me'
                : user.name ?? user.email,
          ),
          subtitle: Text(
            'Hi, how are you?',
          ),
          trailing: Text(
            '19:34',
          ),
        );
      },
    );
  }
}
