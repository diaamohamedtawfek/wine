import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wineapp/backEndAndModels/connect_apis.dart';
import 'package:wineapp/backEndAndModels/model/DataUpdateApp.dart';
import 'package:wineapp/home/HomApp.dart';
import 'package:wineapp/startApp/Check_Location.dart';
import 'package:wineapp/startApp/Login.dart';
import '../main.dart';



class SplashScrean extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return  UISplash ();
  }

}

class UISplash extends State<SplashScrean> {


  Location? location = new Location();
  // LocationPermission? permission;

  // bool? _serviceEnabled;
  // PermissionStatus? _permissionGranted;
  // LocationData? _locationData;
  int moreactionPermation=1;




  Future<Position?> _determinePosition() async {
    try{
      // bool serviceEnabled;
      LocationPermission permission;

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        print("LocationPermission.denied");
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("LocationPermission.denied");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Check_Location()));
          return Future.error('Location permissions are denied');
        }else{
          getStringValuesSF();
        }
      } else if (permission == LocationPermission.always){
        print("LocationPermission.always");
        getStringValuesSF();
      }
      else if (permission == LocationPermission.whileInUse){
        print("LocationPermission.whileInUse");

        getStringValuesSF();
      }
      else if (permission == LocationPermission.denied){
        print("LocationPermission.whileInUse");

        getStringValuesSF();
      }
      else if (permission == LocationPermission.unableToDetermine){
        print("LocationPermission.unableToDetermine");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Check_Location()));
      }
      else if (permission == LocationPermission.unableToDetermine){
        print("LocationPermission.unableToDetermine");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Check_Location()));
      }else{
        getStringValuesSF();
      }

      if (permission == LocationPermission.deniedForever) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Check_Location()));
        print("deniedForever");
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      // getStringValuesSF();
      return await Geolocator.getCurrentPosition();
    }catch(e){
      print(":::::::::::::::::::::"+e.toString());
      print(":::::::::::::::::::::");
      getStringValuesSF();
      return null;
    }

    // return await Geolocator.getCurrentPosition();
   }



  // Future<void> checkLocationPermission(BuildContext context) async{
  //
  //
  //   Timer(
  //       Duration(seconds: 4),
  //           () async {
  //
  //         // try{
  //         //   _serviceEnabled = await location!.serviceEnabled();
  //         //   print("_serviceEnabled>>>>>   $_serviceEnabled");
  //         //
  //         //
  //         //
  //         //   _permissionGranted = await location!.hasPermission();
  //         //
  //         //   permission = await Geolocator.checkPermission();
  //         //
  //         // }catch(e){
  //         //
  //         // }
  //
  //             SharedPreferences prefs = await SharedPreferences.getInstance();
  //             bool checkValue = prefs.containsKey('perm');
  //
  //
  //             if(checkValue== true){
  //               getStringValuesSF();
  //               print("SharedPreferences");
  //             }else
  //             if (await permission == LocationPermission.deniedForever) {
  //               getStringValuesSF();
  //               print("deniedForever");
  //               return Future.error('Location permissions are permantly denied, we cannot request permissions.');
  //             }else if (await _permissionGranted ==  PermissionStatus.deniedForever) {
  //               print("deniedForever");
  //               getStringValuesSF();
  //             }else if (_permissionGranted == PermissionStatus.denied) {
  //               print("denied");
  //               Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Check_Location()));
  //             }else if (_permissionGranted == PermissionStatus.granted){
  //               getStringValuesSF();
  //             }
  //
  //             getStringValuesSF();
  //
  //             print("object>>>>>");
  //
  //       });
  // }

  Future<void> mainApp() async {
    print('Fetching user order...');
    // await checkLocationPermission(context);
    Timer(
        Duration(seconds: 4),
            () async {
      // await checkLocationPermission(context);
      await _determinePosition();
    });

  }

  Future<DataUpdateApp?>? getDataUpdateApp;

  @override
  void initState() {
    super.initState();

    getlang();
    mainApp();
    // _determinePosition();






  }

  getPInfo() async{

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    Map<String, dynamic> body = {
      "version":version,
      "buld_version":buildNumber,
    };

    getDataUpdateApp=ConnectApis.getUpdateApp(body);
    getDataUpdateApp!.then((value)  {
      setState(() {

        if(value!.update==true){
          // _showVersionDialog(context);
        }

      });
    });

    // final newVersion = NewVersion(
    //   iOSId: 'https://apps.apple.com/us/app/3wain-sale3/23edaid1560505432eee',
    //   androidId: 'com.google.android.apps.cloudconsole',
    // );
    //
    // const simpleBehavior = true;
    //
    // if (simpleBehavior) {
    //   print("::::::::::::");
    //   basicStatusCheck(newVersion);
    // } else {
    //   print("--------");
    //
    //   advancedStatusCheck(newVersion);
    // }
  }
  _showVersionDialog(context) async {
    // await showDialog<String>(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     String title = "Update Available";
    //     String message =
    //         "About Update: \n";
    //
    //     return ButtonBarTheme(
    //       data:   ButtonBarThemeData(alignment: MainAxisAlignment.center),
    //       child: new AlertDialog(
    //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    //         title: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Text(title),
    //             // Text("v"+versionCode),
    //           ],
    //         ),
    //         content: Container(
    //           height: 80,
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text("You can now update this app",style: TextStyle(fontWeight: FontWeight.bold),),
    //               // Text(aboutVersion??""),
    //             ],
    //           ),
    //         ),
    //         actions: <Widget>[
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: RaisedButton(
    //               child: new Text(
    //                 'Update',
    //                 style: TextStyle(color: Colors.white),
    //               ),
    //               color: Color(0xFF121A21),
    //               shape: new RoundedRectangleBorder(
    //                 borderRadius: new BorderRadius.circular(30.0),
    //               ),
    //               onPressed: () async{
    //                 // Navigator.pop(context);
    //                 // _launchURL(PLAY_STORE_URL);
    //                 if(Platform.isIOS){
    //                   await launch("https://apps.apple.com/us/app/wain-sale/id1560505432");
    //                 }if(Platform.isAndroid){
    //                   await launch("https://play.google.com/store/apps/details?id=com.wain.technology.wain&hl=ar&gl=US");
    //                 }
    //
    //               },
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: RaisedButton(
    //               child: new Text(
    //                 'cancel',
    //                 style: TextStyle(color: Colors.white),
    //               ),
    //               color: Colors.teal,
    //               shape: new RoundedRectangleBorder(
    //                 borderRadius: new BorderRadius.circular(30.0),
    //               ),
    //               onPressed: () {
    //                 Navigator.pop(context);
    //                 // _launchURL(PLAY_STORE_URL);
    //               },
    //             ),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );


    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => new Dialog(
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(22.0))),
        // contentPadding: EdgeInsets.only(top: 10.0),
        backgroundColor: Colors.transparent,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(
              width: 4,
              color: Color(0xff00838f),
            ),
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
          ),
          child: Stack(
            children: [
              gender(),

            ],
          ),
        ),
      ),
    );
  }

  Widget gender(){

    return Container(
      // color: Colors.red,
      padding: EdgeInsets.only(left: 15,right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
              child:Directionality(
                  textDirection: TextDirection.ltr,
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Row(
                        children: [

                          Expanded(child: InkWell(
                            // color: Colors.white,
                            // elevation: 0,
                            onTap: (){

                            },
                            child:  Container(
                              height: 40,
                              padding: EdgeInsets.only(left: 5,right: 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 6,
                                  color: Color(0xff00838f),
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                                color: Color(0xff00838f),
                              ),
                              child: Center(child: Text("English",style: TextStyle(color: Colors.white)),),
                            ),
                          ),
                          ),


                          SizedBox(width: 11,),

                          Expanded(child: InkWell(
                            // color: Colors.white,
                            // elevation: 0,
                            onTap: (){

                            },
                            child:  Container(
                              padding: EdgeInsets.only(left: 5,right: 5),
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 4,
                                  color: Color(0xff00838f),
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                                color: Color(0xff00838f),
                              ),
                              child: Center(child:Text("العربية",style: TextStyle(color: Colors.white),)),
                            ),
                          ),
                          ),
                        ],
                      ),

                    ],

                  )
              )
          ),
        ],
      ),
    );
  }


  getlang () async {
    // Timer(
    //     Duration(seconds: 4),
    //         () {
    //       getStringValuesSF();
    //     });
    Locale _temp;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('lang');
    bool checkValue = prefs.containsKey('lang');
    print("lang check => "+checkValue.toString());
    if(checkValue== true){
      print(">>>>>>>>>>>>>$checkValue");
      print(">>>>>stringValue>>>>>>>>$stringValue");
      if(stringValue=="ar"){
        _temp = Locale("ar", 'EG');
        MyApp.setLocale(context, _temp);
      }else{
        _temp = Locale("en", 'US');
        MyApp.setLocale(context, _temp);
        print(">>>>>>>>>>>>>$checkValue");
      }
    }else{
       var x= window.locale.languageCode;
       if(x=="ar"){
         _temp = Locale(x, 'EG');
         MyApp.setLocale(context, _temp);
       }else{
         _temp = Locale("en", 'US');
         MyApp.setLocale(context, _temp);
       }

      _temp = Locale("en", 'US');
      MyApp.setLocale(context, _temp);
      prefs.setString('lang',"en");
    }

    if(checkValue== false){
      print(">>>>>>>>>>>>>${false}");
      MyApp.setLocale(context, _temp);
    }
  }

  getStringValuesSF() async {
    print("getStringValuesSF");

    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool checkValue = prefs.containsKey('userid');
      bool gist = prefs.containsKey('gist');
      print("idUser=> "+checkValue.toString());

      if(checkValue== true || gist==true){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomApp()));  // HomApp
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomeNew()));  // HomApp

