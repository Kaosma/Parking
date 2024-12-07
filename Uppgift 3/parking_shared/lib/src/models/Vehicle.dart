import '../helpers/functions/generateUuid.dart';
import 'Person.dart';

class Vehicle {
  String registrationNumber;
  String type;
  Person owner;
  String id;
  Vehicle(this.registrationNumber, this.type, this.owner, [String? id])
      : id = id ?? generateUuid();

  Map<String, dynamic> toJSON() {
    return {
      'registrationNumber': registrationNumber,
      'type': type,
      'owner': owner.toJSON(),
      'id': id,
    };
  }

  factory Vehicle.fromJSON(Map<String, dynamic> json) {
    return Vehicle(json['registrationNumber'], json['type'],
        Person.fromJSON(json['owner']), json['id']);
  }

  @override
  String toString() =>
      '[Id: $id, Registreringsnummber: $registrationNumber, Fordonstyp: $type, Ägare: $owner]';
}
