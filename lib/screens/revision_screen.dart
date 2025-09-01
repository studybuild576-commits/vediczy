import 'package:flutter/material.dart';

class RevisionScreen extends StatelessWidget {
  const RevisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Revision PDFs'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.description,
                size: 100,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Text(
                'आपकी सभी revision PDFs यहाँ पर दिखेंगी।',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
