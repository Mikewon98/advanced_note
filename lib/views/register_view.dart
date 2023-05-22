import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  // decoration: const InputDecoration(hintText: 'Enter Your Email'),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    hintText: "Enter email address",
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  // decoration: const InputDecoration(hintText: 'Enter Password'),
                  decoration: const InputDecoration(
                    labelText: "Password",
                    hintText: "Enter password",
                  ),
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;

                    try {
                      final userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      print(userCredential);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == "weak-password") {
                        print("Password is weak");
                        SnackBar(content: Text("Password is weak"));
                      }
                      if (e.code == "invalid-email") {
                        print("Invalid Email");
                      }
                      if (e.code == "email-already-in-use") {
                        print("Email already in use");
                      }
                    }
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
