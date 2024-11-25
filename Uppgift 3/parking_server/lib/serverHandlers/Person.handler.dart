import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:parking_shared/parking_shared.dart';

import '../repositories/Person.repository.dart';

final personRepository = PersonRepository();

// POST
Future<Response> postPersonHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final person = Person.fromJSON(json);

  personRepository.add(person);

  return Response.ok(null);
}

// GET ALL
Future<Response> getAllPersonsHandler(Request request) async {
  final persons = await personRepository.getAll();
  return Response.ok(
    jsonEncode(persons.map((person) => person.toJSON()).toList()),
    headers: {'Content-Type': 'application/json'},
  );
}

// GET
Future<Response> getPersonHandler(Request request, int personalNumber) async {
  final person = await personRepository.getByPersonalNumber(personalNumber);
  return Response.ok(
    jsonEncode(person),
    headers: {'Content-Type': 'application/json'},
  );
}

// UPDATE
Future<Response> updatePersonHandler(Request request, Person person) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final updatedPerson = Person.fromJSON(json);

  try {
    personRepository.update(person.personalNumber.toString(), updatedPerson);
    return Response.ok('Person updated successfully');
  } catch (e) {
    return Response.notFound('Person not found');
  }
}

// DELETE
Future<Response> deletePersonHandler(Request request, Person person) async {
  try {
    personRepository.delete(person.personalNumber);
    return Response.ok('Person deleted successfully');
  } catch (e) {
    return Response.notFound('Person not found');
  }
}
