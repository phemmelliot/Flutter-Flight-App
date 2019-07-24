import 'package:flutter/material.dart';
import 'package:flight_appplication/model/flight_deals.dart';
import 'package:flight_appplication/components/flight_card.dart';

const dropDownItemsStyle = TextStyle(color: Colors.black, fontSize: 18.0);
const dropDownMenuText = TextStyle(color: Colors.white, fontSize: 16.0);

List<String> locations = [
  'Boston (BS)',
  'New York City (JFK)',
  'Abuja (ABJ)',
  'Lagos (LG)',
  'Abu dhabi (AD)'
];

ThemeData appTheme = ThemeData(
  primaryColor: Color(0xFFF3791A),
  fontFamily: 'Oxygen'
);

double screenAwareSize(double percent, BuildContext context){
  return percent/100 * MediaQuery.of(context).size.height;
}

double screenAwareWidth(double percent, BuildContext context){
  return percent/100 * MediaQuery.of(context).size.width;
}

Widget buildDeals(BuildContext context, List<FlightDeals> snapshots) {
  return ListView.builder(
    shrinkWrap: true,
    padding: EdgeInsets.only(top: 0.0),
    scrollDirection: Axis.vertical,
    physics: ClampingScrollPhysics(),
    itemBuilder: (context, index) {
      var currentBestDeal = snapshots[index];
      return FlightCard(
        flightName: currentBestDeal.flightName,
        discountedPrice: currentBestDeal.discountedPrice,
        discount: currentBestDeal.discount,
        rating: currentBestDeal.rating,
        date: currentBestDeal.date,
        realPrice: currentBestDeal.realPrice,
      );
    },
    itemCount: snapshots.length,
  );
}