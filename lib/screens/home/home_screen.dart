import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vediczy/models/test_model.dart';
import 'package:vediczy/services/auth_service.dart';
import 'package:vediczy/services/dummy_data_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  final User? user = FirebaseAuth.instance.currentUser;
  
  // Ek future variable jo tests ko hold karega
  late Future<List<Test>> _testsFuture;

  @override
  void initState() {
    super.initState();
    // Screen load hote hi dummy data service se tests fetch karein
    _testsFuture = DummyDataService().getAllTests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vediczy Tests"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
            },
            tooltip: 'Logout',
          )
        ],
      ),
      body: FutureBuilder<List<Test>>(
        future: _testsFuture,
        builder: (context, snapshot) {
          // Jab tak data load ho raha hai, loading indicator dikhayein
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Agar koi error aata hai to error message dikhayein
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong!"));
          }

          // Agar data aa gaya hai aur khali nahi hai
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
                      // Yahan hum test details screen par navigate karenge
                      print("Tapped on ${test.title}");
                    },
                  ),
                );
              },
            );
          }
          
          // Agar data khali hai
          return Center(child: Text("No tests available right now."));
        },
      ),
    );
  }
}
