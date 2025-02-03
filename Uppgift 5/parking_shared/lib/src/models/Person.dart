import '../../parking_shared.dart';

class Person {
  String name;
  int personalNumber;
  String email;
  String password;
  String id;
  Person(this.name, this.personalNumber, this.email, this.password,
      [String? id])
      : id = id ?? generateUuid();

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'personalNumber': personalNumber,
      'email': email,
      'password': password,
      'id': id,
    };
  }

  factory Person.fromJSON(Map<String, dynamic> json) {
    return Person(json['name'], json['personalNumber'], json['email'],
        json['password'], json['id']);
  }

  @override
  String toString() => '[Id: $id, Namn: $name, Personnummer: $personalNumber]';
}
