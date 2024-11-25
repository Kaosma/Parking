import 'package:firebase_dart/database.dart';
import 'package:serverparking/serverHandlers/router.config.dart';
import 'package:parking_shared/parking_shared.dart';
import 'package:http/http.dart' as http;

class PersonRepository implements RepositoryInterface<Person> {
  final String baseUrl =
      'https://serverparking-9de55-default-rtdb.europe-west1.firebasedatabase.app/';
  DatabaseReference database = FirebaseDatabase(app: RouterConfig.instance.app)
      .reference()
      .child("persons");

  // @override
  // Future<Person> add(Person person) async {
  //   database.push().set(person);
  //   return person;
  // }

  @override
  Future<Person> add(Person person) async {
    final url = Uri.parse(
        '$baseUrl/persons.json?auth=AIzaSyBo49difNHzRFTc7SL9CsVt2owQrqXpV2E');
    final response = await http.post(
      url,
      body: person.toJSON(),
    );

    if (response.statusCode == 200) {
      print('success');
    } else {
      print('Failed to create data: ${response.body}');
    }
    return person;
  }

  Future<Person?> getByPersonalNumber(int personalNumber) async {
    DataSnapshot snapshot = await database.child('/$personalNumber').once();

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
  Future<Person?> update(String personalNumber, Person newPerson) async {
    try {
      await database.child('/$personalNumber').update(newPerson.toJSON());
      return newPerson;
    } catch (e) {
      return null;
    }
  }

  Future<void> delete(int personalNumber) async {
    await database.child('/$personalNumber').remove();
  }
}
