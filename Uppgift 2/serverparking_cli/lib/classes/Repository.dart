import 'dart:convert';

import 'Parking.dart';
import 'ParkingSpace.dart';
import 'Person.dart';
import 'Vehicle.dart';

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

  // Future<List<T>> getItemsFromServer() async {
  //   final response = await client.get(Uri.parse('$baseUrl/items'));
  //   if (response.statusCode = 200) {
  //     final jsonResponse = jsonDecode(response.body);
  //     return jsonResponse;
  //   } else {
  //     throw Exception('Failed to get items;');
  //   }
  // }

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

  // Future<void> addPersonItem(Person person) async {
  //   final uri = Uri.parse('http://localhost:8000/persons');
  //   final response = await http.post(uri,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'name': person.name,
  //         'personalNumber': person.personalNumber,
  //         'id': person.id
  //       }));
  //   final json = jsonDecode(response.body);
  //   print(json);
  // }
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
