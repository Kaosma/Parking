import '../../parking_shared.dart';

class Person {
  String id;
  String name;
  int personalNumber;
  Person(this.name, this.personalNumber, [String? id])
      : id = id ?? generateUuid();

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'name': name,
      'personalNumber': personalNumber,
    };
  }

  factory Person.fromJSON(Map<String, dynamic> json) {
    return Person(json['id'], json['name'], json['personalNumber']);
  }

  @override
  String toString() => '[Namn: $name, Personnummer: $personalNumber]';
}
