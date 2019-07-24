import 'package:flutter/material.dart';

import 'package:flight_appplication/bloc/main_bloc.dart';

import 'package:flight_appplication/helpers.dart';

import 'package:flight_appplication/bloc/bloc_provider.dart';

class DealsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Current Deals',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DealsBottomPart(),
          ],
        ),
      ),
    );
  }
}

class DealsBottomPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MainBloc _bloc = InheritedFlightApp.of(context).bloc;
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Current Available Deals',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontFamily: 'Oxygen',
                fontWeight: FontWeight.bold
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

