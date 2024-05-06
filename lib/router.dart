import 'package:flutter/material.dart';
import 'package:poultry_classify/history.dart';
import 'package:poultry_classify/home.dart';
import 'package:poultry_classify/login.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home':
        return MaterialPageRoute(
            builder: (context) => Home(settings.arguments as String));
      case 'history':
        return MaterialPageRoute(builder: (context) => const History());
      default:
        {
          return MaterialPageRoute(
            builder: (context) => const Login(),
          );
        }
    }
  }
}
