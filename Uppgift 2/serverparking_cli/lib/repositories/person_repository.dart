import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:serverparking_shared/serverparking_shared.dart';

class PersonRepository implements RepositoryInterface<Person> {
  Future<Person> getByPersonalNumber(int personalNumber) async {
    final uri = Uri.parse("http://localhost:8080/persons/$personalNumber");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Person.fromJSON(json);
  }

  @override
  Future<Person> add(Person person) async {
    final uri = Uri.parse("http://localhost:8080/persons");

    Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(person.toJSON()));

    final json = jsonDecode(response.body);

    return Person.fromJSON(json);
  }

  @override
  Future<List<Person>> getAll() async {
    final uri = Uri.parse("http://localhost:8080/persons");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return (json as List).map((person) => Person.fromJSON(person)).toList();
  }

  Future<Person> delete(int personalNumber) async {
    final uri = Uri.parse("http://localhost:8080/persons/$personalNumber");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Person.fromJSON(json);
  }

  @override
  Future<Person> update(String id, Person person) async {
    final uri = Uri.parse("http://localhost:8080/persons/$id");

    Response response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(person.toJSON()));

    final json = jsonDecode(response.body);

    return Person.fromJSON(json);
  }
}
