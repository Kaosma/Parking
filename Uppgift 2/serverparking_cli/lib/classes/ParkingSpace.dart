import '../functions/helperFunctions.dart';

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
