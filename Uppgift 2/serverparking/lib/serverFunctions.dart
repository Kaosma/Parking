import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'classes.dart';

final personRepository = PersonRepository();
final vehicleRepository = VehicleRepository();
final parkingSpaceRepository = ParkingSpaceRepository();
final parkingRepository = ParkingRepository();

Future<Response> postPersonHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final person = Person.fromJSON(json);

  personRepository.addItem(person);

  return Response.ok(null);
}

Future<Response> postVehicleHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final vehicle = Vehicle.fromJSON(json);

  vehicleRepository.addItem(vehicle);

  return Response.ok(null);
}

Future<Response> postParkingSpaceHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final parkingSpace = ParkingSpace.fromJSON(json);

  parkingSpaceRepository.addItem(parkingSpace);

  return Response.ok(null);
}

Future<Response> postParkingHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final parking = Parking.fromJSON(json);

  parkingRepository.addItem(parking);

  return Response.ok(null);
}

Future<Response> getAllPersonsHandler(Request request) async {
  final persons = await personRepository.getItems;
  return Response.ok(
    jsonEncode(persons.map((person) => person.toJSON()).toList()),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getAllVehiclesHandler(Request request) async {
  final vehicles = await vehicleRepository.getItems;
  return Response.ok(
    jsonEncode(vehicles.map((vehicle) => vehicle.toJSON()).toList()),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getAllParkingSpacesHandler(Request request) async {
  final parkingSpaces = await parkingSpaceRepository.getItems;
  return Response.ok(
    jsonEncode(
        parkingSpaces.map((parkingSpace) => parkingSpace.toJSON()).toList()),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getAllParkingsHandler(Request request) async {
  final parkings = await parkingRepository.getItems;
  return Response.ok(
    jsonEncode(parkings.map((parking) => parking.toJSON()).toList()),
    headers: {'Content-Type': 'application/json'},
  );
}
