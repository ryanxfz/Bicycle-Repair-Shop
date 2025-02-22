import 'package:fahrradworkshop/mitarbeiterUI/landingPage.dart';
import 'package:flutter/material.dart';
import 'package:fahrradworkshop/betreiberui/tab.dart';
import 'package:fahrradworkshop/kundenui/tab.dart';

class LoginScreenMitarbeiter extends StatefulWidget {
  final String userType;

  const LoginScreenMitarbeiter({required this.userType});

  @override
  _LoginScreenMitarbeiterState createState() => _LoginScreenMitarbeiterState();
}

class _LoginScreenMitarbeiterState extends State<LoginScreenMitarbeiter> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isRegistering = false;
  List<Map<String, String>> users = [
    {'username': '1234', 'password': '1234'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('${widget.userType} ${_isRegistering ? 'Registration' : 'Login'}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_isRegistering) {
                  _performRegistration();
                } else {
                  _performLogin();
                }
              },
              child: Text(_isRegistering ? 'Register' : 'Login'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isRegistering = !_isRegistering;
                });
              },
              child: Text(_isRegistering ? 'Already have an account? Login' : 'New user? Register here'),
            ),
          ],
        ),
      ),
    );
  }

  void _performLogin() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    bool userFound = false;
    for (var user in users) {
      if (user['username'] == username && user['password'] == password) {
        userFound = true;
        break;
      }
    }

    if (userFound) {
      print('${widget.userType} logged in with username: $username');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LandingPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not detected. Please check your username and password.')),
      );
    }
  }

  void _performRegistration() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      // Check if the username already exists
      bool usernameExists = users.any((user) => user['username'] == username);

      if (usernameExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username already exists. Please choose a different one.')),
        );
      } else {
        // Add new user
        users.add({'username': username, 'password': password});
        print('User created successfully with username: $username');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User created successfully.')),
        );
        setState(() {
          _isRegistering = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both username and password')),
      );
    }
  }
}