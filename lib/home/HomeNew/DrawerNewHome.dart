// import 'package:flutter/material.dart';
// // import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wineapp/home/drawearPage/ClassWebView.dart';
// import 'package:wineapp/home/drawearPage/SettingsScreen.dart';
// import 'package:wineapp/lang/localization/set_localization.dart';
// import 'package:wineapp/startApp/Login.dart';
//
// class DrawerNewHome extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return UiDr();
//   }
//
// }
//
// class UiDr extends State<DrawerNewHome> {
//
//
//
//   String? langApp;
//   String? idUser;
//   // bool showStartImage=true;
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
//     });
// //    return stringValue;
//   }
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getStringValuesSF();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Drawer(
//       child: Container(
//           color: Colors.white,
//           child:ListView(
//             children: [
//
//               Container(
//                 height: 78,
//                 color: Color(0xff00838f),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Image.asset(
//                       'assets/images/logo.png',
//                       height: 58,
//                       width: 64,
//                     ),
//                     SizedBox(
//                       width: 15,
//                     ),
//                     Image.asset(
//                       'assets/images/app_name.png',
//                       height: 32,
//                       width: 100,
//                     )
//                   ],
//                 ),
//               ),
//
//               //home
//               InkWell(
//                 onTap: () {
//                   print('pressed');
//                   setState(() {
//                     // homeIsSelected = false;
//
//                   });
//                   Navigator.pop(context);
//                 },
//                 child: Container(
//                   color:  Colors.grey.withOpacity(0.5) ,
//                   padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       SizedBox(
//                         width: 25,
//                       ),
//                       Image.asset(
//                         'assets/images/drawer/icon_home.png',
//                         color: Color(0xff00838f),
//                         height: 24,
//                         width: 24,
//                       ),
//
//                       SizedBox(
//                         width: 25,
//                       ),
//                       Text(
//                         SetLocalization.of(context)!.getTranslateValue('nav_home')!,
//                         style: TextStyle(fontSize: 14, color: Colors.black),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//
//               //favorite
//               InkWell(
//                 // onTap: () async {
//                 //   if(idUser==null){
//                 //     sign_in(context);
//                 //   }else {
//                 //     // setState(() {
//                 //     Navigator.pop(context);
//                 //     var result =await Navigator.push(context, MaterialPageRoute(builder: (context) =>
//                 //         FavoriteScreen(locationid_mal: id_location_id.toString(),)));
//                 //
//                 //     // ignore: unrelated_type_equality_checks
//                 //     if (result=="test") {
//                 //       print(result);
//                 //       // _onRefresh();
//                 //       print(result);
//                 //       print(">>>>>>>>>>>>>favorite>>>>>>>>>>>>>");
//                 //       // getData_allOffer_FromFiltter(id_location_id, "sup");
//                 //       getRefrich();
//                 //     }
//                 //   }
//                 // },
//
//                 child: Container(
//                   color:  Colors.white,
//                   padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
//                   child: Row(
//                     children: <Widget>[
//                       SizedBox(
//                         width: 25,
//                       ),
//                       Image.asset(
//                         'assets/images/drawer/favorite_border.png',
//                         color:  Color(0xff00838f),
//                         height: 24,
//                         width: 24,
//                       ),
//                       SizedBox(
//                         width: 25,
//                       ),
//                       Text(
//                         SetLocalization.of(context)!.getTranslateValue('nav_fav')!,
//                         style: TextStyle(fontSize: 14, color: Colors.black),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//
//               //setting
//               InkWell(
//                 onTap: () async {
//
//                   if(idUser==null){
//                     sign_in(context);
//                   }else
//                   {
//                     Navigator
//                         .push(
//                         context, MaterialPageRoute(builder: (context) => SettingsScreen()));
//                   }
//                 },
//                 child: Container(
//                   color:  Colors.white,
//                   padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
//                   child: Row(
//                     children: <Widget>[
//                       SizedBox(
//                         width: 25,
//                       ),
//                       Image.asset(
//                         'assets/images/drawer/settings.png',
//                         color:  Color(0xff00838f),
//                         height: 24,
//                         width: 24,
//                       ),
//                       SizedBox(
//                         width: 25,
//                       ),
//                       Text(
//                         SetLocalization.of(context)!.getTranslateValue('nav_settings')!,
//                         style: TextStyle(fontSize: 14, color: Colors.black),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//
//               //line
//               Container(
//                 child: Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: Divider(
//                         thickness: 2,
//                         color: Color(0xff00838f),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//
//               //aboutUs  ,  Terms  , JoinUs
//               InkWell(
//                 onTap: () {
//                   Navigator
//                       .push(context, MaterialPageRoute(builder: (context) => WebViewExample(direction: "aboutApp",
//                     urlLink: "https://wainsale.com/apps_api/pages/aboutus.php?lang=", lang: langApp??"en",)));
//                   // Navigator
//                   //     .push(context, MaterialPageRoute(builder: (context) => AboutUsPage()));
//
//                 },
//                 child: Container(
//                   color: Colors.white,
//                   padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
//                   child: Row(
//                     children: <Widget>[
//                       SizedBox(
//                         width: 25,
//                       ),
//                       Image.asset(
//                         'assets/images/drawer/about_us.png',
//                         color:  Color(0xff00838f),
//                         height: 24,
//                         width: 24,
//                       ),
//                       SizedBox(
//                         width: 25,
//                       ),
//                       Text(
//                         SetLocalization.of(context)!.getTranslateValue('nav_about_us')!,
//                         style: TextStyle(fontSize: 14, color: Colors.black),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//
//               InkWell(
//                 onTap: () {
//                   Navigator
//                       .push(context, MaterialPageRoute(builder: (context) => WebViewExample(
//                     direction: "terms",
//                     urlLink: "https://wainsale.com/apps_api/pages/terms.php?lang=", lang:langApp??"en")));
//                   // Navigator
//                   //     .push(context, MaterialPageRoute(builder: (context) => TermsConditions()));
//                 },
//                 child: Container(
//                   color:  Colors.white,
//                   padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
//                   child: Row(
//                     children: <Widget>[
//                       SizedBox(
//                         width: 25,
//                       ),
//                       Image.asset(
//                         'assets/images/drawer/privacy_policy.png',
//                         color:  Color(0xff00838f),
//                         height: 24,
//                         width: 24,
//                       ),
//                       SizedBox(
//                         width: 25,
//                       ),
//                       Text(
//                         SetLocalization.of(context)!.getTranslateValue('nav_terms')!,
//                         style: TextStyle(fontSize: 14, color: Colors.black),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//
//               //polcy
//
//               InkWell(
//                 onTap: () {
//                   Navigator
//                       .push(context, MaterialPageRoute(builder: (context) => WebViewExample(direction: "privacypolicy",
//                     urlLink: "http://wainsale.com/apps_api/pages/privacy.php?lang=", lang: langApp??"en",)));
//                   // Navigator
//                   //     .push(context, MaterialPageRoute(builder: (context) => TermsConditions()));
//                 },
//                 child: Container(
//                   color: Colors.white,
//                   padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
//                   child: Row(
//                     children: <Widget>[
//                       SizedBox(
//                         width: 25,
//                       ),
//                       Image.asset(
//                         'assets/images/drawer/privacy_policy.png',
//                         color: Color(0xff00838f),
//                         height: 24,
//                         width: 24,
//                       ),
//                       SizedBox(
//                         width: 25,
//                       ),
//                       Text(
//                         SetLocalization.of(context)!.getTranslateValue('privacypolicy')!,
//                         style: TextStyle(fontSize: 14, color: Colors.black),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//
//               InkWell(
//                 onTap: () {
//                   Navigator
//                       .push(context, MaterialPageRoute(builder: (context) => WebViewExample(direction: "joinus",
//                     urlLink: "https://wainsale.com/apps_api/pages/joinus.php?lang=",lang: langApp??"en",)));
//                   //https://wainsale.com/apps_api/pages/joinus.php?lang=
//                   // Navigator
//                   //     .push(context, MaterialPageRoute(builder: (context) => Joinus()));
//                 },
//                 child: Container(
//                   color: Colors.white,
//                   padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
//                   child: Row(
//                     children: <Widget>[
//                       SizedBox(
//                         width: 25,
//                       ),
//                       Image.asset(
//                         'assets/images/drawer/contact_us.png',
//                         color: Color(0xff00838f),
//                         height: 24,
//                         width: 24,
//                       ),
//                       SizedBox(
//                         width: 25,
//                       ),
//                       Text(
//                         SetLocalization.of(context)!.getTranslateValue('nav_join')!,
//                         style: TextStyle(fontSize: 14, color: Colors.black),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 child: Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: Divider(
//                         thickness: 2,
//                         color: Color(0xff00838f),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//
//               InkWell(
//                 onTap: () {
//                   removs();
//                 },
//                 child: Container(
//                   padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
//                   child: Row(
//                     children: <Widget>[
//                       SizedBox(
//                         width: 25,
//                       ),
//                       Image.asset(
//                         'assets/images/drawer/sing_out.png',
//                         height: 24,
//                         width: 24,
//                       ),
//                       SizedBox(
//                         width: 25,
//                       ),
//                       Text(
//                         SetLocalization.of(context)!.getTranslateValue('nav_sign_out')!,
//                         style: TextStyle(fontSize: 14),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//
//             ],
//           )
//       ),
//     );
//   }
//
//
//
//
//   Future<void> sign_in(BuildContext context) {
//     return showDialog<void>(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           // title: Text(SetLocalization.of(context)!.getTranslateValue('error')!),
//           content: Text(SetLocalization.of(context)!.getTranslateValue('sign_in_err')!),
//           actions: <Widget>[
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 FlatButton(
//                   child: Text(
//                     SetLocalization.of(context)!.getTranslateValue('sign_in')!,
//                     style: TextStyle(
//                         color: Color(0xff00838f)
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.pushReplacement(context, MaterialPageRoute(
//                         builder: (context) => Login()));
//                   },
//                 ),
//                 FlatButton(
//                   child: Text(SetLocalization.of(context)!.getTranslateValue('close')!),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           ],
//
//         );
//       },
//     );
//   }
//
//
//
//   removs() async {
//
//     try{
//       GoogleSignIn _googlSignIn = new GoogleSignIn();
//       _googlSignIn.signOut();
//     }catch(e){}
//
//     try{
//       await FacebookAuth.instance.logOut();
//       setState(() {});
//
//     }catch(e){}
//
//     SharedPreferences prefsa=await SharedPreferences.getInstance();
//     prefsa.clear();
//     prefsa.setString('lang',"$langApp");
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (BuildContext context) => Login()),
//         ModalRoute.withName('/')
//     );
//
//   }
// }