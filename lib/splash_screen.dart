import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flight_appplication/helpers.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: appTheme.primaryColor, //top bar color
    ));

    Future.delayed(Duration(seconds: 5), (){
      Navigator.pushReplacementNamed(context, '/');
    });

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: appTheme.primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.flight_takeoff, size: 60, color: Colors.white,),
            SizedBox(height: 10,),
            Text('Dummy FlightApp', style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'RaleWay',),),
          ],
        )
      ),
    );
  }
}
