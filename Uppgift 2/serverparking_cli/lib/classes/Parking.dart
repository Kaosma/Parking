import 'ParkingSpace.dart';
import 'Vehicle.dart';
import '../functions/helperFunctions.dart';

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
