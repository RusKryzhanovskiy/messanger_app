import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum SnackbarType { error, info, success }

class DialogAction {
  final String buttonText;
  final Function(BuildContext context) onTap;

  DialogAction(this.buttonText, this.onTap);
}

class WidgetUtils {
  static void showSnackbar(
    BuildContext context,
    String text, {
    Duration duration,
    SnackbarType type = SnackbarType.info,
  }) {
    Color backgroundColor = type == SnackbarType.error
        ? Colors.red
        : Theme.of(context).snackBarTheme.backgroundColor;
    if (type == SnackbarType.success) {
      backgroundColor = Colors.green;
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: duration ?? Duration(milliseconds: 2500),
      backgroundColor: backgroundColor,
    ));
  }

  static void showSnackbarWithScaffoldKey(
    GlobalKey<ScaffoldState> scaffoldKey,
    BuildContext context,
    String text, {
    Duration duration,
    SnackbarType type = SnackbarType.info,
  }) {
    Color backgroundColor = type == SnackbarType.error
        ? Colors.red
        : Theme.of(context).snackBarTheme.backgroundColor;
    if (type == SnackbarType.success) {
      backgroundColor = Colors.green;
    }
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      duration: duration ?? Duration(milliseconds: 2500),
      backgroundColor: backgroundColor,
    ));
  }

  static void showOkDialog(BuildContext context, Widget content) {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            content: content,
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Ok'),
              )
            ],
          );
        } else {
          return CupertinoAlertDialog(
            content: content,
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Ok'),
              ),
            ],
          );
        }
      },
    );
  }

  static void showAlertDialog(BuildContext context, Widget content,
      {List<DialogAction> actions}) {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          List<FlatButton> androidActions = actions
              ?.map((DialogAction action) => FlatButton(
                  onPressed: () {
                    return action.onTap(context);
                  },
                  child: Text(action.buttonText)))
              ?.toList();
          return AlertDialog(content: content, actions: androidActions);
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          List<CupertinoDialogAction> iosActions = actions
              ?.map((DialogAction action) => CupertinoDialogAction(
                    onPressed: () {
                      return action.onTap(context);
                    },
                    child: Text(action.buttonText),
                  ))
              ?.toList();
          return CupertinoAlertDialog(
            content: content,
            actions: iosActions,
          );
        },
      );
    }
  }
}
