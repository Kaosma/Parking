import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_shared/parking_shared.dart';

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
  String userId = '';

  @override
  Widget build(BuildContext context) {
    authenticate() => {authenticateUser(context, userId)};
    final formKey = GlobalKey<FormState>();

    void addPersonDialog() {
      String name = '';
      String personalNumberString = '';

      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Ny användare'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Namn',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Skriv in ett namn';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Personnummer',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Skriv in ett personnummer';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Personnummer måste vara ett nummer';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      personalNumberString = value;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Stäng'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final int? personalNumber =
                        int.tryParse(personalNumberString);

                    if (personalNumber != null) {
                      personRepository.add(
                        Person(name, personalNumber),
                      );
                      Navigator.of(dialogContext).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ogiltigt personnummer'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Lägg till'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
        appBar: AppBar(title: const Text('Inloggning')),
        body: FutureBuilder<List<Person>>(
            future: getAllOwnersHandler(),
            builder: (context, snapshot) {
              final users = snapshot.data?.map((user) => {user.id});
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Id',
                          hintText: 'Fyll i id',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Fyll i id';
                          }
                          return null;
                        },
                        onChanged: (value) => userId = value,
                      ),
                      // TextFormField(
                      //   controller: _emailController,
                      //   decoration: const InputDecoration(
                      //     labelText: 'Email',
                      //     hintText: 'Fyll i email',
                      //   ),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Fyll i email';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // const SizedBox(height: 16.0),
                      // TextFormField(
                      //   controller: _passwordController,
                      //   decoration: const InputDecoration(
                      //     labelText: 'Lösenord',
                      //     hintText: 'Fyll i lösenord',
                      //   ),
                      //   obscureText: true,
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Fyll i lösenord';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: addPersonDialog,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(8.0), // Padding
                        ),
                        child: const Text('Registrera ny användare'),
                      ),
                      const SizedBox(height: 16.0),

                      ElevatedButton(
                        onPressed: authenticate,
                        child: const Text('Logga in'),
                      ),
                      const SizedBox(height: 16.0),
                      SelectableText('Tillgängliga användare: $users')
                    ],
                  ),
                ),
              );
            }));
  }
}
