import 'package:serverparking_shared/src/helpers/generate_uuid.dart';

class Person {
  String name;
  int personalNumber;
  String id;
  Person(this.name, this.personalNumber, [String? id])
      : id = id ?? generateUuid();

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'personalNumber': personalNumber,
      'id': id,
    };
  }

  factory Person.fromJSON(Map<String, dynamic> json) {
    return Person(json['name'], json['personalNumber'], json['id']);
  }

  @override
  String toString() => '[Id: $id, Namn: $name, Personnummer: $personalNumber]';
}
