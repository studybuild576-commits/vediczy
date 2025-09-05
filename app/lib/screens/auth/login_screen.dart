import 'package:flutter/material.dart';
import 'package:vediczy/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login to Vediczy")),
      body: Center(
        child: _isLoading
        ? CircularProgressIndicator()
        : Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Welcome Back!", style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                  onPressed: () async {
                    _setLoading(true);
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();
                    if (email.isNotEmpty && password.isNotEmpty) {
                      var user = await _auth.signInWithEmail(email, password);
                      if (user == null && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to sign in. Please check credentials.")),
                        );
                      }
                    }
                    if(mounted) _setLoading(false);
                  },
                  child: Text('Login with Email'),
                ),
                SizedBox(height: 15),
                ElevatedButton.icon(
                  icon: Icon(Icons.g_mobiledata),
                  label: Text('Sign in with Google'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    _setLoading(true);
                    var user = await _auth.signInWithGoogle();
                    if (user == null && mounted) {
                       ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Google Sign-In was cancelled or failed.")),
                        );
                    }
                    if(mounted) _setLoading(false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
