import 'package:flutter/material.dart';
import 'package:parking_shared/parking_shared.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late Future<List<Person>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    setState(() {
      _usersFuture = getAllOwnersHandler();
    });
  }

  void addPersonDialog() {
    final formKey = GlobalKey<FormState>();
    String name = '';
    String personalNumberString = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                Navigator.of(context).pop();
              },
              child: const Text('Stäng'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final int? personalNumber =
                      int.tryParse(personalNumberString);

                  if (personalNumber != null) {
                    personRepository.add(Person(name, personalNumber));
                    _loadUsers(); // Reload the list
                    Navigator.of(context).pop();
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
      builder: (BuildContext context) {
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
                Navigator.of(context).pop();
              },
              child: const Text('Avbryt'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final int? parsedPersonalNumber =
                      int.tryParse(personalNumberController.text);

                  if (parsedPersonalNumber != null) {
                    personRepository.update(
                      person.id,
                      Person(nameController.text.trim(), parsedPersonalNumber,
                          person.id),
                    );
                    _loadUsers(); // Reload the list
                    Navigator.of(context).pop();
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ta bort användare'),
          content: Text(
              'Är du säker på att du vill ta bort användare ${person.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Avbryt'),
            ),
            ElevatedButton(
              onPressed: () {
                personRepository.delete(person.id);
                _loadUsers(); // Reload the list
                Navigator.of(context).pop();
              },
              child: const Text('Ta bort'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Person>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users available.'));
          }

          final personsList = snapshot.data!.map((person) {
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

          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: personsList,
          );
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
