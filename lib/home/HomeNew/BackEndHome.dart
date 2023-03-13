import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../URL_LOGIC.dart';

class ApiHome {

  // ignore: missing_return
  static Future<http.Response?> getData_defultFiltter() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('lang');

    print(Uri.parse(URL_LOGIC.filterHome!));
    Map<String, dynamic> body = {
      "lang":lang,
      "action":"defullt"
    };

    print(body);
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};
    final responce = await http.post(Uri.parse(URL_LOGIC.filterHome!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );

    try{

      if(responce.statusCode==200){
        return responce;
      }

    }catch(e){
      print(responce.statusCode);
      print(responce.body.toString());
      print(e.toString());
      throw "error fetch data";
    }
  }




  static Future<http.Response?> getData_defultLocation({longitude,latitude,token_fromFirbase}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('lang');
    String? userid = prefs.getString('userid');

    print(Uri.parse(URL_LOGIC.defultLocationHome!));
    Map<String, dynamic> body = {
      "lang":lang,
      "longitude":longitude,
      "latitude":latitude,
      "user_token":token_fromFirbase,
      "userid":userid,

    };
    print(body.toString());
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};
    final responce = await http.post(Uri.parse(URL_LOGIC.defultLocationHome!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    // item

    try{
      if(responce.statusCode==200){
        return responce;
      }

    }catch(e){
      print(responce.statusCode);
      print(responce.body.toString());
      print(e.toString());
      throw "error fetch data";
    }

  }


  static Future<http.Response?> getData_serive(id_location_mal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('lang');


    Map<String, dynamic> body = {
      "lang":lang,
      "locationid":id_location_mal.toString()
    };
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};
    print("URL_LOGIC  "+URL_LOGIC.get_events_servicesHome.toString());
    print("body  "+jsonBody.toString());
    final responce = await http.post(Uri.parse(URL_LOGIC.get_events_servicesHome!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    // item
    try{
      if(responce.statusCode==200){
        return responce;
      }

    }catch(e){
      print(e.toString());
      throw "error fetch data";
    }
  }



  static Future<http.Response?> getADS_inhome(id_location_mal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('lang');


    Map<String, dynamic> body = {
      "lang":lang,
      "locationid":id_location_mal,
    };

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json'};
      print("URL_LOGIC  " + URL_LOGIC.main_offer_ads.toString());
      print("body  " + jsonBody.toString());
      final responce = await http.post(Uri.parse(URL_LOGIC.main_offer_ads!),
        body: jsonBody,
        encoding: encoding,
        headers: headers,
      );

      // item
    try{
      if(responce.statusCode==200){
        return responce;
      }

    }catch(e){
      print(e.toString());
      throw "error fetch data";
    }
  }

}