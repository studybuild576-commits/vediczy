import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vediczy/screens/auth/login_screen.dart';
import 'package:vediczy/screens/splash_screen.dart';
import 'package:vediczy/screens/main_navigation_screen.dart'; // Naya import
import 'package:vediczy/services/auth_service.dart';

void main() async {
  // Flutter ko Firebase se connect karne ke liye
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // StreamProvider user ki auth state (login/logout) ko sunega
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vediczy Exam Prep',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(), // Yeh Wrapper ko call karega
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Provider se user ki state haasil karein
    final user = Provider.of<User?>(context);

    // Agar user null hai (logged out), to LoginScreen dikhayein
    if (user == null) {
      return LoginScreen();
    }
    // Agar user logged in hai, to MainNavigationScreen dikhayein
    else {
      // YEH BADLAAV KIYA GAYA HAI
      return MainNavigationScreen();
    }
  }
}
