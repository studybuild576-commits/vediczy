import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vediczy/screens/exam_segments_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SSC Exams'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildExamCard(context, 'SSC CGL'),
            _buildExamCard(context, 'SSC CHSL'),
            _buildExamCard(context, 'SSC GD'),
            _buildExamCard(context, 'SSC MTS'),
            _buildExamCard(context, 'SSC CPO'),
            // Add more exams as needed
          ],
        ),
      ),
    );
  }

  Widget _buildExamCard(BuildContext context, String examName) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          examName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ExamSegmentsScreen(examName: examName)),
          );
        },
      ),
    );
  }
}
