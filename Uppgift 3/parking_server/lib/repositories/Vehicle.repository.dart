import 'package:firebase_dart/database.dart';
import 'package:serverparking/serverHandlers/router.config.dart';
import 'package:parking_shared/parking_shared.dart';

class VehicleRepository implements RepositoryInterface<Vehicle> {
  final String baseUrl =
      'https://serverparking-9de55-default-rtdb.europe-west1.firebasedatabase.app/';
  DatabaseReference database = FirebaseDatabase(app: RouterConfig.instance.app)
      .reference()
      .child("vehicles");

  @override
  Future<Vehicle> add(Vehicle vehicle) async {
    database.push().set(vehicle);
    return vehicle;
  }

  Future<Vehicle?> getByRegistrationNumber(String registrationNumber) async {
    DataSnapshot snapshot = await database.child('/$registrationNumber').once();

    if (snapshot.value != null) {
      Map<String, dynamic> vehicle =
          Map<String, dynamic>.from(snapshot.value as Map);
      return Vehicle.fromJSON(vehicle);
    } else {
      return null;
    }
  }

  @override
  Future<List<Vehicle>> getAll() async {
    DataSnapshot snapshot = await database.once();
    List<Vehicle> vehiclesList = [];

    if (snapshot.value != null) {
      Map<dynamic, dynamic> vehiclesMap =
          snapshot.value as Map<dynamic, dynamic>;
      vehiclesMap.forEach((key, value) {
        Map<String, dynamic> vehicle = Map<String, dynamic>.from(value as Map);
        vehiclesList.add(Vehicle.fromJSON(vehicle));
      });
    }
    return vehiclesList;
  }

  @override
  Future<Vehicle?> update(String registrationNumber, Vehicle newVehicle) async {
    try {
      await database.child('/$registrationNumber').update(newVehicle.toJSON());
      return newVehicle;
    } catch (e) {
      return null;
    }
  }

  Future<void> delete(String registrationNumber) async {
    await database.child('/$registrationNumber').remove();
  }
}
