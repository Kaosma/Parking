import 'dart:convert';

import 'package:parking_shared/parking_shared.dart';
import 'package:firebase_database/firebase_database.dart';

class ParkingSpaceRepository implements RepositoryInterface<ParkingSpace> {
  DatabaseReference database =
      FirebaseDatabase.instance.ref().child("parkingSpaces");

  @override
  Future<ParkingSpace> add(ParkingSpace parkingSpace) async {
    try {
      await database.child('/${parkingSpace.id}').set(parkingSpace.toJSON());
      return parkingSpace;
    } on Exception catch (e) {
      print(e);
      return parkingSpace;
    }
  }

  @override
  Future<ParkingSpace?> getById(String id) async {
    DatabaseEvent event = await database.child('/$id').once();
    if (event.snapshot.value != null) {
      dynamic parkingSpaceMap = event.snapshot.value;
      Map<String, dynamic> parkingSpace =
          Map<String, dynamic>.from(json.decode(json.encode(parkingSpaceMap)));
      return ParkingSpace.fromJSON(parkingSpace);
    } else {
      return null;
    }
  }

  @override
  Future<List<ParkingSpace>> getAll() async {
    DatabaseEvent event = await database.once();
    List<ParkingSpace> parkingSpacesList = [];

    if (event.snapshot.value != null) {
      dynamic parkingSpacesMap = event.snapshot.value;
      parkingSpacesMap.forEach((key, value) {
        Map<String, dynamic> parkingSpace =
            Map<String, dynamic>.from(json.decode(json.encode(value)));
        parkingSpacesList.add(ParkingSpace.fromJSON(parkingSpace));
      });
    }
    return parkingSpacesList;
  }

  @override
  Future<ParkingSpace?> update(ParkingSpace newParkingSpace) async {
    try {
      await database
          .child('/${newParkingSpace.id}')
          .update(newParkingSpace.toJSON());

      final parkingsSnapshot = await database.child('parkings').get();
      if (parkingsSnapshot.exists) {
        final parkingsMap = parkingsSnapshot.value as Map<String, dynamic>;
        final parkingsToUpdate = parkingsMap.entries.where((entry) {
          final parking = Parking.fromJSON(entry.value);
          return parking.parkingSpace.id == newParkingSpace.id;
        });

        for (var entry in parkingsToUpdate) {
          final parking = Parking.fromJSON(entry.value);
          parking.parkingSpace = newParkingSpace;
          await database
              .child('parkings/${entry.key}')
              .update(parking.toJSON());
        }
      }
      return newParkingSpace;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> delete(ParkingSpace parkingSpace) async {
    await database.child('/${parkingSpace.id}').remove();
  }

  Stream<List<ParkingSpace>> getParkingSpacesStream() {
    return database.onValue.map((event) {
      if (event.snapshot.value != null) {
        dynamic parkingSpacesMap = event.snapshot.value;
        List<ParkingSpace> parkingSpacesList = [];
        parkingSpacesMap.forEach((key, value) {
          Map<String, dynamic> parkingSpace =
              Map<String, dynamic>.from(json.decode(json.encode(value)));
          parkingSpacesList.add(ParkingSpace.fromJSON(parkingSpace));
        });
        return parkingSpacesList;
      } else {
        return [];
      }
    });
  }
}
