import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:serverparking_shared/serverparking_shared.dart';
import 'Parking.handler.dart';

// POST
Future<Response> postVehicleHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final vehicle = Vehicle.fromJSON(json);

  vehicleRepository.add(vehicle);

  return Response.ok(null);
}

// GET ALL
Future<Response> getAllVehiclesHandler(Request request) async {
  final vehicles = await vehicleRepository.getAll();
  return Response.ok(
    jsonEncode(vehicles.map((vehicle) => vehicle.toJSON()).toList()),
    headers: {'Content-Type': 'application/json'},
  );
}

// GET
Future<Response> getVehicleHandler(
    Request request, String registrationNumber) async {
  final vehicle =
      await vehicleRepository.getByRegistrationNumber(registrationNumber);
  return Response.ok(
    jsonEncode(vehicle),
    headers: {'Content-Type': 'application/json'},
  );
}

// UPDATE
Future<Response> updateVehicleHandler(Request request, Vehicle vehicle) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final updatedVehicle = Vehicle.fromJSON(json);

  try {
    vehicleRepository.update(vehicle.registrationNumber, updatedVehicle);
    return Response.ok('Vehicle updated successfully');
  } catch (e) {
    return Response.notFound('Vehicle not found');
  }
}

// DELETE
Future<Response> deleteVehicleHandler(Request request, Vehicle vehicle) async {
  try {
    vehicleRepository.delete(vehicle.registrationNumber);
    return Response.ok('Vehicle deleted successfully');
  } catch (e) {
    return Response.notFound('Vehicle not found');
  }
}
