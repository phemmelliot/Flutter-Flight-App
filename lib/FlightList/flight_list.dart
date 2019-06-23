import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../custom_shape_clipper.dart';
import 'package:intl/intl.dart';
import '../Data/data.dart';

class InheritedFlightListPage extends InheritedWidget {
  final String toLocation, fromLocation;

  InheritedFlightListPage({Widget child, this.toLocation, this.fromLocation})
      : super(child: child);

  static InheritedFlightListPage of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(InheritedFlightListPage);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

class FlightListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Search Results',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FlightListTopPart(),
            FlightListBottomPart(),
          ],
        ),
      ),
    );
  }
}

class FlightListTopPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: 160.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFF47D15), Color(0xFFEF772C)],
              ),
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          elevation: 10.0,
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        InheritedFlightListPage.of(context).fromLocation,
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Divider(
                        height: 20.0,
                        color: Colors.grey,
                      ),
                      Text(
                        InheritedFlightListPage.of(context).toLocation,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.import_export,
                    size: 40.0,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

//class InheritedFlightCard extends InheritedWidget {
//  final String flightName, date, rating, discount;
//  final int realPrice, discountedPrice;
//
//  InheritedFlightCard({
//    Widget child,
//    this.flightName,
//    this.date,
//    this.discount,
//    this.rating,
//    this.realPrice,
//    this.discountedPrice,
//  });
//
//  static InheritedFlightCard of(BuildContext context) =>
//      context.inheritFromWidgetOfExactType(InheritedFlightCard);
//
//  @override
//  bool updateShouldNotify(InheritedWidget oldWidget) => true;
//}

class FlightListBottomPart extends StatelessWidget {

  Widget _buildDeals(context, List<DocumentSnapshot> snapshots) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        var currentBestDeal = snapshots[index].data;
        return FlightCard(
          flightName: currentBestDeal['flightName'],
          discountedPrice: currentBestDeal['discountedPrice'],
          discount: currentBestDeal['discount'],
          rating: currentBestDeal['rating'],
          date: currentBestDeal['date'],
          realPrice: currentBestDeal['realPrice'],
        );
        },
      itemCount: snapshots.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Best Deals for Next 6 Months',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
                fontFamily: 'Oxygen',
              ),
            ),
          ),
          StreamBuilder(
            stream: Firestore.instance.collection('deals').snapshots(),
            builder: (context, snapshot){
              return !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : _buildDeals(context, snapshot.data.documents);
            },
          )
        ],
      ),
    );
  }
}

class FlightCard extends StatelessWidget {
  final String flightName, date, rating, discount;
  final int realPrice, discountedPrice;
  final formatCurrency = NumberFormat.simpleCurrency();

  FlightCard(
      {this.flightName,
      this.date,
      this.discount,
      this.rating,
      this.realPrice,
      this.discountedPrice});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 5.0),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Container(
              height: 140.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                      style: BorderStyle.solid)),
            ),
          ),
          Positioned(
            top: 30.0,
            left: 25.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '${formatCurrency.format(discountedPrice)}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      '(${formatCurrency.format(realPrice)})',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CardChip(
                        iconData: Icons.calendar_today,
                        label: date,
                      ),
                      SizedBox(width: 5.0),
                      CardChip(
                        iconData: Icons.flight_takeoff,
                        label: flightName,
                      ),
                      SizedBox(width: 5.0),
                      CardChip(
                        iconData: Icons.star,
                        label: rating,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 7.0,
            right: 5.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: Text(
                discount,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardChip extends StatelessWidget {
  final String label;
  final IconData iconData;

  CardChip({this.iconData, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            iconData,
            size: 13.0,
          ),
          SizedBox(width: 10.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
