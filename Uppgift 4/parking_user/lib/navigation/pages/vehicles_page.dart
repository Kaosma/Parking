import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_shared/parking_shared.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  _VehiclesPageState createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  void _loadVehicles() {
    context.read<VehiclesBloc>().add(LoadVehicles());
  }

  @override
  Widget build(BuildContext context) {
    final owner = context.read<Person>();
    final formKey = GlobalKey<FormState>();

    void addVehicleDialog() {
      String registrationNumber = '';
      String vehicleType = '';

      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
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
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Stäng'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<VehiclesBloc>().add(CreateVehicle(
                        vehicle:
                            Vehicle(registrationNumber, vehicleType, owner)));
                    Navigator.of(dialogContext).pop();
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

      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
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
                    context.read<VehiclesBloc>().add(UpdateVehicle(
                        vehicle: Vehicle(registrationNumber, vehicleType, owner,
                            vehicle.id)));
                    Navigator.of(dialogContext).pop();
                  }
                },
                child: const Text('Spara'),
              ),
            ],
          );
        },
      );
    }

    void deleteVehicleDialog(Vehicle vehicle) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Ta bort fordon'),
            content: Text(
              'Är du säker på att du vill ta bort fordon ${vehicle.registrationNumber}?',
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
                  context
                      .read<VehiclesBloc>()
                      .add(DeleteVehicle(vehicle: vehicle));
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
      body: BlocBuilder<VehiclesBloc, VehiclesState>(
        builder: (context, state) {
          if (state is VehiclesError) {
            return Center(
              child: Text('Error fetching vehicles: ${state.message}'),
            );
          } else if (state is VehiclesLoaded) {
            final vehicles =
                state.vehicles.where((vehicle) => vehicle.owner.id == owner.id);
            if (vehicles.isNotEmpty) {
              final vehiclesList = vehicles
                  .map((vehicle) => ListCard(
                        icon: Icons.car_crash,
                        title: vehicle.registrationNumber,
                        text: 'Typ: ${vehicle.type}',
                        onEdit: () => editVehicleDialog(vehicle),
                        onDelete: () => deleteVehicleDialog(vehicle),
                      ))
                  .toList();
              return ListView(
                padding: const EdgeInsets.all(8.0),
                children: vehiclesList,
              );
            } else {
              return const Center(
                child: Text('Inga fordon hittade.'),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addVehicleDialog,
        label: const Text('Lägg till fordon'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
