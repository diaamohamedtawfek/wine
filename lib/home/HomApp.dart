
import 'dart:io';
import 'dart:ui';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wineapp/SherdRefreanseAllApp/SherdRefreanseAllApp.dart';
import 'package:wineapp/backEndAndModels/connect_apis.dart';
import 'package:wineapp/backEndAndModels/model/DataHomeAlefent.dart';
import 'package:wineapp/backEndAndModels/model/DataUpdateApp.dart';
import 'package:wineapp/home/SearchApp/SearchAppNew.dart';
import 'package:wineapp/home/affiliates/Affiliates.dart';
import 'package:wineapp/home/changeCituAndMal/changeCituAndMalNew.dart';
import 'package:wineapp/home/drawearPage/SettingsScreen.dart';
import 'package:wineapp/lang/localization/set_localization.dart';
//
import 'package:wineapp/startApp/Login.dart';
import 'package:wineapp/widgetApp/witting_shimmer_list.dart';
import 'FavoriteScreen.dart';
import 'CurvedClipper.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../URL_LOGIC.dart';
import 'EventsScreen/EventsScreen.dart';
import 'drawearPage/ClassWebView.dart';
import 'item/OfferScreen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:geolocator/geolocator.dart'as geolocator3 ;



class HomApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return UnHomApp();
  }
}

class UnHomApp extends State<HomApp> {


  int firstHome=0;
  Future<DataHomeAlefent?>? getDataHomeAlefent;


