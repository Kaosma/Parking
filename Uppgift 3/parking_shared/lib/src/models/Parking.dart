import '../helpers/convertUnixToDateTime.dart';
import '../helpers/generateUuid.dart';
import 'ParkingSpace.dart';
import 'Vehicle.dart';

class Parking {
  String id;
  Vehicle vehicle;
  ParkingSpace parkingSpace;
  int startTime;
  int endTime;
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
      'id': id,
      'vehicle': vehicle,
      'parkingSpace': parkingSpace,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory Parking.fromJSON(Map<String, dynamic> json) {
    return Parking(
        id: json['id'],
        vehicle: json['vehicle'],
        parkingSpace: json['parkingSpace'],
        startTime: json['startTime'],
        endTime: json['endTime']);
  }

  @override
  String toString() {
    String convertedStarttime = convertUnixToDateTime(startTime);
    String convertedEndtime = convertUnixToDateTime(endTime);
    int parkingPrice = calculateParkingPrice();
    return '[$id, $vehicle, $parkingSpace, $convertedStarttime-$convertedEndtime, Parking price: $parkingPrice kr]';
  }
}
