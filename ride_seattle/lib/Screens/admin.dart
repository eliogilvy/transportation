import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/firebase_provider.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isTapped = false;
  bool hasTried = false;

  void failure() {
    setState(() {
      isTapped = false;
      hasTried = true;
    });
  }

  void success() {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final fire = Provider.of<FireProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: hasTried ? 'Please try again' : null,
            ),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          SizedBox(height: 16),
          !isTapped ? ElevatedButton(
            onPressed: () async {
              setState(() {
                isTapped = true;
              });
              final String email = _emailController.text;
              final String password = _passwordController.text;

              await fire.auth.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                  failure: failure,
                  success: success);
            },
            child: const Text('Sign In'),
          ) : const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
