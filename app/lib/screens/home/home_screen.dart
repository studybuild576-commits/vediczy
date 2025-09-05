import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vediczy/screens/exam_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vediczy/screens/profile/profile_screen.dart';
import 'package:vediczy/services/firestore_service.dart'; // FirestoreService इम्पोर्ट करें

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      // NAYA FLOATING ACTION BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Adding sample data to Firestore...')),
          );
          await FirestoreService().addSampleData();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✅ Sample data added successfully!')),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Sample Data',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Choose a Category', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 12),
              _buildExamCategories(context),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.indigo.shade600,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome, ${user?.displayName?.split(' ')[0] ?? 'Aspirant'}!', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('Let\'s start your preparation', style: GoogleFonts.poppins(color: Colors.white70)),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen())),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(user?.displayName?.substring(0, 1) ?? user?.email?.substring(0, 1).toUpperCase() ?? 'U', style: TextStyle(color: Colors.indigo.shade600, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
  
  Widget _buildExamCategories(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildCategoryCard(context, title: 'SSC Exams', icon: Icons.school, categoryId: 'ssc'),
          SizedBox(height: 12),
          _buildCategoryCard(context, title: 'Railway Exams', icon: Icons.train, categoryId: 'railway'),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, {required String title, required IconData icon, required String categoryId}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        leading: Icon(icon, size: 40, color: Colors.indigo),
        title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
        trailing: Icon(Icons.arrow_forward_ios_rounded),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ExamListScreen(categoryId: categoryId, categoryName: title),
          ));
        },
      ),
    );
  }
}
