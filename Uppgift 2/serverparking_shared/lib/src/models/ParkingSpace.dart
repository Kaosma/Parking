import '../helpers/generateUuid.dart';

class ParkingSpace {
  String id;
  String address;
  int price;
  ParkingSpace(this.address, this.price, [String? id])
      : id = id ?? generateUuid();

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'address': address,
      'price': price,
    };
  }

  factory ParkingSpace.fromJSON(Map<String, dynamic> json) {
    return ParkingSpace(json['id'], json['address'], json['price']);
  }

  @override
  String toString() => '[$id, $address, $price kr per timme]';
}
