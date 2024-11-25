import 'dart:convert';
import 'package:parking_shared/parking_shared.dart';
import 'package:shelf/shelf.dart';

import '../repositories/Parking.repository.dart';

final parkingRepository = ParkingRepository();

// POST
Future<Response> postParkingHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final parking = Parking.fromJSON(json);

  parkingRepository.add(parking);

  return Response.ok(null);
}

// GET ALL
Future<Response> getAllParkingsHandler(Request request) async {
  final parkings = await parkingRepository.getAll();
  return Response.ok(
    jsonEncode(parkings.map((parking) => parking.toJSON()).toList()),
    headers: {'Content-Type': 'application/json'},
  );
}

// GET
Future<Response> getParkingHandler(Request request, String id) async {
  final parking = await parkingRepository.getById(id);
  return Response.ok(
    jsonEncode(parking),
    headers: {'Content-Type': 'application/json'},
  );
}

// UPDATE
Future<Response> updateParkingHandler(Request request, Parking parking) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final updatedParking = Parking.fromJSON(json);

  try {
    parkingRepository.update(parking.id, updatedParking);
    return Response.ok('Parking updated successfully');
  } catch (e) {
    return Response.notFound('Parking not found');
  }
}

// DELETE
Future<Response> deleteParkingHandler(Request request, Parking parking) async {
  try {
    parkingRepository.delete(parking.id);
    return Response.ok('Parking deleted successfully');
  } catch (e) {
    return Response.notFound('Parking not found');
  }
}
