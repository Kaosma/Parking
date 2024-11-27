import 'package:firebase_dart/database.dart';
import 'package:parking_shared/parking_shared.dart';
import '../serverHandlers/router.config.dart';

class VehicleRepository implements RepositoryInterface<Vehicle> {
  DatabaseReference database = FirebaseDatabase(app: RouterConfig.instance.app)
      .reference()
      .child("vehicles");

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
    DataSnapshot snapshot = await database.child('/$id').once();

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
  Future<Vehicle?> update(String id, Vehicle newVehicle) async {
    try {
      await database.child('/$id').update(newVehicle.toJSON());
      return newVehicle;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> delete(String id) async {
    await database.child('/$id').remove();
  }
}
