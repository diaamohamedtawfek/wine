import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wineapp/home/HomApp.dart';

import 'Login.dart';

// ignore: camel_case_types
class Check_Location extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return UniCheck_Location();
  }

}

// ignore: camel_case_types
class UniCheck_Location extends State<Check_Location> {



  @override
  void initState() {
    super.initState();
    print("object>>>>>>>>>>>>>>mab test UniCheck_Location ");
  }


  int deniedForeverPermation=0;
  Future<Position> _determinePosition() async {

    try{
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {

        onWillPop(context,"Location services are disabled.");
        return Future.error('Location services are disabled.>>');
      }

      permission = await Geolocator.checkPermission();
      if (await permission == LocationPermission.deniedForever) {
        // AppSettings.openLocationSettings();
        // deniedForeverPermation++;
        // if(deniedForeverPermation==2){
        //   AppSettings.openAppSettings();
        // }
        getStringValuesSF();

        print("deniedForever");

        return Future.error('Location permissions are permantly denied, we cannot request permissions.');
      }

      else if (await permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (await permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          Location? location = new Location();
          var  _serviceEnabled = await location.requestService();

          print("always");
          if (_serviceEnabled) {
            // AppSettings.openLocationSettings();
            AppSettings.openAppSettings(asAnotherTask: true);
          }
          // AppSettings.openLocationSettings();
          return Future.error(
              'Location permissions are denied (actual value: $permission).');
        }
      }else{
        getStringValuesSF();
      }

      if(await LocationPermission.always ==true ||await LocationPermission.whileInUse ==true){
        print("alaw \n\n\n\n al>>>>>>>");
      }
    }catch(e){
      print(">>>>>>>>>");
    }


    return await Geolocator.getCurrentPosition();
  }

  getStringValuesSF() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkValue = prefs.containsKey('userid');
    bool gist = prefs.containsKey('gist');
    print("idUser=> "+checkValue.toString());

    if(checkValue== true || gist==true){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => HomApp()));  // HomApp

//      addpermation_directionPage();
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => Login()));  //Login
    }
//    return stringValue;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(""),),


      body: Stack(
        children: [



          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
             decoration: BoxDecoration(
               image: DecorationImage(
                   image: AssetImage('assets/map.png'),
                   fit: BoxFit.cover
               ),
             ),
          ),


          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 255,
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 50,right: 50),
              child: ListView(
                children: [
                  Column(

                    children: [

                      SizedBox(height: 30,),

                      Text(
                          "Allow Maps to access your location while you're using the app?",
                          style: const TextStyle(
                              color:  const Color(0xff060000),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Roboto",
                              fontStyle:  FontStyle.normal,
                              fontSize: 15.0
                          ),
                          textAlign: TextAlign.center
                      ),


                      SizedBox(height: 20,),


                      Text(
                          "This app collects location data to identify the nearest malls around & shows the latest offers based on your location even when the app is closed or not in use.",
                          style: const TextStyle(
                              color:  const Color(0xff747474),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Roboto",
                              fontStyle:  FontStyle.normal,
                              fontSize: 13.0
                          ),
                          textAlign: TextAlign.center
                      ),


                      SizedBox(height: 20,),

                      button(),
                    ],
                  ),
                ],
              ),

            ),
          ),

        ],
      ),
    );
  }


  Widget button(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [

        //exit
        Visibility(
          child:  InkWell(
            onTap: ()=>{
              cancelButtonPermation()
              // Navigator.pop(context)
            },
            child: Container(
                width: 110.5,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(11),
                      bottomRight: Radius.circular(11),
                      bottomLeft: Radius.circular(11),
                      topLeft: Radius.circular(11)
                  ),
                  border: Border.all(
                      color: const Color(0xff183568),
                      width: 0.20000000298023224
                  ),
                ),

                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                      "Cancel",
                      style: const TextStyle(
                          color:   Color(0xff672297),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Roboto",
                          fontStyle:  FontStyle.normal,
                          fontSize: 15.0
                      ),
                      textAlign: TextAlign.left
                  ),
                )

            ),
          ),
        ),

        //save
        InkWell(
          onTap:()=> {
    // _determinePosition()
            setState(() {
              try{
                Future<Position> x=  _determinePosition();
                x.then((value) => {
                  if(value!=null){
                    getStringValuesSF()
                  }
                });

                print(">>>>>>>>>>>>>>"+x.toString());

              }catch(e){
                print(">>>>>>>>>");
              }

              // AppSettings.openLocationSettings();


            }),
          },
          child: Container(
            width: 110.5,
            height: 38,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(11),
                    bottomRight: Radius.circular(11),
                    bottomLeft: Radius.circular(11),
                    topLeft: Radius.circular(11)
                ),

                gradient: LinearGradient(
                    begin: Alignment(0.5, 0),
                    end: Alignment(0.5, 1),
                    colors: [const Color(0xFF00838f), const Color(0xFF00838f)])
            ),
            child: Center(
              child: Text(
                  "Allow",
                  style: const TextStyle(
                      color:  const Color(0xfffbf8f8),
                      fontWeight: FontWeight.w700,
                      fontFamily: "Roboto",
                      fontStyle:  FontStyle.normal,
                      fontSize: 15.0
                  ),
                  textAlign: TextAlign.left
              ),
            ),
          ),
        ),



      ],
    );
  }


  cancelButtonPermation() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("perm", "cansel");
    getStringValuesSF();
  }



  static Future<bool> onWillPop(BuildContext context, String s) async {
    return (await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        title: Text(
          s
            // SetLocalization.of(context)!.getTranslateValue('are_you_sure')!
        ),
        titlePadding: EdgeInsets.only(left: 5.0,right: 5.0,top: 5.0),
        contentPadding: EdgeInsets.only(left: 5.0,right: 5.0,top: 5.0,bottom: 0),
        content: Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('no',style: TextStyle(
                    color: Color(0xff00838f)
                ),),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                padding: EdgeInsets.all(0.0),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  AppSettings.openLocationSettings();
                },
                child: new Text('ok',style: TextStyle(
                    color: Color(0xff00838f)
                ),),
                padding: EdgeInsets.all(0.0),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ), // button 2
            ]
        ),
      ),
    )) ?? false;
  }

}