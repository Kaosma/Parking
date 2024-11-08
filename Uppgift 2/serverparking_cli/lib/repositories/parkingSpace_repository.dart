import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:serverparking_shared/serverparking_shared.dart';

class ParkingSpaceRepository implements RepositoryInterface<ParkingSpace> {
  Future<ParkingSpace> getByAddress(String address) async {
    final uri = Uri.parse("http://localhost:8080/parkingspaces/$address");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return ParkingSpace.fromJSON(json);
  }

  @override
  Future<ParkingSpace> add(ParkingSpace parkingSpace) async {
    final uri = Uri.parse("http://localhost:8080/parkingspaces");

    Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parkingSpace.toJSON()));

    final json = jsonDecode(response.body);

    return ParkingSpace.fromJSON(json);
  }

  @override
  Future<List<ParkingSpace>> getAll() async {
    final uri = Uri.parse("http://localhost:8080/parkingspaces");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return (json as List)
        .map((parkingSpace) => ParkingSpace.fromJSON(parkingSpace))
        .toList();
  }

  Future<ParkingSpace> delete(String address) async {
    final uri = Uri.parse("http://localhost:8080/parkingspaces/$address");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return ParkingSpace.fromJSON(json);
  }

  @override
  Future<ParkingSpace> update(String id, ParkingSpace parkingSpace) async {
    final uri = Uri.parse("http://localhost:8080/parkingspaces/$id");

    Response response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parkingSpace.toJSON()));

    final json = jsonDecode(response.body);

    return ParkingSpace.fromJSON(json);
  }
}
