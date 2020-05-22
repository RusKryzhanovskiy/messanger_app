import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Navigation {
  static Future<T> toScreen<T>(
    BuildContext context,
    Widget screen, {
    bool rootNavigator = false,
  }) async {
    return await Navigator.of(context, rootNavigator: rootNavigator).push<T>(
      MaterialPageRoute<T>(builder: (_) => screen),
    );
  }

  static Future<T> toScreenRemoveUntil<T>(
    BuildContext context,
    Widget screen, {
    bool hideBottomNavigation = false,
  }) async {
    return await Navigator.of(
      context,
      rootNavigator: hideBottomNavigation,
    ).pushAndRemoveUntil(
      MaterialPageRoute<T>(builder: (_) => screen),
      (_) => false,
    );
  }

  static Future<T> toScreenWithKey<T>(
    GlobalKey<NavigatorState> key,
    Widget screen, {
    bool rootNavigator = false,
  }) async {
    return key.currentState.push(MaterialPageRoute<T>(builder: (_) => screen));
  }

  static Future<T> toScreenWithKeyAndRemoveUntil<T>(
    GlobalKey<NavigatorState> key,
    Widget screen, {
    bool rootNavigator = false,
  }) async {
    return key.currentState.pushAndRemoveUntil(
      MaterialPageRoute<T>(builder: (_) => screen),
      (Route<dynamic> route) => false,
    );
  }
}
