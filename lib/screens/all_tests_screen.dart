import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vediczy/screens/exam_list_screen.dart';

class AllTestsScreen extends StatelessWidget {
  const AllTestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Test Series'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCategoryCard(context, title: 'SSC Exams', icon: Icons.school, categoryId: 'ssc'),
              SizedBox(height: 12),
              _buildCategoryCard(context, title: 'Railway Exams', icon: Icons.train, categoryId: 'railway'),
            ],
          ),
        ),
      ),
    );
  }

  // Humne yeh widget HomeScreen se yahan copy kiya hai
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
