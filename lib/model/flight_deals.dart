import 'package:cloud_firestore/cloud_firestore.dart';

class FlightDeals {
  final String flightName, date, discount, rating;
  final int discountedPrice, realPrice;

  FlightDeals.fromMap(Map<String, dynamic> map)
      : assert(map['flightName'] != null),
        assert(map['date'] != null),
        assert(map['discount'] != null),
        assert(map['rating'] != null),
        assert(map['discountedPrice'] != null),
        flightName = map['flightName'],
        date = map['date'],
        discount = map['discount'],
        realPrice = map['realPrice'],
        discountedPrice = map['discountedPrice'],
        rating = map['rating'];

  FlightDeals.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);
}
