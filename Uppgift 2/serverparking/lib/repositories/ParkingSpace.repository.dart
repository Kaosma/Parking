import 'package:firebase_dart/database.dart';
import 'package:serverparking/serverHandlers/router.config.dart';
import 'package:serverparking_shared/serverparking_shared.dart';

class ParkingSpaceRepository implements RepositoryInterface<ParkingSpace> {
  DatabaseReference database = FirebaseDatabase(app: RouterConfig.instance.app)
      .reference()
      .child("parkingSpaces");

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
    DataSnapshot snapshot = await database.child('/$id').once();

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

  @override
  Future<void> delete(String id) async {
    await database.child('/$id').remove();
  }
}
