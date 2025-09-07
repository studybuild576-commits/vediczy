import 'package:flutter/material.dart';

void main() {
  runApp(const WebAppTest());
}

class WebAppTest extends StatelessWidget {
  const WebAppTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vediczy Web App - Test'),
          backgroundColor: Colors.indigo,
        ),
        body: const Center(
          child: Text(
            'Hello! If you can see this, the configuration is correct.',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
