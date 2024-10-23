import 'package:serverparking_cli/functions/helperFunctions.dart';

class Person {
  String id = generateUuid();
  String name;
  int personalNumber;
  Person(this.name, this.personalNumber);

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'name': name,
      'personalNumber': personalNumber,
    };
  }

  factory Person.fromJSON(Map<String, dynamic> json) {
    return Person(json['name'], json['personalNumber']);
  }

  @override
  String toString() => '[Namn: $name, Personnummer: $personalNumber]';
}
