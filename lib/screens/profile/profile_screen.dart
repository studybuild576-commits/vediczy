import 'package:flutter/material.dart'; // YEH LINE ADD KI GAYI HAI
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vediczy/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Firebase se current user ki details haasil karein
    final User? user = FirebaseAuth.instance.currentUser;
    final AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SizedBox(height: 20),
          // User ki profile picture ya initial ke liye
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.indigo.shade100,
            child: Text(
              user?.displayName?.substring(0, 1) ?? user?.email?.substring(0, 1).toUpperCase() ?? 'U',
              style: TextStyle(fontSize: 40, color: Colors.indigo.shade800),
            ),
          ),
          SizedBox(height: 20),
          
          // User ka naam aur email dikhane ke liye card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person, color: Colors.indigo),
                  title: Text('Name'),
                  subtitle: Text(
                    user?.displayName ?? 'Not Set',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.email, color: Colors.indigo),
                  title: Text('Email'),
                  subtitle: Text(
                    user?.email ?? 'No Email',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 30),

          // Logout Button
          ElevatedButton.icon(
            icon: Icon(Icons.logout),
            label: Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              await authService.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }
}
