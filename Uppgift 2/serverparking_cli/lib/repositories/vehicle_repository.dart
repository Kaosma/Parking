import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:serverparking_shared/serverparking_shared.dart';

class VehicleRepository implements RepositoryInterface<Vehicle> {
  @override
  Future<Vehicle?> getById(String id) async {
    final uri = Uri.parse("http://localhost:8080/vehicles/$id");
    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      return null;
    }

    final json = jsonDecode(response.body);
    return Vehicle.fromJSON(json);
  }

  @override
  Future<Vehicle?> add(Vehicle vehicle) async {
    final uri = Uri.parse("http://localhost:8080/vehicles");
    Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(vehicle.toJSON()));

    if (response.statusCode != 200) {
      return null;
    }

    final json = jsonDecode(response.body);
    return Vehicle.fromJSON(json);
  }

  @override
  Future<List<Vehicle>> getAll() async {
    final uri = Uri.parse("http://localhost:8080/vehicles");
    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      return [];
    }

    final json = jsonDecode(response.body);
    return (json as List).map((vehicle) => Vehicle.fromJSON(vehicle)).toList();
  }

  @override
  Future<Vehicle?> update(String id, Vehicle vehicle) async {
    final uri = Uri.parse("http://localhost:8080/vehicles/$id");
    Response response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(vehicle.toJSON()));

    if (response.statusCode != 200) {
      return null;
    }

    final json = jsonDecode(response.body);
    return Vehicle.fromJSON(json);
  }

  @override
  Future<void> delete(String id) async {
    final uri = Uri.parse("http://localhost:8080/vehicles/$id");
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
