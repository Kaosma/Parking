import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:serverparking_shared/serverparking_shared.dart';
import 'Parking.handler.dart';

// POST
Future<Response> postParkingSpaceHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final parkingSpace = ParkingSpace.fromJSON(json);

  parkingSpaceRepository.add(parkingSpace);

  return Response.ok(null);
}

// GET ALL
Future<Response> getAllParkingSpacesHandler(Request request) async {
  final parkingSpaces = await parkingSpaceRepository.getAll();
  return Response.ok(
    jsonEncode(
        parkingSpaces.map((parkingSpace) => parkingSpace.toJSON()).toList()),
    headers: {'Content-Type': 'application/json'},
  );
}

// GET
Future<Response> getParkingSpaceHandler(Request request, String address) async {
  final parkingSpace = await parkingSpaceRepository.getByAddress(address);
  return Response.ok(
    jsonEncode(parkingSpace),
    headers: {'Content-Type': 'application/json'},
  );
}

// UPDATE
Future<Response> updateParkingSpaceHandler(
    Request request, ParkingSpace parkingSpace) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final updatedParkingSpace = ParkingSpace.fromJSON(json);

  try {
    parkingSpaceRepository.update(parkingSpace.address, updatedParkingSpace);
    return Response.ok('Parking space updated successfully');
  } catch (e) {
    return Response.notFound('Parking space not found');
  }
}

// DELETE
Future<Response> deleteParkingSpaceHandler(
    Request request, ParkingSpace parkingSpace) async {
  try {
    parkingSpaceRepository.delete(parkingSpace.address);
    return Response.ok('Parking space deleted successfully');
  } catch (e) {
    return Response.notFound('Parking space not found');
  }
}
