import 'dart:math';

String generateUuid() {
  final random = Random();

  String fourRandomHexDigits() {
    return random.nextInt(0x10000).toRadixString(16).padLeft(4, '0');
  }

  return '${fourRandomHexDigits()}${fourRandomHexDigits()}-${fourRandomHexDigits()}${fourRandomHexDigits()}';
}

String convertUnixToDateTime(unixTimestamp) {
  return DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000).toString();
}

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

class ParkingSpace {
  String id = generateUuid();
  String address;
  int price;
  ParkingSpace(this.address, this.price);

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'address': address,
      'price': price,
    };
  }

  factory ParkingSpace.fromJSON(Map<String, dynamic> json) {
    return ParkingSpace(json['address'], json['price']);
  }

  @override
  String toString() => '[$id, $address, $price kr per timme]';
}

class Parking {
  String id = generateUuid();
  Vehicle vehicle;
  ParkingSpace parkingSpace;
  int startTime;
  int endTime;
  Parking(this.vehicle, this.parkingSpace, this.startTime, this.endTime);

  int calculateParkingPrice() {
    double timeOfParking = (endTime - startTime) / 3600;
    return (timeOfParking * parkingSpace.price).round();
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'vehicle': vehicle,
      'parkingSpace': parkingSpace,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory Parking.fromJSON(Map<String, dynamic> json) {
    return Parking(json['vehicle'], json['parkingSpace'], json['startTime'],
        json['endTime']);
  }

  @override
  String toString() {
    String convertedStarttime = convertUnixToDateTime(startTime);
    String convertedEndtime = convertUnixToDateTime(endTime);
    int parkingPrice = calculateParkingPrice();
    return '[$id, $vehicle, $parkingSpace, $convertedStarttime-$convertedEndtime, Parking price: $parkingPrice kr]';
  }
}

abstract class Repository<T> {
  final String baseUrl = '';
  // final client = http.Client;
  List<T> _items = [];

  Repository([List<T>? initialItems]) {
    if (initialItems != null) {
      _items = initialItems;
    }
  }

  Future<void> addItem(T item) async => _items.add(item);

  Future<List<T>> get getItems async => _items;

  Future<void> updateItem(T item, T newItem) async {
    var index = _items.indexWhere((element) => element == item);
    _items[index] = newItem;
  }

  Future<void> deleteItem(T item) async => _items.remove(item);
}

class PersonRepository extends Repository<Person> {
  static final PersonRepository _instance = PersonRepository._internal();

  PersonRepository._internal()
      : super([Person('Carl', 9811102467), Person('Gustav', 9211103456)]);

  factory PersonRepository() => _instance;

  Future<Person> getByPersonalNumber(int personalNumber) async {
    if (_items
        .any((Person element) => element.personalNumber == personalNumber)) {
      print(
          '222222 ${_items.singleWhere((element) => element.personalNumber == personalNumber)} 222222');
      final person = _items
          .singleWhere((element) => element.personalNumber == personalNumber);
      return person;
    } else {
      throw Exception('Person does not exist');
    }
  }
}

class VehicleRepository extends Repository<Vehicle> {
  static final VehicleRepository _instance = VehicleRepository._internal();

  VehicleRepository._internal()
      : super([
          Vehicle('GTN037', 'Bil', Person('Carl', 9811102467)),
          Vehicle('ABC123', 'Motorcykel', Person('Gustav', 9211103456))
        ]);

  factory VehicleRepository() => _instance;

  Future<Vehicle> getByRegistrationNumber(String registrationNumber) async {
    if (_items
        .any((element) => element.registrationNumber == registrationNumber)) {
      final vehicle = _items.singleWhere(
          (element) => element.registrationNumber == registrationNumber);
      return vehicle;
    } else {
      throw Exception('Vehicle does not exist');
    }
  }
}

class ParkingSpaceRepository extends Repository<ParkingSpace> {
  static final ParkingSpaceRepository _instance =
      ParkingSpaceRepository._internal();

  ParkingSpaceRepository._internal() : super([ParkingSpace('Vägvägen 25', 20)]);

  factory ParkingSpaceRepository() => _instance;

  Future<ParkingSpace> getByAddress(String address) async {
    if (_items.any((element) => element.address == address)) {
      final parkingSpace =
          _items.singleWhere((element) => element.address == address);
      return parkingSpace;
    } else {
      throw Exception('Parkingspace does not exist');
    }
  }
}

class ParkingRepository extends Repository<Parking> {
  static final ParkingRepository _instance = ParkingRepository._internal();

  ParkingRepository._internal()
      : super([
          Parking(Vehicle('GTN037', 'Bil', Person('Carl', 9811102467)),
              ParkingSpace('Vägvägen 25', 20), 1728656065, 1728657000)
        ]);

  factory ParkingRepository() => _instance;

  Future<Parking> getById(String id) async {
    if (_items.any((element) => element.id == id)) {
      final parking = _items.singleWhere((element) => element.id == id);
      return parking;
    } else {
      throw Exception('Parking does not exist');
    }
  }
}
