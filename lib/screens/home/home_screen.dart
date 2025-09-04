import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vediczy/models/test_model.dart';
import 'package:vediczy/screens/profile/profile_screen.dart';
import 'package:vediczy/screens/test/test_instructions_screen.dart';
import 'package:vediczy/services/auth_service.dart';
import 'package:vediczy/services/dummy_data_service.dart';

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
        title: Text("Vediczy Dashboard"),
        actions: [
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
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              Text(
                'Welcome, ${user?.displayName ?? 'Aspirant'}!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Let\'s start your preparation',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
              ),
              SizedBox(height: 24),

              // Category Cards
              _buildCategoryGrid(),
              SizedBox(height: 24),

              // Featured Tests Section
              Text(
                'Featured Mock Tests',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              _buildFeaturedTestsList(),
            ],
          ),
        ),
      ),
    );
  }

  // Naya Widget: Category Grid banane ke liye
  Widget _buildCategoryGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildCategoryCard(
          context,
          title: 'Full Mock Tests',
          icon: Icons.article,
          color: Colors.orange.shade100,
          iconColor: Colors.orange.shade800,
        ),
        _buildCategoryCard(
          context,
          title: 'Subject Quizzes',
          icon: Icons.menu_book,
          color: Colors.blue.shade100,
          iconColor: Colors.blue.shade800,
        ),
        _buildCategoryCard(
          context,
          title: 'Previous Papers',
          icon: Icons.history,
          color: Colors.green.shade100,
          iconColor: Colors.green.shade800,
        ),
        _buildCategoryCard(
          context,
          title: 'Current Affairs',
          icon: Icons.public,
          color: Colors.red.shade100,
          iconColor: Colors.red.shade800,
        ),
      ],
    );
  }

  // Naya Widget: Category Card design karne ke liye
  Widget _buildCategoryCard(BuildContext context, {required String title, required IconData icon, required Color color, required Color iconColor}) {
    return Card(
      elevation: 2,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Abhi ke liye sabhi cards ek hi jagah jayenge
          // Baad mein hum alag-alag screens ke liye logic likhenge
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: iconColor),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: iconColor),
            ),
          ],
        ),
      ),
    );
  }

  // Naya Widget: Featured Test List banane ke liye
  Widget _buildFeaturedTestsList() {
    return FutureBuilder<List<Test>>(
      future: _testsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No tests available."));
        }
        final tests = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: tests.length,
          itemBuilder: (context, index) {
            final test = tests[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 6.0),
              child: ListTile(
                leading: Icon(Icons.article_outlined, color: Theme.of(context).primaryColor),
                title: Text(test.title, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("${test.examName} | ${test.durationInMinutes} Mins"),
                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
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
      },
    );
  }
}
