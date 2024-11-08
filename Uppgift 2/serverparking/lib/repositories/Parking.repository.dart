import 'package:firebase_dart/database.dart';
import 'package:serverparking/serverHandlers/router.config.dart';
import 'package:serverparking_shared/serverparking_shared.dart';

class ParkingRepository implements RepositoryInterface<Parking> {
  final String baseUrl =
      'https://serverparking-9de55-default-rtdb.europe-west1.firebasedatabase.app/';
  DatabaseReference database = FirebaseDatabase(app: RouterConfig.instance.app)
      .reference()
      .child("parkings");

  @override
  Future<Parking> add(Parking parking) async {
    database.push().set(parking);
    return parking;
  }

  Future<Parking?> getById(String id) async {
    DataSnapshot snapshot = await database.child('/$id').once();

    if (snapshot.value != null) {
      Map<String, dynamic> parking =
          Map<String, dynamic>.from(snapshot.value as Map);
      return Parking.fromJSON(parking);
    } else {
      return null;
    }
  }

  @override
  Future<List<Parking>> getAll() async {
    DataSnapshot snapshot = await database.once();
    List<Parking> parkingsList = [];

    if (snapshot.value != null) {
      Map<dynamic, dynamic> parkingsMap =
          snapshot.value as Map<dynamic, dynamic>;
      parkingsMap.forEach((key, value) {
        Map<String, dynamic> parking = Map<String, dynamic>.from(value as Map);
        parkingsList.add(Parking.fromJSON(parking));
      });
    }
    return parkingsList;
  }

  @override
  Future<Parking?> update(String id, Parking newParking) async {
    try {
      await database.child('/$id').update(newParking.toJSON());
      return newParking;
    } catch (e) {
      return null;
    }
  }

  Future<void> delete(String id) async {
    await database.child('/$id').remove();
  }
}
