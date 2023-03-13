//


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wineapp/backEndAndModels/model/DataAffiliates.dart';
import 'package:wineapp/backEndAndModels/model/DataCatigry.dart';
import 'package:wineapp/backEndAndModels/model/DataDetilesItem.dart';
import 'package:wineapp/backEndAndModels/model/DataFavoritAffilet.dart';
import 'package:wineapp/backEndAndModels/model/DataHomeAlefent.dart';
import 'package:wineapp/backEndAndModels/model/DataSearchApp.dart';
import 'package:wineapp/backEndAndModels/model/DataUpdateApp.dart';

class ConnectApis{



  static Future<DataSearchApp?> fetchDataSearch(Map body) async{
    var headers = {
      'Content-Type': 'application/json',
    };

    debugPrint(body.toString());
    debugPrint("http://wainsale.com/apps_api/home/search2.php");
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    var response = await http.post(
      Uri.parse("http://wainsale.com/apps_api/home/search2.php"),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );

    debugPrint("http://wainsale.com/apps_api/home/search2.php");
    debugPrint(response.body.toString());

    try{
      if(response.statusCode==200){
        DataSearchApp dataMyOrder=DataSearchApp.fromJson(json.decode(response.body));
        return dataMyOrder;
      }
    }catch(e){
      throw "error fetch data";
    }
  }



  static Future<DataDetilesItem?> fetchDataDetailesItem(Map body) async{
    var headers = {
      'Content-Type': 'application/json',
    };

    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    var response = await http.post(
      Uri.parse("http://wainsale.com/apps_api/offers/details2.php"),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );

    debugPrint("http://wainsale.com/apps_api/offers/details2.php");
    debugPrint(response.body.toString());

    try{
      if(response.statusCode==200){
        DataDetilesItem dataMyOrder=DataDetilesItem.fromJson(json.decode(response.body));
        return dataMyOrder;
      }
    }catch(e){
      print(e.toString());
      throw "error fetch data";
    }
  }



  static Future<DataHomeAlefent?> fetchDataHomeElefent(Map body) async{
    var headers = {
      'Content-Type': 'application/json',
    };

    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    var response = await http.post(
      Uri.parse("http://wainsale.com/apps_api/home/home_icons.php"),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );

    // debugPrint("http://wainsale.com/apps_api/home/home_icons.php");
    // debugPrint(response.body.toString());

    try{
      if(response.statusCode==200){
        DataHomeAlefent dataMyOrder=DataHomeAlefent.fromJson(json.decode(response.body));
        return dataMyOrder;
      }
    }catch(e){
      print(e.toString());
      throw "error fetch data";
    }
  }


  static Future<DataAffiliates?> fetchDataAffiliates(Map body) async{
    var headers = {
      'Content-Type': 'application/json',
    };
    debugPrint(body.toString());
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    var response = await http.post(
      Uri.parse("http://wainsale.com/apps_api/home/affiliates_offers.php"),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );

    debugPrint("http://wainsale.com/apps_api/home/affiliates_offers.php");
    debugPrint(response.body.toString());

    try{
      if(response.statusCode==200){
        DataAffiliates dataMyOrder=DataAffiliates.fromJson(json.decode(response.body));
        return dataMyOrder;
      }
    }catch(e){
      throw "error fetch data";
    }
  }


  static Future<DataUpdateApp?> getUpdateApp(Map body) async{
    var headers = {
      'Content-Type': 'application/json',
    };
    debugPrint(body.toString());
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    var response = await http.post(
      Uri.parse("http://wainsale.com/apps_api/update.php"),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );

    debugPrint("http://wainsale.com/apps_api/update.php");
    debugPrint(response.body.toString());

    try{
      if(response.statusCode==200){
        DataUpdateApp dataMyOrder=DataUpdateApp.fromJson(json.decode(response.body));
        return dataMyOrder;
      }
    }catch(e){
      throw "error fetch data";
    }
  }





  static Future<DataCatigry?> fetchDataCatigryElefent(Map body) async{
    var headers = {
      'Content-Type': 'application/json',
    };

    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    var response = await http.post(
      Uri.parse("http://wainsale.com/apps_api/home/get_affiliates_categories.php"),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );

    // debugPrint("http://wainsale.com/apps_api/home/home_icons.php");
    // debugPrint(response.body.toString());

    try{
      if(response.statusCode==200){
        DataCatigry dataMyOrder=DataCatigry.fromJson(json.decode(response.body));
        return dataMyOrder;
      }
    }catch(e){
      print(e.toString());
      throw "error fetch data";
    }
  }



  static Future<DataFavoritAffilet?> fetchDataFavoritAffilet(Map body) async{
    var headers = {
      'Content-Type': 'application/json',
    };

    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    var response = await http.post(
      Uri.parse("http://wainsale.com/apps_api/offers/my_affiliates_favorite.php"),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );

    // debugPrint("http://wainsale.com/apps_api/home/home_icons.php");
    // debugPrint(response.body.toString());

    try{
      if(response.statusCode==200){
        DataFavoritAffilet dataMyOrder=DataFavoritAffilet.fromJson(json.decode(response.body));
        return dataMyOrder;
      }
    }catch(e){
      print(e.toString());
      throw "error fetch data";
    }
  }
}