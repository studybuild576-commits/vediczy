import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vediczy_admin/screens/add_edit_test_screen.dart';

class ManageTestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditTestScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Test',
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Tests').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No tests found. Add one!"));
          }
          final tests = snapshot.data!.docs;
          return ListView.builder(
            itemCount: tests.length,
            itemBuilder: (context, index) {
              final test = tests[index];
              return ListTile(
                title: Text(test['title']),
                subtitle: Text("Exam: ${test['examName']}"),
                trailing: Icon(Icons.edit),
                onTap: () {
                   Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddEditTestScreen(testDocument: test)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
