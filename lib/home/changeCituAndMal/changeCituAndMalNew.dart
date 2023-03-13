import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wineapp/lang/localization/set_localization.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../URL_LOGIC.dart';

// ignore: must_be_immutable
class changeCituAndMalNew extends StatefulWidget{
  changeCituAndMalNew({Key? key, this.city_id, this.city_name_default, this.location_id, this.location_name_default, this.indexCity}) : super(key: key);
  String? city_id;
  String? city_name_default;
  String? location_id;
  String? location_name_default;
 final int? indexCity;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UnchangeCituAndMal();
  }
}

class UnchangeCituAndMal extends State<changeCituAndMalNew> {
  TextEditingController nameController = TextEditingController();

  int x=23;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    indexCity=widget.indexCity;
    getStringValuesSF();

    idcity=widget.city_id;
    namecity=widget.city_name_default;

    idmal=widget.location_id;
    namemal=widget.location_name_default;
  }
  String? idUsers;
  String? langApp;

  String? idcity="";
  String? namecity="";

  String? idmal="";
  String? namemal="";
  int? indexCity=0;
  int? indexMall=0;


  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('lang');
    String? idUser = prefs.getString('userid');

    setState(() {
      idUsers=idUser;
      langApp=lang;

        getData_cityHome();
    });
  }


  Map? data_cityHome;
  List _All_City=[];
  List _All_City_old=[];
  double numCunontCity=0;

  Future getData_cityHome() async {

    idmal = null;
    namemal = null;
    Map<String, Object> body = {
      "lang":langApp!,
      // "loc_click":1,
    };
    // print("body is :"+body.toString());
    // print("url is :"+URL_LOGIC.get_cityHome_new.toString());
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};

    http.Response response_offer = await http.post(
      Uri.parse(URL_LOGIC.get_cityHome_new!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    data_cityHome = json.decode(response_offer.body);

//    userData_offer = data_offer["bestseller"];


    setState(() {
      // print(data_cityHome.toString());
      data_cityHome = json.decode(response_offer.body);

      setState(() {

        // print(indexCity.toString()+">>>>>>>");
        _All_City.addAll(data_cityHome!["city"]);
        _All_City_old.addAll(data_cityHome!["city"]);
        if(_All_City.length>0){
          _All_MalfromCity.addAll(data_cityHome!["city"][indexCity]["locations"]);
          _All_MalfromCity_old.addAll(data_cityHome!["city"][indexCity]["locations"]);

          idmal = data_cityHome!["city"][indexCity]["locations"][0]["id"];
          namemal = data_cityHome!["city"][indexCity]["locations"][0]["location_name"];

          indexCity=widget.indexCity;
        }
      });

    });
  }


  List _All_MalfromCity=[];
  List _All_MalfromCity_old=[];


  int selected = 0;
  int selectedmal = 0;


  void _filterMall(value) {
    print("_filterMall");
    setState(() {
      var _results = _All_MalfromCity_old.where((item) => item['location_name'].toLowerCase().contains(value.toLowerCase())).toList();
      print("><><><><><><><><><><><><><><"+ _results.toString()+"><><><><><><><><><><><><><><");
      print("><><><><><><><><><><><><><><"+ _results[0]["id"].toString()+"><><><><><><><><><><><><><><");
      print("><><><><><><><><><><><><><><"+ _results[0]["location_name"].toString()+"><><><><><><><><><><><><><><");


      setState(() {
        try{
          if(_results[0]["id"]!=null){
            idmal=_results[0]["id"];
            namemal=_results[0]["location_name"];
          }
        }catch(e){

        }
        _All_MalfromCity=_results;

        print("><><><><><><><><><><><><><>< id mal is "+ idmal.toString()+"><><><><><><><><><><><><><><");
      });
    });
  }

  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Material(
          type: MaterialType.transparency,
          // color: Colors.black12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(height: 22,),


                 Container(
                   decoration: BoxDecoration(
                     color: Colors.white,
                     // color: Color(0xffeeeeee),
                     borderRadius: BorderRadius.only(
                       topLeft: Radius.circular(12),
                       topRight: Radius.circular(12),
                     ),
                   ),
                   // color: Color(0xffeeeeee),
                   child: Row(
                     children: <Widget>[
                       SizedBox(
                         width: 14,
                       ),
                       Expanded(
                         child: Container(
                           height: 35,
                           decoration: BoxDecoration(
                             shape: BoxShape.rectangle,
                             borderRadius: BorderRadius.circular(15),
                             // color: Colors.black12,
                             color: Color(0x14b5b5b5),
                           ),
                           child: TextField(
                             controller: nameController,
                             onChanged: (value) {


                               setState(() {
                                 if (value.length >= 0) {

                                  if(_All_MalfromCity_old.isNotEmpty){
                                    setState(() {
                                      _filterMall(value);
                                      print(value);
                                    });
                                  }else if(_All_City.isNotEmpty){
                                    setState(() {
                                      // _filterCountries(value);
                                      print(value);
                                    });
                                  }
                                   // List<Location> searchLoc = locations.where((Location item) => item.locationName.toLowerCase().contains(value.toLowerCase())).toList();
                                   // if(searchLoc.isNotEmpty) {
                                   //   locations = searchLoc;
                                   //   locationID = locations[0].locationID;
                                   // }else{
                                   //   locations = searchLoc;
                                   //   locations.add(Location(locationID: '0', locationName: AppLocalizations.of(context).translate('no_location_available')));
                                   //   locationID = locations[0].locationID;
                                   // }
                                 } else {print(">>>"+value.toString());
                                   // if(mainPageOrder.cities[cityIndex].location.isNotEmpty) {
                                   //   locations = mainPageOrder.cities[cityIndex].location;
                                   //   locationID = locations[0].locationID;
                                   // }else {
                                   //   locations = mainPageOrder.cities[cityIndex].location;
                                   //   locations.add(Location(locationID: '0', locationName: AppLocalizations.of(context).translate('no_location_available')));
                                   //   locationID = locations[0].locationID;
                                   // }
                                 }
                                 //locationController.jumpToItem(0);
                               });
                             },
                             style: TextStyle(fontSize: 13, color: Color(0xffb5b5b5)),
                             textAlign: TextAlign.start,
                             decoration: InputDecoration(
                               contentPadding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                               prefixIcon: IconButton(
                                 icon: Icon(Icons.search,color: Color(0xFF00838f),),
                                 onPressed: () {},
                               ),
                               hintText: SetLocalization.of(context)!.getTranslateValue('search_loc'),
                               hintStyle: TextStyle(fontSize: 12, color: Color(0xffb5b5b5)),
                               border: InputBorder.none,
                             ),
                           ),
                         ),
                       ),
                       ButtonTheme(
                         minWidth: 40,
                         child: FlatButton(
                           child: Text(
                             SetLocalization.of(context)!.getTranslateValue('close')!,
                             style: TextStyle(fontSize: 13, color: Colors.black),
                           ),
                           onPressed: () {
                             // isDone = false;
                             Navigator.pop(context);
                           },
                         ),
                       )
                     ],
                   ),
                 ),


                Container(
                // A simplified version of dialog.
                // width: 235.0,
                height: 235.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // color: Color(0xffeeeeee),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),

                child:Row(
                    children: [

                      _All_City.isEmpty ? Expanded(child:Center(child: CircularProgressIndicator(),)) :
                      Expanded(
                        child:
                        CupertinoPicker(
                          itemExtent: 40,
                          children: <Widget>[
                            for (var i = 0; i < _All_City.length;
                            i++)
                              Center(child: Text(_All_City[i]["city_name"],
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 15,
                                  )
                              )

                              ),
                          ],


                                  onSelectedItemChanged: (int index) {
                                      setState(() {
                                        setState((){
                                          nameController.text="";
                                          indexCity=index;
                                          indexMall=0;
                                          ctrl.animateToItem(
                                            _All_MalfromCity.length>0?0:_All_MalfromCity.length,
                                            duration: Duration(milliseconds: 50),
                                            curve:  ElasticInCurve(),

                                          );
                                          print("indexMall indexMall indexMall>>>> $indexMall");
                                        });

                                        // getData_MalfromCity(_All_City[index]["id"]);
                                        idcity=_All_City[index]["id"];
                                        namecity=_All_City[index]["city_name"];
                                        if(_All_MalfromCity.isNotEmpty){
                                          _All_MalfromCity.clear();
                                          _All_MalfromCity_old.clear();
                                        }

                                        _All_MalfromCity.addAll(_All_City[index]["locations"]);
                                        _All_MalfromCity_old.addAll(_All_City[index]["locations"]);
                                        if(_All_MalfromCity.isNotEmpty){
                                          idmal = _All_MalfromCity[0]["id"];
                                          namemal = _All_MalfromCity[0]["location_name"];
                                        }

                                      });

                            print('good boi>>   $index');
                            print(_All_City[index]["id"]);
                            print(_All_City[index]["locations"]);
                          },
                          looping: false,
                          scrollController: FixedExtentScrollController(initialItem: indexCity!),
                        )
                      ),


                      // SizedBox(width: 11,),


                      _All_MalfromCity.isEmpty  ? Expanded(child:Center(child: Text(SetLocalization.of(context)!.getTranslateValue('no_location_available')!),)) :
                      _All_MalfromCity.isEmpty ? Expanded(child:Center(child: CircularProgressIndicator(),)) :
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 40,
                          children: <Widget>[

                            for (var i = 0; i < _All_MalfromCity.length;
                            i++)
                             Container(
                               padding: EdgeInsets.only(left: 4,right: 4),
                               child:  Center(
                                   child: Text(_All_MalfromCity[i]["location_name"].toString(),
                                       maxLines: 1,
                                       textAlign: TextAlign.center,
                                       style: TextStyle(fontSize: 15,
                                       ))),

                             )
                          ],


                          onSelectedItemChanged: (int index) {
                            setState(() {
                              indexMall=0;
                              selectedmal=index;
                              idmal=_All_MalfromCity[index]["id"];
                              namemal=_All_MalfromCity[index]["location_name"];
                            });
                            print('good boi>>   $index');
                            print(_All_MalfromCity[index]["id"]);
                            print(_All_MalfromCity[index]["location_name"]);
                    // });
                          },

                          looping: false,//_All_MalfromCity.length>9?true:false,
                          // scrollController: FixedExtentScrollController(initialItem: indexMall!),
                          useMagnifier: true,
                          scrollController: ctrl,
                        ),
                      ),




                    ],
                  )
                ),




                  SizedBox(
                    height: 10,
                  ),

                  GestureDetector(
                    onTap: () {
                      // isDone = true;
                      Navigator.pop(context,[{"idCity":idcity,"nameCity":namecity,"idMal":idmal,"nameMAl":namemal,"indexCity":indexCity}]);
                      //sign_in(context);
                    },
                    child: Container(
                      // A simplified version of dialog.
                      // width: 328.0,
                      height: 52.0,
                      decoration: BoxDecoration(
                        color: Color(0xffeeeeee),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: MaterialButton(
                        onPressed: null,
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            SetLocalization.of(context)!.getTranslateValue('done')!,
                            style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              )


      );
    });
  }

  static final ctrl = FixedExtentScrollController();
}