  getAllDataApp() async{

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      print("appName????????"+appName);
      print("version__________"+version);
      print("buildNumber---------"+buildNumber);

      Map<String,dynamic> body=
        {"lang":langApp,"version":version,"buld_version":buildNumber}
      ;

      getDataHomeAlefent=ConnectApis.fetchDataHomeElefent(body);
      getDataHomeAlefent!.then((value)  {
        setState(() {
        });
      });
    });

  }


  Future<DataUpdateApp?>? getDataUpdateApp;
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
      // setState(() {

        if(value!.update==true){
          _showVersionDialog(context);
        }

      // });
    });
  }

  _showVersionDialog(context) async {
    showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => new Dialog(
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(22.0))),
        // contentPadding: EdgeInsets.only(top: 10.0),
        backgroundColor: Colors.transparent,
        child: Container(
          height: 170,
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

                      Text(
                          SetLocalization.of(context)!.getTranslateValue('updateApp')!,
                        textAlign: TextAlign.center,
                        textDirection: langApp=="ar"?TextDirection.rtl:TextDirection.ltr,
                      ),

                      SizedBox(height: 30,),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                           InkWell(
                            // color: Colors.white,
                            // elevation: 0,
                            onTap: () async{
                                if(Platform.isIOS){
                                  await launch("https://apps.apple.com/us/app/wain-sale/id1560505432");
                                }if(Platform.isAndroid){
                                  await launch("https://play.google.com/store/apps/details?id=com.wain.technology.wain&hl=ar&gl=US");
                                }
                            },
                            child:  Container(
                              height: 40,
                              padding: EdgeInsets.only(left: 25,right: 25),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 6,
                                  color: Color(0xff00838f),
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                                color: Color(0xff00838f),
                              ),
                              child: Center(
                                child: Text(SetLocalization.of(context)!.getTranslateValue('update')!,style:
                                TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                )
                                ,),
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
  // * initState ----------------



  @override
  void initState() {
    super.initState();

    getPInfo();

    //  * _scrollListener
    controller = new ScrollController()..addListener(_scrollListener);

    searchBarFcous = FocusNode();


    getPermationsNotification();


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("::::::::::::::::::::::::::::::::::::::::::::::::::::::");
      print(message.data.toString());
      print("notification!.title   "+message.notification!.title.toString());
      print("notification!.body  "+message.notification!.body.toString());
      showNotification("${message.notification!.body}",message.data,message.notification!.title.toString());
    });


    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print(message.toString());
      if (message != null) {
        print(message.toString());
        // Navigator.pushNamed(context, '/message',

        var androidInitilize = new AndroidInitializationSettings('wineapp');
        var iOSinitilize = new IOSInitializationSettings();
        var initilizationsSettings =
        new InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
        fltrNotification = new FlutterLocalNotificationsPlugin();
        fltrNotification!.initialize(
          initilizationsSettings,
          // onSelectNotification: notificationSelected
        );
        // showNotification("${message.notification!.body}",message.data,"???????"+message.notification!.title.toString());
      }
    });

    var androidInitilize = new AndroidInitializationSettings('wineapp');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
    new InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification!.initialize(
      initilizationsSettings,
      // onSelectNotification: notificationSelected
    );



    FirebaseMessaging.instance.getToken().then((token) {
      // print("token  >>>>>>>\n\n");
      // print("token  >>>>>>>${token}");
      // print("token  >>>>>>>\n\n");
      _sendItemData(token);
      setState(() {
        token_fromFirbase=token.toString();
      });

    });


    callbackDispatcher();
    getStringValuesSF();




  }





  int numpage=1;

  int startHome=0;

  TextEditingController serachField = TextEditingController();
  @override
  // ignore: must_call_super
  void dispose() {
    searchBarFcous!.dispose();
    // timer!.cancel();

    super.dispose();
  }
  String? index_categryAnd_SupCatigru;
  List? changeCity_And_defoultMAl;

  int indexCity=0;

  bool isMainVisable = false;

  bool isChecked_filteNotAvtiveOffer =true;
  int index_categry = 0;
  int currentLocation = 0;
  bool homeIsSelected = false;
  bool showSlider = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  FlutterLocalNotificationsPlugin? fltrNotification;

  int viewEvent=0;
  String? filtterChoce;

  var directionPajenation="offers";

  late ScrollController controller;

  bool ceckNet=true;
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }




  late Future<String> permissionStatusFuture;

  var permGranted = "granted";
  var permDenied = "denied";
  var permUnknown = "unknown";
  var permProvisional = "provisional";

  getPermationsNotification() async{
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
  }


  double positionList=0;
  void _scrollListener() {
    firstHome=1;
    if (controller.position.pixels == controller.position.maxScrollExtent) {
        startLoader();
    }

    print(MediaQuery.of(context).size.height);
    // print(controller.position.pixels);
    if (controller.position.atEdge) {
      final isTop = controller.position.pixels == 0;
    }
    setState(() {
      positionList = controller.position.pixels;
    });
  }

  void startLoader() {
    setState(() {
      _onLoading();
    });
  }

  bool isLoading = false;
  Widget _loader() {
    return isLoading
        ? new Align(
      child: new Container(
        width: 70.0,
        height: 70.0,
        child: new Padding(
            padding: const EdgeInsets.all(5.0),
            child: new Center(child: new CircularProgressIndicator())),
      ),
      alignment: FractionalOffset.bottomCenter,
    )
        : new SizedBox(
      width: 0.0,
      height: 0.0,
    );
  }

  String? token_fromFirbase;

  _sendItemData(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token',"$token");
  }

  Future onDidReceiveLocalNotifications(
      int? id, String? title, String? body, String? payload) async {
  }


  Future showNotification(String? s,Map<String, dynamic> mas,String tit) async {

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('wineapp');

    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        requestAlertPermission: true,
        requestBadgePermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotifications
    );

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS
    );

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        "130", "Wain", //"s",
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);

    const IOSNotificationDetails iosNotificationDetails=IOSNotificationDetails(

    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(
        android: androidPlatformChannelSpecifics,
      iOS: iosNotificationDetails

    );

    // ContrrolerPageHome controller=Get.put(ContrrolerPageHome());
    // controller.textTitel(data_Item["location_name_default"].toString());

    try{
      await flutterLocalNotificationsPlugin.show(
          130, "$s",tit, platformChannelSpecifics,
          // payload: '${mas["data"]["offer"].toString()}'
      );
    }catch(e){
  print(e.toString()+">>>");
  }



    try{
      print(s!+"////////");
      var androidDetails = new AndroidNotificationDetails(
          "Channel ID", "Desi programmer", //"This is my channel",
          importance: Importance.max);
      var iSODetails = new IOSNotificationDetails();
      var generalNotificationDetails =
      new NotificationDetails(android: androidDetails, iOS: iSODetails);

      await fltrNotification?.show(
          130, "Wain", "$s",
          generalNotificationDetails,
          payload: mas["data"]["offer"].toString()
      );


    }catch(e){
      print(e.toString()+">>>");
    }

  }

  Future onSelectNotification(String? payload) async {
    debugPrint("payload : $payload");
  }


  double? longitude;
  double? latitude;
  void callbackDispatcher() async {
    print("?????????????????------callbackDispatcher");
    print("?????????????????------callbackDispatcher");
    try{
      var x=await Geolocator.getCurrentPosition().then((value) => {
        print("?????????????????"),
        print("Location is ...  "+value.toString()),
        print("?????????????????"),
        print("?????????????????"),
        print("?????????????????"),
        setState(() {
          longitude=value.longitude;
          latitude=value.latitude;
          getData_defultLocation();
        })
      });
      print(x);
      print("?????????????????------callbackDispatcher done");
      print("?????????????????------ callbackDispatcher done");
    }catch(e){
      print("?????????????????------callbackDispatcher error");
      print("?????????????????------callbackDispatcher error");
      addPermatiomn();
      // _determinePosition();
    }



    bool enabled = await Geolocator.isLocationServiceEnabled();
    if(enabled==true){
      print("?????????????????------addPermation ");
      print("?????????????????------addPermeation ");
      addPermatiomn();
    }else{
      getData_defultLocation();
      // addPermatiomn();
    }
    // getData_defultLocation();
  }

  Future<Position?>? _determinePosition() async {
    print("__________________determinePosition");
    try{
      // bool serviceEnabled;
      LocationPermission permission;

      permission = await Geolocator.checkPermission();
      print(permission);
      print("permission1----------------");
      print("permission2----------------");
      print("permission3----------------");
      if (permission ==await LocationPermission.denied) {
        print("LocationPermission.denied");
        permission = await Geolocator.requestPermission();
        addPermatiomn();
      }

      else if (permission ==await LocationPermission.always){
        // addPermatiomn();
      }
      else if (permission ==await LocationPermission.whileInUse){
        print("LocationPermission.whileInUse");
        // addPermatiomn();
      }
      // addPermatiomn();
      return await Geolocator.getCurrentPosition();
    }catch(e){
      return null;
    }
    // return await Geolocator.getCurrentPosition();
  }

  addPermatiomn() async {
    int x=0;
    try{
      Future<Position?> position =  Geolocator.getCurrentPosition(desiredAccuracy: geolocator3.LocationAccuracy.lowest);
      print(position.toString()+">>>>>>>>>>>>------->>>>>>>>");
      position.then((value) => {
        setState((){
          print(position.toString()+">>>>>>>>>>>>--??????-*********---->>>>>>>>");
      longitude=value!.longitude;
      latitude=value.latitude;
      _All_allOffer!.clear();
      _All_allOfferId!.clear();
          numpage=1;
          getData_defultLocation();
        }),
        startHome++,
      }).catchError((error) {
        x=1;
        print(position.toString()+"?>>>>>>>>>>>>---*********---->>>>>>>>");
        _All_allOffer!.clear();
        _All_allOfferId!.clear();
        numpage=1;
        _determinePosition();
        getData_defultFiltter(); //or
        getData_defultLocation();// even the same error
      });
      position.onError((error, stackTrace){
        // _determinePosition();
      print(position.toString()+"--->>>>>>>>>>>>---????*********---->>>>>>>>");
      });



      Timer(
          Duration(seconds: 3),
              () async {
            if(x==1){
            if(longitude==null){
              _All_allOffer!.clear();
              _All_allOfferId!.clear();
              numpage=1;
              getData_defultFiltter(); //or
              getData_defultLocation();
            }
            }
              });

      // position.timeout(const Duration (seconds:7),onTimeout : (){
      //   //cancel future ??
      //   print('????????Timeout');
      // });



      // getData_defultFiltter();

      // getData_defultLocation();

      setState(() {
        geolocator3.Geolocator
            .getCurrentPosition(desiredAccuracy: geolocator3.LocationAccuracy.best)
            .then((geolocator3.Position position) {
          setState(() {
            geolocator3.Position position_Map=position;
            print(position);
            print(""+position_Map.latitude.toString()+"   &&&&   "+position_Map.longitude.toString());

            setState(() {
              longitude=position_Map.longitude;
              latitude=position_Map.latitude;
              getData_defultFiltter();
              getData_defultLocation();
            });
          });
        }).catchError((e) {
          print("error map GeoLocation   "+e.toString());
              // setState(() {
                getData_defultFiltter();
                getData_defultLocation();
              // });
        });
      });

    }catch(e){
      getData_defultFiltter();
      getData_defultLocation();//
      print(e.toString()+">>>  eror ");
    }
  }



  String? langApp;
  String? idUser;
  // bool showStartImage=true;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   bool checkLogin = prefs.containsKey('userid');
   bool showStartImageSharedPreferences = prefs.containsKey('showStartImage');
    String? lang = prefs.getString('lang');
    String? userid = prefs.getString('userid');
    print("idUser=> "+lang.toString());
    setState(() {
      langApp=lang;
      idUser=userid;

      getData_defultFiltter();
      getAllDataApp();
    });
  }

  SharedPreferencesImageStartApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('showStartImage',"showStartImage");
  }

  bool serviceWatched=false;
  bool isrefrech=false;



  Future getRefrich() async {
    setState(() {
      firstHome=1;
      numpage=1;
      _All_allOfferId!.clear();
    });

   if(data_defultLocation!.isNotEmpty){
     data_defultLocation!.clear;
   }
   getData_Slider(id_location_id,"filtter");
   // getData_Slider(changeCity_And_defoultMAl[0]["idMal"]);

   if(index_SubCategy!=null){
     if(_All_allOffer!.isNotEmpty){
       _All_allOffer!.clear();
       _All_allOffer_old!.clear();
       data_allOffer!.clear();
     }
     print("index_SubCategy $index_SubCategy");
     print("index_SubCategy $filtterChoce");

     setState(() {
       _All_allOffer_testdata = null;
     });
     getData_allOffer_FromFiltter(id_location_id,"test");

   }else if(filtterChoce!=null){
     if(_All_allOffer!.isNotEmpty){
       _All_allOffer!.clear();
       _All_allOffer_old!.clear();
       data_allOffer!.clear();
     }
     print("index_SubCategy $index_SubCategy");
     print("index_SubCategy $filtterChoce");

     setState(() {
       _All_allOffer_testdata = null;
     });
     getData_allOffer_FromFiltter(id_location_id,"test");

   }else{
     getData_MainCatigry(id_location_id,"re","");
   }

   isrefrech=true;

    // await Future.delayed(Duration(seconds: 3));
  }


  // RefreshController _refreshController = RefreshController(initialRefresh: false);
  void _onLoading() async{
    print("_refreshController");
    if(directionPajenation=="offers"){
      getData_allOffer(id_location_id,idCategry,"categry",numpage);
    }else{
      setState(() {
        _All_allOffer_testdata = null;
      });
      getData_allOffer_FromFiltter(id_location_id, "sss");
    }
    await Future.delayed(Duration(milliseconds: 1000));
    //await client.getMain(position.latitude.toString(),position.longitude.toString(),myLocale.languageCode,session: PreferenceUtils.getUserSessionID(), email: PreferenceUtils.getUserEmail()).then((value) => {
    // _refreshController.loadComplete();
  }

  Future getRefrich_onLoading() async {
    print("_refreshController");
    firstHome=1;
    if(directionPajenation=="offers"){
      getData_allOffer(id_location_id,idCategry,"categry",numpage);
    }else{
      setState(() {
        _All_allOffer_testdata = null;
      });
      getData_allOffer_FromFiltter(id_location_id, "sss");
    }
    await Future.delayed(Duration(milliseconds: 1000));
  }


  FocusNode? searchBarFcous;




  // bool net=true;
  // Map _source = {ConnectivityResult.none: true};
  // MyConnectivity _connectivity = MyConnectivity.instance;
  @override
  Widget build(BuildContext context) {

    // print(_source.keys.toList()[0]);
    // if (_source.keys.toList()[0] == ConnectivityResult.none) {
    //   setState(() {
    //     ceckNet = false;
    //
    //   });
    // } else {
    //   setState(() {
    //     ceckNet = true;
    //     // Timer.periodic(new Duration(seconds: 0), (time) {
    //     //   if(id_city_id==null){
    //     //     print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    //     //     print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    //     //     print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    //     //     print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    //     //     print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    //     //     print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    //     //     getData_defultLocation();
    //     //   }
    //
    //     // });
    //
    //     //
    //   });
    // }
    // print(_source.keys.toList()[0]);

    return
      // ceckNet==true?
      // ceckNet==false?
      //     HomwWithOutNet():

      WillPopScope(
      onWillPop: () {
        searchBarFcous!.unfocus();
        print(_scaffoldKey.currentState!.isDrawerOpen);
        if (_scaffoldKey.currentState!.isDrawerOpen) {
          print("?>>>>>>>>>>>>>>>>>");
          print("object");
          // return true;
          return popup(context);
        } else {
          print("onWillPop");
          return onWillPop(context);
        }
      },
      child:

      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
          // searchBarFcous.unfocus();
        },
        child: Stack(
          children: [
            SafeArea(
              bottom: true,
                child: Scaffold(

                    backgroundColor: Colors.white,
                    key: _scaffoldKey,

                    drawer: drawerApp(),


                  appBar: PreferredSize(
                      preferredSize: Size.fromHeight(98.0),
                      child: AppBar(
                        backgroundColor: Color(0xFF00838f),
                        shape: CurvedClipper(),
                        actions: <Widget>[



                          // if(_All_event.isNotEmpty)
                          Container(
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsetsDirectional.only(top: 15, end: 0, start: 0, bottom: 0),
                                  child:

                                  // to go to EventsScreen

                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      print("object");
                                      print("_All_event :> "+_All_event.toString());

                                      // if(_All_event!=null && _All_event.isNotEmpty){
                                        print("_All_event :> "+_All_event.toString());
                                        setState(() {
                                          viewEvent=1;
                                        });
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => EventsScreen(events:_All_event ,nameMAl: location_name_default.toString(),)));

                                      // }else{
                                      //   try{
                                      //
                                      //     // TipDialogHelper.fail(SetLocalization.of(context)!.getTranslateValue('NoEventsavailablerightnow'));
                                      //   }catch(e){}
                                      //
                                      // }
                                    },
                                    child: Container(
                                      width: 43,
                                      padding: EdgeInsets.all(0.0),
                                      child: Image.asset(
                                        'assets/images/event_and_services_icon.png',
                                        height: 27,
                                        width: 27,
                                      ),
                                    ),
                                  ),
                                ),

                                Visibility(
                                  visible: serviceWatched==true && viewEvent==0, //serviceWatched,
                                  child: Positioned(
                                    left: langApp == 'en' ? 28 : null,
                                    right: langApp == 'en' ? null : 28,
                                    top: 16,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: EdgeInsets.all(1),
                                        decoration: new BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        constraints: BoxConstraints(
                                          minWidth: 7,
                                          minHeight: 7,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],

                            ),
                          ),

                          categryFiltter(),

                        ],

                        flexibleSpace: Container(
                          // color: Colors.red,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[


                              Container(
                                // color: Colors.red,
                                height: 46,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(top: 7, bottom: 0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                                  onTap: () async {

                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return  StatefulBuilder(builder: (context, setState){
                                            return
                                              Material(
                                                // type: MaterialType.transparency,
                                                  color: Colors.black12,
                                                  child:
                                                  Center(
                                                    // Aligns the container to center
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Container(
                                                          // A simplified version of dialog.
                                                            margin: EdgeInsets.only(
                                                                left: 15, right: 15,top: 60),
                                                            width: MediaQuery
                                                                .of(context)
                                                                .size
                                                                .width,
                                                            decoration: BoxDecoration(
                                                              color: Colors.transparent,
                                                              borderRadius: BorderRadius.circular(
                                                                  12),
                                                            ),

                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.transparent,
                                                                borderRadius: BorderRadius.circular(
                                                                    12),
                                                              ),
                                                              child:  changeCituAndMalNew(indexCity: indexCity,),
                                                            )
                                                        )
                                                        // ),
                                                      ],
                                                    ),
                                                  )
                                              );
                                          });

                                        }
                                    ).then((val) {
                                      setState(() {
                                        _All_allOffer_testdata=null;

                                        controller.jumpTo(0);
                                        setState(() {
                                          positionList=0;
                                        });
                                        numpage=1;
                                        changeCity_And_defoultMAl = val;
                                        serachField.text="";

                                        idfiltterDefult!=null;



                                        print("changeCity_And_defoultMAl %%%%%%%%"+val.toString());

                                        print(val[0]["indexCity"].toString());
                                        indexCity=val[0]["indexCity"];

                                        if(changeCity_And_defoultMAl !=null ||changeCity_And_defoultMAl?[0] !=null ||
                                            changeCity_And_defoultMAl?[0]["idCity"] !=null){
                                          setState(() {
                                            id_city_id=changeCity_And_defoultMAl![0]["idCity"].toString();
                                            city_name_default=changeCity_And_defoultMAl![0]["nameCity"].toString();
                                          });
                                        }

                                        if(changeCity_And_defoultMAl![0]["idMal"] !=null){
                                          if(changeCity_And_defoultMAl?[0]["idMal"] !=id_location_id){


                                            setState(() {
                                              showAds=0;
                                              directionPajenation="offers";

                                              id_location_id=changeCity_And_defoultMAl![0]["idMal"].toString();
                                              location_name_default=changeCity_And_defoultMAl![0]["nameMAl"].toString();


                                              // * use to save name Location to use in HomeWth out Net
                                              setNameeMole_SherdRefreanse(nameMoaledd: location_name_default);

                                              getData_serive(changeCity_And_defoultMAl![0]["idMal"],changeCity_And_defoultMAl![0]["nameMAl"].toString());
                                              // data_offer,_All_Slider
                                              if(data_offer!=null){
                                                data_offer!.clear();
                                              }
                                              if(_All_Slider!=null){
                                                _All_Slider.clear();
                                              }
                                              if(_All_mainCatigry!=null){
                                                _All_mainCatigry.clear();
                                                data_mainCatigry!.clear();
                                              }

                                              if(_All_SupCatigry.isNotEmpty){
                                                _All_SupCatigry.clear();
                                                data_SupCatigry!.clear();
                                                _All_SupCatigry.clear();
                                              }
                                              // if(_selecteSupCategorys_index.isNotEmpty){
                                              //   _selecteSupCategorys_index.clear();
                                              //   _selecteSupCategorys.clear();
                                              // }
                                              index_SubCategy=null;
                                              index_SubCategy_id=null;
                                              //........
                                              _All_allOfferId!.clear();
                                              if(_All_allOffer!.isNotEmpty){
                                                _All_allOffer!.clear();
                                                data_allOffer!.clear();
                                              }

                                              setState(() {
                                                _currentPage = 0;
                                                index_categry=0;
                                                controlleree = PageController(initialPage: 0);
                                              });

                                              setState(() {
                                                filtterChoce=null;
                                                idfiltterDefult=null;
                                              });

                                              // getADS_inhome(changeCity_And_defoultMAl![0]["idMal"]);
                                              getData_Slider(changeCity_And_defoultMAl![0]["idMal"],"no");
                                              getData_MainCatigry(changeCity_And_defoultMAl![0]["idMal"],"not","appBar");

                                              Timer(
                                                  Duration(seconds: 0),
                                                      () async {
                                                    // getStringValuesSF();

                                                    getADS_inhome(changeCity_And_defoultMAl![0]["idMal"]);
                                                  });

                                              setState(() {
                                                filtterChoce=null;
                                              });

                                            });
                                          }

                                        }
                                      });
                                    });
                                  },

                                  child: Container(
                                    // color: Colors.yellow,
                                    padding: EdgeInsets.only(top: 0),
                                    constraints: BoxConstraints(
                                        maxWidth: 260,
                                        minWidth:100,

                                    ),
                                    // width: MediaQuery.of(context).size.width/1.4,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),




                                       Container(
                                         height: 45,
                                         alignment: Alignment.center,
                                         // color: Colors.red,
                                         padding: EdgeInsets.only(top: 0),
                                         child:Center(child:
                                           Text(
//                            truncateWithEllipsis(20,cityName),
                                             location_name_default==null?"   "  :
                                             location_name_default.toString().length>20?location_name_default.toString().substring(0,17)+"..":
                                             location_name_default.toString()
                                             ,
                                             style: TextStyle(fontSize:langApp=="ar"?19: 19, color: Colors.white),
                                             softWrap: false,
                                             overflow: TextOverflow.visible,
                                             textAlign: TextAlign.start,
                                             maxLines: 1,
                                           ),
                                       ),
                                       ),




                                        SizedBox(
                                          width: 4,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            'assets/images/icon_down.png',
                                            height: 8,
                                            width: 15,
                                          )
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),

                                 // Container(
                                 //   // color: Colors.red,
                                 //   width: MediaQuery.of(context).size.width,),
                                // Align(
                                //    alignment: Alignment.center,
                                //    child:


                                   Directionality(
                                             textDirection: TextDirection.ltr,
                                             child:   Container(
                                               width: 260,
                                               height: 40,
                                               decoration: BoxDecoration(
                                                 // color: Colors.red,
                                                 color: Colors.white,
                                                 shape: BoxShape.rectangle,
                                                 borderRadius: BorderRadius.circular(30),
                                                 boxShadow: [
                                                   BoxShadow(
                                                     color: Color(0x29000000),
                                                     blurRadius: 10,
                                                     spreadRadius: 1,
                                                     offset: Offset(0, 5),
                                                   ),
                                                 ],
                                               ),
                                               child:ClipRRect(
                                                 borderRadius: BorderRadius.circular(30),
                                                 child: InkWell(
                                                   focusColor: Colors.transparent ,
                                                   highlightColor: Colors.transparent ,
                                                   hoverColor: Colors.transparent ,
                                                   splashColor: Colors.transparent ,
                                                   onTap: ()=>{
                                                     //location_name_default,id_location_id
                                                     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>SearchAppNew(
                                                       nameLcation: location_name_default.toString(),
                                                       idLcation: id_location_id.toString(),
                                                     )))
                                                   },

                                                   child:TextField(
                                                     enabled: false,
                                                     controller: serachField,
                                                     style: TextStyle(fontSize: 13, color: Color(0xffb5b5b5)),
                                                     textAlign: langApp == 'en' ? TextAlign.center : TextAlign.center,
                                                     decoration: InputDecoration(
                                                       contentPadding: EdgeInsets.fromLTRB(44, 4, 0, 0),
                                                       prefixIcon: IconButton(onPressed: (){
                                                         Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>SearchAppNew(
                                                           nameLcation: location_name_default.toString(),
                                                           idLcation: id_location_id.toString(),
                                                         )));
                                                       },
                                                           icon: Icon(
                                                             Icons.search,
                                                             size: 22,
                                                             color: Color(0xffb5b5b5),
                                                           )
                                                       ),
                                                       hintText:  SetLocalization.of(context)!.getTranslateValue('SearchStore'),
                                                       // hintText: SetLocalization.of(context).getTranslateValue('search_bar'),
                                                       hintStyle: TextStyle(fontSize: 15, color: Color(0xffb5b5b5)),
                                                       border: InputBorder.none,
                                                     ),
                                                   ),
                                                 ),
                                               )
                                         )
                                     ),
                                 // ),


                            ],
                          ),
                        ),

                      )
                  ),



                    body:
                    // *& ??????????????\
                     Stack(
                       children: [

                         RefreshIndicator(
                           onRefresh: getRefrich,
                           color: Colors.white,
                           backgroundColor: Colors.black,
                           child:
                           Scrollbar(
                             isAlwaysShown: true,
                             // radius: Radius.circular(22),
                             child:
                             SingleChildScrollView(
                               physics: NeverScrollableScrollPhysics(),
                               // controller: controller,
                               child:

                               // // ceckNet==true?
                               // ceckNet==false?
                               //     // Column(
                               //     //   children: [
                               //     //     Center(child:  Image.asset("assets/no.png",height: 200,width: 200,),),
                               //     //     SizedBox(height: 33,),
                               //     //     Padding(padding: EdgeInsets.only(left: 22,right: 22),
                               //     //     child: Text("you must have internet connection to continue using this app")
                               //     //       ,),
                               //     //   ],
                               //     // )
                               //
                               // HomwWithOutNet()
                               //     :
                               bodyApp(),

                             ),
                           ),
                         ),


                        Positioned(
                          right: 20,
                          bottom: 70,
                          child:  FloatingActionButton(
                          onPressed: () {
                            // Add your onPressed code here!
                            controller.jumpTo(0);
                            setState(() {
                              positionList=0;
                            });
                          },
                          child: const Icon(Icons.navigation),
                          backgroundColor:Color(0xff00838f).withOpacity(.470),
                        )
                        ),

                             // afiet
                             futureBuilder_fetchCatagy(),
                       ],
                     )
                    // )
                )
            ),
            Visibility(
              visible: isMainVisable,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 8.0,
                  sigmaY: 8.0,
                ),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget futureBuilder_fetchCatagy() {
    return FutureBuilder<DataHomeAlefent?>(
        future: getDataHomeAlefent, // async work
        builder: (BuildContext context, snapshot) {
          if(snapshot.hasData && snapshot.data!.homeIcons!.isNotEmpty){

            if(snapshot.data!.bar?[0].active.toString()=="1")
            return Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                    child: InkWell(
                      onTap: (){
                        // if(idUser==null){
                        //   sign_in(context);
                        // }else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>Affiliates()));
                        // }
                      },
                      child: Container(
                        height: 67,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child:Center(
                          child:  ListView(
                            physics: NeverScrollableScrollPhysics(),
                            // scrollDirection: Axis.horizontal,
                            children:[
                              Center(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    // spacing: 5.0,
                                    // runSpacing: 5.0,
                                    children: List.generate(
                                        snapshot.data!.homeIcons?.length??0, (index) => Container(
                                      height: MediaQuery.of(context).size.width/6-10,
                                      width: MediaQuery.of(context).size.width/6-10,
                                      margin: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(64),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Color(0xFFf19000),
                                            // color: Colors.black45,
                                            width: 2
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          // imageUrl: "_All_allOffer[inde",
                                          imageUrl: snapshot.data!.homeIcons?[index].img??"",
                                          placeholder: (context, url) => Container(),
                                          errorWidget: (context, url, error) => Image.asset("assets/images/no_image_avilable.png",
                                            height: 50,width:50,),
                                        ),
                                      ),
                                    )),
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                )
            );
          }else if(snapshot.hasError){
            return  Scaffold(
              body:  SizedBox(
                child: Center(child:  Text(""),),
              ) ,
            );
          }
          return  Container();
        });
  }


  Widget drawerApp(){
    return  Drawer(
      child: Container(
          color: Colors.white,
          child:ListView(
            children: [

              Container(
                height: 78,
                color: Color(0xff00838f),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/logo.png',
                      height: 58,
                      width: 64,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Image.asset(
                      'assets/images/app_name.png',
                      height: 32,
                      width: 100,
                    )
                  ],
                ),
              ),

              //home
              InkWell(
                onTap: () {
                  print('pressed');
                  setState(() {
                    homeIsSelected = false;

                  });
                  Navigator.pop(context);
                },
                child: Container(
                  color: homeIsSelected ? Colors.grey.withOpacity(0.5) : Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 25,
                      ),
                      Image.asset(
                        'assets/images/drawer/icon_home.png',
                        color: homeIsSelected ? Colors.white : Color(0xff00838f),
                        height: 24,
                        width: 24,
                      ),

                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        SetLocalization.of(context)!.getTranslateValue('nav_home')!,
                        style: TextStyle(fontSize: 14, color: homeIsSelected ? Colors.white : Colors.black),
                      )
                    ],
                  ),
                ),
              ),

              //favorite
              InkWell(
                onTap: () async {
                  if(idUser==null){
                    sign_in(context);
                  }else {
                    // setState(() {
                      Navigator.pop(context);
                      var result =await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          FavoriteScreen(locationid_mal: id_location_id.toString(),)));

                      // ignore: unrelated_type_equality_checks
                      if (result==1) {
                        print(result);
                        // _onRefresh();
                        print(result);
                        print(">>>>>>>>>>>>>favorite>>>>>>>>>>>>>");
                        // getData_allOffer_FromFiltter(id_location_id, "sup");
                        getRefrich();
                      }
                  }
                },
                child: Container(
                  color: homeIsSelected ? Colors.grey.withOpacity(0.5) : Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 25,
                      ),
                      Image.asset(
                        'assets/images/drawer/favorite_border.png',
                        color: homeIsSelected ? Colors.white : Color(0xff00838f),
                        height: 24,
                        width: 24,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        SetLocalization.of(context)!.getTranslateValue('nav_fav')!,
                        style: TextStyle(fontSize: 14, color: homeIsSelected ? Colors.white : Colors.black),
                      )
                    ],
                  ),
                ),
              ),

              //setting
              InkWell(
                onTap: () async {

                    if(idUser==null){
                    sign_in(context);
                    }else
                    {
                      Navigator
                          .push(
                          context, MaterialPageRoute(builder: (context) => SettingsScreen()));
                    }
                },
                child: Container(
                  color: homeIsSelected ? Colors.grey.withOpacity(0.5) : Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 25,
                      ),
                      Image.asset(
                        'assets/images/drawer/settings.png',
                        color: homeIsSelected ? Colors.white : Color(0xff00838f),
                        height: 24,
                        width: 24,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        SetLocalization.of(context)!.getTranslateValue('nav_settings')!,
                        style: TextStyle(fontSize: 14, color: homeIsSelected ? Colors.white : Colors.black),
                      )
                    ],
                  ),
                ),
              ),

              //line
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        color: Color(0xff00838f),
                      ),
                    )
                  ],
                ),
              ),

              //aboutUs  ,  Terms  , JoinUs
              InkWell(
                onTap: () {
                  Navigator
                      .push(context, MaterialPageRoute(builder: (context) => WebViewExample(direction: "aboutApp",
                    lang: langApp??"en",
                    urlLink: "https://wainsale.com/apps_api/pages/aboutus.php?lang=",)));
                  // Navigator
                  //     .push(context, MaterialPageRoute(builder: (context) => AboutUsPage()));

                },
                child: Container(
                  color: homeIsSelected ? Colors.grey.withOpacity(0.5) : Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 25,
                      ),
                      Image.asset(
                        'assets/images/drawer/about_us.png',
                        color: homeIsSelected ? Colors.white : Color(0xff00838f),
                        height: 24,
                        width: 24,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        SetLocalization.of(context)!.getTranslateValue('nav_about_us')!,
                        style: TextStyle(fontSize: 14, color: homeIsSelected ? Colors.white : Colors.black),
                      )
                    ],
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator
                      .push(context, MaterialPageRoute(builder: (context) => WebViewExample(
                    lang: langApp??"en",
                    direction: "terms",
                    urlLink: "https://wainsale.com/apps_api/pages/terms.php?lang=",)));
                  // Navigator
                  //     .push(context, MaterialPageRoute(builder: (context) => TermsConditions()));
                },
                child: Container(
                  color: homeIsSelected ? Colors.grey.withOpacity(0.5) : Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 25,
                      ),
                      Image.asset(
                        'assets/images/drawer/privacy_policy.png',
                        color: homeIsSelected ? Colors.white : Color(0xff00838f),
                        height: 24,
                        width: 24,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        SetLocalization.of(context)!.getTranslateValue('nav_terms')!,
                        style: TextStyle(fontSize: 14, color: homeIsSelected ? Colors.white : Colors.black),
                      )
                    ],
                  ),
                ),
              ),

              //polcy

              InkWell(
                onTap: () {
                  Navigator
                      .push(context, MaterialPageRoute(builder: (context) => WebViewExample(
                    lang: langApp??"en",
                    direction: "privacypolicy",
                    urlLink: "https://wainsale.com/apps_api/pages/privacy.php?lang=",
                  )));
                  // Navigator
                  //     .push(context, MaterialPageRoute(builder: (context) => TermsConditions()));
                },
                child: Container(
                  color: homeIsSelected ? Colors.grey.withOpacity(0.5) : Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 25,
                      ),
                      Image.asset(
                        'assets/images/drawer/privacy_policy.png',
                        color: homeIsSelected ? Colors.white : Color(0xff00838f),
                        height: 24,
                        width: 24,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        SetLocalization.of(context)!.getTranslateValue('privacypolicy')!,
                        style: TextStyle(fontSize: 14, color: homeIsSelected ? Colors.white : Colors.black),
                      )
                    ],
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator
                      .push(context, MaterialPageRoute(builder: (context) => WebViewExample(direction: "joinus",
                    lang: langApp??"en",
                    urlLink: "https://wainsale.com/apps_api/pages/joinus.php?lang=",)));
                  //https://wainsale.com/apps_api/pages/joinus.php?lang=
                  // Navigator
                  //     .push(context, MaterialPageRoute(builder: (context) => Joinus()));
                },
                child: Container(
                  color: homeIsSelected ? Colors.grey.withOpacity(0.5) : Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 25,
                      ),
                      Image.asset(
                        'assets/images/drawer/contact_us.png',
                        color: homeIsSelected ? Colors.white : Color(0xff00838f),
                        height: 24,
                        width: 24,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        SetLocalization.of(context)!.getTranslateValue('nav_join')!,
                        style: TextStyle(fontSize: 14, color: homeIsSelected ? Colors.white : Colors.black),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        color: Color(0xff00838f),
                      ),
                    )
                  ],
                ),
              ),

              InkWell(
                onTap: () {
                  removs();
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 25,
                      ),
                      Image.asset(
                        'assets/images/drawer/sing_out.png',
                        height: 24,
                        width: 24,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        SetLocalization.of(context)!.getTranslateValue('nav_sign_out')!,
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
              ),

            ],
          )
      ),
    );
  }

  Widget bodyApp(){
    return  Container(
      height: MediaQuery.of(context).size.height,
      // color: Colors.black38,
      padding: EdgeInsets.only(
          left: 15,right: 15,bottom: 100
      ),
      child: Column(
            children: [

              Visibility(
                  visible: _All_Slider.isEmpty?false:true,
                  child:  sliderOffers()
              ),


              SizedBox(height: 4,),

             Expanded(
                 child: Container(
                   child:   RefreshIndicator(
                     onRefresh: getRefrich,
                     color: Colors.white,
                     backgroundColor: Colors.black,
                     child:ListView(
                       controller:controller,
                     padding: EdgeInsets.only(bottom: _All_allOffer!.isEmpty?1:150),
                     // physics: FixedExtentScrollPhysics(),
                     shrinkWrap: true,
                     children: [
                       // _All_mainCatigry.isEmpty ? Text("") :
                       if(_All_mainCatigry.isNotEmpty)
                       CtigryMain_List(),
                       // _All_mainCatigry.isEmpty ? Text("") :
                       if(_All_mainCatigry.isNotEmpty)
                       Divider(
                         thickness: 1,
                         color: Colors.black12,
                       ),

                       // // SizedBox(height: 2,),
                       // _All_SupCatigry.isEmpty ? Text("") :
                           if(_All_SupCatigry.isNotEmpty)
                       Visibility(
                           visible: index_categry==0?false:true,
                           child:  SupCAtigry_List()
                       ),


                       // _All_SupCatigry.isEmpty ? Text("") :
                       if(_All_SupCatigry.isNotEmpty)
                       Visibility(
                         visible: index_categry==0?false:true,
                         child:Divider(
                           thickness: 1,
                           color: Colors.black12,
                         ),
                       ),

                       Visibility(
                           visible:index_categry==0?true:false,
                           child:  SizedBox(height: 15,)
                       ),
                       //
                       // _All_allOffer.isEmpty ?
                       Stack(
                         children: [

                           Visibility(
                             visible: _All_allOffer!.isNotEmpty?true:false,
                             // true,
                             // visible: !isListLoading,
                             replacement: Container(
                               child: Center(child: Text("")),
                               // child: Center(child: CircularProgressIndicator()),
                             ),
                             child:  Container(

                               // height: MediaQuery.of(context).size.height/2,
                               child: ListView.builder(
                                 physics: ScrollPhysics(),
                                 shrinkWrap: true,
                                 itemCount: _All_allOffer==null ? 0 : _All_allOffer!.length,
                                 itemBuilder: (BuildContext context, int index) {
                                   return InkWell(
                                       onTap: () async {
                                         print("offer ");
                                         var result = await  Navigator.push(
                                             context,
                                             MaterialPageRoute(
                                               builder: (context) => OfferScreen(
                                                 offerID: _All_allOffer![index]["id"].toString(),
                                                 offerName: _All_allOffer![index]["name"],
                                                 offerFavorite:  _All_allOffer![index]["favorite"].toString(),
                                                 locationid_mal: id_location_id.toString(),
                                                 id_Catigry: idCategry.toString(),
                                                 id_SubCatrgry: index_SubCategy_id.toString(),
                                                 cat_id: index_categryAnd_SupCatigru.toString(),
                                                 direction: "offer",
                                                 indexrow: index,
                                               ),
                                             ));
                                         print(result.toString());
                                         print(result.toString());
                                         if(result!=null){
                                           setState(() {
                                             serachField.text="";
                                             // _filterCountries("");
                                           });
                                           print("Back offer to home : >>>>>>>>>>>>>>  $result");
                                           if(result["favorit"]!=null&& result["directio"]=="offer"){
                                             setState(() {
                                               _All_allOffer![int.parse(result["index"].toString())]["favorite"]=result["favorit"].toString();
                                             });
                                           }
                                           // _onRefresh();
                                         }
                                       },
                                       child: _getOffers(context, index,_All_allOffer!.length)

                                   );

                                 },
                               ),
                             ),

                           ),

                           Visibility(
                             visible:_All_allOffer==null|| _All_allOffer!.isEmpty?true:false,
                             child: Container(
                               margin: EdgeInsets.only(top: 0),//15
                               // padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/4),
                               child:
                               _All_allOffer_testdata==null?WitingShimmerList()
                               //   CircularProgressIndicator(backgroundColor: Color(0x2900838f),
                               //   valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff00838f)),
                               // ),
                               :
                               Center(child:
                               numOfferNotActive==0?
                               WitingShimmerList()
                                   :
                               Padding(padding: EdgeInsets.only(top: 140),
                                 child: Text(SetLocalization.of(context)!.getTranslateValue('no_offer2')!, style: TextStyle(
                                   fontSize: 20,
                                 ), textAlign: TextAlign.center,),
                               )),
                             ),
                           )
                         ],
                       ),

                       Container(

                         height:_All_allOffer!.length<5?MediaQuery.of(context).size.height/3:1,
                       )
                     ],
                   ),
                 )
                 )
             ),


            ],
          ),

    );
  }

  Widget _getOffers(BuildContext context, int index,lengh) {
    return
      InkWell(
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                //image
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  width: 70,
                  height: 70,
                  child: FittedBox(
                    child:
                    CachedNetworkImage(
                      height: 70,
                      width:70,
                      fit: BoxFit.fill,
                      imageUrl: "${_All_allOffer![index]["offer_img"]}",
                        placeholder: (context, url) => Container(),
                        errorWidget: (context, url, error) => Image.asset("assets/images/no_image_avilable.png",height: 120,width:120,),
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),

                Expanded(
                  child:Container(
                    height: 82,
                    padding: EdgeInsets.only(top: 2),
                    child:  Column(
                      children: <Widget>[

                        Row(
                          children: <Widget>[

                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child:Text(
                                      _All_allOffer![index]["name"],
                                      // _All_allOffer![index]["name"]+".....${index}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Expanded(
                            //   child:
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: Icon(
                                      _All_allOffer![index]["favorite"].toString() == 'null' ? Icons.favorite_border :
                                      _All_allOffer![index]["favorite"].toString() == '0' ? Icons.favorite_border :
                                      Icons.favorite,
                                      color: _All_allOffer![index]["favorite"].toString() == '0' ? Colors.grey :
                                      _All_allOffer![index]["favorite"].toString() == '1' ? Colors.red :
                                      Colors.grey,
                                    ),
                                    onTap: () {
                                      if (idUser != null) {
                                        if (_All_allOffer![index]["favorite"]
                                            .toString() == '1') {
                                          _sendItemData_favorite("un_fav",
                                              _All_allOffer![index]["id"],
                                              index,idMal: id_location_id
                                          );
                                          // client.addFavorite(PreferenceUtils.getUserEmail(), allOffer[index].id, PreferenceUtils.getUserSessionID()).then((value) => {if (value.statusCode != 200) {}});
                                        } else {
                                          _sendItemData_favorite("fav",
                                              _All_allOffer![index]["id"],
                                              index,idMal: id_location_id);
                                          // client
                                          //     .deleteFavorite(PreferenceUtils.getUserEmail(), allOffer[index].id, PreferenceUtils.getUserSessionID())
                                          //     .then((value) => {if (value.statusCode != 200) {}});
                                        }
                                      } else {
                                        sign_in(context);
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                            // )
                          ],
                        ),

                        Stack(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[

                                Container(
                                  // color: Colors.blue,
                                  // padding: EdgeInsets.only(bottom: 10),
                                  width: MediaQuery.of(context).size.width-110,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child:
                                        Text(
                                          _All_allOffer![index]["offer_description"].toString().length>76 ?
                                          _All_allOffer![index]["offer_description"].toString().substring(0,76)+"...." :
                                          _All_allOffer![index]["offer_description"]
                                          ,maxLines: 2,
                                          // style: TextStyle(fontSize: 13,
                                          //   color: Color(0xff9b9b9b),),
                                          // overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: const Color(0xff9b9b9b),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "SFProText",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.0
                                          ),
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            Align(
                              alignment: langApp=="ar"?Alignment.bottomLeft: Alignment.bottomRight,
                              child:  Container(
                                height: 50,
                                padding: EdgeInsets.only(right: 6),
                                width: MediaQuery.of(context).size.width/4.5,
                                child: ListView.builder(
                                  reverse: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                  _All_allOffer==null?0:
                                  _All_allOffer![index]==null?0:
                                  _All_allOffer![index]["small_icon"]==null?0:
                                  _All_allOffer![index]["small_icon"].length,
                                  itemBuilder: (BuildContext context, int position) {
                                    return Container(
                                      // color: Colors.red,
                                      // _All_allOffer[index]["small_icon"][position]
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            // SizedBox(width: 5,),

                                            Container(
                                              height: 27,
                                              width: 27,
                                              margin: EdgeInsets.only(left: 1,right: 1),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(color: const Color(0x33A6A6A6)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.1),
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: Offset(0, 1), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: ClipOval(
                                                child:
                                                CachedNetworkImage(
                                                  height: 34,
                                                  width:34,
                                                  fit: BoxFit.fill,
                                                  imageUrl: "${_All_allOffer![index]["small_icon"][position]}",
                                                  placeholder: (context, url) =>
                                                      Center(child:Container(),),
                                                  errorWidget: (context, url,
                                                      error) =>
                                                      Image.asset(
                                                        "assets/images/no_image_avilable.png",
                                                        height: 34, width: 34,),
                                                ),
                                                // FadeInImage(
                                                //     image:
                                                //     NetworkImage(_All_allOffer![index]["small_icon"][position]),
                                                //     width: 34,
                                                //     height: 34,
                                                //     placeholder: AssetImage('assets/images/no_image_avilable.png'),
                                                //     fit: BoxFit.cover,
                                                //   imageErrorBuilder:
                                                //       (context, error, stackTrace) {
                                                //     return Image.asset(
                                                //         'assets/images/logo2.png',
                                                //         fit: BoxFit.fitWidth);
                                                //   },
                                                // ),
                                              ),
                                            ),


                                          ],
                                        ));
                                  },
                                ),
                              ),
                            )
                          ],
                        ),


                        SizedBox(height: 2,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsetsDirectional.only(top: 0, bottom: 2),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(height: 1,
                        color: Color(0x80000000)),
                  ),
                ],
              ),
            ),

            // lengh>5?Text(""):Container(height: MediaQuery.of(context).size.height/2,)
          ],
        ),
      ),
    );
  }
  // all trending and slider


  Widget sliderOffers() {
    return Column(
      children: [

        Visibility(
          visible: showSlider,
          child: Container(
            margin: EdgeInsets.all(0),
            height: 120,
            decoration: new BoxDecoration(
              // color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(3),
              boxShadow: [BoxShadow(
                  color: Color(0x0a000000),
                  offset: Offset(0, 8),
                  blurRadius: 12,
                  spreadRadius: 0
              )
              ],
            ),
            child:
            _All_Slider.isEmpty ?
            Center(child: Text(
                SetLocalization.of(context)!.getTranslateValue("no_offer")!),)
                :
            sliderOffer(),

          ),
        ),


      ]

    );
  }

  int _current=0;

  // slider move
  Widget sliderOffer() {
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: showSlider,
      child: CarouselSlider(
        options: CarouselOptions(
          viewportFraction: 1.0,// max height
          autoPlay: true,
          enlargeCenterPage: true,
          height: 100,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(milliseconds: 1000),
          scrollDirection: Axis.horizontal,
          enableInfiniteScroll: true,
          reverse: true,
          onPageChanged: (index, reason) {
            setState(() {
              _current=index;
            });
          },
        ),
        carouselController: CarouselControllerImpl(
        ),

        items: <Widget>[
          for (var i = 0; i < _All_Slider.length; i++)
            InkWell(
              onTap: (){
                print("Slider Image ");
                Navigator
                    .push(context, MaterialPageRoute(builder: (context) => OfferScreen(
                  offerID: _All_Slider[i]["trending_offer"].toString(),
                  offerName:_All_Slider[i]["trending_name"],
                  locationid_mal: id_location_id.toString(),
                  id_Catigry: idCategry.toString(),
                  id_SubCatrgry: index_SubCategy_id.toString(),
                  cat_id: index_categryAnd_SupCatigru.toString(),
                  trending: _All_Slider[i]["trending_id"].toString(),
                  // offerFavorite:  _All_Slider[i]["favorite"]==null?null: _All_Slider[i]["favorite"],
                )));
              },
                child: Stack(
                  children: <Widget>[

                    Container(
                        decoration: new BoxDecoration(
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(0),
                        ),

                      child: Stack(
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                //Image offer
                                Container(
//                              height: 120,
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: Offset(0, 2), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child:
                                  CachedNetworkImage(
                                    height: 120,
                                    width:120,
                                    fit: BoxFit.fill,
                                    imageUrl: "${_All_Slider[i]["offer_img"]}",
                                    placeholder: (context, url) => Container(),
                                    errorWidget: (context, url, error) => Image.asset("assets/images/no_image_avilable.png",height: 120,width:120,),
                                  )
                                  // FadeInImage.assetNetwork(
                                  //   width: 120,
                                  //   height: 120,
                                  //   imageErrorBuilder:
                                  //       (context, error, stackTrace) {
                                  //     return Image.asset(
                                  //         'assets/images/logo2.png',
                                  //         fit: BoxFit.fitWidth);
                                  //   },
                                  //   fit: BoxFit.fill,
                                  //   placeholder: 'assets/images/logo2.png',
                                  //   image:  _All_Slider[i]["offer_img"],
                                  // ),
                                ),
                                SizedBox(width: 5,),

                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${_All_Slider[i]["trending_name"].toString().replaceAll("[&line;]", "\n").trim()}",
                                          style: const TextStyle(
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "SFProText",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.0
                                          ),
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),

                                        SizedBox(height: 5,),


                                        Text(
                                          "${_All_Slider[i]["offer_description"].toString().replaceAll("[&line;]", "\n").trim()}"
                                          ,
                                          style: const TextStyle(
                                              color: const Color(0xff9b9b9b),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "SFProText",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.0
                                          ),
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                        // SizedBox(height: 10,),
                                      ],
                                    )
                                ),

                              ]
                          ),

                          // Expanded(
                          //   child:
                            Container(
                              padding: EdgeInsets.only(left: 15,right: 7,),
                              child:
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(width: 1,),

                                      Row(
                                        children: List.generate(_All_Slider[i]["small_icon"].toString()=="null"?0 :_All_Slider[i]["small_icon"]==null?0 :
                                        _All_Slider[i]["small_icon"].length, (index) {
                                          return Row(
                                            children: [
                                              Container(
                                                height: 27, width: 27,

                                                margin: EdgeInsets.only(left: 1,right: 1),
                                                // padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  // color: Colors.cyan
                                                ),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      ClipRRect(
                                                      borderRadius: BorderRadius.circular(25.0),
                                                        child: CachedNetworkImage(
                                                          height: 27,
                                                          width:27,
                                                          fit: BoxFit.fill,
                                                          imageUrl: "${_All_Slider[i]["small_icon"][index]}",
                                                          placeholder: (context, url) => Container(),
                                                          errorWidget: (context, url, error) => Image.asset("assets/images/no_image_avilable.png",height: 120,width:120,),
                                                        )
                                                          // FadeInImage(
                                                          //   image:
                                                          //   NetworkImage(_All_Slider[i]["small_icon"][index])
                                                          //   ,
                                                          //   height: 27, width: 27,
                                                          //   placeholder: AssetImage('assets/images/no_image_avilable.png'),
                                                          //   fit: BoxFit.fill,
                                                          // ),
                                                      )
                                                    ]
                                                ),
                                              ),

                                            ],
                                          );
                                        }),
                                      ),
                                    ],
                                  ),

                                  // SizedBox(height: 10,),
                                  // InkWell(
                                  //   // onTap: (){
                                  //   //   print("Slider Image button ");
                                  //   //   Navigator
                                  //   //       .push(context, MaterialPageRoute(builder: (context) => OfferScreen(
                                  //   //     offerID: _All_Slider[i]["trending_offer"].toString(),
                                  //   //     offerName:_All_Slider[i]["trending_name"],
                                  //   //     // offerFavorite:  _All_Slider[i]["favorite"]==null?null: _All_Slider[i]["favorite"],
                                  //   //   )));
                                  //   //   // MaterialPageRoute(
                                  //   //   //   builder: (context) => OfferScreen(
                                  //   //   //     offerID: _All_Slider[i]["trending_offer"].toString(),
                                  //   //   //     offerName:_All_Slider[i]["trending_name"],
                                  //   //   //     // offerFavorite:  _All_Slider[i]["favorite"]==null?null: _All_Slider[i]["favorite"],
                                  //   //   //   ),
                                  //   //   // );
                                  //   // },
                                  //     child:Container(
                                  //       width: 78.5919189453125,
                                  //       height: 25,
                                  //       margin: EdgeInsets.only(left: 0,right: 0),
                                  //       decoration: new BoxDecoration(
                                  //         borderRadius: BorderRadius.circular(
                                  //             32.0),
                                  //         color: Color(0xffffffff),
                                  //         boxShadow: [BoxShadow(
                                  //             color: Color(0x29000000),
                                  //             offset: Offset(0, 3),
                                  //             blurRadius: 6,
                                  //             spreadRadius: 0
                                  //         )
                                  //         ],
                                  //       ),
                                  //       child: Center(child: Text(
                                  //           "View",
                                  //           style: const TextStyle(
                                  //               color: const Color(
                                  //                   0xff00838f),
                                  //               fontWeight: FontWeight.w500,
                                  //               fontFamily: "SFProText",
                                  //               fontStyle: FontStyle.normal,
                                  //               fontSize: 11.0
                                  //           ),
                                  //           textAlign: TextAlign.center
                                  //       ),),
                                  //     )
                                  // ),

                                  SizedBox(height: 1,),


                                ],
                              ) ,
                            ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                )
            )
        ],
      ),
    );
  }

 late List<Widget> pages=[];
  // List<Widget> pages = List<Widget>();
  var controlleree = PageController(initialPage: 0);



  categryFiltter() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[

        Visibility(
            visible: idUser==null ?true  :true ,
            child: Container(
              margin: EdgeInsets.only(
                left: langApp == 'en' ? 0 : 10,
                right: langApp == 'en' ? 10 : 0,
              ),
                alignment: Alignment.topRight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,

                ),
                height: 27,
                width: 27,
                child:  PopupMenuButton<String>(
                  padding: EdgeInsets.all(0),
                  color: Color(0xFF00838f).withOpacity(.752),
                  onSelected: (String result) {
                    print(result.toString()+">>>>>>>>>");
                    if(result!=null) {
                      setState(() {
                        print("..........................................");
                        print("..........................................");
                        if (idUser != null) {


                          setState(() {
                            firstHome=1;
                            numpage=1;
                            idfiltterDefult = result;
                            _All_allOfferId!.clear();
                          });
                          _All_allOfferId!.clear();
                          if (_All_allOffer!.isNotEmpty) {
                            _All_allOffer!.clear();
                            _All_allOffer_old!.clear();
                            data_allOffer!.clear();
                          }
                          setState(() {
                            firstHome=1;
                            _All_allOffer_testdata!.clear();
                            numpage = 1;
                            _All_allOfferId!.clear();
                          });
                          setState(() {
                            filtterChoce = result.toString();
                            // filtterChoce="choce";
                          });
                          print("?>?>");
                          print(result);
                          getData_allOffer_FromFiltter(id_location_id, "test");

                        } else {
                          sign_in(context);
                        }
                        // _selection = result;
                      });
                    }
                    else{
                    }
                  },
                  initialValue: null,
                  icon:
                  Icon(Icons.arrow_drop_down_outlined,color:Color(0xff00838f),size: 28,),
                  // Image.asset(
                  //   'assets/fi.png',
                  //   height: 42,
                  //   width: 22,
                  // ),
                  // elevation: 15,
                  // offset: Offset(11, 11),

                  itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<String>>[

                    // * ------------------------------------------------------------
                    // * ------------------------------------------------------------
                    PopupMenuItem(
                      height: 32,
                      enabled: false,
                      onTap: (){},
                      child:Center(
                        child:Text(
                          // SetLocalization.of(context).getTranslateValue('numOfferNotActive')+"$numOfferNotActive"+
                          SetLocalization.of(context)!.getTranslateValue('ShowOffersOnly')!
                          ,
                          style: TextStyle(fontSize: 16,
                              color: Colors.white
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),



                    // * ------------------------------------------------------------
                    PopupMenuItem(
                      height: 32,
                      enabled: false,
                      child: Center(
                        child: Switch(
                          onChanged: (val) {
                            print(val);

                            if (idUser != null) {
                              if(isChecked_filteNotAvtiveOffer==true){
                                setState(() {
                                  firstHome=1;
                                  _All_allOfferId!.clear();
                                  numpage=1;
                                  isChecked_filteNotAvtiveOffer=false;
                                });
                              }else{
                                setState(() {
                                  _All_allOfferId!.clear();
                                  numpage=1;
                                  firstHome=1;
                                  isChecked_filteNotAvtiveOffer=true;
                                });
                              }

                              try {
                                // index_categry=0;
                                // idCategry=null;
                                setState(() {
                                  positionList=0;
                                });
                                controller.jumpTo(0);
                                index_SubCategy_id=null;
                                index_SubCategy=null;
                                _All_mainCatigry.clear();
                                data_mainCatigry!.clear();
                                _All_allOffer!.clear();
                                _All_allOffer_old!.clear();
                                data_allOffer!.clear();

                                if(_All_SupCatigry.isNotEmpty){
                                  _All_SupCatigry.clear();
                                  // _All_SupCatigry.clear();
                                  data_SupCatigry!.clear();
                                }

                                setState(() {
                                  _All_allOfferId!.clear();
                                  _All_allOffer_testdata=null;
                                });


                                Timer(
                                    Duration(seconds: 0),
                                        () {
                                      setState(() {
                                        numpage=1;
                                        _All_allOffer_testdata = null;
                                      });
                                      // getData_allOffer_FromFiltter(id_location_id,"test");
                                    });
                                getData_MainCatigry(id_location_id, "switch","");



                                // getData_allOffer_FromFiltter(id_location_id);
                              }catch(e){}


                              Navigator.pop(context);

                            } else {
                              sign_in(context);
                            }



                          },
                          value:  isChecked_filteNotAvtiveOffer,
                          activeTrackColor: Colors.white,
                          // activeTrackColor: Color(0x3D00838f),
                          activeColor: Colors.orange,
                          // activeColor: Color(0xff00838f),
                        ),
                      ),
                    ),


                    // * ------------------------------------------------------------
                    PopupMenuItem(
                      height: 32,
                      enabled: false,
                      onTap: (){},
                      child:Center(
                        child: Text(
                          // "Offer Type Filter"
                          SetLocalization.of(context)!.getTranslateValue('offerTypeFilter')!
                          ,
                          style: TextStyle(fontSize: 16,
                              color: Colors.white,
                              decoration: TextDecoration.underline
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    for(int i=0 ; i<_All_filttercategry.length;i++)
                      PopupMenuItem<String>(
                        height: 32,
                        value: _All_filttercategry[i]["id"].toString(),
                        child: Text(_All_filttercategry[i]["type_name"],
                          style: TextStyle(
                              color: filtterChoce.toString()=="all"?Colors.white:
                              filtterChoce.toString()=="null"?Colors.white:
                              idfiltterDefult.toString()==_All_filttercategry[i]["id"].toString()?
                              Colors.black:
                              // Color(0xFF00838f):
                              Colors.white
                          ),
                        ),
                      ),
                  ],
                )
            )
        ),


      ],
    )
    );
  }

  String? idCategry="all";
  String? idfiltterDefult;

  Widget CtigryMain_List() {
    return
      Container(
        child: new Container(
          margin: EdgeInsets.all(4),
          height: 100,
          child:
          new ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 3),
            scrollDirection: Axis.horizontal,
//            itemCount: 15,
            itemCount: _All_mainCatigry == null ||
                _All_mainCatigry.length < 1 || _All_mainCatigry.isEmpty
                ? 0
                : data_mainCatigry?["categories"].length + 1,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () =>
                {
                  setState(() {
                    setState(() {
                      firstHome=1;
                      // filtterChoce=null;
                      // index_SubCategy_id = null;
                      _All_allOfferId!.clear();
                      _All_allOffer_testdata = null;
                    });
                    directionPajenation = "offers";
                    index_categry = index;
                    if (index == 0) {
                      setState(() {
                        idCategry = "all";
                        index_categryAnd_SupCatigru = "all";
                        print("idCategry $idCategry  index  $index");
                      });
                    } else {
                      setState(() {
                        idCategry = _All_mainCatigry[index]["id"].toString();
                        index_categryAnd_SupCatigru =
                            _All_mainCatigry[index]["id"].toString();
                      });
                    }

                    print("idCategry $idCategry  index  $index");

                    if (_All_SupCatigry.isNotEmpty) {
                      _All_SupCatigry.clear();
                      data_SupCatigry!.clear();
                      _All_SupCatigry.clear();
                    }
                    index_SubCategy = null;
                    index_SubCategy_id = null;

                    //........
                    if (_All_allOffer!.isNotEmpty) {
                      _All_allOffer!.clear();
                      data_allOffer!.clear();
                      _All_allOffer_old!.clear();
                    }

                    setState(() {
                      setState(() {
                        numOfferNotActive = 0;
                      });
                    });
                    setState(() {
                      numpage = 1;
                    });
                    getData_SupCatigry(idCategry, id_location_id);
                    getData_allOffer(id_location_id, idCategry, "categry", numpage);
                  }),

                },
                child:
                Container(
                  margin: EdgeInsets.only(
                      left: 10, right: 10, bottom: 0, top: 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),

                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                      child: Container(
                        child: Row(
                          children: <Widget>[



                            Visibility(
                                visible: index == 0 ? true : true,
                                child:
                                Column(
                                  children: [


                                    Container(
                                      width: 67,
                                      height: 67,
                                      decoration: new BoxDecoration(
                                        color: Color(0xffffffff),
                                        shape: BoxShape.circle,
                                        // borderRadius: BorderRadius.circular(45),
                                        boxShadow: [BoxShadow(
                                            color: Color(index_categry == index
                                                ? 0xff00838f
                                                : 0x29000000),
                                            offset: Offset(0, 3),
                                            blurRadius: 6,
                                            spreadRadius: 0
                                        )
                                        ],
                                      ),
                                      child: Container(
                                          margin: index == 0 ? EdgeInsets.all(
                                              14) : EdgeInsets.all(11),
                                          height: 35, width: 35,
                                          child: index == 0 ? Image.asset(
                                            "assets/images/allc2.png",
                                          )
                                              :
                                          CachedNetworkImage(
                                            // height: 120,
                                            // width:120,
                                            fit: BoxFit.fill,
                                            imageUrl: "${_All_mainCatigry[index]["image"]}",
                                            placeholder: (context, url) => Container(),
                                            errorWidget: (context, url, error) => Image.asset("assets/images/no_image_avilable.png",height: 120,width:120,),

                                          )
                                      ),
                                    ),

                                    SizedBox(height: 10,),


                                    Flexible(child: Container(
                                      // width: 67,
                                        child: Center(
                                          child: Text(
                                            _All_mainCatigry[index]["category_name"],
                                            style: TextStyle(
                                              fontFamily: 'SFProText',
                                              color: Color(
                                                  index_categry == index
                                                      ? 0xff00838f
                                                      : 0xff000000),
                                              fontSize: 13,
                                              // backgroundColor: Colors.redAccent,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                    )
                                    ),

                                  ],
                                )
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              );
            },
          ),
        ),
      );
  }

  int? index_SubCategy;
  int? index_SubCategy_id;

//index_categry
  Widget SupCAtigry_List() {
    return
      Center(
        child: Container(
          // color: Colors.red,
          padding: EdgeInsets.only(top: 0),
          // margin: EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 5),
          height: 32,
          child:
          new Center(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
//            itemCount: 15,
              itemCount: _All_SupCatigry == null ? 0 : _All_SupCatigry.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: ()=>{
                    // if(idUser!=null){
                    setState(() {
                      firstHome=1;
                      print("fdfdfdfdfdfdfdff"+_All_SupCatigry[index]["id"]);
                      _All_allOfferId!.clear();
                       index_SubCategy=index;
                       index_SubCategy_id=int.parse(_All_SupCatigry[index]["id"]);
                       index_categryAnd_SupCatigru=_All_SupCatigry[index]["id"].toString();
                      if(_All_allOffer!.isNotEmpty){
                        _All_allOffer!.clear();
                        _All_allOffer_old!.clear();
                        data_allOffer!.clear();
                      }

                      setState(() {
                        numpage=1;
                        _All_allOffer_testdata = null;
                      });
                      getData_allOffer_FromFiltter(id_location_id,"sup");
                    }),

                  },

                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child:
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10,bottom: 0,top: 1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // border: Border.all(
                      //   color: select_index != index?Color(0xff672297)
                      //       :Colors.white,
                      //   width: 1,
                      // )
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),

                      child: Padding(
                        padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                        child: Container(
                          child: Row(
                            children: <Widget>[


                              Visibility(
                                  visible: index==0?true:true,
                                  child:
                                  Column(
                                    children: [

                                      Container(
                                        // width: 67,
                                        height: 25,
                                        padding: EdgeInsets.only(left: 10,right: 10,),
                                        decoration: new BoxDecoration(
                                          color: Color(0xffffffff),
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [BoxShadow(
                                              color: Color(index_SubCategy_id.toString()==_All_SupCatigry[index]["id"].toString()? 0xff00838f :0x29000000),
                                              // color: Color(_selecteSupCategorys_index.contains(index)? 0xff00838f :0x29000000),
                                              offset: Offset(0,3),
                                              blurRadius: 6,
                                              spreadRadius: 0
                                          ) ],
                                        ),
                                        child: Center(child: Text(_All_SupCatigry[index]["category_name"],
                                            style: TextStyle(
                                              fontFamily: 'SFProText',
                                              color: Color(index_SubCategy_id.toString()==_All_SupCatigry[index]["id"].toString()? 0xff00838f :0xff000000),
                                              // color: Color(_selecteSupCategorys_index.contains(index)? 0xff00838f :0xff000000),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,


                                            )
                                        ),),
                                      )



                                    ],
                                  )
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                );
              },
            ),
          ),
//              ),
        ),
      )
    ;
  }





  Map? data_defultFiltter;
  List _All_filttercategry=[];

  Future getData_defultFiltter() async {

    // print(Uri.parse(URL_LOGIC.filterHome!));
    Map<String, dynamic> body = {
      "lang":langApp,
      "action":"defullt"
    };
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};
    final response_offer = await http.post(Uri.parse(URL_LOGIC.filterHome!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    // item
    data_defultLocation = json.decode(response_offer.body);


    setState(()  {
      data_defultFiltter = json.decode(response_offer.body);

      // print("data_defultFiltter  "+data_defultFiltter.toString());
      // setState(() {

        if(_All_filttercategry.isNotEmpty){
          _All_filttercategry.clear();
        }

        // print(data_defultFiltter!["filter"].toString());
        _All_filttercategry.addAll(data_defultFiltter!["filter"]);

        // * use to save allSlider to use in HomeWithoutNet
        setAllFilter(allFiltter: response_offer.body);
        // }
      // });

    });

  }


  Map? data_defultLocation;
  String? id_city_id;
  String? id_location_id;
  String? city_name_default;
  String? location_name_default;//location_name_default,id_location_id

  Future getData_defultLocation() async {
    Map<String, dynamic> body = {
      "lang":langApp,
      "longitude":longitude,
      "latitude":latitude,
      "user_token":token_fromFirbase,
      "userid":idUser,

    };
    print(body.toString());
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};
    final response_offers = await http.post(Uri.parse(URL_LOGIC.defultLocationHome!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    // item


    data_defultLocation = json.decode(response_offers.body);
    // setState(()  {
      data_defultLocation = json.decode(response_offers.body);
      print(data_defultLocation.toString());

      // setState(() {//city_id, location_id,  city_name_default , location_name_default
        indexCity=int.parse(data_defultLocation!["postion"].toString());
        // print("؟؟؟؟؟؟؟؟؟؟؟؟؟؟\n\n\n\ ${data_defultLocation!["postion"].toString()}");
         id_city_id=data_defultLocation!["city_id"].toString();
        id_location_id=data_defultLocation!["location_id"].toString();
        city_name_default=data_defultLocation!["city_name_default"].toString();
        location_name_default=data_defultLocation!["location_name_default"].toString();



        // * use to save name Location to use in HomeWth out Net
        setNameeMole_SherdRefreanse(nameMoaledd: location_name_default);

        if(id_location_id!=null){

          if(_All_mainCatigry.isNotEmpty){
            setState(() {
              _All_mainCatigry.clear();
              data_mainCatigry!.clear();
            });
          }

          if(_All_Slider.isNotEmpty){
            setState(() {
            _All_Slider.clear();
            data_offer!.clear();
            });
          }

          if(_All_event.isNotEmpty){
            setState(() {
            _All_event.clear();
            data_event_mal!.clear();
            });
          }
          setState(() {
            numOfferNotActive=0;
          });


          getADS_inhome(id_location_id);
          Timer(
              Duration(seconds: 0),
                  () async {
                    getData_serive(id_location_id, location_name_default);
                  });
          getData_Slider(id_location_id,"no");
          getData_MainCatigry(id_location_id,"not","");
        }

      // });

    // });

  }


  //data_offer,_All_Slider
  Map? data_offer;
  List _All_Slider = [];


  addDataIntoSlider(){

    // setState(() {
    //   for (var i = 0; i < _All_Slider.length; i++)
    //     print("i>>>>>>>>>"+ _All_Slider[i]["offer_img"]);
    // });
    setState(() {
      for (var i = 0; i < _All_Slider.length; i++)
        pages.add(
            Container(
                height: 100,
                child: InkWell(
                    onTap: (){
                      // print("Slider Image ");
                      Navigator
                          .push(context, MaterialPageRoute(builder: (context) => OfferScreen(
                        offerID: _All_Slider[i]["trending_offer"].toString(),
                        offerName:_All_Slider[i]["trending_name"],
                        locationid_mal: id_location_id!.toString(),
                        id_Catigry: idCategry!.toString(),
                        id_SubCatrgry: index_SubCategy_id.toString(),
                        cat_id: index_categryAnd_SupCatigru!.toString(),
                        trending: _All_Slider[i]["trending_id"].toString(),
                        // offerFavorite:  _All_Slider[i]["favorite"]==null?null: _All_Slider[i]["favorite"],
                      )));
                    },
                    child: Stack(
                      children: <Widget>[

                        Container(
                          height: 100,
                          decoration: new BoxDecoration(
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(0),
                          ),

                          child: Stack(
                            children: [
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    // SizedBox(width: 5,),
                                    //Image offer
                                    Container(
//                              height: 120,
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 2,
                                            offset: Offset(0, 2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: FadeInImage.assetNetwork(
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.fill,
                                        placeholder: 'assets/images/logo2.png',
                                        image:  _All_Slider[i]["offer_img"],
                                      ),
                                    ),
                                    SizedBox(width: 5,),

                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
//                                  crossAxisAlignment: WrapCrossAlignment.start,
//                                  direction: Axis.vertical,
                                          children: [

                                            // SizedBox(height: 10,),
                                            Text(
                                              "${_All_Slider[i]["trending_name"].toString().replaceAll("\n", "ضسا")}",
                                              style: const TextStyle(
                                                  color: const Color(0xff000000),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "SFProText",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 15.0
                                              ),
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),

                                            SizedBox(height: 5,),


                                            Text(
                                              "${_All_Slider[i]["offer_description"].toString().replaceAll("[&line;]", "\n")}"
                                              ,
                                              style: const TextStyle(
                                                  color: const Color(0xff9b9b9b),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "SFProText",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 12.0
                                              ),
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                            // SizedBox(height: 10,),
                                          ],
                                        )
                                    ),

                                  ]
                              ),

                              // Expanded(
                              //   child:
                                Container(
                                  padding: EdgeInsets.only(left: 15,right: 7,),
                                  child:
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          SizedBox(width: 1,),

                                          Row(
                                            children: List.generate(_All_Slider[i]["small_icon"]==null?0:_All_Slider[i]["small_icon"].length, (index) {
                                              return Row(
                                                children: [
                                                  Container(
                                                    height: 27, width: 27,

                                                    margin: EdgeInsets.only(left: 1,right: 1),
                                                    // padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      // color: Colors.cyan
                                                    ),
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(25.0),
                                                            child:
                                                            FadeInImage(
                                                              image:
                                                              // _All_Slider[i]==null?AssetImage('assets/images/no_image_avilable.png'):
                                                              // _All_Slider[i]["small_icon"]==null?AssetImage('assets/images/no_image_avilable.png'):
                                                              // _All_Slider[i]["small_icon"][index]==null?AssetImage('assets/images/no_image_avilable.png'):
                                                              NetworkImage(_All_Slider[i]["small_icon"][index])
                                                              //       :
                                                              // AssetImage('assets/images/no_image_avilable.png')
                                                              ,
                                                              height: 27, width: 27,
                                                              placeholder: AssetImage('assets/images/no_image_avilable.png'),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          )
                                                        ]
                                                    ),
                                                  ),

                                                ],
                                              );
                                            }),
                                          ),
                                        ],
                                      ),

                                      // SizedBox(height: 10,),
                                      // InkWell(
                                      //   // onTap: (){
                                      //   //   print("Slider Image button ");
                                      //   //   Navigator
                                      //   //       .push(context, MaterialPageRoute(builder: (context) => OfferScreen(
                                      //   //     offerID: _All_Slider[i]["trending_offer"].toString(),
                                      //   //     offerName:_All_Slider[i]["trending_name"],
                                      //   //     // offerFavorite:  _All_Slider[i]["favorite"]==null?null: _All_Slider[i]["favorite"],
                                      //   //   )));
                                      //   //   // MaterialPageRoute(
                                      //   //   //   builder: (context) => OfferScreen(
                                      //   //   //     offerID: _All_Slider[i]["trending_offer"].toString(),
                                      //   //   //     offerName:_All_Slider[i]["trending_name"],
                                      //   //   //     // offerFavorite:  _All_Slider[i]["favorite"]==null?null: _All_Slider[i]["favorite"],
                                      //   //   //   ),
                                      //   //   // );
                                      //   // },
                                      //     child:Container(
                                      //       width: 78.5919189453125,
                                      //       height: 25,
                                      //       margin: EdgeInsets.only(left: 0,right: 0),
                                      //       decoration: new BoxDecoration(
                                      //         borderRadius: BorderRadius.circular(
                                      //             32.0),
                                      //         color: Color(0xffffffff),
                                      //         boxShadow: [BoxShadow(
                                      //             color: Color(0x29000000),
                                      //             offset: Offset(0, 3),
                                      //             blurRadius: 6,
                                      //             spreadRadius: 0
                                      //         )
                                      //         ],
                                      //       ),
                                      //       child: Center(child: Text(
                                      //           "View",
                                      //           style: const TextStyle(
                                      //               color: const Color(
                                      //                   0xff00838f),
                                      //               fontWeight: FontWeight.w500,
                                      //               fontFamily: "SFProText",
                                      //               fontStyle: FontStyle.normal,
                                      //               fontSize: 11.0
                                      //           ),
                                      //           textAlign: TextAlign.center
                                      //       ),),
                                      //     )
                                      // ),

                                      SizedBox(height: 1,),


                                    ],
                                  ) ,
                                ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    )
                )
            )
        );
    });




    setState(() {
      _currentPage=0;
    });

    setState(() {
      timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
        // print(">>>>>>>>>>"+_currentPage.toString());
        if (_currentPage < _All_Slider.length-1)
          // if (_currentPage < widget.events[0].eventsImg.length)
            {
              // try{
              //   setState(() {
              //     _currentPage++;
              //   });
              // }catch(e){
              //
              // }


        } else {
        //   try{
        //   setState(() {
        //   _currentPage = 0;
        //   });
        // }catch(e){
        //
        // }

        }

        try {
          controlleree.animateToPage(_currentPage,
            duration: Duration(milliseconds: 1350),
            curve: Curves.easeIn,
          );
        }catch(e){

        }
      });
    });

  }

  Timer? timer;
  int _currentPage = 0;

  Future getData_Slider(idmal,filtter) async {
    try{
      if(_All_Slider.isNotEmpty|| _All_Slider!=null){
        data_offer!.clear();
        _All_Slider.clear();
      }
    }catch(e){

    }

    if(_All_Slider.isNotEmpty){
      data_offer!.clear;
      _All_Slider.clear;
    }
    if(_All_Slider.length>0){
      setState(() {
        data_offer!.clear;
        _All_Slider.clear;
      });

    }
        Map<String, dynamic> body = {
      "lang":langApp,
      "locationid":idmal
    };
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};
    final response_offer = await http.post(Uri.parse(URL_LOGIC.sliderHome!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    // item
    data_offer = json.decode(response_offer.body);


    setState(()  {
      if(_All_Slider.length>0){
        setState(() {
          data_offer!.clear();
          _All_Slider.clear();
        });
      }
      data_offer = json.decode(response_offer.body);
      _All_Slider.clear;
      try{
        // * use to save allSlider to use in HomeWithoutNet
        setAllSlider(allSlider: response_offer.body);

        if(data_offer!["trending_offers"][0]["trending_id"]!=null){
          setState(() {
            _All_Slider.addAll(data_offer!["trending_offers"]);
            showSlider=true;


            addDataIntoSlider();
          });

        }else{
          showSlider=true;
        }


      }catch(e){

      }
  });

  }



  List _All_event=[];
  Map? data_event_mal;
  // to get all event in mal
  Future getData_serive(id_location_mal,mall) async {

    if(data_event_mal!=null ){
      data_event_mal!.clear();
    }
    if(_All_event.isNotEmpty){
      _All_event.clear();
    }

    Map<String, dynamic> body = {
      "lang":langApp,
      "locationid":id_location_mal.toString(),
      "mall":mall
    };

    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};
    final response_offer = await http.post(Uri.parse(URL_LOGIC.get_events_servicesHome!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    // item
    data_event_mal = json.decode(response_offer.body);


    setState(()  {
      data_event_mal = json.decode(response_offer.body);

      // print("data_event_mal  "+data_event_mal.toString());

      setState(() {
        if(data_event_mal!["main"]!=null){
          setState(() {
            serviceWatched=true;
            viewEvent=0;
            _All_event.addAll(data_event_mal!["main"]);
            // print("_All_event  :::::::::::::::::::::::::::::::::::::::");
            // print("_All_event  "+_All_event.toString());
            // print("_All_event  :::::::::::::::::::::::::::::::::::::::");

            // * use to save name Location to use in HomeWth out Net
            setAllEvents(allEvents: response_offer.body);
          });
        }else{
          setState(() {
            viewEvent=1;
            serviceWatched=false;
          });
        }

        // id_city_id=data_defultLocation["city_id"].toString();
        // id_location_id=data_defultLocation["location_id"].toString();
        // city_name_default=data_defultLocation["city_name_default"].toString();
        // location_name_default=data_defultLocation["location_name_default"].toString();
      });

    });

  }


//_All_mainCatigry,data_mainCatigry
  List _All_mainCatigry=[];
  Map? data_mainCatigry;

  Future getData_MainCatigry(id_location_mal,filterORnot,direction) async {

    print(numpage);
    print("...........!!!!!....."+numpage.toString());
    if(_All_mainCatigry!=null){
      setState(() {
        _All_mainCatigry.clear();
      });

    }

    if(_All_mainCatigry.isNotEmpty){
      setState(() {
        _All_mainCatigry.clear();
      });

    }
    if(data_mainCatigry!=null){
      setState(() {
      data_mainCatigry?.clear();
      });
    }

    Map<String, dynamic> body = {
      "lang":langApp,
      "locationid":id_location_mal,
      "switch_offers":isChecked_filteNotAvtiveOffer,
    "userid":idUser
    };
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};
    final response_offer = await http.post(Uri.parse(URL_LOGIC.mainCAtegryHome!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    // print("data_mainCatigry  "+response_offer.body.toString());
    // item
    data_mainCatigry = json.decode(response_offer.body);

    if(isrefrech=true){
      setState(() {
        isrefrech=false;
      });
    }

    setState(()  {
      // data_mainCatigry = json.decode(response_offer.body);

      setState(() {
        // * use to save allSlider to use in HomeWithoutNet
        setAllCatigry(allCategry:response_offer.body);

        if(data_mainCatigry!["categories"][0]["id"]!=null){

          setState(() {
            _All_mainCatigry.clear();
            _All_mainCatigry.addAll([
              {
                "id": 8,
                "category_name": langApp=="ar"? "الكل":"All",
                "offer_img": "https://prestige.sa/uploads/categories/categories4227-132.png",
                "locations":""

              }
            ]);
            // serviceWatched=true;
            _All_mainCatigry.addAll(data_mainCatigry!["categories"]);

            if(_All_SupCatigry.isNotEmpty){
              _All_SupCatigry.clear();
              data_SupCatigry!.clear();
              _All_SupCatigry.clear();
            }

            // //........
            if(_All_allOffer!.isNotEmpty){
              _All_allOffer!.clear();
              _All_allOffer_old!.clear();
              // data_allOffer!.clear();
              _All_allOffer_old!.clear();
            }

            if(filterORnot.toString()=="not") {
              getData_SupCatigry("all", id_location_mal);
              getData_allOffer(id_location_mal,"all",direction,numpage);
            }

            if(filterORnot.toString()=="switch") {
              getData_SupCatigry(idCategry, id_location_mal);
              getData_allOffer(id_location_mal,idCategry,direction,numpage);
              // getData_SupCatigry("all", id_location_mal);
              // getData_allOffer(id_location_mal,"all",direction,numpage);
            }
            //
            if(filterORnot.toString()=="re") {
              getData_SupCatigry(idCategry, id_location_mal);
              getData_allOffer(id_location_mal,idCategry,direction,numpage);
            }

          });
        }

        // id_city_id=data_defultLocation["city_id"].toString();
        // id_location_id=data_defultLocation["location_id"].toString();
        // city_name_default=data_defultLocation["city_name_default"].toString();
        // location_name_default=data_defultLocation["location_name_default"].toString();
      });

    });

  }



  List _All_SupCatigry=[];
  Map? data_SupCatigry;
  Future getData_SupCatigry(id_categry,id_location_mal) async {


    if(data_event_mal!=null ){
      data_event_mal!.clear();
    }

    Map<String, dynamic> body = {
      "lang":langApp,
      "perent":id_categry,
      "locationid":id_location_mal,
      "switch_offers":isChecked_filteNotAvtiveOffer,
    };
    // Map<String, String> timeOutMessage = {
    //   'state': 'timeout',
    //   'content': 'server is not responding'
    // };
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);


    final headers = {'Content-Type': 'application/json'};
    final response_offer = await http.post(Uri.parse(URL_LOGIC.mainCAtegryHome!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );

    // item
    // data_mainCatigry = json.decode(response_offer.body);
    try{
      // progressDialog!.dismiss();
      // TipDialogHelper.dismiss();
    }catch(e){

    }


    setState(()  {
      data_SupCatigry = json.decode(response_offer.body);

      print(jsonBody);
      print(data_SupCatigry);
      print("getData_SupCatigry");

      setState(() {
        if(data_SupCatigry!["categories"]!=null||data_SupCatigry!["categories"][0]["id"]!=null){
          setState(() {
            // _All_mainCatigry.add
            // _All_mainCatigry.addAll([
            //   {
            //     "id": 8,
            //     "name": "All",
            //     "image": "https://prestige.sa/uploads/categories/categories4227-132.png"
            //   }
            // ]);
            // serviceWatched=true;
            _All_SupCatigry.addAll(data_SupCatigry!["categories"]);
          });
        }

        // id_city_id=data_defultLocation["city_id"].toString();
        // id_location_id=data_defultLocation["location_id"].toString();
        // city_name_default=data_defultLocation["city_name_default"].toString();
        // location_name_default=data_defultLocation["location_name_default"].toString();
      });

    });

  }



  List? _All_allOffer=[];
  List? _All_allOfferId=[];
  List? _All_allOffer_testdata=null;
  List? _All_allOffer_old=[];
  Map? data_allOffer;
  int numOfferNotActive=0;
  int allOfferfromBack=0;

  Future getData_allOffer(id_location_mal,id_categry,direction,numpagepajenation) async {
    setState(() {
      allOfferfromBack=0;
    });

    if(numpage.toString()=="1"){
      if(data_allOffer!=null ){
        data_allOffer!.clear();
      }
      if(_All_allOffer!.isNotEmpty){
        _All_allOffer!.clear();
        _All_allOffer_old!.clear();
        _All_allOffer_testdata=null;
      }
    }



    Map<String, dynamic> body = {
      "lang":langApp,
      // "locationid":5,
      "locationid":id_location_mal,
      // "locationid":id_location_id,
      "userid":idUser,
      "perent":id_categry,
      "switch_offers":isChecked_filteNotAvtiveOffer,
      "click_item" :idfiltterDefult,
      "page":numpage
      // "page":numpagepajenation
    };

    if(direction=="appBar"){
      body.addAll({"loc_click":1});
    }
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};
   final response_offer = await http.post(Uri.parse(URL_LOGIC.offersHome!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    // item
    data_allOffer = json.decode(response_offer.body);
    setState(()  {
      data_allOffer = json.decode(response_offer.body);
      print(jsonBody);
      print(response_offer.body);
      print("-----------");
      // * use to save allSlider to use in HomeWithoutNet
      if(idCategry=="all"){
        setAllOffers(allOffers:response_offer.body);
      }


      setState(() {

        try{
          if(data_allOffer!["offers"][0]["id"]!=null){
            setState(() {

              // _All_allOffer!.addAll(data_allOffer!["offers"]);
              for(int i=0;i<data_allOffer!["offers"].length;i++){
                if(_All_allOfferId!.contains(data_allOffer!["offers"][i]["id"])==false){
                if(_All_allOfferId!.contains(data_allOffer!["offers"][i]["id"])==false){
                //   print(data_allOffer!["offers"][i]["id"]);
                  _All_allOffer!.add(data_allOffer!["offers"][i]);
                  _All_allOfferId!.add(data_allOffer!["offers"][i]["id"]);
                  }

                  // print(data_allOffer!["offers"]![i]);
                  // print(_All_allOfferId!.contains(data_allOffer!["offers"][i]["id"]));
                }
              }
              for(int active=0 ; active<_All_allOffer!.length ;active++){
                if(_All_allOffer![active]["active"].toString() =="null" ||_All_allOffer![active]["active"].toString() !="1" ){
                  numOfferNotActive=numOfferNotActive+1;
                  setState(() {});
                }
              }
            });

            setState(() {
              if(firstHome==0&&numpage==1){
                numpage++;
              }else if(firstHome==1){
                numpage++;
              }

            });

            print(data_allOffer!["offers"].length);
            print(numpage);
            print(":::::.>>>>>>>>");
            print(":::::.>>>>>>>>");
            print(":::::.>>>>>>>>");
            print(":::::.>>>>>>>>");
          }else {
            setState(() {
              _All_allOffer_testdata = [];
            });
          }


        }catch(e){setState(() {
          numOfferNotActive=1;
        });}

        _All_allOffer_testdata = [];

      });

    });

  }



  Future getData_allOffer_FromFiltter(id_location_mal,sup) async {


    setState(() {
      directionPajenation="filtter";
    });

    Map<String, dynamic> body = {
      "lang":langApp,
      "action":"search",
      "type":idfiltterDefult,//idfiltterDefult
      "categories":idCategry,
      // "sub_categories":_selecteSupCategorys,
      "sub_categories":index_SubCategy_id,
      "switch_offers":isChecked_filteNotAvtiveOffer,
      "locationid":id_location_id,
      "userid":idUser,
      "page":numpage
    };



    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);

    print(jsonBody);
    print(":::::::::::::::::::::::::");

    final headers = {'Content-Type': 'application/json'};
    final response_offer = await http.post(Uri.parse(URL_LOGIC.offersHome_FromFiltter!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );

    if(isrefrech=true){
      setState(() {
        isrefrech=false;
        // _refreshController.refreshCompleted();
      });
    }


    // item
    data_allOffer = json.decode(response_offer.body);

    setState(()  {
      data_allOffer = json.decode(response_offer.body);
      // _All_allOffer!.clear();
      // _All_allOfferId!.clear();
      print(data_allOffer!["filter"]);

      try{
        setState(() {
          if(data_allOffer!["filter"][0]["id"]!=null){
            print("............");
            setState(() {
              numpage++;
              // _All_allOffer!.add(data_allOffer!["filter"]);
              for(int i=0;i<data_allOffer!["filter"].length;i++){
                if(_All_allOfferId!.contains(data_allOffer!["filter"][i]["id"])==false){
                  if(_All_allOfferId!.contains(data_allOffer!["filter"][i]["id"])==false){
                    //   print(data_allOffer!["offers"][i]["id"]);
                    _All_allOffer!.add(data_allOffer!["filter"][i]);
                    _All_allOffer_old!.add(data_allOffer!["filter"][i]);
                    _All_allOfferId!.add(data_allOffer!["filter"][i]["id"]);
                    setState(() {

                    });
                  }
                }
              }
              // _All_allOffer_old!.addAll(data_allOffer!["filter"]);
              if(index_categry>=0 && sup.toString() !="sup"){

                if(_All_SupCatigry.isNotEmpty){
                  _All_SupCatigry.clear();
                  _All_SupCatigry.clear();
                  data_SupCatigry!.clear();
                }
                getData_SupCatigry(idCategry, id_location_mal);
              }
            });

            setState(() {
              _All_allOffer_testdata = [];
            });
          }else{
            setState(() {
              _All_allOffer_testdata = [];
            });
          }
          setState(() {
            numOfferNotActive=1;
          });
        });

        print(numpage);
        print(":::::.>>>>>>>>");
        print(":::::.>>>>>>>>");
        print(":::::.>>>>>>>>");
        print(":::::.>>>>>>>>");
      }catch(e){
        setState(() {
          numOfferNotActive=1;
        });
        setState(() {
          _All_allOffer_testdata = [];
        });
        if(isrefrech=true){
          setState(() {
            isrefrech=false;
            // _refreshController.refreshCompleted();

          });
        }
      }
    });

  }







  Future getADS_inhome(id_location_mal) async {
    // {"lang":"en","locationid":"6"}
    setState(() {
      isMainVisable=false;
    });

    Map<String, dynamic> body = {
      "lang":langApp,
      "locationid":id_location_mal,
    };

    // Navigator;
    try {
      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json'};
      final response_offer = await http.post(Uri.parse(URL_LOGIC.main_offer_ads!),
        body: jsonBody,
        encoding: encoding,
        headers: headers,
      );

      // item
      Map dataADS = json.decode(response_offer.body);
      setState(() {
        dataADS = json.decode(response_offer.body);
        if (dataADS["main_offers"][0]["image_url"] != null) {
          setState(() {
            isMainVisable = false;
          });
          if(showAds==0){
            setState(() {
              showAds=1;
            });
            Timer(
                Duration(seconds: 0),
                    () async {
            showAdvDialog(context, dataADS["main_offers"][0]["image_url"].toString());

          });
          }

        } else {
          setState(() {
            isMainVisable = false;
          });

        }
      });
    }catch(e){
      setState(() {
        isMainVisable = false;
      });
    }
  }


  int showAds=0;
  Future<void> showAdvDialog(BuildContext context, String image) {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Container(
                        height: 350,
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                        BoxShadow(
                          blurRadius: 0.0,
                          offset: Offset(0.0, 0.0),
                        ),
                      ]),
                      child: FittedBox(
                        child: CachedNetworkImage(
                          height: 350,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                          imageUrl: "$image",
                          placeholder: (context, url) => Container(),
                          errorWidget: (context, url, error) => Image.asset("assets/images/no_image_avilable.png",height: 350,
                            width: MediaQuery.of(context).size.width,),
                        ),
                        // FadeInImage(
                        //   height: 350,
                        //   fit: BoxFit.fill,
                        //   width: MediaQuery.of(context).size.width,
                        //   image: NetworkImage(image),
                        //   placeholder:
                        //   AssetImage('assets/images/loadimage.gif',),
                        // ),
                        fit: BoxFit.fill,
                      )
                    ),
                    Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isMainVisable = false;
                            // showAds=0;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 14.0,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }



  static Future<bool> popup(BuildContext context) async {
    // Navigator.pop(context);
    return true;
  }

  static Future<bool> onWillPop(BuildContext context) async {
    return (await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        title: Text(SetLocalization.of(context)!.getTranslateValue('are_you_sure')!),
        titlePadding: EdgeInsets.only(left: 5.0,right: 5.0,top: 5.0),
        contentPadding: EdgeInsets.only(left: 5.0,right: 5.0,top: 5.0,bottom: 0),
        content: Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(SetLocalization.of(context)!.getTranslateValue('no')!,style: TextStyle(
                    color: Color(0xff00838f)
                ),),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                padding: EdgeInsets.all(0.0),
              ),
              FlatButton(
                onPressed: () {

                  try{
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  }catch(e){

                  }
                  exit(0);
                  // Navigator.of(context).pop(true);
                },
                child: new Text(SetLocalization.of(context)!.getTranslateValue('yes')!,style: TextStyle(
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



  Future<void> sign_in(BuildContext context) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text(SetLocalization.of(context)!.getTranslateValue('error')!),
          content: Text(SetLocalization.of(context)!.getTranslateValue('sign_in_err')!),
          actions: <Widget>[
        Row(
        crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FlatButton(
              child: Text(
                  SetLocalization.of(context)!.getTranslateValue('sign_in')!,
                style: TextStyle(
                  color: Color(0xff00838f)
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => Login()));
              },
            ),
            FlatButton(
              child: Text(SetLocalization.of(context)!.getTranslateValue('close')!),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
          ],

        );
      },
    );
  }

  Future<List?> _sendItemData_favorite(direction,id,index,{required idMal}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    // String iduserS = prefs.getString('idUser');
    String? lang = prefs.getString('lang');
    //to send order
    // ProgressDialog pr = new ProgressDialog(context);
    // pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
//    pr.show();

    print(URL_LOGIC.favorit_unfavorit);
    late Map<String?, Object?> body;
    if(direction.toString()=="un_fav"){
      body = {
        "lang":lang!,
        "action":"delete",
        "userid":idUser!,
        "offer_id":id,
        "locationid":idMal
      };


      setState(() {
        _All_allOffer![index] =
        {
          "id":_All_allOffer![index]["id"],
          "name": _All_allOffer![index]["name"],
          "offer_description": _All_allOffer![index]["offer_description"],
          "offer_img": _All_allOffer![index]["offer_img"],
          "favorite": "0",
          "small_icon": _All_allOffer![index]["small_icon"]
        };

        print( _All_allOffer![index].toString());
      });

    } else if(direction.toString()=="fav"){
      body = {
        "lang":"en",
        "action":"add",
        "userid":idUser!,
        "offer_id":id,
        "locationid":idMal
      };

//       if(direction_section=="offer") {
        setState(() {
          _All_allOffer![index] =
          {
            "id":_All_allOffer![index]["id"],
          "name": _All_allOffer![index]["name"],
          "offer_description": _All_allOffer![index]["offer_description"],
          "offer_img": _All_allOffer![index]["offer_img"],
          "favorite": "1",
          "small_icon": _All_allOffer![index]["small_icon"]
          };

          print( _All_allOffer![index].toString());
        });

//       }

    }

    // print(body);

    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(
      Uri.parse(URL_LOGIC.favorit_unfavorit!),
      body: jsonBody,
      encoding: encoding,
      headers: headers,
    );
    //"message":"You Logined To Your Account ."
    var datauser = json.decode(response.body);
//      var code=datauser["code"];
//      var actions=datauser["action"];
    print(datauser.toString());
    setState(() {
      if(datauser["code"].toString().trim()=="1"||datauser["code"].toString().trim()=="2"||datauser["code"].toString().trim()=="3"){

        setState(() {
//          dataOffer.clear();
//           userDataOffer.clear();
//           getData();
        });

//        getRefrich();
      }
    });
    debugPrint(datauser.toString());
  }

  removs() async {

    try{
      GoogleSignIn _googlSignIn = new GoogleSignIn();
      _googlSignIn.signOut();
    }catch(e){}

    try{
     // await FacebookAuth.instance.logOut();
     setState(() {});

    }catch(e){}

    SharedPreferences prefsa=await SharedPreferences.getInstance();
    prefsa.clear();
    prefsa.setString('lang',"$langApp");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Login()),
        ModalRoute.withName('/')
    );

  }



}
