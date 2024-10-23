import 'dart:io';

import 'package:serverparking/serverFunctions.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler)
  // Person routes
  ..post('/person', postPersonHandler)
  ..get('/persons', getAllPersonsHandler)
  ..get('/person/<id>', getPersonHandler)
  ..put('/person/<id>', updatePersonHandler)
  ..delete('/person/<id>', deletePersonHandler)

  // Vehicle routes
  ..post('/vehicle', postVehicleHandler)
  ..get('/vehicles', getAllVehiclesHandler)
  ..get('/vehicle/<id>', getVehicleHandler)
  ..put('/vehicle/<id>', updateVehicleHandler)
  ..delete('/vehicle/<id>', deleteVehicleHandler)

  // ParkingSpace routes
  ..post('/parking-space', postParkingSpaceHandler)
  ..get('/parking-spaces', getAllParkingSpacesHandler)
  ..get('/parking-space/<id>', getParkingSpaceHandler)
  ..put('/parking-space/<id>', updateParkingSpaceHandler)
  ..delete('/parking-space/<id>', deleteParkingSpaceHandler)

  // Parking routes
  ..post('/parking', postParkingHandler)
  ..get('/parkings', getAllParkingsHandler)
  ..get('/parking/<id>', getParkingHandler)
  ..put('/parking/<id>', updateParkingHandler)
  ..delete('/parking/<id>', deleteParkingHandler);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
