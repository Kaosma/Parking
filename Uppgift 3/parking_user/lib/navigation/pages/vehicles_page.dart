import 'package:flutter/material.dart';
import 'package:parking_shared/parking_shared.dart';
import 'package:parking_user/utils/constants.dart';

class VehiclesPage extends StatelessWidget {
  const VehiclesPage({super.key});

  Future<List<Vehicle>> getAllVehiclesHandler(
      VehicleRepository repository) async {
    return await repository.getAll();
  }

  Future<Person?> getUser(PersonRepository repository) async {
    return await repository.getById(AppStrings.userId);
  }

  Future<List<Person>> getAllOwners(PersonRepository repository) async {
    return await repository.getAll();
  }

  @override
  Widget build(BuildContext context) {
    var personRepository = PersonRepository();
    var vehicleRepository = VehicleRepository();

    return FutureBuilder<Person?>(
      future: getUser(personRepository),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (userSnapshot.hasError || userSnapshot.data == null) {
          return Scaffold(
            body: Center(
              child: Text('Error fetching user: ${userSnapshot.error}'),
            ),
          );
        }

        final owner = userSnapshot.data!;
        final formKey = GlobalKey<FormState>();

        void addVehicleDialog() {
          String registrationNumber = '';
          String vehicleType = '';

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Nytt fordon'),
                content: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Registreringsnummer',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Skriv in ett registreringsnummer';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          registrationNumber = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Fordonstyp',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Skriv in en fordonstyp';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          vehicleType = value;
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Stäng'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        vehicleRepository.add(
                          Vehicle(registrationNumber, vehicleType, owner),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        }

        void editVehicleDialog(Vehicle vehicle) {
          String registrationNumber = vehicle.registrationNumber;
          String vehicleType = vehicle.type;
          Person? selectedOwner = vehicle.owner;

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return FutureBuilder<List<Person>>(
                future: getAllOwners(personRepository),
                builder: (context, ownersSnapshot) {
                  if (ownersSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (ownersSnapshot.hasError ||
                      !ownersSnapshot.hasData) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: Text(
                          'Could not fetch owners: ${ownersSnapshot.error}'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  }

                  final owners = ownersSnapshot.data!;

                  return AlertDialog(
                    title: const Text('Edit Vehicle'),
                    content: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            initialValue: registrationNumber,
                            decoration: const InputDecoration(
                              labelText: 'Registreringsnummer',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Skriv in ett registreringsnummer';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              registrationNumber = value;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            initialValue: vehicleType,
                            decoration: const InputDecoration(
                              labelText: 'Fordonstyp',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Skriv in en fordonstyp';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              vehicleType = value;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: selectedOwner
                                ?.id, // Use the owner's id to identify the selected owner
                            decoration: const InputDecoration(
                              labelText: 'Ägare',
                            ),
                            items: owners
                                .map(
                                  (owner) => DropdownMenuItem<String>(
                                    value: owner.id,
                                    child: Text(owner.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              // Find the owner by id
                              selectedOwner = owners
                                  .firstWhere((owner) => owner.id == value);
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
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate() &&
                              selectedOwner != null) {
                            vehicleRepository.update(
                              vehicle.id,
                              Vehicle(
                                registrationNumber,
                                vehicleType,
                                selectedOwner!,
                              ),
                            );
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        }

        void deleteVehicleDialog(Vehicle vehicle) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm Deletion'),
                content: Text(
                    'Are you sure you want to delete vehicle ${vehicle.id}?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      vehicleRepository.delete(vehicle.id);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Delete'),
                  ),
                ],
              );
            },
          );
        }

        return Scaffold(
          body: FutureBuilder<List<Vehicle>>(
            future: getAllVehiclesHandler(vehicleRepository),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error fetching vehicles: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No vehicles available.'),
                );
              }

              final vehiclesList = snapshot.data!
                  .where((vehicle) => vehicle.owner.id == AppStrings.userId)
                  .map((vehicle) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: const Icon(Icons.car_crash),
                    title: Text('Vehicle: ${vehicle.registrationNumber}'),
                    subtitle: Text('Type: ${vehicle.type}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => editVehicleDialog(vehicle),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteVehicleDialog(vehicle),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList();

              return ListView(
                padding: const EdgeInsets.all(8.0),
                children: vehiclesList,
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => addVehicleDialog(),
            label: const Text('Lägg till fordon'),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.amber,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
