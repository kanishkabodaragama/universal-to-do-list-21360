import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'src/app_theme.dart';
import 'src/providers/auth_provider.dart';
import 'src/providers/todo_provider.dart';
import 'src/routes.dart';

// Entry point with dotenv for environment configuration.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables from .env asset. Ensure .env exists in root.
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // PUBLIC_INTERFACE
  /// Root of the application.
  /// Applies Ocean Professional theme, sets up Providers for Auth and Todos,
  /// and configures named routes including authentication guard.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider()..loadFromStorage(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, TodoProvider>(
          create: (_) => TodoProvider(null),
          update: (_, auth, previous) => (previous?..updateToken(auth.token)) ?? TodoProvider(auth.token),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'Universal ToDo',
            debugShowCheckedModeBanner: false,
            theme: buildOceanProfessionalTheme(),
            initialRoute: auth.isAuthenticated ? Routes.home : Routes.login,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
