import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import 'package:flight_appplication/model/city.dart';
import 'package:flight_appplication/helpers.dart';

class CityCard extends StatelessWidget {
  final City city;
  final bool isGridCard;
  final formatCurrency = NumberFormat.simpleCurrency();

  CityCard({this.city, this.isGridCard = false});

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
                  width: isGridCard ? screenAwareWidth(60, context) : 170.0,
                  child: CachedNetworkImage(
                    imageUrl: '${city.imageUrl}',
                    fit: BoxFit.cover,
                    fadeInDuration: Duration(milliseconds: 500),
                    fadeInCurve: Curves.easeIn,
                    placeholder: (context, loadingText) => Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
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
          mainAxisAlignment: isGridCard ? MainAxisAlignment.center : MainAxisAlignment.end,
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
        ),
      ],
    );
  }
}
