import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

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
  final client = http.Client;
  List<T> _items = [];

  Repository([List<T>? initialItems]) {
    if (initialItems != null) {
      _items = initialItems;
    }
  }

  Future<List<T>> getItemsFromServer() async {
    final response = await client.get(Uri.parse('$baseUrl/items'));
    if (response.statusCode = 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to get items;');
    }
  }

  void updateItem(T item, T newItem) {
    var index = _items.indexWhere((element) => element == item);
    _items[index] = newItem;
  }

  void deleteItem(T item) => _items.remove(item);
}

class PersonRepository extends Repository<Person> {
  static final PersonRepository _instance = PersonRepository._internal();

  PersonRepository._internal()
      : super([Person('Carl', 9811102467), Person('Gustav', 9211103456)]);

  factory PersonRepository() => _instance;

  Future<Person> getByPersonalNumber(int personalNumber) async =>
      _items.singleWhere((element) => element.personalNumber == personalNumber);

  Future<void> addItem(Person person) async {
    final uri = Uri.parse('http://localhost:8000/persons');
    final response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': person.name,
          'personalNumber': person.personalNumber,
          'id': person.id
        }));
    final json = jsonDecode(response.body);
    print(json);
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

  // Future<Vehicle> getByRegistrationNumber() async {
  //   final response = await http.get(Uri.parse('http://localhost:8000/'));
  //   if (response.statusCode = 200)
  //     return response.body;
  //   else
  //     throw Exception('Failed to load data');
  // }

  Future<Vehicle> getByRegistrationNumber(String registrationNumber) async =>
      _items.singleWhere(
          (element) => element.registrationNumber == registrationNumber);
}

class ParkingSpaceRepository extends Repository<ParkingSpace> {
  static final ParkingSpaceRepository _instance =
      ParkingSpaceRepository._internal();

  ParkingSpaceRepository._internal() : super([ParkingSpace('Vägvägen 25', 20)]);

  factory ParkingSpaceRepository() => _instance;

  Future<ParkingSpace> getByAddress(String address) async =>
      _items.singleWhere((element) => element.address == address);
}

class ParkingRepository extends Repository<Parking> {
  static final ParkingRepository _instance = ParkingRepository._internal();

  ParkingRepository._internal()
      : super([
          Parking(Vehicle('GTN037', 'Bil', Person('Carl', 9811102467)),
              ParkingSpace('Vägvägen 25', 20), 1728656065, 1728657000)
        ]);

  factory ParkingRepository() => _instance;

  Future<Parking> getById(String id) async =>
      _items.singleWhere((element) => element.id == id);
}
