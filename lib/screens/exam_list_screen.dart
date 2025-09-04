import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vediczy/services/dummy_data_service.dart';
import 'package:vediczy/screens/test_type_screen.dart';

class ExamListScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ExamListScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  _ExamListScreenState createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  late Future<List<String>> _examsFuture;

  @override
  void initState() {
    super.initState();
    _examsFuture = DummyDataService().getUniqueExamNamesForCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: FutureBuilder<List<String>>(
        future: _examsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No exams found in this category."));
          }
          final exams = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: exams.length,
            itemBuilder: (context, index) {
              final examName = exams[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(examName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => TestTypeScreen(examName: examName)
                    ));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
