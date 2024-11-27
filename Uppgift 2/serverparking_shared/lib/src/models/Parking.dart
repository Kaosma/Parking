import '../helpers/convertUnixToDateTime.dart';
import '../helpers/generate_uuid.dart';
import 'ParkingSpace.dart';
import 'Vehicle.dart';

class Parking {
  Vehicle vehicle;
  ParkingSpace parkingSpace;
  int startTime;
  int endTime;
  String id;
  Parking(
      {required this.vehicle,
      required this.parkingSpace,
      required this.startTime,
      required this.endTime,
      String? id})
      : id = id ?? generateUuid();

  int calculateParkingPrice() {
    double timeOfParking = (endTime - startTime) / 3600;
    return (timeOfParking * parkingSpace.price).round();
  }

  Map<String, dynamic> toJSON() {
    return {
      'vehicle': vehicle.toJSON(),
      'parkingSpace': parkingSpace.toJSON(),
      'startTime': startTime,
      'endTime': endTime,
      'id': id,
    };
  }

  factory Parking.fromJSON(Map<String, dynamic> json) {
    return Parking(
      vehicle: Vehicle.fromJSON(json['vehicle']),
      parkingSpace: ParkingSpace.fromJSON(json['parkingSpace']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      id: json['id'],
    );
  }

  @override
  String toString() {
    String convertedStarttime = convertUnixToDateTime(startTime);
    String convertedEndtime = convertUnixToDateTime(endTime);
    int parkingPrice = calculateParkingPrice();
    return '[Id: $id, Fordon: $vehicle, Plats: $parkingSpace, Tid: $convertedStarttime-$convertedEndtime, Parking price: $parkingPrice kr]';
  }
}
