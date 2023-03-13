import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wineapp/lang/localization/set_localization.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../URL_LOGIC.dart';

class ChangeCIty extends StatefulWidget{

  ChangeCIty({Key? key, this.mapCity, this.idCity}) : super(key: key);
  List? mapCity;
  String? idCity;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UniChangeCIty();
  }
}

class UniChangeCIty extends State<ChangeCIty> {

  @override
  void initState() {
    super.initState();

    getStringValuesSF();

    _All_City=widget.mapCity! ;
    idcity=widget.idCity! ;
  }
  String? idUsers;
  String? langApp;

  String idcity="";
  String namecity="";



  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('lang');
    String? idUser = prefs.getString('userid');
    // print("idUser=> "+lang.toString());

    setState(() {
      idUsers=idUser;
      langApp=lang;

      if(idUsers!=null){
       // getData_User();
      }
    });
//    return stringValue;
  }


  Map? data_User;
  List _All_City= [];

  Future getData_User() async {

    // Map<String, String> timeOutMessage = {
    //   'state': 'timeout',
    //   'content': 'server is not responding'
    // };
    // offer
    Map<String, Object> body = {
      "lang":langApp!,
      "action":"view",
      "userid":idUsers!
    };
    print("body is :"+body.toString());
    print("url is :"+URL_LOGIC.accountInfo_Setting.toString());
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};

    http.Response responseOffer = await http.post(
      Uri.parse(URL_LOGIC.accountInfo_Setting!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    data_User = json.decode(responseOffer.body);

//    userData_offer = data_offer["bestseller"];


    setState(() {
      print(data_User.toString());
      data_User = json.decode(responseOffer.body);

      setState(() {
        idcity=data_User!["main"][1]["settings_info"][0]["city"];
        namecity=data_User!["main"][1]["settings_info"][0]["cityname"];

        _All_City.addAll(data_User!["main"][0]["city"]);
        print("_allCity  "+_All_City.toString());
      });

      // print("Nationality "+_All_nationality.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      backgroundColor: Colors.transparent,
      body:
      _All_City==null?Center(child: new CircularProgressIndicator()) :
      _All_City.isEmpty?Center(child: new CircularProgressIndicator()) :
      Center(
        child: Container(
            // color: Colors.black12,
            // padding: EdgeInsets.only(left: 30, right: 30,top: 10,bottom: 30),
            // margin: EdgeInsets.only(left: 30, right: 30,top: 10,bottom: 30),
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  decoration: BoxDecoration(
                      // color: Colors.black12,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)),
                      // color: Colors.white
                  ),
                  padding: EdgeInsets.only(
                      left: 5, right: 5, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween,
                    children: [
                      Text(
                        '${SetLocalization.of(context)!.getTranslateValue("SelectCity")}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     // done = false;
                      //     Navigator.pop(context);
                      //   },
                      //   child: Container(width: 60,
                      //       child: Center(child: Text(
                      //           SetLocalization.of(context).getTranslateValue('close')))),
                      // )
                    ],
                  ),
                ),

                Container(

                  child: Divider(
                    color: Colors.black,
                  ),
                  color: Colors.white,
                ),

                Card(
                  elevation: 2.0,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                        color: Colors.white
                    ),

                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 4,
                    padding: EdgeInsets.only(
                        left: 5, right: 5, top: 10, bottom: 20),
                    child: ListView.separated(
                      itemCount: _All_City.length,
                      // itemCount: cities.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              print("dilog");
                              idcity=_All_City[index]["id"];
                              namecity=_All_City[index]["city_name"];
                              print("$namecity");
                            });
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Text(_All_City[index]["city_name"]),
                                Icon(
                                  idcity == _All_City[index]["id"] ? Icons.check_circle
                                      :
                                  Icons.radio_button_unchecked,
                                  color: idcity == _All_City[index]["id"] ? Color(
                                      0xff00838f) : Colors.grey,)
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(color: Colors.grey,);
                      },),
                  ),
                ),
                SizedBox(height: 10,),

                GestureDetector(
                  onTap: () {
                    // done = true;
                    Navigator.pop(context, [{"namecity" : namecity,"idcity":idcity}],);
                  },
                  child: Card(
                    elevation: 3.0,
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.black26,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          SetLocalization.of(context)!.getTranslateValue('done')!,
                          style: TextStyle(fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                )
              ],
            ),
          ),

      ),
    )
    ;
  }
}