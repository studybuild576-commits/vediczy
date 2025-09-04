import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vediczy/models/test_model.dart';
import 'package:vediczy/screens/profile/profile_screen.dart'; // Naya import
import 'package:vediczy/screens/test/test_instructions_screen.dart'; // Naya import
import 'package.vediczy/services/auth_service.dart';
import 'package.vediczy/services/dummy_data_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  final User? user = FirebaseAuth.instance.currentUser;
  
  late Future<List<Test>> _testsFuture;

  @override
  void initState() {
    super.initState();
    _testsFuture = DummyDataService().getAllTests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vediczy Tests"),
        actions: [
          // NAYA PROFILE ICON BUTTON
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            tooltip: 'Profile',
          ),
          // Logout button ko ab profile screen mein rakhenge, yahan se hata sakte hain
          // IconButton(
          //   icon: Icon(Icons.logout),
          //   onPressed: () async {
          //     await _auth.signOut();
          //   },
          //   tooltip: 'Logout',
          // )
        ],
      ),
      body: FutureBuilder<List<Test>>(
        future: _testsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong!"));
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final tests = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(12.0),
              itemCount: tests.length,
              itemBuilder: (context, index) {
                final test = tests[index];
                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: Icon(Icons.article_outlined, color: Theme.of(context).primaryColor, size: 40),
                    title: Text(
                      test.title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text("${test.examName}\n${test.durationInMinutes} Mins | ${test.totalMarks} Marks"),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      // Test Instructions Screen par navigate karein
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestInstructionsScreen(test: test),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          
          return Center(child: Text("No tests available right now."));
        },
      ),
    );
  }
}
