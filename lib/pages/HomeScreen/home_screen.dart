import 'package:flutter/material.dart';

import 'package:flight_appplication/custom_shape_clipper.dart';
import 'package:flight_appplication/helpers.dart';
import 'package:flight_appplication/components/choice_clip.dart';
import 'package:flight_appplication/model/city.dart';
import 'package:flight_appplication/components/city_card.dart';

import 'package:flight_appplication/bloc/main_bloc.dart';
import 'package:flight_appplication/bloc/events.dart';
import 'package:flight_appplication/bloc/bloc_provider.dart';

import 'package:flutter/services.dart';

class InheritedHomePage extends InheritedWidget {
  final TextEditingController textFieldContent;
  final Function saveSelectedLocation;

  InheritedHomePage(
      {Widget child, this.textFieldContent, this.saveSelectedLocation})
      : super(child: child);

  static InheritedHomePage of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(InheritedHomePage);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          HomeScreenTopPart(),
          HomeScreenBottomPart(),
        ],
      ),
    );
  }
}

class HomeScreenTopPart extends StatelessWidget {
  @override
  Widget build(BuildContext buildContext) {
    final textFieldContent =
        InheritedHomePage.of(buildContext).textFieldContent;
    MainBloc _bloc = InheritedFlightApp.of(buildContext).bloc;
    return StreamBuilder(
      stream: _bloc.locations,
      builder: (context, snapshot) {
        List<String> locationList =
            snapshot.data == null ? ['LA'] : snapshot.data;
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
                child: StreamBuilder(
                  stream: _bloc.selectedPopupItemIndex,
                  builder: (context, snapshot) {
                    var selectedPopupItemIndex =
                        snapshot.data == null ? 0 : snapshot.data;
                    InheritedHomePage.of(buildContext).saveSelectedLocation(
                        locationList[selectedPopupItemIndex]);
                    return Column(
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
                                var flightEvent = SelectLocationEvent();
                                flightEvent.content = index;
                                _bloc.flightEventSink.add(flightEvent);
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
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
                                      Navigator.pushNamed(context, '/search');
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
                              var isFlight =
                                  snapshot.data == null ? true : snapshot.data;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ChoiceClip(
                                    icon: Icons.flight_takeoff,
                                    text: 'Flights',
                                    isFlightSelected: isFlight,
                                    onChoiceSelected: (type) =>
                                        onChoiceClicked(type, isFlight, _bloc),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  ChoiceClip(
                                    icon: Icons.hotel,
                                    text: 'Hotels',
                                    isFlightSelected: isFlight,
                                    onChoiceSelected: (type) =>
                                        onChoiceClicked(type, isFlight, _bloc),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  onChoiceClicked(String type, bool isFlightSelected, MainBloc bloc) {
    if (type == 'Flights' && !isFlightSelected) {
      bloc.flightEventSink.add(SelectTypeEvent());
    }

    if (type == 'Hotels' && isFlightSelected) {
      bloc.flightEventSink.add(UnSelectTypeEvent());
    }
  }
}

class HomeScreenBottomPart extends StatelessWidget {
  Widget _buildCityCards(City city) {
    return CityCard(city: city);
  }

  @override
  Widget build(BuildContext context) {
    MainBloc _bloc = InheritedFlightApp.of(context).bloc;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: appTheme.primaryColor, //top bar color
          statusBarIconBrightness: Brightness.light, //top bar icons
          systemNavigationBarColor: Colors.white, //bottom bar color
          systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
        )
    );
    return Column(
      children: <Widget>[
        WatchedItems(bloc: _bloc),
        SizedBox(
          height: 10.0,
        ),
        BestDeals(bloc: _bloc),
      ],
    );
  }
}

class WatchedItems extends StatelessWidget {
  final MainBloc bloc;

  WatchedItems({this.bloc});

  Widget _buildCityCards(City city) {
    return CityCard(city: city);
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
            stream: bloc.cities,
            builder: (context, snapshot) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return _buildCityCards(snapshot.data[index]);
                },
                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
              );
            },
          ),
        ),
      ],
    );
  }
}

class BestDeals extends StatelessWidget {
  final MainBloc bloc;

  BestDeals({this.bloc});

  Widget _buildCityCards(City city) {
    return CityCard(city: city);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: 30.0, left: 16.0, right: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Current Best Deals',
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
        StreamBuilder(
          stream: bloc.deals,
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : buildDeals(context, snapshot.data),
            );
          },
        ),
      ],
    );
  }
}
