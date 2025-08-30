import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Import path ko theek kiya gaya hai kyunki file 'screens' folder mein hai.
import 'package:vediczy/screens/google_sign_in_page.dart';

// Main function ab async hai, taki Firebase ko app chalane se pehle initialize kar sakein.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // AuthWrapper widget user ki login state ke hisaab se screen dikhayega.
      home: const AuthWrapper(),
    );
  }
}

// Yeh class user ki authentication state ko manage karti hai.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Yeh stream user ki login ya logout state mein changes ko listen karta hai.
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Agar connection waiting state mein hai, toh loading spinner dikhayein.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // Agar user signed-in hai, toh MyHomePage dikhayein.
        if (snapshot.hasData) {
          return const MyHomePage(title: 'Firestore Test Data');
        }
        // Agar user signed-in nahi hai, toh GoogleSignInPage dikhayein.
        // 'const' keyword ko yahan se hata diya gaya hai.
        return const GoogleSignInPage();
      },
    );
  }
}

// Jab user login kar lega, toh yeh screen dikhegi.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Firebase Auth aur Firestore ke instances.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore mein naya data add karne ka function.
  Future<void> _addData() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Data ko 'test_data' collection mein add karein.
      await _firestore.collection('test_data').add({
        'text': 'This is a test message!',
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
      });
    }
  }

  // User ko sign out karne ka function.
  Future<void> _signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          // Sign Out button.
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Data from Firebase Firestore:',
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            // StreamBuilder Firestore se real-time data fetch karta hai.
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('test_data').snapshots(),
                builder: (context, snapshot) {
                  // Connection state ke hisaab se UI dikhayein.
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No data found. Add some!'));
                  }

                  // Data ko list mein dikhayein.
                  final data = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index].data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(item['text'] ?? 'No text'),
                        subtitle: Text('User ID: ${item['userId'] ?? 'Unknown'}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addData,
        tooltip: 'Add Data',
        child: const Icon(Icons.add),
      ),
    );
  }
}
