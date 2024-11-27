import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:parking_shared/parking_shared.dart';

import '../repositories/Person.repository.dart';

final personRepository = PersonRepository();

// POST
Future<Response> postPersonHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  var person = Person.fromJSON(json);

  person = await personRepository.add(person);

  try {
    return Response.ok(
      jsonEncode(person.toJSON()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError();
  }
}

// GET ALL
Future<Response> getAllPersonsHandler(Request request) async {
  final persons = await personRepository.getAll();
  try {
    return Response.ok(
      jsonEncode(persons.map((person) => person.toJSON()).toList()),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.notFound('Persons not found');
  }
}

// GET
Future<Response> getPersonHandler(Request request, String id) async {
  final person = await personRepository.getById(id);
  if (person != null) {
    return Response.ok(
      jsonEncode(person.toJSON()),
      headers: {'Content-Type': 'application/json'},
    );
  } else {
    return Response.notFound('No person matching $id');
  }
}

// UPDATE
Future<Response> updatePersonHandler(Request request, String id) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final updatedPerson = Person.fromJSON(json);

  try {
    var updated = await personRepository.update(id, updatedPerson);
    if (updated != null) {
      return Response.ok(
        jsonEncode(updated.toJSON()),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      return Response.internalServerError(
          body: {"message": "failed db update"});
    }
  } catch (e) {
    return Response.notFound('Person not found');
  }
}

// DELETE
Future<Response> deletePersonHandler(Request request, String id) async {
  try {
    personRepository.delete(id);
    return Response.ok('Person deleted successfully');
  } catch (e) {
    return Response.notFound('Person not found');
  }
}
