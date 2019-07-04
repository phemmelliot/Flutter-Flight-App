import 'package:flutter/material.dart';

import 'package:flight_appplication/custom_shape_clipper.dart';

import 'package:flight_appplication/bloc/main_bloc.dart';

import 'package:flight_appplication/helpers.dart';

class InheritedFlightListPage extends InheritedWidget {
  final String toLocation, fromLocation;
  final MainBloc bloc;

  InheritedFlightListPage(
      {Widget child, this.toLocation, this.fromLocation, this.bloc})
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

class FlightListBottomPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MainBloc _bloc = InheritedFlightListPage.of(context).bloc;
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
            stream: _bloc.deals,
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : buildDeals(context, snapshot.data);
            },
          )
        ],
      ),
    );
  }
}
