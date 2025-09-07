import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Firestore se test count laane ke liye ek Future banayein
    final Future<AggregateQuerySnapshot> testCountFuture = 
        FirebaseFirestore.instance.collection('Tests').count().get();

    return Center(
      child: FutureBuilder<AggregateQuerySnapshot>(
        future: testCountFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error loading data!');
          }
          if (snapshot.hasData) {
            int testCount = snapshot.data?.count ?? 0; // Null check ke saath
            return Card(
              margin: EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Total Tests in Database: $testCount',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            );
          }
          return Text('No data found.');
        },
      ),
    );
  }
}
