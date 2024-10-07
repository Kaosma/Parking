import 'dart:math';

String generateUuid() {
  final random = Random();

  String fourRandomHexDigits() {
    return random.nextInt(0x10000).toRadixString(16).padLeft(4, '0');
  }

  return '${fourRandomHexDigits()}${fourRandomHexDigits()}-${fourRandomHexDigits()}${fourRandomHexDigits()}';
}

class Person {
  String name;
  int personalNumber;
  Person(this.name, this.personalNumber);
}

class Vehicle {
  String registrationNumber;
  String type;
  Person owner;
  Vehicle(this.registrationNumber, this.type, this.owner);
}

class ParkingSpace {
  String _id = generateUuid();
  int address;
  int price;
  ParkingSpace(this._id, this.address, this.price);
}

class Parking {
  String _id = generateUuid();
  Vehicle vehicle;
  ParkingSpace parkingSpace;
  int startTime;
  int endTime;
  Parking(
      this._id, this.vehicle, this.parkingSpace, this.startTime, this.endTime);
}

abstract class Repository<T> {
  List<T> _items = [];

  void add(T item) => _items.add(item);

  List<T> getAll() => _items;

  void update(T item, T newItem) {
    var index = _items.indexWhere((element) => element == item);
    _items[index] = newItem;
  }

  void delete(T item) => _items.remove(item);
}

class PersonRepository extends Repository<Person> {
  Person getByPersonalNumber(int personalNumber) =>
      _items.singleWhere((element) => element.personalNumber == personalNumber);
}

class VehicleRepository extends Repository<Vehicle> {
  Vehicle getByRegistrationNumber(String registrationNumber) =>
      _items.singleWhere(
          (element) => element.registrationNumber == registrationNumber);
}

class ParkingSpaceRepository extends Repository<ParkingSpace> {
  ParkingSpace getById(String id) =>
      _items.singleWhere((element) => element._id == id);
}

class ParkingRepository extends Repository<Parking> {
  Parking getById(String id) =>
      _items.singleWhere((element) => element._id == id);
}
