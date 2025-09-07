import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? _error;

  Future<void> _login() async {
    setState(() { _error = null; });
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() { _error = e.message; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Admin Panel Login', style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(height: 20),
                  TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
                  SizedBox(height: 10),
                  TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
                  if (_error != null) ...[
                    SizedBox(height: 10),
                    Text(_error!, style: TextStyle(color: Colors.red)),
                  ],
                  SizedBox(height: 20),
                  ElevatedButton(onPressed: _login, child: Text('Login')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
