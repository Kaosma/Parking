import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_shared/parking_shared.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    context.read<AuthBloc>().add(LoadPersons());
  }

  @override
  Widget build(BuildContext context) {
    void addPersonDialog() {
      final formKey = GlobalKey<FormState>();
      String name = '';
      String personalNumberString = '';
      String email = '';
      String password = '';

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
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Skriv in en e-mail';
                      }
                      if (!isValidEmail(value)) {
                        return 'E-mail måste följa format: test@exempel.com';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Lösenord',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Välj ett lösenord';
                      }
                      if (value.length > 6) {
                        return 'Giltigt lösenord måste vara 6 tecken eller fler';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      password = value;
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
                      context.read<AuthBloc>().add(CreatePerson(
                          user: Person(name, personalNumber, email, password)));
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

    void editPersonDialog(Person person) {
      final formKey = GlobalKey<FormState>();
      final TextEditingController nameController =
          TextEditingController(text: person.name);
      final TextEditingController personalNumberController =
          TextEditingController(text: person.personalNumber.toString());

      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Ändra användare'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Namn',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Skriv in ett namn';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: personalNumberController,
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
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Avbryt'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final int? parsedPersonalNumber =
                        int.tryParse(personalNumberController.text);

                    if (parsedPersonalNumber != null) {
                      context.read<AuthBloc>().add(UpdatePerson(
                          user: Person(nameController.text.trim(),
                              parsedPersonalNumber, person.email, person.id)));
                      Navigator.of(dialogContext).pop();
                    }
                  }
                },
                child: const Text('Spara'),
              ),
            ],
          );
        },
      );
    }

    void deletePersonDialog(Person person) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Ta bort användare'),
            content: Text(
                'Är du säker på att du vill ta bort användare ${person.name}?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Avbryt'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(DeletePerson(user: person));
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Ta bort'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthError) {
            return Center(
              child: Text('Error fetching users: ${state.message}'),
            );
          } else if (state is AuthLoaded) {
            final users = state.users.map((person) {
              return ListCard(
                icon: Icons.person,
                title: 'Owner: ${person.name}',
                text: 'Id: ${person.id}',
                onEdit: () {
                  editPersonDialog(person);
                },
                onDelete: () {
                  deletePersonDialog(person);
                },
              );
            }).toList();

            if (users.isNotEmpty) {
              return ListView(
                padding: const EdgeInsets.all(8.0),
                children: users,
              );
            } else {
              return const Center(
                child:
                    Text('Inga användare hittade.'), // Updated text for clarity
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addPersonDialog,
        label: const Text('Lägg till användare'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
