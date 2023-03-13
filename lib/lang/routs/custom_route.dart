import 'package:flutter/material.dart';
import 'package:wineapp/home/HomApp.dart';

class CustomRoute {

  static Route<dynamic> allRoutes(RouteSettings settings) {
//       switch (settings.name) {
//         case homeRoute:
//           return MaterialPageRoute(builder: (_) => HomePage());
//
//       }
       return MaterialPageRoute(builder: (_) => HomApp());
  }


}

