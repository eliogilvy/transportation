import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/firebase_provider.dart';
import 'package:ride_seattle/widgets/enter_phone_number.dart';
import '../classes/auth.dart';
import '../classes/firebase.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword(Auth auth) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword(Auth auth) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      userSetup();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text('Ride Seattle');
  }

  Widget _entryField(
      String title, TextEditingController controller, ValueKey key,
      {bool password = false}) {
    return TextField(
      key: key,
      obscureText: password,
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _passwordField(String title, TextEditingController controller) {
    return TextField(
      key: const ValueKey("passwordField"),
      obscureText: true,
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _emailField(String title, TextEditingController controller) {
    return TextField(
      key: const ValueKey("emailField"),
      obscureText: false,
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Error ? $errorMessage',
      key: const ValueKey('error_message'),
    );
  }

  Widget _submitButton(Auth auth) {
    return ElevatedButton(
      key: const ValueKey("submit_login_Register_Button"),
      onPressed: () {
        if (isLogin) {
          signInWithEmailAndPassword(auth);
        } else {
          createUserWithEmailAndPassword(auth);
        }
      },
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      key: const ValueKey("login_or_registerButton"),
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Register instead' : 'Login instead'),
    );
  }

  Widget _phoneAuth(Auth auth) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(const Color.fromARGB(255, 66, 133, 244)),
      ),
      onPressed: () {
        context.push('/phone_auth');
      },
      child: Text(
        'Use a phone number',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _googleSignIn(Auth auth) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 66, 133, 244),
          ),
          elevation: MaterialStateProperty.all<double>(5),
        ),
        onPressed: () async {
          await auth.signInWithGoogle();
          setState(() {});
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 40.0,
              width: 40,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/google_sign_in.png'),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.rectangle,
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            const Text(
              "Sign in with Google",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'route',
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fire = Provider.of<FireProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: _title(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 140),
          Image.asset('assets/images/logo.png'),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _googleSignIn(fire.auth),
                  _phoneAuth(fire.auth),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
