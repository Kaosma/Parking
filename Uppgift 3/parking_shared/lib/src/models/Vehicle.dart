import '../helpers/generateUuid.dart';
import 'Person.dart';

class Vehicle {
  String id;
  String registrationNumber;
  String type;
  Person owner;
  Vehicle(this.registrationNumber, this.type, this.owner, [String? id])
      : id = id ?? generateUuid();

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'registrationNumber': registrationNumber,
      'type': type,
      'owner': owner,
    };
  }

  factory Vehicle.fromJSON(Map<String, dynamic> json) {
    return Vehicle(
        json['id'], json['registrationNumber'], json['type'], json['owner']);
  }

  @override
  String toString() =>
      '[Registreringsnummber: $registrationNumber, Fordonstyp: $type, Ägare: $owner]';
}
