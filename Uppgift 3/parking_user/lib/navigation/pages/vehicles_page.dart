import 'package:flutter/material.dart';
import 'package:parking_shared/parking_shared.dart';

class VehiclesPage extends StatelessWidget {
  final String userId;
  const VehiclesPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Person?>(
      future: getOwnerHandler(userId),
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
                    child: const Text('Lägg till'),
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
                future: getAllOwnersHandler(),
                builder: (context, ownersSnapshot) {
                  if (ownersSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (ownersSnapshot.hasError ||
                      !ownersSnapshot.hasData) {
                    return InfoDialog(
                      title: 'Error',
                      text: 'Could not fetch owners: ${ownersSnapshot.error}',
                    );
                  }

                  return AlertDialog(
                    title: const Text('Ändra fordon'),
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
                            vehicleRepository.update(
                              vehicle.id,
                              Vehicle(
                                registrationNumber,
                                vehicleType,
                                selectedOwner,
                                vehicle.id,
                              ),
                            );
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Spara'),
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
              return InfoDialog(
                  title: 'Ta bort fordon',
                  text:
                      'Är du säker på att du vill ta bort fordon ${vehicle.id}?',
                  actionText: 'Ta bort',
                  confirmAction: () {
                    vehicleRepository.delete(vehicle.id);
                  });
            },
          );
        }

        return Scaffold(
          body: FutureBuilder<List<Vehicle>>(
            future: getAllVehiclesHandler(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error fetching vehicles: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Inga fordon hittade.'),
                );
              }

              final vehiclesList = snapshot.data!
                  .where((vehicle) => vehicle.owner.id == AppStrings.userId)
                  .map((vehicle) {
                return ListCard(
                    icon: Icons.car_crash,
                    title: vehicle.registrationNumber,
                    text: 'Typ: ${vehicle.type}',
                    onEdit: () {
                      editVehicleDialog(vehicle);
                    },
                    onDelete: () {
                      deleteVehicleDialog(vehicle);
                    });
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
