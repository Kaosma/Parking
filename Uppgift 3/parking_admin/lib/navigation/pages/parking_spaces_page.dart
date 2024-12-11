import 'package:flutter/material.dart';
import 'package:parking_shared/parking_shared.dart';

class ParkingSpacesPage extends StatelessWidget {
  const ParkingSpacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    void addParkingSpaceDialog() {
      String address = '';
      String priceString = '';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ny parkeringsplats'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Adress',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Skriv in en adress';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      address = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Pris per timme (kr)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Skriv in ett pris';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Pris måste vara ett nummer';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      priceString = value;
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
                    final int? price = int.tryParse(priceString);

                    if (price != null) {
                      parkingSpaceRepository.add(
                        ParkingSpace(address, price),
                      );
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ogiltigt pris'),
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

    void editParkingSpaceDialog(ParkingSpace parkingSpace) {
      final TextEditingController addressController =
          TextEditingController(text: parkingSpace.address);
      final TextEditingController priceController =
          TextEditingController(text: parkingSpace.price.toString());

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ändra adress'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Adress',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Skriv in en adress';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Pris per timme (kr)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Skriv in ett pris';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Pris måste vara ett nummer';
                      }
                      return null;
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
                    final int? parsedPrice = int.tryParse(priceController.text);

                    if (parsedPrice != null) {
                      parkingSpaceRepository.update(
                        parkingSpace.id,
                        ParkingSpace(addressController.text.trim(), parsedPrice,
                            parkingSpace.id),
                      );
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

    void deleteParkingSpaceDialog(ParkingSpace parkingSpace) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return InfoDialog(
              title: 'Ta bort parkeringsplats',
              text: 'Är du säker på att du vill ta bort ${parkingSpace.id}?',
              actionText: 'Ta bort',
              confirmAction: () {
                parkingSpaceRepository.delete(parkingSpace.id);
              });
        },
      );
    }

    return Scaffold(
      body: FutureBuilder<List<ParkingSpace>>(
        future: getAllParkingSpacesHandler(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error new: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Inga parkeringsplatser hittade.'));
          }

          final parkingSpacesList = snapshot.data!.map((parkingSpace) {
            return ListCard(
                icon: Icons.car_crash,
                title: parkingSpace.address,
                text: 'Pris: ${parkingSpace.price}kr/h',
                onEdit: () {
                  editParkingSpaceDialog(parkingSpace);
                },
                onDelete: () {
                  deleteParkingSpaceDialog(parkingSpace);
                });
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: parkingSpacesList,
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => addParkingSpaceDialog(),
        label: const Text('Lägg till parkeringsplats'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
