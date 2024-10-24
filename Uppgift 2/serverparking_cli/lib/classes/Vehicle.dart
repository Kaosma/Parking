import 'Person.dart';
import '../functions/helperFunctions.dart';

class Vehicle {
  String id = generateUuid();
  String registrationNumber;
  String type;
  Person owner;
  Vehicle(this.registrationNumber, this.type, this.owner);

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'registrationNumber': registrationNumber,
      'type': type,
      'owner': owner,
    };
  }

  factory Vehicle.fromJSON(Map<String, dynamic> json) {
    return Vehicle(json['registrationNumber'], json['type'], json['owner']);
  }

  @override
  String toString() =>
      '[Registreringsnummber: $registrationNumber, Fordonstyp: $type, Ägare: $owner]';
}
