import 'package.flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vediczy_admin/screens/admin_login_screen.dart';
import 'package:vediczy_admin/screens/main_layout.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(AdminApp());
}

class AdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vediczy Admin Panel',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final String adminEmail = "studybuild576@gmail.com";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return AdminLoginScreen();
        }
        if (snapshot.data!.email == adminEmail) {
          return MainLayout();
        } else {
          return AccessDeniedScreen();
        }
      },
    );
  }
}

class AccessDeniedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 60, color: Colors.red),
            const SizedBox(height: 10),
            const Text('Access Denied', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
