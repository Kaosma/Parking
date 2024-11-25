import 'package:firebase_dart/database.dart';
import 'package:serverparking/serverHandlers/router.config.dart';
import 'package:parking_shared/parking_shared.dart';

class ParkingSpaceRepository implements RepositoryInterface<ParkingSpace> {
  final String baseUrl =
      'https://serverparking-9de55-default-rtdb.europe-west1.firebasedatabase.app/';
  DatabaseReference database = FirebaseDatabase(app: RouterConfig.instance.app)
      .reference()
      .child("parkingSpaces");

  @override
  Future<ParkingSpace> add(ParkingSpace parkingSpace) async {
    database.push().set(parkingSpace);
    return parkingSpace;
  }

  Future<ParkingSpace?> getByAddress(String address) async {
    DataSnapshot snapshot = await database.child('/$address').once();

    if (snapshot.value != null) {
      Map<String, dynamic> parkingSpace =
          Map<String, dynamic>.from(snapshot.value as Map);
      return ParkingSpace.fromJSON(parkingSpace);
    } else {
      return null;
    }
  }

  @override
  Future<List<ParkingSpace>> getAll() async {
    DataSnapshot snapshot = await database.once();
    List<ParkingSpace> parkingSpacesList = [];

    if (snapshot.value != null) {
      Map<dynamic, dynamic> parkingSpacesMap =
          snapshot.value as Map<dynamic, dynamic>;
      parkingSpacesMap.forEach((key, value) {
        Map<String, dynamic> parkingSpace =
            Map<String, dynamic>.from(value as Map);
        parkingSpacesList.add(ParkingSpace.fromJSON(parkingSpace));
      });
    }
    return parkingSpacesList;
  }

  @override
  Future<ParkingSpace?> update(
      String address, ParkingSpace newParkingSpace) async {
    try {
      await database.child('/$address').update(newParkingSpace.toJSON());
      return newParkingSpace;
    } catch (e) {
      return null;
    }
  }

  Future<void> delete(String address) async {
    await database.child('/$address').remove();
  }
}
