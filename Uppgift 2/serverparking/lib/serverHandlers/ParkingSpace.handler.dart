import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:serverparking_shared/serverparking_shared.dart';
import '../repositories/ParkingSpace.repository.dart';

final parkingSpaceRepository = ParkingSpaceRepository();

// POST
Future<Response> postParkingSpaceHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  var parkingSpace = ParkingSpace.fromJSON(json);

  parkingSpace = await parkingSpaceRepository.add(parkingSpace);

  try {
    return Response.ok(
      jsonEncode(parkingSpace.toJSON()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError();
  }
}

// GET ALL
Future<Response> getAllParkingSpacesHandler(Request request) async {
  final parkingSpaces = await parkingSpaceRepository.getAll();
  try {
    return Response.ok(
      jsonEncode(parkingSpaces
          .map((parkingSpaces) => parkingSpaces.toJSON())
          .toList()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.notFound('Parking spaces not found');
  }
}

// GET
Future<Response> getParkingSpaceHandler(Request request, String id) async {
  final parkingSpace = await parkingSpaceRepository.getById(id);
  if (parkingSpace != null) {
    return Response.ok(
      jsonEncode(parkingSpace.toJSON()),
      headers: {'Content-Type': 'application/json'},
    );
  } else {
    return Response.notFound('No parking space matching $id');
  }
}

// UPDATE
Future<Response> updateParkingSpaceHandler(Request request, String id) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final updatedParkingSpace = ParkingSpace.fromJSON(json);

  try {
    var updated = await parkingSpaceRepository.update(id, updatedParkingSpace);
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
    return Response.notFound('Parking space not found');
  }
}

// DELETE
Future<Response> deleteParkingSpaceHandler(Request request, String id) async {
  try {
    parkingSpaceRepository.delete(id);
    return Response.ok('Parking space deleted successfully');
  } catch (e) {
    return Response.notFound('Parking space not found');
  }
}
