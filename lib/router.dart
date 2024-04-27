import 'package:flutter/material.dart';
import 'package:poultry_classify/home.dart';
import 'package:poultry_classify/login.dart';
import 'package:poultry_classify/result.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home':
        return MaterialPageRoute(builder: (context) => const Home());
      case 'result':
        return MaterialPageRoute(builder: (context) => const Result());

      default:
        {
          return MaterialPageRoute(
            builder: (context) => const Login(),
          );
        }
    }
  }
}
