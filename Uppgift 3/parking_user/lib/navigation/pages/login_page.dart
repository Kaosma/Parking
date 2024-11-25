import 'package:flutter/material.dart';

import '../../handlers/login/authenticate_user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    authenticate() => authenticateUser(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Inloggning')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Fyll i email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Fyll i email';
                  }
                  // You can add more email validation here.
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Lösenord',
                  hintText: 'Fyll i lösenord',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Fyll i lösenord';
                  }
                  // You can add more password validation here.
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: authenticate,
                child: const Text('Logga in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
