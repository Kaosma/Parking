import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:serverparking_shared/serverparking_shared.dart';

class ParkingRepository implements RepositoryInterface<Parking> {
  Future<Parking> getById(String id) async {
    final uri = Uri.parse("http://localhost:8080/parkings/$id");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Parking.fromJSON(json);
  }

  @override
  Future<Parking> add(Parking parking) async {
    final uri = Uri.parse("http://localhost:8080/parkings");

    Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parking.toJSON()));

    final json = jsonDecode(response.body);

    return Parking.fromJSON(json);
  }

  @override
  Future<List<Parking>> getAll() async {
    final uri = Uri.parse("http://localhost:8080/parkings");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return (json as List).map((parking) => Parking.fromJSON(parking)).toList();
  }

  Future<Parking> delete(String id) async {
    final uri = Uri.parse("http://localhost:8080/parkings/$id");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Parking.fromJSON(json);
  }

  @override
  Future<Parking> update(String id, Parking parking) async {
    final uri = Uri.parse("http://localhost:8080/parkings/$id");

    Response response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(parking.toJSON()));

    final json = jsonDecode(response.body);

    return Parking.fromJSON(json);
  }
}
