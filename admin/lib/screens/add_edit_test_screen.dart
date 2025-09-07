import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class AddEditTestScreen extends StatefulWidget {
  final DocumentSnapshot? testDocument;
  const AddEditTestScreen({super.key, this.testDocument});

  @override
  _AddEditTestScreenState createState() => _AddEditTestScreenState();
}

class _AddEditTestScreenState extends State<AddEditTestScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _examNameController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.testDocument?['title'] ?? '');
    _examNameController = TextEditingController(text: widget.testDocument?['examName'] ?? '');
    _descriptionController = TextEditingController(text: widget.testDocument?['description'] ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _examNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });
      try {
        final testData = {
          'title': _titleController.text,
          'examName': _examNameController.text,
          'description': _descriptionController.text,
          'isActive': true, 'category': 'ssc', 'tier': 1, 'testType': 'mock',
          'testFormat': 'full', 'durationInMinutes': 60, 'totalMarks': 200,
        };
        if (widget.testDocument == null) {
          await FirebaseFirestore.instance.collection('Tests').add(testData);
        } else {
          await widget.testDocument!.reference.update(testData);
        }
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving test: $e')));
      } finally {
         if (mounted) { setState(() { _isLoading = false; }); }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.testDocument == null ? 'Add New Test' : 'Edit Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _titleController, decoration: InputDecoration(labelText: 'Test Title'), validator: (value) => value!.isEmpty ? 'Please enter a title' : null),
              SizedBox(height: 16),
              TextFormField(controller: _examNameController, decoration: InputDecoration(labelText: 'Exam Name (e.g., SSC CGL)'), validator: (value) => value!.isEmpty ? 'Please enter an exam name' : null),
              SizedBox(height: 16),
              TextFormField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description'), validator: (value) => value!.isEmpty ? 'Please enter a description' : null),
              SizedBox(height: 32),
              _isLoading ? CircularProgressIndicator() : ElevatedButton(
                onPressed: _saveForm,
                child: Text('Save Test'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
