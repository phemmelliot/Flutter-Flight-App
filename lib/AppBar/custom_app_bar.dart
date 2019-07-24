import 'package:flutter/material.dart';
import 'package:flight_appplication/bloc/main_bloc.dart';
import 'package:flight_appplication/bloc/events.dart';

import 'package:flight_appplication/helpers.dart';

class CustomAppBar extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomBarItems = [];
  final TextStyle passiveNavigationItemStyle =
      TextStyle(color: Colors.black87, fontSize: 16.0);
  final TextStyle activeNavigationItemStyle =
  TextStyle(color: appTheme.primaryColor, fontSize: 16.0);
  final MainBloc bloc;
  final int index;

  CustomAppBar({this.bloc, this.index}) {
    bottomBarItems.add(
      BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
          color: index == 0 ? appTheme.primaryColor : Colors.black,
        ),
        title: Text(
          'Explore',
          style: index == 0 ? activeNavigationItemStyle : passiveNavigationItemStyle,
        ),
      ),
    );

    bottomBarItems.add(
      BottomNavigationBarItem(
        icon: Icon(
          Icons.favorite,
          color: index == 1 ? appTheme.primaryColor : Colors.black,
        ),
        title: Text(
          'Watchlist',
          style: index == 1 ? activeNavigationItemStyle : passiveNavigationItemStyle,
        ),
      ),
    );

    bottomBarItems.add(
      BottomNavigationBarItem(
        icon: Icon(
          Icons.local_offer,
          color: index == 2 ? appTheme.primaryColor : Colors.black,
        ),
        title: Text(
          'Deals',
          style: index == 2 ? activeNavigationItemStyle : passiveNavigationItemStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 15.0,
      child: BottomNavigationBar(
        onTap: (index) => bloc.flightEventSink.add(SelectPageEvent(index)),
        currentIndex: index,
        items: bottomBarItems,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
