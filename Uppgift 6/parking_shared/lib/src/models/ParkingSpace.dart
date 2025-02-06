import '../helpers/functions/generateUuid.dart';

class ParkingSpace {
  String address;
  int price;
  String id;
  ParkingSpace(this.address, this.price, [String? id])
      : id = id ?? generateUuid();

  Map<String, dynamic> toJSON() {
    return {
      'address': address,
      'price': price,
      'id': id,
    };
  }

  factory ParkingSpace.fromJSON(Map<String, dynamic> json) {
    return ParkingSpace(json['address'], json['price'], json['id']);
  }

  @override
  String toString() => '[Id: $id, Adress: $address, $price kr per timme]';
}
