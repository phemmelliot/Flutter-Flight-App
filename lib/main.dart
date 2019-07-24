import 'package:flutter/material.dart';

import 'package:flight_appplication/helpers.dart';
import 'package:flight_appplication/AppBar/custom_app_bar.dart';
import 'package:flight_appplication/pages/FlightList/flight_list.dart';

import 'package:flight_appplication/bloc/main_bloc.dart';
import 'package:flight_appplication/bloc/bloc_provider.dart';

import 'package:flight_appplication/pages/HomeScreen/home_screen.dart';
import 'package:flight_appplication/pages/WatchListScreen/watchlist_screen.dart';
import 'package:flight_appplication/pages/DealsScreen/deals_screen.dart';
import 'package:flight_appplication/splash_screen.dart';

void main() => runApp(MainPage());

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainBloc mainBloc = MainBloc();
  final textFieldContent = TextEditingController(text: 'New York (JFK)');
  String location = 'LA';

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      InheritedHomePage(
          child: HomeScreen(),
          textFieldContent: textFieldContent,
          saveSelectedLocation: saveSelectedLocation),
      WatchListScreen(),
      DealsScreen()
    ];

    return MaterialApp(
      title: 'Flight App',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (BuildContext context) => SplashScreen(),
        '/': (BuildContext context) => StreamBuilder(
          stream: mainBloc.selectedPageIndex,
          builder: (context, snapshot) {
            int index = snapshot.data == null ? 0 : snapshot.data;
            return Scaffold(
              bottomNavigationBar: CustomAppBar(bloc: mainBloc, index: index),
              body: InheritedFlightApp(bloc: mainBloc, child: _children[index]),
            );
          },
        ),
        '/search': (BuildContext context) {
          return InheritedFlightListPage(
            bloc: mainBloc,
            child: FlightListPage(),
            fromLocation: location,
            toLocation: textFieldContent.text,
          );
        },
      },
    );
  }

  void saveSelectedLocation(String fromLocation) {
    location = fromLocation;
  }

  @override
  void dispose() {
    super.dispose();
    mainBloc.dispose();
  }
}
