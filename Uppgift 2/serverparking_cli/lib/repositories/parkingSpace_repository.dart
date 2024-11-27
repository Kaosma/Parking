import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:serverparking_shared/serverparking_shared.dart';

class ParkingSpaceRepository implements RepositoryInterface<ParkingSpace> {
  @override
  Future<ParkingSpace?> getById(String id) async {
    final uri = Uri.parse("http://localhost:8080/parking-spaces/$id");
    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      return null;
    }

    final json = jsonDecode(response.body);
    return ParkingSpace.fromJSON(json);
  }

  @override
  Future<ParkingSpace?> add(ParkingSpace parkingSpace) async {
    final uri = Uri.parse("http://localhost:8080/parking-spaces");
    Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parkingSpace.toJSON()));

    if (response.statusCode != 200) {
      return null;
    }

    final json = jsonDecode(response.body);
    return ParkingSpace.fromJSON(json);
  }

  @override
  Future<List<ParkingSpace>> getAll() async {
    final uri = Uri.parse("http://localhost:8080/parking-spaces");
    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      return [];
    }

    final json = jsonDecode(response.body);
    return (json as List)
        .map((parkingSpace) => ParkingSpace.fromJSON(parkingSpace))
        .toList();
  }

  @override
  Future<ParkingSpace?> update(String id, ParkingSpace parkingSpace) async {
    final uri = Uri.parse("http://localhost:8080/parking-spaces/$id");
    Response response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parkingSpace.toJSON()));

    if (response.statusCode != 200) {
      return null;
    }

    final json = jsonDecode(response.body);
    return ParkingSpace.fromJSON(json);
  }

  @override
  Future<void> delete(String id) async {
    final uri = Uri.parse("http://localhost:8080/parking-spaces/$id");
    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('');
      print('Successfully deleted');
    }
  }
}
