import 'package:cloud_firestore/cloud_firestore.dart';

class City {
  final String cityName, date, discount, imageUrl, realPrice, discountedPrice;

  City.fromMap(Map<String, dynamic> map)
      : assert(map['cityName'] != null),
        assert(map['date'] != null),
        assert(map['discount'] != null),
        assert(map['discountedPrice'] != null),
        assert(map['imageUrl'] != null),
        assert(map['realPrice'] != null),
        cityName = map['cityName'],
        date = map['date'],
        discount = map['discount'],
        imageUrl = map['imageUrl'],
        discountedPrice = map['discountedPrice'],
        realPrice = map['realPrice'];

  City.fromSnapshots(DocumentSnapshot snapshot) : this.fromMap(snapshot.data);
}
