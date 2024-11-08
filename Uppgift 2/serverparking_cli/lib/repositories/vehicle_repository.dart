import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:serverparking_shared/serverparking_shared.dart';

class VehicleRepository implements RepositoryInterface<Vehicle> {
  Future<Vehicle> getByRegistrationNumber(String registrationNumber) async {
    final uri = Uri.parse("http://localhost:8080/vehicles/$registrationNumber");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Vehicle.fromJSON(json);
  }

  @override
  Future<Vehicle> add(Vehicle vehicle) async {
    final uri = Uri.parse("http://localhost:8080/vehicles");

    Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(vehicle.toJSON()));

    final json = jsonDecode(response.body);

    return Vehicle.fromJSON(json);
  }

  @override
  Future<List<Vehicle>> getAll() async {
    final uri = Uri.parse("http://localhost:8080/vehicles");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return (json as List).map((vehicle) => Vehicle.fromJSON(vehicle)).toList();
  }

  Future<Vehicle> delete(String registrationNumber) async {
    final uri = Uri.parse("http://localhost:8080/vehicles/$registrationNumber");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Vehicle.fromJSON(json);
  }

  @override
  Future<Vehicle> update(String id, Vehicle vehicle) async {
    final uri = Uri.parse("http://localhost:8080/vehicles/$id");

    Response response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(vehicle.toJSON()));

    final json = jsonDecode(response.body);

    return Vehicle.fromJSON(json);
  }
}
