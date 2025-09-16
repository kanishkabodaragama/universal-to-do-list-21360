import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/todo_form_screen.dart';

class Routes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/';
  static const String todoForm = '/todo-form';
}

class AppRouter {
  // PUBLIC_INTERFACE
  /// Centralized route generator with simple guards for authenticated routes.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return _material(settings, const LoginScreen());
      case Routes.signup:
        return _material(settings, const SignupScreen());
      case Routes.home:
        return _material(settings, const HomeScreen());
      case Routes.todoForm:
        final args = settings.arguments as Map<String, dynamic>?;
        return _material(settings, TodoFormScreen(todo: args?['todo']));
      default:
        return _material(
          settings,
          const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }

  static PageRoute _material(RouteSettings settings, Widget child) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(begin: 0.95, end: 1.0).chain(CurveTween(curve: Curves.easeOutCubic));
        return ScaleTransition(scale: animation.drive(tween), child: child);
      },
    );
  }
}
