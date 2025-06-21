import 'package:flutter/material.dart';
import 'package:groza/screens/home_screen.dart';
import 'package:groza/screens/login_screen.dart';
import 'package:groza/screens/register_screen.dart';
import 'package:groza/screens/user_profile.dart';
import 'package:groza/services/api_service.dart';
import 'package:groza/services/auth_service.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => ApiService()),
        Provider(create: (context) {
          final apiService = Provider.of<ApiService>(context, listen: false);
          return AuthService(apiService: apiService);
        }),
      ],
      child: MaterialApp(
        title: 'Groza The Grocery App',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => AuthWrapper(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => HomeScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return FutureBuilder<String?>(
      future: authService.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          return snapshot.hasData ? HomeScreen() : LoginScreen();
        }
      },
    );
  }
}