import 'dart:convert';

import 'package:parking_shared/parking_shared.dart';
import 'package:firebase_database/firebase_database.dart';

class VehicleRepository implements RepositoryInterface<Vehicle> {
  DatabaseReference database =
      FirebaseDatabase.instance.ref().child("vehicles");

  @override
  Future<Vehicle> add(Vehicle vehicle) async {
    try {
      await database.child('/${vehicle.id}').set(vehicle.toJSON());
      return vehicle;
    } on Exception catch (e) {
      print(e);
      return vehicle;
    }
  }

  @override
  Future<Vehicle?> getById(String id) async {
    DatabaseEvent event = await database.child('/$id').once();
    if (event.snapshot.value != null) {
      dynamic vehicleMap = event.snapshot.value;
      Map<String, dynamic> vehicle =
          Map<String, dynamic>.from(json.decode(json.encode(vehicleMap)));
      return Vehicle.fromJSON(vehicle);
    } else {
      return null;
    }
  }

  @override
  Future<List<Vehicle>> getAll() async {
    DatabaseEvent event = await database.once();
    List<Vehicle> vehiclesList = [];

    if (event.snapshot.value != null) {
      dynamic vehiclesMap = event.snapshot.value;
      vehiclesMap.forEach((key, value) {
        Map<String, dynamic> vehicle =
            Map<String, dynamic>.from(json.decode(json.encode(value)));
        vehiclesList.add(Vehicle.fromJSON(vehicle));
      });
    }
    return vehiclesList;
  }

  @override
  Future<Vehicle?> update(Vehicle newVehicle) async {
    try {
      await database.child('/${newVehicle.id}').update(newVehicle.toJSON());

      final parkingsSnapshot = await database.child('parkings').get();
      if (parkingsSnapshot.exists) {
        final parkingsMap = parkingsSnapshot.value as Map<String, dynamic>;
        final parkingsToUpdate = parkingsMap.entries.where((entry) {
          final parking = Parking.fromJSON(entry.value);
          return parking.vehicle.id == newVehicle.id;
        });

        for (var entry in parkingsToUpdate) {
          final parking = Parking.fromJSON(entry.value);
          parking.vehicle = newVehicle;
          await database
              .child('parkings/${entry.key}')
              .update(parking.toJSON());
        }
      }
      return newVehicle;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> delete(Vehicle vehicle) async {
    await database.child('/${vehicle.id}').remove();
  }

  Stream<List<Vehicle>> getVehiclesStream() {
    return database.onValue.map((event) {
      if (event.snapshot.value != null) {
        dynamic vehiclesMap = event.snapshot.value;
        List<Vehicle> vehiclesList = [];
        vehiclesMap.forEach((key, value) {
          Map<String, dynamic> vehicle =
              Map<String, dynamic>.from(json.decode(json.encode(value)));
          vehiclesList.add(Vehicle.fromJSON(vehicle));
        });
        return vehiclesList;
      } else {
        return [];
      }
    });
  }
}
