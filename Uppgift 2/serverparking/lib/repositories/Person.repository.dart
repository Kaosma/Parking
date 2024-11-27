import 'package:firebase_dart/database.dart';
import 'package:serverparking/serverHandlers/router.config.dart';
import 'package:serverparking_shared/serverparking_shared.dart';

class PersonRepository implements RepositoryInterface<Person> {
  DatabaseReference database = FirebaseDatabase(app: RouterConfig.instance.app)
      .reference()
      .child("persons");

  @override
  Future<Person> add(Person person) async {
    try {
      await database.child('/${person.id}').set(person.toJSON());
      return person;
    } on Exception catch (e) {
      print(e);
      return person;
    }
  }

  @override
  Future<Person?> getById(String id) async {
    DataSnapshot snapshot = await database.child('/$id').once();

    if (snapshot.value != null) {
      Map<String, dynamic> person =
          Map<String, dynamic>.from(snapshot.value as Map);
      return Person.fromJSON(person);
    } else {
      return null;
    }
  }

  @override
  Future<List<Person>> getAll() async {
    DataSnapshot snapshot = await database.once();
    List<Person> personsList = [];

    if (snapshot.value != null) {
      Map<dynamic, dynamic> personsMap =
          snapshot.value as Map<dynamic, dynamic>;
      personsMap.forEach((key, value) {
        Map<String, dynamic> person = Map<String, dynamic>.from(value as Map);
        personsList.add(Person.fromJSON(person));
      });
    }
    return personsList;
  }

  @override
  Future<Person?> update(String id, Person newPerson) async {
    try {
      await database.child('/$id').update(newPerson.toJSON());
      return newPerson;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> delete(String id) async {
    await database.child('/$id').remove();
  }
}
