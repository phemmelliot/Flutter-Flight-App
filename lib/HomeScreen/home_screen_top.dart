import 'package:flutter/material.dart';

import '../custom_shape_clipper.dart';
import '../constants.dart';
import '../choice_clip.dart';


class HomeScreenTopPart extends StatefulWidget {
  @override
  _HomeScreenTopPartState createState() => _HomeScreenTopPartState();
}

class _HomeScreenTopPartState extends State<HomeScreenTopPart> {
  int selectedPopupItemIndex = 0;
  bool isFlightSelected = true;

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

  Widget dropDownRow() {
    return Row(
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
    );
  }

  Widget textFieldRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.0),
      child: Material(
        elevation: 10.0,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        child: TextField(
          controller: TextEditingController(
              text: locations[selectedPopupItemIndex]),
          cursorColor: appTheme.primaryColor,
          style: dropDownItemsStyle,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
                vertical: 14.0, horizontal: 32.0),
            suffixIcon: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              child: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                ),
                dropDownRow(),
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
                textFieldRow(),
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
}
