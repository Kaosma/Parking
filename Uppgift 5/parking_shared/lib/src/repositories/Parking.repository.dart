import 'dart:convert';

import 'package:parking_shared/parking_shared.dart';
import 'package:firebase_database/firebase_database.dart';

class ParkingRepository implements RepositoryInterface<Parking> {
  DatabaseReference database =
      FirebaseDatabase.instance.ref().child("parkings");

  @override
  Future<Parking> add(Parking parking) async {
    try {
      await database.child('/${parking.id}').set(parking.toJSON());
      return parking;
    } on Exception catch (e) {
      print(e);
      return parking;
    }
  }

  @override
  Future<Parking?> getById(String id) async {
    DatabaseEvent event = await database.child('/$id').once();
    if (event.snapshot.value != null) {
      dynamic parkingMap = event.snapshot.value;
      Map<String, dynamic> parking =
          Map<String, dynamic>.from(json.decode(json.encode(parkingMap)));
      return Parking.fromJSON(parking);
    } else {
      return null;
    }
  }

  @override
  Future<List<Parking>> getAll() async {
    DatabaseEvent event = await database.once();
    List<Parking> parkingsList = [];

    if (event.snapshot.value != null) {
      dynamic parkingsMap = event.snapshot.value;
      parkingsMap.forEach((key, value) {
        Map<String, dynamic> parking =
            Map<String, dynamic>.from(json.decode(json.encode(value)));
        parkingsList.add(Parking.fromJSON(parking));
      });
    }
    return parkingsList;
  }

  @override
  Future<Parking?> update(Parking newParking) async {
    try {
      await database.child('/${newParking.id}').update(newParking.toJSON());
      return newParking;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> delete(Parking parking) async {
    await database.child('/${parking.id}').remove();
  }

  Stream<List<Parking>> getParkingsStream() {
    return database.onValue.map((event) {
      if (event.snapshot.value != null) {
        dynamic parkingsMap = event.snapshot.value;
        List<Parking> parkingsList = [];
        parkingsMap.forEach((key, value) {
          Map<String, dynamic> parking =
              Map<String, dynamic>.from(json.decode(json.encode(value)));
          parkingsList.add(Parking.fromJSON(parking));
        });
        return parkingsList;
      } else {
        return [];
      }
    });
  }
}