//      addpermation_directionPage();
      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Login()));  //Login
      }
    }catch(e){
      print("error SharedPreferences ---");
      print(e.toString());
    }

//    return stringValue;
  }


  @override
  Widget build(BuildContext context) {

//    var response = ResponseUI.instance;
    return Scaffold(
       // backgroundColor: Color(0xFF00838f),
       body: Container(
         height: double.maxFinite,
         child:Image.asset(
           "assets/gif1.gif",
           height: MediaQuery.of(context).size.height,
           width: MediaQuery.of(context).size.width,
           fit: BoxFit.fill,
         ),

//          new Stack(
//            children: <Widget>[
//              new Positioned(child: new Align(
//                alignment: FractionalOffset.center,
//                child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: <Widget>[
//                      Image.asset('assets/images/gif1.gif',
//                        height: 121,
//                        width: 134,),
//                      SizedBox(height: 20),
//                      Container(
//                        child: Directionality(
//                          textDirection: TextDirection.ltr,
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//                              Image.asset('assets/images/app_name.png',
//                                width: MediaQuery.of(context).size.width/2,)
//                            ],
//                          ),
//                        ),
//                      )
//
//
//
//
//
//                    ]),
//              ),),
//
//              new Positioned(child: new Align(
//                alignment: FractionalOffset.bottomCenter,
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  mainAxisSize: MainAxisSize.max,
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  children: <Widget>[
//
//
//                    Text(SetLocalization.of(context)!.getTranslateValue('copyright1')!,
// //                     AppLocalizations.of(context).translate('copyright1'),
//                      style: TextStyle(color: Color(0xFFffffff),
//                        fontWeight: FontWeight.w400,
//                        fontFamily: "SFProText",
//                        fontStyle:  FontStyle.normal,
//                      ),),
//
//
//                    Text(SetLocalization.of(context)!.getTranslateValue('copyright2')!,
// //                     AppLocalizations.of(context).translate('copyright1'),
//                      style: TextStyle(color: Color(0xFFffffff),
//                        fontWeight: FontWeight.w400,
//                        fontFamily: "SFProText",
//                        fontStyle:  FontStyle.normal,
//                      ),),
//
//
// //                   Text(AppLocalizations.of(context).translate('copyright2'),
// //                       style: TextStyle(color: Color(0xFFffffff))),
//                    SizedBox(height: 20),
//                  ],
//                ),
//              ))
//            ],
//          ),
       )

   );
  }
}

