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
  @override
  String toString() => '$name, $personalNumber';
}

class Vehicle {
  String registrationNumber;
  String type;
  Person owner;
  Vehicle(this.registrationNumber, this.type, this.owner);
  @override
  String toString() => '$registrationNumber, $type, $owner';
}

class ParkingSpace {
  String address;
  int price;
  ParkingSpace(this.address, this.price);
  @override
  String toString() => '$address, $price(kr) per timme';
}

class Parking {
  String id = generateUuid();
  Vehicle vehicle;
  ParkingSpace parkingSpace;
  int startTime;
  int endTime;
  Parking(this.vehicle, this.parkingSpace, this.startTime, this.endTime);
  @override
  String toString() => '$vehicle, $parkingSpace, $startTime - $endTime';
}

abstract class Repository<T> {
  List<T> _items = [];

  void addItem(T item) => _items.add(item);

  List<T> get getItems => _items;

  void updateItem(T item, T newItem) {
    var index = _items.indexWhere((element) => element == item);
    _items[index] = newItem;
  }

  void deleteItem(T item) => _items.remove(item);
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
  ParkingSpace getById(String address) =>
      _items.singleWhere((element) => element.address == address);
}

class ParkingRepository extends Repository<Parking> {
  Parking getById(String id) =>
      _items.singleWhere((element) => element.id == id);
}
