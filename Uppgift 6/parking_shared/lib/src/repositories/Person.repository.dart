import 'dart:convert';

import 'package:parking_shared/parking_shared.dart';
import 'package:firebase_database/firebase_database.dart';

class PersonRepository implements RepositoryInterface<Person> {
  DatabaseReference database = FirebaseDatabase.instance.ref().child("persons");
  final authRepository = FirebaseAuthRepository();

  @override
  Future<Person> add(Person person) async {
    try {
      final credentials = await authRepository.register(
          email: person.email, password: person.password);
      final user = credentials.user;
      if (user != null) {
        person.id = user.uid;
        await database.child('/${user.uid}').set(person.toJSON());
      }
    } on Exception catch (e) {
      print(e);
    }
    return person;
  }

  @override
  Future<Person?> getById(String id) async {
    DatabaseEvent event = await database.child('/$id').once();
    if (event.snapshot.value != null) {
      dynamic personMap = event.snapshot.value;
      Map<String, dynamic> person =
          Map<String, dynamic>.from(json.decode(json.encode(personMap)));
      return Person.fromJSON(person);
    } else {
      return null;
    }
  }

  @override
  Future<List<Person>> getAll() async {
    DatabaseEvent event = await database.once();
    List<Person> personsList = [];

    if (event.snapshot.value != null) {
      dynamic personsMap = event.snapshot.value;
      personsMap.forEach((key, value) {
        Map<String, dynamic> person =
            Map<String, dynamic>.from(json.decode(json.encode(value)));
        personsList.add(Person.fromJSON(person));
      });
    }
    return personsList;
  }

  @override
  Future<Person?> update(Person newPerson) async {
    try {
      await database.child('/${newPerson.id}').update(newPerson.toJSON());
      final vehiclesSnapshot = await database.child('vehicles').get();
      if (vehiclesSnapshot.exists) {
        final vehiclesMap = vehiclesSnapshot.value as Map<String, dynamic>;
        final vehiclesToUpdate = vehiclesMap.entries.where((entry) {
          final vehicle = Vehicle.fromJSON(entry.value);
          return vehicle.owner.id == newPerson.id;
        });

        for (var entry in vehiclesToUpdate) {
          final vehicle = Vehicle.fromJSON(entry.value);
          vehicle.owner = newPerson;
          await database
              .child('vehicles/${entry.key}')
              .update(vehicle.toJSON());
        }
      }
      return newPerson;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> delete(Person person) async {
    await database.child('/${person.id}').remove();
    final vehiclesSnapshot = await database.child('vehicles').get();
    if (vehiclesSnapshot.exists) {
      final vehiclesMap = vehiclesSnapshot.value as Map<String, dynamic>;

      final vehiclesToDelete = vehiclesMap.entries.where((entry) {
        final vehicle = Vehicle.fromJSON(entry.value);
        return vehicle.owner.id == person.id;
      });

      for (var entry in vehiclesToDelete) {
        await database.child('vehicles/${entry.key}').remove();
      }
    }
  }

  Stream<List<Person>> getPersonsStream() {
    return database.onValue.map((event) {
      if (event.snapshot.value != null) {
        dynamic personsMap = event.snapshot.value;
        List<Person> personsList = [];
        personsMap.forEach((key, value) {
          Map<String, dynamic> person =
              Map<String, dynamic>.from(json.decode(json.encode(value)));
          personsList.add(Person.fromJSON(person));
        });
        return personsList;
      } else {
        return [];
      }
    });
  }
}
