import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:parking_shared/parking_shared.dart';
import '../repositories/Vehicle.repository.dart';

final vehicleRepository = VehicleRepository();

// POST
Future<Response> postVehicleHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  var vehicle = Vehicle.fromJSON(json);

  vehicle = await vehicleRepository.add(vehicle);

  try {
    return Response.ok(
      jsonEncode(vehicle.toJSON()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError();
  }
}

// GET ALL
Future<Response> getAllVehiclesHandler(Request request) async {
  final vehicles = await vehicleRepository.getAll();
  try {
    return Response.ok(
      jsonEncode(vehicles.map((vehicle) => vehicle.toJSON()).toList()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.notFound('Vehicles not found');
  }
}

// GET
Future<Response> getVehicleHandler(Request request, String id) async {
  final vehicle = await vehicleRepository.getById(id);
  if (vehicle != null) {
    return Response.ok(
      jsonEncode(vehicle.toJSON()),
      headers: {'Content-Type': 'application/json'},
    );
  } else {
    return Response.notFound('No vehicle matching $id');
  }
}

// UPDATE
Future<Response> updateVehicleHandler(Request request, String id) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final updatedVehicle = Vehicle.fromJSON(json);

  try {
    var updated = await vehicleRepository.update(id, updatedVehicle);
    if (updated != null) {
      return Response.ok(
        jsonEncode(updated.toJSON()),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      return Response.internalServerError(
          body: {"message": "Failed db update"});
    }
  } catch (e) {
    return Response.notFound('Vehicle not found');
  }
}

// DELETE
Future<Response> deleteVehicleHandler(Request request, String id) async {
  try {
    vehicleRepository.delete(id);
    return Response.ok('Vehicle deleted successfully');
  } catch (e) {
    return Response.notFound('Vehicle not found');
  }
}
