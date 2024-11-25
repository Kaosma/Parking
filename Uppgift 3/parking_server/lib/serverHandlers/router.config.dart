import 'package:firebase_dart/core.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:firebase_dart/firebase_dart.dart';

import 'Parking.handler.dart';
import 'ParkingSpace.handler.dart';
import 'Person.handler.dart';
import 'Vehicle.handler.dart';

class RouterConfig {
  RouterConfig._privateConstructor();
  static final RouterConfig _instance = RouterConfig._privateConstructor();
  static RouterConfig get instance => _instance;

  late FirebaseApp app;
  late Router router;

  initialize() async {
    var options = FirebaseOptions(
        apiKey: "AIzaSyBo49difNHzRFTc7SL9CsVt2owQrqXpV2E",
        authDomain: "serverparking-9de55.firebaseapp.com",
        projectId: "serverparking-9de55",
        storageBucket: "serverparking-9de55.firebasestorage.app",
        messagingSenderId: "1059671592375",
        appId: "1:1059671592375:web:9492d6deb0dc3cff84ec32");

    app = await Firebase.initializeApp(options: options);

    router = Router()
      // Person routes
      ..post('/person', postPersonHandler)
      ..get('/persons', getAllPersonsHandler)
      ..get('/person/<personalNumber>', getPersonHandler)
      ..put('/person/<personalNumber>', updatePersonHandler)
      ..delete('/person/<personalNumber>', deletePersonHandler)

      // Vehicle routes
      ..post('/vehicle', postVehicleHandler)
      ..get('/vehicles', getAllVehiclesHandler)
      ..get('/vehicle/<registrationNumber>', getVehicleHandler)
      ..put('/vehicle/<registrationNumber>', updateVehicleHandler)
      ..delete('/vehicle/<registrationNumber>', deleteVehicleHandler)

      // ParkingSpace routes
      ..post('/parking-space', postParkingSpaceHandler)
      ..get('/parking-spaces', getAllParkingSpacesHandler)
      ..get('/parking-space/<address>', getParkingSpaceHandler)
      ..put('/parking-space/<address>', updateParkingSpaceHandler)
      ..delete('/parking-space/<address>', deleteParkingSpaceHandler)

      // Parking routes
      ..post('/parking', postParkingHandler)
      ..get('/parkings', getAllParkingsHandler)
      ..get('/parking/<id>', getParkingHandler)
      ..put('/parking/<id>', updateParkingHandler)
      ..delete('/parking/<id>', deleteParkingHandler);
    return router;
  }
}
