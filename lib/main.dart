import 'package:flutter/material.dart';

import 'custom_shape_clipper.dart';
import 'constants.dart';
import 'choice_clip.dart';
import 'Data/data.dart';
import 'package:intl/intl.dart';
import 'AppBar/custom_app_bar.dart';
import 'FlightList/flight_list.dart';

void main() => runApp(HomeScreen());

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

  @override
  Widget build(BuildContext context) {
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
                            locations[selectedPopupItemIndex],
                            style: dropDownMenuText,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          )
                        ],
                      ),
                      itemBuilder: (BuildContext context) =>
                          locations.map((String location) {
                            return PopupMenuItem(
                              child: Text(
                                location,
                                style: dropDownItemsStyle,
                              ),
                              value: locations.indexOf(location),
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
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InheritedFlightListPage(
                                        child: FlightListPage(),
                                        fromLocation:
                                            locations[selectedPopupItemIndex],
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ChoiceClip(
                        icon: Icons.flight_takeoff,
                        text: 'Flights',
                        isFlightSelected: isFlightSelected,
                        onChoiceSelected: (type) => onChoiceClicked(type),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      ChoiceClip(
                        icon: Icons.hotel,
                        text: 'Hotels',
                        isFlightSelected: isFlightSelected,
                        onChoiceSelected: (type) => onChoiceClicked(type),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  onChoiceClicked(String type) {
    if (type == 'Flights' && !isFlightSelected) {
      setState(() {
        isFlightSelected = true;
      });
    }

    if (type == 'Hotels' && isFlightSelected) {
      setState(() {
        isFlightSelected = false;
      });
    }
  }
}

class HomeScreenBottomPart extends StatelessWidget {
  Widget _buildCityCards(context, index) {
    return CityCard(
      cityName: watchList[index]['cityName'],
      date: watchList[index]['date'],
      discount: watchList[index]['discount'],
      imageUrl: watchList[index]['imageUrl'],
      realPrice: watchList[index]['realPrice'],
      discountedPrice: watchList[index]['discountedPrice'],
    );
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
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: _buildCityCards,
            itemCount: watchList.length,
          ),
        ),
      ],
    );
  }
}

class CityCard extends StatelessWidget {
  final String cityName, date, discount, imageUrl, realPrice, discountedPrice;
  final formatCurrency = NumberFormat.simpleCurrency();

  CityCard({
    this.imageUrl,
    this.cityName,
    this.date,
    this.discount,
    this.realPrice,
    this.discountedPrice,
  });

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
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                    )),
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
                            cityName,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            date,
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
                          discount,
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
              "\$$discountedPrice",
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
              "(\$$realPrice)",
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
