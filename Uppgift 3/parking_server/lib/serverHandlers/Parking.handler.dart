import 'dart:convert';
import 'package:parking_shared/parking_shared.dart';
import 'package:shelf/shelf.dart';

import '../repositories/Parking.repository.dart';

final parkingRepository = ParkingRepository();

// POST
Future<Response> postParkingHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  var parking = Parking.fromJSON(json);

  parking = await parkingRepository.add(parking);

  try {
    return Response.ok(
      jsonEncode(parking.toJSON()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError();
  }
}

// GET ALL
Future<Response> getAllParkingsHandler(Request request) async {
  final parkings = await parkingRepository.getAll();
  try {
    return Response.ok(
      jsonEncode(parkings.map((parking) => parking.toJSON()).toList()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.notFound('Parkings not found');
  }
}

// GET
Future<Response> getParkingHandler(Request request, String id) async {
  final parking = await parkingRepository.getById(id);
  if (parking != null) {
    return Response.ok(
      jsonEncode(parking.toJSON()),
      headers: {'Content-Type': 'application/json'},
    );
  } else {
    return Response.notFound('No parking matching $id');
  }
}

// UPDATE
Future<Response> updateParkingHandler(Request request, String id) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final updatedParking = Parking.fromJSON(json);

  try {
    var updated = await parkingRepository.update(id, updatedParking);
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
    return Response.notFound('Person not found');
  }
}

// DELETE
Future<Response> deleteParkingHandler(Request request, String id) async {
  try {
    parkingRepository.delete(id);
    return Response.ok('Parking deleted successfully');
  } catch (e) {
    return Response.notFound('Parking not found');
  }
}
