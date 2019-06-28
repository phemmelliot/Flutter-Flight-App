import 'package:flutter/material.dart';
import 'package:flight_appplication/bloc/main_bloc.dart';
import 'package:flight_appplication/bloc/events.dart';

class CustomAppBar extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomBarItems = [];
  final TextStyle passiveNavigationItemStyle =
      TextStyle(color: Colors.black87, fontSize: 16.0);
  final MainBloc bloc;
  final int index;

  CustomAppBar({this.bloc, this.index}) {
    bottomBarItems.add(BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
          color: Colors.black,
        ),
        title: Text(
          'Explore',
          style: passiveNavigationItemStyle,
        )));

    bottomBarItems.add(BottomNavigationBarItem(
        icon: Icon(
          Icons.favorite,
          color: Colors.black,
        ),
        title: Text(
          'Watchlist',
          style: passiveNavigationItemStyle,
        )));

    bottomBarItems.add(BottomNavigationBarItem(
        icon: Icon(
          Icons.local_offer,
          color: Colors.black,
        ),
        title: Text(
          'Deals',
          style: passiveNavigationItemStyle,
        )));

//    bottomBarItems.add(
//        BottomNavigationBarItem(
//            icon: Icon(Icons.notifications, color: Colors.black,) ,
//            title: Text('Notifications', style: passiveNavigationItemStyle,)
//        )
//    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 15.0,
      child: BottomNavigationBar(
//        onTap: (index) => bloc.flightEventSink.add(SelectPageEvent(index)),
        currentIndex: index,
        items: bottomBarItems,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
