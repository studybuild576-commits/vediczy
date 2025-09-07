import 'package.flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

// Question ka data hold karne ke liye ek choti class
class Question {
  String questionText;
  List<String> options;
  int correctOptionIndex;
  String solutionText;
  String subject;

  Question({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.solutionText,
    required this.subject,
  });
}

class AddEditTestScreen extends StatefulWidget {
  final DocumentSnapshot? testDocument;
  const AddEditTestScreen({super.key, this.testDocument});

  @override
  _AddEditTestScreenState createState() => _AddEditTestScreenState();
}

class _AddEditTestScreenState extends State<AddEditTestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _examNameController = TextEditingController();
  
  // Naye questions ko hold karne ke liye list
  final List<Question> _questions = [];
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.testDocument != null) {
      final data = widget.testDocument!.data() as Map<String, dynamic>;
      _titleController.text = data['title'] ?? '';
      _examNameController.text = data['examName'] ?? '';
      // Yahan hum edit mode ke liye purane questions load kar sakte hain (bhavishya ke liye)
    }
  }

  // Naya question jodne ke liye dialog box
  void _showAddQuestionDialog() {
    final questionTextController = TextEditingController();
    final optionsControllers = List.generate(4, (_) => TextEditingController());
    final solutionTextController = TextEditingController();
    int correctOptionIndex = 0;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder( // Taki dialog ke andar state update ho sake
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Question'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: questionTextController, decoration: const InputDecoration(labelText: 'Question Text')),
                    const SizedBox(height: 10),
                    ...List.generate(4, (index) {
                      return Row(
                        children: [
                          Radio<int>(
                            value: index,
                            groupValue: correctOptionIndex,
                            onChanged: (value) {
                              setDialogState(() { correctOptionIndex = value!; });
                            },
                          ),
                          Expanded(child: TextField(controller: optionsControllers[index], decoration: InputDecoration(labelText: 'Option ${index + 1}'))),
                        ],
                      );
                    }),
                    const SizedBox(height: 10),
                    TextField(controller: solutionTextController, decoration: const InputDecoration(labelText: 'Solution')),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    final newQuestion = Question(
                      questionText: questionTextController.text,
                      options: optionsControllers.map((c) => c.text).toList(),
                      correctOptionIndex: correctOptionIndex,
                      solutionText: solutionTextController.text,
                      subject: 'General', // Aap iske liye bhi ek field add kar sakte hain
                    );
                    setState(() { _questions.add(newQuestion); });
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Add Question'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Test aur uske sabhi questions ko save karne ka function
  Future<void> _saveTestAndQuestions() async {
    if (!_formKey.currentState!.validate() || _questions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all test details and add at least one question.')));
        return;
    }
    setState(() { _isLoading = true; });

    try {
      // Step 1: Test ki details save karein ya update karein
      final testData = {
        'title': _titleController.text,
        'examName': _examNameController.text,
        'isActive': true, 'category': 'ssc', 'tier': 1, 'testType': 'mock', 'testFormat': 'full',
        'durationInMinutes': 60, 'totalMarks': _questions.length * 2, // Example
      };
      
      DocumentReference testRef;
      if (widget.testDocument == null) {
        testRef = await FirebaseFirestore.instance.collection('Tests').add(testData);
      } else {
        testRef = widget.testDocument!.reference;
        await testRef.update(testData);
        // Edit mode mein purane questions delete karne ka logic yahan aayega
      }
      
      // Step 2: Sabhi naye questions ko ek batch mein save karein
      final batch = FirebaseFirestore.instance.batch();
      for (final question in _questions) {
        final questionRef = FirebaseFirestore.instance.collection('Questions').doc();
        batch.set(questionRef, {
          'testId': testRef.id,
          'questionText': question.questionText,
          'options': question.options,
          'correctOptionIndex': question.correctOptionIndex,
          'solutionText': question.solutionText,
          'subject': question.subject,
        });
      }
      await batch.commit();

      Navigator.of(context).pop();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving data: $e')));
    } finally {
      if(mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.testDocument == null ? 'Create New Test' : 'Edit Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1. Test Details', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Test Title', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _examNameController, decoration: const InputDecoration(labelText: 'Exam Name', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 24),
              
              const Divider(),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text('2. Questions (${_questions.length})', style: Theme.of(context).textTheme.headlineSmall),
                    TextButton.icon(
                        icon: const Icon(Icons.add_circle),
                        label: const Text('Add Question'),
                        onPressed: _showAddQuestionDialog,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              // Yahan add kiye gaye questions ki list dikhegi
              _questions.isEmpty
                ? const Center(child: Text('No questions added yet. Click "Add Question" to start.'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _questions.length,
                    itemBuilder: (ctx, index) {
                      return Card(
                        child: ListTile(
                          leading: Text('${index + 1}.'),
                          title: Text(_questions[index].questionText, maxLines: 1, overflow: TextOverflow.ellipsis),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              setState(() { _questions.removeAt(index); });
                            },
                          ),
                        ),
                      );
                    },
                  ),
              
              const SizedBox(height: 40),

              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Center(
                  child: ElevatedButton(
                    onPressed: _saveTestAndQuestions,
                    child: const Text('Save Full Test'),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
