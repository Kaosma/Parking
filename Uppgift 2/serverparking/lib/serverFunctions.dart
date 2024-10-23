import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'classes.dart';

final personRepository = PersonRepository();
final vehicleRepository = VehicleRepository();
final parkingSpaceRepository = ParkingSpaceRepository();
final parkingRepository = ParkingRepository();

// POST
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

// GET ALL
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

// GET
Future<Response> getPersonHandler(Request request, String id) async {
  final persons = await personRepository.getItems;
  final person = persons.singleWhere((element) => element.id == id);
  return Response.ok(
    jsonEncode(person.toJSON()),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getVehicleHandler(Request request, String id) async {
  final vehicles = await vehicleRepository.getItems;
  final vehicle = vehicles.singleWhere((element) => element.id == id);
  return Response.ok(
    jsonEncode(vehicle.toJSON()),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getParkingSpaceHandler(Request request, String id) async {
  final parkingSpaces = await parkingSpaceRepository.getItems;
  final parkingSpace = parkingSpaces.singleWhere((element) => element.id == id);
  return Response.ok(
    jsonEncode(parkingSpace.toJSON()),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getParkingHandler(Request request, String id) async {
  final parkings = await parkingRepository.getItems;
  final parking = parkings.singleWhere((element) => element.id == id);
  return Response.ok(
    jsonEncode(parking.toJSON()),
    headers: {'Content-Type': 'application/json'},
  );
}

// UPDATE
Future<Response> updatePersonHandler(Request request, Person person) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final updatedPerson = Person.fromJSON(json);

  try {
    personRepository.updateItem(person, updatedPerson);
    return Response.ok('Person updated successfully');
  } catch (e) {
    return Response.notFound('Person not found');
  }
}

Future<Response> updateVehicleHandler(Request request, Vehicle vehicle) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final updatedVehicle = Vehicle.fromJSON(json);

  try {
    vehicleRepository.updateItem(vehicle, updatedVehicle);
    return Response.ok('Vehicle updated successfully');
  } catch (e) {
    return Response.notFound('Vehicle not found');
  }
}

Future<Response> updateParkingSpaceHandler(
    Request request, ParkingSpace parkingSpace) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final updatedParkingSpace = ParkingSpace.fromJSON(json);

  try {
    parkingSpaceRepository.updateItem(parkingSpace, updatedParkingSpace);
    return Response.ok('Parking space updated successfully');
  } catch (e) {
    return Response.notFound('Parking space not found');
  }
}

Future<Response> updateParkingHandler(Request request, Parking parking) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final updatedParking = Parking.fromJSON(json);

  try {
    parkingRepository.updateItem(parking, updatedParking);
    return Response.ok('Parking updated successfully');
  } catch (e) {
    return Response.notFound('Parking not found');
  }
}

// DELETE

Future<Response> deletePersonHandler(Request request, Person person) async {
  try {
    personRepository.deleteItem(person);
    return Response.ok('Person deleted successfully');
  } catch (e) {
    return Response.notFound('Person not found');
  }
}

Future<Response> deleteVehicleHandler(Request request, Vehicle vehicle) async {
  try {
    vehicleRepository.deleteItem(vehicle);
    return Response.ok('Vehicle deleted successfully');
  } catch (e) {
    return Response.notFound('Vehicle not found');
  }
}

Future<Response> deleteParkingSpaceHandler(
    Request request, ParkingSpace parkingSpace) async {
  try {
    parkingSpaceRepository.deleteItem(parkingSpace);
    return Response.ok('Parking space deleted successfully');
  } catch (e) {
    return Response.notFound('Parking space not found');
  }
}

Future<Response> deleteParkingHandler(Request request, Parking parking) async {
  try {
    parkingRepository.deleteItem(parking);
    return Response.ok('Parking deleted successfully');
  } catch (e) {
    return Response.notFound('Parking not found');
  }
}
