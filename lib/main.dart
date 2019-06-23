import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

import 'custom_shape_clipper.dart';
import 'constants.dart';
import 'choice_clip.dart';
import 'package:intl/intl.dart';
import 'AppBar/custom_app_bar.dart';
import 'FlightList/flight_list.dart';
import 'Data/city.dart';

import 'bloc/main_bloc.dart';
import 'bloc/events.dart';

Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'flight-app',
    options: Platform.isIOS
        ? const FirebaseOptions(
            googleAppID: '1:209246495743:ios:192ddf177e552326',
            gcmSenderID: '209246495743',
            databaseURL: 'https://flight-app-11ff1.firebaseio.com/',
          )
        : const FirebaseOptions(
            googleAppID: '1:209246495743:android:bcf85e5019f93292',
            apiKey: 'AIzaSyC-91FlUFywLE2th6hWAXbroCTCNtwpB24',
            databaseURL: 'https://flight-app-11ff1.firebaseio.com/',
          ),
  );

  runApp(HomeScreen());
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight App',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: Scaffold(
        bottomNavigationBar: CustomAppBar(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              HomeScreenTopPart(),
              HomeScreenBottomPart(),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreenTopPart extends StatefulWidget {
  @override
  _HomeScreenTopPartState createState() => _HomeScreenTopPartState();
}

class _HomeScreenTopPartState extends State<HomeScreenTopPart> {
  int selectedPopupItemIndex = 0;
  bool isFlightSelected = true;
  final textFieldContent = TextEditingController(text: 'New York (JFK)');
  final _bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('locations').snapshots(),
        builder: (context, snapshot) {
          var locationDynamic = snapshot.data.documents[0].data['list'];
          List<String> locationList = List<String>.from(locationDynamic);
          return Stack(
            children: <Widget>[
              ClipPath(
                clipper: CustomShapeClipper(),
                child: Container(
                  height: 400.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFF47D15), Color(0xFFEF772C)],
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40.0,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          PopupMenuButton(
                            onSelected: (int index) {
                              setState(() {
                                selectedPopupItemIndex = index;
                              });
                            },
                            child: Row(
                              children: <Widget>[
                                Text(
                                  locationList[selectedPopupItemIndex],
                                  style: dropDownMenuText,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                )
                              ],
                            ),
                            itemBuilder: (BuildContext context) =>
                                locationList.map((String location) {
                                  return PopupMenuItem(
                                    child: Text(
                                      location,
                                      style: dropDownItemsStyle,
                                    ),
                                    value: locationList.indexOf(location),
                                  );
                                }).toList(),
                          ),
                          Spacer(),
                          Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Text(
                        'Where Would\n You Wanna Go?',
                        style: TextStyle(color: Colors.white, fontSize: 24.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.0),
                        child: Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          child: TextField(
                            controller: textFieldContent,
                            cursorColor: appTheme.primaryColor,
                            style: dropDownItemsStyle,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0, horizontal: 32.0),
                              suffixIcon: Material(
                                elevation: 5.0,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            InheritedFlightListPage(
                                              child: FlightListPage(),
                                              fromLocation: locationList[
                                                  selectedPopupItemIndex],
                                              toLocation: textFieldContent.text,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: StreamBuilder(
                          stream: _bloc.isFlightSelected,
                          builder: (context, snapshot) {
                            var isFlight = snapshot.data == null ? true : snapshot.data;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ChoiceClip(
                                  icon: Icons.flight_takeoff,
                                  text: 'Flights',
                                  isFlightSelected: isFlight,
                                  onChoiceSelected: (type) => onChoiceClicked(type, isFlight),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                ChoiceClip(
                                  icon: Icons.hotel,
                                  text: 'Hotels',
                                  isFlightSelected: isFlight,
                                  onChoiceSelected: (type) => onChoiceClicked(type, isFlight),
                                )
                              ],
                            );
                          }
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  onChoiceClicked(String type, bool isFlightSelected) {
    if (type == 'Flights' && !isFlightSelected) {
      _bloc.flightEventSink.add(SelectTypeEvent());
    }

    if (type == 'Hotels' && isFlightSelected) {
      _bloc.flightEventSink.add(UnSelectTypeEvent());
    }
  }
}

class HomeScreenBottomPart extends StatelessWidget {
  Widget _buildCityCards(DocumentSnapshot snapshot) {
    return CityCard(city: City.fromSnapshots(snapshot));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: 30.0, left: 16.0, right: 16.0, bottom: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Currently Watched Items',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontFamily: 'Oxygen',
                ),
              ),
              Text(
                'VIEW ALL (12)',
                style: TextStyle(
                  fontSize: 15.0,
                  color: appTheme.primaryColor,
                  fontFamily: 'Oxygen',
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 240.0,
          child: StreamBuilder(
            stream: Firestore.instance.collection('cities').snapshots(),
            builder: (context, snapshot) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return _buildCityCards(snapshot.data.documents[index]);
                },
                itemCount: snapshot.data.documents.length,
              );
            },
          ),
        ),
      ],
    );
  }
}

class CityCard extends StatelessWidget {
  final City city;
  final formatCurrency = NumberFormat.simpleCurrency();

  CityCard({this.city});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 210.0,
                  width: 170.0,
                  child: CachedNetworkImage(
                    imageUrl: '${city.imageUrl}',
                    fit: BoxFit.cover,
                    fadeInDuration: Duration(milliseconds: 500),
                    fadeInCurve: Curves.easeIn,
                    placeholder: (context, loadingText) => Center(
                          child: CircularProgressIndicator(
                            backgroundColor: appTheme.primaryColor,
                          ),
                        ),
                  ),
                ),
                Positioned(
                  top: 0.0,
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.1)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter),
                    ),
                  ),
                ),
                Positioned(
                  left: 10.0,
                  bottom: 10.0,
                  right: 10.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            city.cityName,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            city.date,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Text(
                          city.discount,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "\$${city.discountedPrice}",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 18.0,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              "(\$${city.realPrice})",
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0,
                  decoration: TextDecoration.lineThrough),
            ),
          ],
        )
      ],
    );
  }
}
