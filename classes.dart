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
  String id = generateUuid();
  String address;
  int price;
  ParkingSpace(this.address, this.price);
  @override
  String toString() => '$id, $address, $price kr per timme';
}

class Parking {
  String id = generateUuid();
  Vehicle vehicle;
  ParkingSpace parkingSpace;
  int startTime;
  int endTime;
  Parking(this.vehicle, this.parkingSpace, this.startTime, this.endTime);
  @override
  String toString() => '$id, $vehicle, $parkingSpace, $startTime - $endTime';
}

abstract class Repository<T> {
  List<T> _items = [];

  // Constructor to initialize with an optional list of items
  Repository([List<T>? initialItems]) {
    if (initialItems != null) {
      _items = initialItems;
    }
  }

  void addItem(T item) => _items.add(item);

  List<T> get getItems => _items;

  void updateItem(T item, T newItem) {
    var index = _items.indexWhere((element) => element == item);
    _items[index] = newItem;
  }

  void deleteItem(T item) => _items.remove(item);
}

class PersonRepository extends Repository<Person> {
  PersonRepository()
      : super([Person('Carl', 9811102467), Person('Gustav', 9211103456)]);
  Person getByPersonalNumber(int personalNumber) =>
      _items.singleWhere((element) => element.personalNumber == personalNumber);
}

class VehicleRepository extends Repository<Vehicle> {
  VehicleRepository()
      : super([
          Vehicle('GTN037', 'Ford', Person('Carl', 9811102467)),
          Vehicle('ABC123', 'Citroen', Person('Gustav', 9211103456))
        ]);
  Vehicle getByRegistrationNumber(String registrationNumber) =>
      _items.singleWhere(
          (element) => element.registrationNumber == registrationNumber);
}

class ParkingSpaceRepository extends Repository<ParkingSpace> {
  ParkingSpaceRepository() : super([ParkingSpace('Vägvägen 25', 20)]);
  ParkingSpace getById(String address) =>
      _items.singleWhere((element) => element.address == address);
}

class ParkingRepository extends Repository<Parking> {
  ParkingRepository()
      : super([
          Parking(Vehicle('GTN037', 'Ford', Person('Carl', 9811102467)),
              ParkingSpace('Vägvägen 25', 20), 1728656065, 1728657000)
        ]);
  Parking getById(String id) =>
      _items.singleWhere((element) => element.id == id);
}
