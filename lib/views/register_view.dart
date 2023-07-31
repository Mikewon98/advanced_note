import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../utilities/dialogs/error_dialog.dart';

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
      body: Padding(
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
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  AuthService.firebase().sendEmailVerification();

                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on WeakPasswordAuthException {
                  await showErrorDialog(context, "Password is weak!");
                } on InvalidEmailAuthException {
                  await showErrorDialog(context, "Invalid Email");
                } on EmailAlreadyInUseException {
                  await showErrorDialog(context, "Email has already registred");
                } on GenericAuthException {
                  await showErrorDialog(context, "Failed to register");
                }
              },
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Already registered, Login here'),
            ),
          ],
        ),
      ),
    );
  }
}
