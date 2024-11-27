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
        appId: "1:1059671592375:web:9492d6deb0dc3cff84ec32",
        databaseURL:
            'https://serverparking-9de55-default-rtdb.europe-west1.firebasedatabase.app/');

    FirebaseDart.setup();
    app = await Firebase.initializeApp(options: options);

    router = Router()
      // Person routes
      ..post('/persons', postPersonHandler)
      ..get('/persons', getAllPersonsHandler)
      ..get('/persons/<id>', getPersonHandler)
      ..put('/persons/<id>', updatePersonHandler)
      ..delete('/persons/<id>', deletePersonHandler)

      // Vehicle routes
      ..post('/vehicles', postVehicleHandler)
      ..get('/vehicles', getAllVehiclesHandler)
      ..get('/vehicles/<id>', getVehicleHandler)
      ..put('/vehicles/<id>', updateVehicleHandler)
      ..delete('/vehicles/<id>', deleteVehicleHandler)

      // ParkingSpace routes
      ..post('/parking-spaces', postParkingSpaceHandler)
      ..get('/parking-spaces', getAllParkingSpacesHandler)
      ..get('/parking-spaces/<id>', getParkingSpaceHandler)
      ..put('/parking-spaces/<id>', updateParkingSpaceHandler)
      ..delete('/parking-spaces/<id>', deleteParkingSpaceHandler)

      // Parking routes
      ..post('/parkings', postParkingHandler)
      ..get('/parkings', getAllParkingsHandler)
      ..get('/parkings/<id>', getParkingHandler)
      ..put('/parkings/<id>', updateParkingHandler)
      ..delete('/parkings/<id>', deleteParkingHandler);
    return router;
  }
}
