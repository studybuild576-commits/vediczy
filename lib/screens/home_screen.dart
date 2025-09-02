import 'package:flutter/material.dart';
import '../models/exam.dart';
import 'test_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Exam> exams = const [
    Exam(
      id: 'ssc_cgl_1',
      name: 'SSC CGL Tier 1',
      type: 'SSC',
      tier: 1,
      subjects: ['Quant', 'Reasoning', 'GA'],
    ),
    Exam(
      id: 'ssc_cgl_2',
      name: 'SSC CGL Tier 2',
      type: 'SSC',
      tier: 2,
      subjects: ['Quant', 'English'],
    ),
    Exam(
      id: 'rrb_ntpc_1',
      name: 'RRB NTPC CBT 1',
      type: 'Railway',
      tier: 1,
      subjects: ['GA', 'Math', 'Reasoning'],
    ),
    Exam(
      id: 'rrb_ntpc_2',
      name: 'RRB NTPC CBT 2',
      type: 'Railway',
      tier: 2,
      subjects: ['Quant', 'English'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Exam'),
      ),
      body: ListView.builder(
        itemCount: exams.length,
        itemBuilder: (context, index) {
          final exam = exams[index];
          return ListTile(
            title: Text(exam.name),
            subtitle: Text('${exam.type}, Tier ${exam.tier}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TestListScreen(exam: exam),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
