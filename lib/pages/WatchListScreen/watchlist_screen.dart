import 'package:flutter/material.dart';

import 'package:flight_appplication/bloc/main_bloc.dart';
import 'package:flight_appplication/helpers.dart';
import 'package:flight_appplication/bloc/bloc_provider.dart';
import 'package:flight_appplication/model/city.dart';
import 'package:flight_appplication/components/city_card.dart';

class WatchListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Current WatchList',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            WatchListBottomPart(),
          ],
        ),
      ),
    );
  }
}

class WatchListBottomPart extends StatelessWidget {
  Widget _buildCityCards(City city) {
    return CityCard(city: city, isGridCard: true,);
  }

  @override
  Widget build(BuildContext context) {
    MainBloc _bloc = InheritedFlightApp.of(context).bloc;
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Currently Watched Items',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontFamily: 'Oxygen',
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: 20,),
          Container(
            height: screenAwareSize(80, context),
            child: StreamBuilder(
              stream: _bloc.cities,
              builder: (context, snapshot) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.7),
                  ),
                  scrollDirection: Axis.vertical,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GridTile(child: _buildCityCards(snapshot.data[index]));
                  },
                  itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                );
//                return ListView.builder(
//                  scrollDirection: Axis.vertical,
//                  physics: ClampingScrollPhysics(),
//                  shrinkWrap: true,
//                  itemBuilder: (context, index) {
//                    return _buildCityCards(snapshot.data[index]);
//                  },
//                  itemCount: snapshot.data == null ? 0 : snapshot.data.length,
//                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
