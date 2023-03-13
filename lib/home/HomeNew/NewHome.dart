// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'dart:ui';
//
// // import 'package:ars_dialog/ars_dialog.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wineapp/home/HomeNew/ScaffoldNewHome.dart';
// // import 'package:tip_dialog/tip_dialog.dart';
// import 'package:wineapp/lang/localization/set_localization.dart';
//
// import 'dart:async';
//
// class HomeNew extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return UiHomeNew();
//   }
// }
//
// class UiHomeNew extends State<HomeNew> {
//
//   final controller = ScrollController();
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     // *  controller List
//     controller.addListener(listenScrolling);
//
//     // * check Internet
//     check().then((intenet) {
//       if (intenet != null && intenet) {
//         // Internet Present Case
//         setState(() {
//           ceckNet=true;
//         });
//       }else{
//         setState(() {
//           ceckNet=false;
//         });
//       }
//     });
//
//
//     searchBarFcous = FocusNode();
//
//     // * check Permation Notification
//     getPermationsNotification();
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print(">>>>>>>>>>>>>>>?????");
//       print(message.data.toString());
//       print(message.notification!.title.toString());
//       showNotification("${message.notification!.body}",message.data);
//       print(">>>>>>>>>>>>>>>?????");
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//       // Navigator.pushNamed(context, '/message',
//       //     arguments: MessageArguments(message, true));
//     });
//
//     FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage? message) {
//       print(message.toString());
//       if (message != null) {
//         print(message.toString());
//         print("/n/n/n");
//         // Navigator.pushNamed(context, '/message',
//
//         var androidInitilize = new AndroidInitializationSettings('wineapp');
//         var iOSinitilize = new IOSInitializationSettings();
//         var initilizationsSettings =
//         new InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
//         fltrNotification = new FlutterLocalNotificationsPlugin();
//         fltrNotification!.initialize(
//           initilizationsSettings,
//           // onSelectNotification: notificationSelected
//         );
//         showNotification("${message.notification!.body}",message.data);
//       }
//     });
//
//     FirebaseMessaging.instance.getToken().then((token) {
//       print("token  >>>>>>>\n\n");
//       print("token  >>>>>>>${token}");
//       print("token  >>>>>>>\n\n");
//       _sendItemData(token);
//       setState(() {
//         token_fromFirbase=token.toString();
//       });
//
//     });
//
//
//
//     // * back End >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//
//     // callbackDispatcher();
//     // getStringValuesSF();
//
//
//   }
//
//   FlutterLocalNotificationsPlugin? fltrNotification;
//
//   FocusNode? searchBarFcous;
//
//
//   // * To trace List
//   void listenScrolling() {
//     print(controller.position.pixels);
//     if (controller.position.atEdge) {
//       final isTop = controller.position.pixels == 0;
//
//       if (isTop) {
//         // Utils.showSnackBar(context, text: 'Reached Start');
//       } else {
//         // Utils.showSnackBar(context, text: 'Reached End');
//       }
//     }
//   }
//
//
//   getPermationsNotification() async{
//     final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//     if (Platform.isIOS) {
//       firebaseMessaging.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );
//     }
//   }
//
//
//   // * Check Internet
//   bool ceckNet=false;
//   Future<bool> check() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile) {
//       return true;
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       return true;
//     }
//     return false;
//   }
//
//
//   // * Get Token
//   String? token_fromFirbase;
//   _sendItemData(token) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('token',"$token");
//   }
//
//
//
//   Future showNotification(String? s,Map<String, dynamic> mas) async {
//
//     // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('wineapp1');
//
//     final IOSInitializationSettings initializationSettingsIOS =
//     IOSInitializationSettings(
//         defaultPresentAlert: true,
//         defaultPresentBadge: true,
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         onDidReceiveLocalNotification: onDidReceiveLocalNotifications
//     );
//
//     final InitializationSettings initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid,
//         iOS: initializationSettingsIOS
//     );
//
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
//
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: onSelectNotification);
//
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//         "130", "Wain",
//         importance: Importance.max,
//         priority: Priority.high,
//         showWhen: false);
//
//     const IOSNotificationDetails iosNotificationDetails=IOSNotificationDetails(
//
//     );
//
//     const NotificationDetails platformChannelSpecifics =
//     NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: iosNotificationDetails
//
//     );
//
//     // ContrrolerPageHome controller=Get.put(ContrrolerPageHome());
//     // controller.textTitel(data_Item["location_name_default"].toString());
//
//     try{
//       await flutterLocalNotificationsPlugin.show(
//         130, "", "$s", platformChannelSpecifics,
//         // payload: '${mas["data"]["offer"].toString()}'
//       );
//     }catch(e){
//       print(e.toString()+">>>");
//     }
//
//
//
//     try{
//       print(s!+"////////");
//       var androidDetails = new AndroidNotificationDetails(
//           "Channel ID", "Desi programmer",// "This is my channel",
//           importance: Importance.max);
//       var iSODetails = new IOSNotificationDetails();
//       var generalNotificationDetails =
//       new NotificationDetails(android: androidDetails, iOS: iSODetails);
//
//       await fltrNotification?.show(
//           130, "Wain", "$s",
//           generalNotificationDetails,
//           payload: mas["data"]["offer"].toString()
//       );
//
//
//     }catch(e){
//       print(e.toString()+">>>");
//     }
//
//
//   }
//
//   Future onSelectNotification(String? payload) async {
//     debugPrint("payload : $payload");
//   }
//
//   Future onDidReceiveLocalNotifications(
//       int? id, String? title, String? body, String? payload) async {
//   }
//
//
//
//
//   String? langApp;
//   String? idUser;
//   getStringValuesSF() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool checkLogin = prefs.containsKey('userid');
//     bool showStartImageSharedPreferences = prefs.containsKey('showStartImage');
//     String? lang = prefs.getString('lang');
//     String? userid = prefs.getString('userid');
//     print("idUser=> "+lang.toString());
//     setState(() {
//       langApp=lang;
//       idUser=userid;
//       print("???????????????? $langApp");
//     });
//   }
//   //
//   // void callbackDispatcher() async {
//   //
//   //   bool enabled = await Geolocator.isLocationServiceEnabled();
//   //   if(enabled==true){
//   //     addPermatiomn();
//   //     print("addPermatiomn");
//   //   }else{
//   //     print("getData_defultLocation????????");
//   //     getData_defultLocation();
//   //     // addPermatiomn();
//   //   }
//   //
//   // }
//
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//
//   // * >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//   // * build Body
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return WillPopScope(
//       onWillPop: () {
//         searchBarFcous!.unfocus();
//         print(_scaffoldKey.currentState!.isDrawerOpen);
//         if (_scaffoldKey.currentState!.isDrawerOpen) {
//           print("?>>>>>>>>>>>>>>>>>");
//           print("object");
//           // return true;
//           return popup(context);
//         } else {
//           print("onWillPop");
//           return onWillPop(context);
//         }
//       },
//       child:
//       GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onPanDown: (_) {
//           FocusScope.of(context).requestFocus(FocusNode());
//           // searchBarFcous.unfocus();
//         },
//         child: Stack(
//           children: [
//
//             ScaffoldNewHome(Lang: langApp,tokenfromfirebase: token_fromFirbase,),
//
//
//
//
//           ],
//         ),
//       ),
//     );
//   }
//
//
//
//
//   static Future<bool> popup(BuildContext context) async {
//     // Navigator.pop(context);
//     return true;
//   }
//
//   static Future<bool> onWillPop(BuildContext context) async {
//     return (await showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) => new AlertDialog(
//         title: Text(SetLocalization.of(context)!.getTranslateValue('are_you_sure')!),
//         titlePadding: EdgeInsets.only(left: 5.0,right: 5.0,top: 5.0),
//         contentPadding: EdgeInsets.only(left: 5.0,right: 5.0,top: 5.0,bottom: 0),
//         content: Row (
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               FlatButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: new Text(SetLocalization.of(context)!.getTranslateValue('no')!,style: TextStyle(
//                     color: Color(0xff00838f)
//                 ),),
//                 splashColor: Colors.transparent,
//                 highlightColor: Colors.transparent,
//                 padding: EdgeInsets.all(0.0),
//               ),
//               FlatButton(
//                 onPressed: () {
//
//                   try{
//                     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//                   }catch(e){
//
//                   }
//                   exit(0);
//                   // Navigator.of(context).pop(true);
//                 },
//                 child: new Text(SetLocalization.of(context)!.getTranslateValue('yes')!,style: TextStyle(
//                     color: Color(0xff00838f)
//                 ),),
//                 padding: EdgeInsets.all(0.0),
//                 splashColor: Colors.transparent,
//                 highlightColor: Colors.transparent,
//               ), // button 2
//             ]
//         ),
//       ),
//     )) ?? false;
//   }
// }