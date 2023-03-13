// import 'dart:async';
// import 'dart:convert';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wineapp/home/EventsScreen/EventsScreen.dart';
// import 'package:wineapp/home/HomeNew/SliderNewHome.dart';
// import 'package:wineapp/home/SearchApp/SearchAppNew.dart';
// import 'package:wineapp/home/changeCituAndMal/changeCituAndMalNew.dart';
// import 'package:wineapp/lang/localization/set_localization.dart';
//
// import '../../URL_LOGIC.dart';
// import '../CurvedClipper.dart';
// import 'BackEndHome.dart';
// import 'DrawerNewHome.dart';
// import 'package:http/http.dart' as http;
//
// class ScaffoldNewHome extends StatefulWidget{
//
//   final String? Lang;
//   final String? tokenfromfirebase;
//
//   const ScaffoldNewHome({Key? key, this.Lang, this.tokenfromfirebase}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return UiScaffoldNewHome();
//   }
// }
//
// class UiScaffoldNewHome extends State<ScaffoldNewHome> {
//
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     controller = new ScrollController()..addListener(_scrollListener);
//
//     getData_defultFiltter();
//     callbackDispatcher();
//     getStringValuesSF();
//
//
//   }
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
//
//       getData_defultFiltter();
//
//       // if(checkLogin==false){
//       //   setState(() {
//       //     showStartImage=true;
//       //   });
//       // }else if(showStartImageSharedPreferences==false){
//       //   setState(() {
//       //     showStartImage=true;
//       //   });
//       // }else{
//       //   setState(() {
//       //     showStartImage=false;
//       //   });
//       // }
//
//       // getData_defultLocation();   //?>>>>>>
//
//       // getData_MainCatigry();
//       //
//       // getData_allOffer();
//
//     });
// //    return stringValue;
//   }
//
//
//
//   double? longitude;
//   double? latitude;
//   void callbackDispatcher() async {
//     bool enabled = await Geolocator.isLocationServiceEnabled();
//     if(enabled==true){
//       addPermeation();
//       print("addPermatiomn");
//     }else{
//       print("getData_defultLocation????????");
//       getData_defultLocation();
//     }
//   }
//
//
//   // * add Permeation
//   addPermeation() async {
//     try{
//       print(">>>  try  >>>>>>> ");
//       Future<Position?>? position =  Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       print(position.toString()+">>>>>>>>>>>>------->>>>>>>>");
//       position.then((value) => {
//         setState((){
//           print(position.toString()+">>>>>>>>>>>>--??????-*********---->>>>>>>>");
//           longitude=value?.longitude;
//           latitude=value?.latitude;
//         }),
//
//         getData_defultLocation(),
//
//       }).catchError((error) {
//         print(position.toString()+">>>>>>>>>>>>---*********---->>>>>>>>");
//         getData_defultFiltter(); //or
//         getData_defultLocation();// even the same error
//       });
//
//     }catch(e){
//       getData_defultFiltter();
//       getData_defultLocation();//
//       print(e.toString()+">>>  eror ");
//     }
//   }
//
//
//   Map? data_defultFiltter;
//   List _All_filttercategry=[];
//   // * get Data_defultFiltter
//   Future getData_defultFiltter() async {
//
//     Future responseDataFilter=ApiHome.getData_defultFiltter();
//     responseDataFilter.then((value) => {
//
//       setState(()  {
//         data_defultFiltter = json.decode(value.body);
//
//         print("data_defultFiltter  "+data_defultFiltter.toString());
//         setState(() {
//           if(_All_filttercategry.isNotEmpty){
//             _All_filttercategry.clear();
//           }
//           print(data_defultFiltter!["filter"].toString());
//           _All_filttercategry.addAll(data_defultFiltter!["filter"]);
//         });
//
//       })
//     });
//
//   }
//
//   int indexCity=0;
//
//
//   // * getData_defultLocation ?????????????????
//   Map? data_defultLocation;
//   String? id_city_id;
//   String? id_location_id;
//   String? city_name_default;
//   String? location_name_default;//location_name_default,id_location_id
//
//   Future getData_defultLocation() async {
//
//     // setState(()  {
//     //   data_defultLocation = json.decode(response_offers.body);
//     //
//     //   setState(() {//city_id, location_id,  city_name_default , location_name_default
//     //     print("__________"+data_defultLocation.toString());
//     //     indexCity=int.parse(data_defultLocation!["postion"].toString());
//     //     print("؟؟؟؟؟؟؟؟؟؟؟؟؟؟\n\n\n\ ${data_defultLocation!["postion"].toString()}");
//     //     id_city_id=data_defultLocation!["city_id"].toString();
//     //     id_location_id=data_defultLocation!["location_id"].toString();
//     //     city_name_default=data_defultLocation!["city_name_default"].toString();
//     //     location_name_default=data_defultLocation!["location_name_default"].toString();
//     //
//     //
//     //
//     //     if(id_location_id!=null){
//     //
//     //       if(_All_mainCatigry.isNotEmpty){
//     //         setState(() {
//     //           _All_mainCatigry.clear();
//     //           data_mainCatigry!.clear();
//     //         });
//     //       }
//     //
//     //       if(_All_Slider.isNotEmpty){
//     //         setState(() {
//     //           _All_Slider.clear();
//     //           data_offer!.clear();
//     //         });
//     //       }
//     //
//     //       if(_All_event.isNotEmpty){
//     //         setState(() {
//     //           _All_event.clear();
//     //           data_event_mal!.clear();
//     //         });
//     //       }
//     //       setState(() {
//     //         numOfferNotActive=0;
//     //       });
//     //
//     //       print("_All_allOffer  \n\n\n");
//     //       print("_All_allOffer  getData_defultLocation");
//     //       print("_All_allOffer  \n\n\n");
//     //
//     //
//     //       getData_serive(id_location_id);
//     //       getData_Slider(id_location_id,"no");
//     //       getData_MainCatigry(id_location_id,"not","");
//     //       getADS_inhome(id_location_id);
//     //
//     //     }
//     //
//     //   });
//     //
//     // });
//
//
//     Future responseDataFilter=ApiHome.getData_defultLocation(latitude: latitude,longitude: longitude,token_fromFirbase:widget.tokenfromfirebase );
//     responseDataFilter.then((value) => {
//
//       setState(()  {
//         data_defultLocation = json.decode(value.body);
//         print("data_defultLocation  "+data_defultLocation.toString());
//
//         setState(() {
//             indexCity=int.parse(data_defultLocation!["postion"].toString());
//             print("؟؟؟؟؟؟؟؟؟؟؟؟؟؟\n\n\n\ ${data_defultLocation!["postion"].toString()}");
//             id_city_id=data_defultLocation!["city_id"].toString();
//             id_location_id=data_defultLocation!["location_id"].toString();
//             city_name_default=data_defultLocation!["city_name_default"].toString();
//             location_name_default=data_defultLocation!["location_name_default"].toString();
//
//             getData_serive(id_location_id);
//             getADS_inhome(id_location_id);
//             getData_Slider(id_location_id,"no");
//
//         });
//       })
//     });
//   }
//
//
//
//   // * getData_serive    Event ?????????????????
//   int viewEvent=0;
//   bool serviceWatched=false;
//   bool isrefrech=false;
//   List _All_event=[];
//   Map? data_event_mal;
//   // to get all event in mal
//   // * getData_serive    Event ?????????????????
//   Future getData_serive(id_location_mal) async {
//
//     if(data_event_mal!=null ){
//       data_event_mal!.clear();
//     }
//     if(_All_event.isNotEmpty){
//       _All_event.clear();
//     }
//     Future getDataEvrent=  ApiHome.getData_serive(id_location_mal);
//     getDataEvrent.then((value) => {
//       setState(() {
//         data_event_mal = json.decode(value.body);
//         if(data_event_mal!["main"]!=null){
//           // if(data_event_mal["main"][0]["events"][0]["code"]==null){
//           setState(() {
//             serviceWatched=true;
//             viewEvent=0;
//             // _All_event.addAll(data_event_mal["main"][0]["events"]);
//             _All_event.addAll(data_event_mal!["main"]);
//             print("_All_event  "+_All_event.toString());
//           });
//         }else{
//           setState(() {
//             viewEvent=1;
//             serviceWatched=false;
//           });
//         }
//       })
//     });
//
//
//   }
//
//
//
//
//   // * get All Ads
//   bool isMainVisable = false;
//   // * get All Ads
//   Future getADS_inhome(id_location_mal) async {
//
//     setState(() {
//       isMainVisable=false;
//     });
//
//     Future dataAdds=ApiHome.getADS_inhome(id_location_mal);
//     dataAdds.then((value){
//       Map dataADS = json.decode(value.body);
//
//         setState(() {
//           dataADS = json.decode(value.body);
//           if (dataADS["main_offers"][0]["image_url"] != null) {
//             setState(() {
//               isMainVisable = false;
//             });
//             showAdvDialog(context, dataADS["main_offers"][0]["image_url"].toString());
//           } else {
//             setState(() {
//               isMainVisable = false;
//             });
//             print("\n\n _____"+"showAdvDialog nooooo".toString()+"\n\n _____");
//           }
//         });
//
//     });
//   }
//   // * Show Ads
//   Future<void> showAdvDialog(BuildContext context, String image) {
//     return showDialog<void>(
//         barrierDismissible: false,
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 child: Stack(
//                   children: [
//                     Container(
//                         height: 350,
//                         decoration: BoxDecoration(
//                           // shape: BoxShape.rectangle,
//                           // borderRadius: BorderRadius.circular(16.0),
//                             boxShadow: <BoxShadow>[
//                               BoxShadow(
//                                 blurRadius: 0.0,
//                                 offset: Offset(0.0, 0.0),
//                               ),
//                             ]),
//                         child: FittedBox(
//                           child: FadeInImage(
//                             height: 350,
//                             fit: BoxFit.fill,
//                             width: MediaQuery.of(context).size.width,
//                             image: NetworkImage(image),
//                             placeholder:
//                             AssetImage('assets/images/loadimage.gif',),
//                           ),
//                           fit: BoxFit.fill,
//                         )
//                     ),
//                     Positioned(
//                       right: 0.0,
//                       child: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             isMainVisable = false;
//                           });
//                           Navigator.of(context).pop();
//                         },
//                         child: Align(
//                           alignment: Alignment.topRight,
//                           child: CircleAvatar(
//                             radius: 14.0,
//                             backgroundColor: Colors.white,
//                             child: Icon(Icons.close, color: Colors.red),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ));
//         });
//   }
//
//
//
//   int? index_SubCategy;
//   int? index_SubCategy_id;
//   String? idCategry="all";
//   String? idfiltterDefult;
//   String? index_categryAnd_SupCatigru;
//   var controlleree = PageController(initialPage: 0);
//
//
//
//   bool showSlider = true;
//   Map? data_offer;
//   List _All_Slider = [];
//   Timer? timer;
//   late List<Widget> pages=[];
//   int _currentPage = 0;
//
//   Future getData_Slider(idmal,filtter) async {
//
//     if(_All_Slider.length>0){
//       setState(() {
//         data_offer!.clear;
//         _All_Slider.clear;
//       });
//     }
//
//     Map<String, dynamic> body = {
//       "lang":langApp,
//       "locationid":idmal
//     };
//     final encoding = Encoding.getByName('utf-8');
//     String jsonBody = json.encode(body);
//     final headers = {'Content-Type': 'application/json'};
//     print("_All_Slider body"+body.toString());
//     print("_All_Slider url "+URL_LOGIC.sliderHome.toString());
//     final response_offer = await http.post(Uri.parse(URL_LOGIC.sliderHome!),
//       body:jsonBody,
//       encoding: encoding,
//       headers: headers,
//     );
//     // item
//     data_offer = json.decode(response_offer.body);
//
//
//     setState(()  {
//       data_offer = json.decode(response_offer.body);
//       _All_Slider.clear;
//       print(" data_Slider <<<؟ "+data_offer.toString());
//       try{
//         if(data_offer!["trending_offers"][0]["trending_id"]!=null){
//           setState(() {
//             _All_Slider.addAll(data_offer!["trending_offers"]);
//             print(_All_Slider.length);
//             showSlider=true;
//             // addDataIntoSlider();
//           });
//
//         }else{
//           showSlider=true;
//         }
//       }catch(e){
//
//       }
//     });
//
//   }
//
//
//   late ScrollController controller;
//   void _scrollListener() {
//     if (controller.position.pixels == controller.position.maxScrollExtent) {
//       startLoader();
//     }
//   }
//
//
//
//   List? _All_allOffer_testdata=null;
//
//   void startLoader() {
//     setState(() {
//       _onLoading();
//     });
//   }
//   void _onLoading() async{
//     // print("_refreshController");
//     // if(directionPajenation=="offers"){
//     //   getData_allOffer(id_location_id,idCategry,"categry",numpage);
//     // }else{
//     //   setState(() {
//     //     _All_allOffer_testdata = null;
//     //   });
//     //   getData_allOffer_FromFiltter(id_location_id, "sss");
//     // }
//     // await Future.delayed(Duration(milliseconds: 1000));
//     }
//
//   bool isLoading = false;
//
//
//
//   Future getRefrich() async {
//     // setState(() {
//     //   numpage=1;
//     // });
//     //
//     // if(data_defultLocation!.isNotEmpty){
//     //   data_defultLocation!.clear;
//     // }
//     // getData_Slider(id_location_id,"filtter");
//     // // getData_Slider(changeCity_And_defoultMAl[0]["idMal"]);
//     //
//     // print("index_SubCategy $index_SubCategy");
//     // print("filtterChoce $filtterChoce");
//     // if(index_SubCategy!=null){
//     //   if(_All_allOffer!.isNotEmpty){
//     //     _All_allOffer!.clear();
//     //     _All_allOffer_old!.clear();
//     //     data_allOffer!.clear();
//     //   }
//     //   print("index_SubCategy $index_SubCategy");
//     //   print("index_SubCategy $filtterChoce");
//     //
//     //   setState(() {
//     //     _All_allOffer_testdata = null;
//     //   });
//     //   getData_allOffer_FromFiltter(id_location_id,"test");
//     //
//     // }else if(filtterChoce!=null){
//     //   if(_All_allOffer!.isNotEmpty){
//     //     _All_allOffer!.clear();
//     //     _All_allOffer_old!.clear();
//     //     data_allOffer!.clear();
//     //   }
//     //   print("index_SubCategy $index_SubCategy");
//     //   print("index_SubCategy $filtterChoce");
//     //
//     //   setState(() {
//     //     _All_allOffer_testdata = null;
//     //   });
//     //   getData_allOffer_FromFiltter(id_location_id,"test");
//     //
//     // }else{
//     //   getData_MainCatigry(id_location_id,"re","");
//     // }
//     //
//     // isrefrech=true;
//
//     // await Future.delayed(Duration(seconds: 3));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return  SafeArea(
//         top: true,
//         bottom: false,
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           key: _scaffoldKey,
//
//
//           drawer: DrawerNewHome(),
//
//
//           appBar: PreferredSize(
//               preferredSize: Size.fromHeight(105.0),
//               child: AppBar(
//                 backgroundColor: Color(0xFF00838f),
//                 shape: CurvedClipper(),
//                 actions: <Widget>[
//                   Container(
//                     child: Stack(
//                       children: [
//                         Container(
//                           padding: EdgeInsetsDirectional.only(top: 15, end: 15, start: 0, bottom: 0),
//                           child:
//
//                           // to go to EventsScreen
//                           InkWell(
//                             splashColor: Colors.transparent,
//                             highlightColor: Colors.transparent,
//                             onTap: () {
//                               print("object");
//                               print("_All_event :> "+_All_event.toString());
//
//                               if(_All_event!=null && _All_event.isNotEmpty){
//                                 print("_All_event :> "+_All_event.toString());
//                                 setState(() {
//                                   viewEvent=1;
//                                 });
//                                 Navigator.push(context, MaterialPageRoute(builder: (context) => EventsScreen(events:_All_event ,nameMAl: location_name_default.toString(),)));
//
//                               }else{
//                                 try{
//
//                                   // TipDialogHelper.fail(SetLocalization.of(context)!.getTranslateValue('NoEventsavailablerightnow'));
//                                 }catch(e){}
//
//                               }
//                             },
//                             child: Container(
//                               width: 43,
//                               padding: EdgeInsets.all(0.0),
//                               child: Image.asset(
//                                 'assets/images/event_and_services_icon.png',
//                                 height: 27,
//                                 width: 27,
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         Visibility(
//                           visible: serviceWatched==true && viewEvent==0, //serviceWatched,
//                           child: Positioned(
//                             left: langApp == 'en' ? 28 : null,
//                             right: langApp == 'en' ? null : 28,
//                             top: 16,
//                             child: Align(
//                               alignment: Alignment.centerRight,
//                               child: Container(
//                                 padding: EdgeInsets.all(1),
//                                 decoration: new BoxDecoration(
//                                   color: Colors.red,
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 constraints: BoxConstraints(
//                                   minWidth: 7,
//                                   minHeight: 7,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//
//                     ),
//                   ),
//                 ],
//
//                 flexibleSpace: Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//
//
//                       Container(
//                         alignment: Alignment.center,
//                         padding: EdgeInsets.only(top: 14, bottom: 7),
//                         child: InkWell(
//                           splashColor: Colors.transparent,
//                           highlightColor: Colors.transparent,
//                           //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//                           onTap: () async {
//
//                             showDialog(
//                                 barrierDismissible: false,
//                                 context: context,
//                                 builder: (context) {
//                                   return  StatefulBuilder(builder: (context, setState){
//                                     return
//                                       Material(
//                                         // type: MaterialType.transparency,
//                                           color: Colors.black12,
//                                           child:
//                                           Center(
//                                             // Aligns the container to center
//                                             child: Column(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               crossAxisAlignment: CrossAxisAlignment.center,
//                                               children: <Widget>[
//                                                 Container(
//                                                   // A simplified version of dialog.
//                                                     margin: EdgeInsets.only(
//                                                         left: 15, right: 15),
//                                                     width: MediaQuery
//                                                         .of(context)
//                                                         .size
//                                                         .width,
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.transparent,
//                                                       borderRadius: BorderRadius.circular(
//                                                           12),
//                                                     ),
//
//                                                     child: Container(
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.transparent,
//                                                         borderRadius: BorderRadius.circular(
//                                                             12),
//                                                       ),
//                                                       child: Center(child: changeCituAndMalNew(indexCity: indexCity,),),
//                                                     )
//                                                 )
//                                                 // ),
//                                               ],
//                                             ),
//                                           )
//                                       );
//                                   });
//
//                                 }
//                             ).then((val) {
//
//                               // setState(() {
//                               //   numpage=1;
//                               //   changeCity_And_defoultMAl = val;
//                               //   serachField.text="";
//                               //
//                               //   idfiltterDefult!=null;
//                               //
//                               //
//                               //
//                               //   print("changeCity_And_defoultMAl %%%%%%%%"+val.toString());
//                               //
//                               //   print(val[0]["indexCity"].toString());
//                               //   indexCity=val[0]["indexCity"];
//                               //
//                               //   if(changeCity_And_defoultMAl !=null ||changeCity_And_defoultMAl?[0] !=null ||
//                               //       changeCity_And_defoultMAl?[0]["idCity"] !=null){
//                               //     setState(() {
//                               //       id_city_id=changeCity_And_defoultMAl![0]["idCity"].toString();
//                               //       city_name_default=changeCity_And_defoultMAl![0]["nameCity"].toString();
//                               //     });
//                               //   }
//                               //
//                               //   if(changeCity_And_defoultMAl![0]["idMal"] !=null){
//                               //     if(changeCity_And_defoultMAl?[0]["idMal"] !=id_location_id){
//                               //
//                               //
//                               //       setState(() {
//                               //
//                               //         directionPajenation="offers";
//                               //
//                               //         id_location_id=changeCity_And_defoultMAl![0]["idMal"].toString();
//                               //         location_name_default=changeCity_And_defoultMAl![0]["nameMAl"].toString();
//                               //
//                               //         getData_serive(changeCity_And_defoultMAl![0]["idMal"]);
//                               //         // data_offer,_All_Slider
//                               //         if(data_offer!=null){
//                               //           data_offer!.clear();
//                               //         }
//                               //         if(_All_Slider!=null){
//                               //           _All_Slider.clear();
//                               //         }
//                               //         if(_All_mainCatigry!=null){
//                               //           _All_mainCatigry.clear();
//                               //           data_mainCatigry!.clear();
//                               //         }
//                               //
//                               //         if(_All_SupCatigry.isNotEmpty){
//                               //           _All_SupCatigry.clear();
//                               //           data_SupCatigry!.clear();
//                               //           _All_SupCatigry.clear();
//                               //         }
//                               //         // if(_selecteSupCategorys_index.isNotEmpty){
//                               //         //   _selecteSupCategorys_index.clear();
//                               //         //   _selecteSupCategorys.clear();
//                               //         // }
//                               //         index_SubCategy=null;
//                               //         index_SubCategy_id=null;
//                               //         //........
//                               //         if(_All_allOffer!.isNotEmpty){
//                               //           _All_allOffer!.clear();
//                               //           data_allOffer!.clear();
//                               //         }
//                               //
//                               //         setState(() {
//                               //           _currentPage = 0;
//                               //           index_categry=0;
//                               //           controlleree = PageController(initialPage: 0);
//                               //         });
//                               //
//                               //         setState(() {
//                               //           filtterChoce=null;
//                               //           idfiltterDefult=null;
//                               //         });
//                               //
//                               //         // getADS_inhome(changeCity_And_defoultMAl![0]["idMal"]);
//                               //         getData_Slider(changeCity_And_defoultMAl![0]["idMal"],"no");
//                               //         getData_MainCatigry(changeCity_And_defoultMAl![0]["idMal"],"not","appBar");
//                               //
//                               //         Timer(
//                               //             Duration(seconds: 4),
//                               //                 () async {
//                               //               // getStringValuesSF();
//                               //
//                               //               getADS_inhome(changeCity_And_defoultMAl![0]["idMal"]);
//                               //             });
//                               //
//                               //         setState(() {
//                               //           filtterChoce=null;
//                               //         });
//                               //
//                               //       });
//                               //     }
//                               //
//                               //   }
//                               // });
//                             });
//
//
//                             // setState(() {
//                             //   numpage=1;
//                             //   print(changeCity_And_defoultMAl);
//                             //
//                             //
//                             //   if(changeCity_And_defoultMAl !=null ||changeCity_And_defoultMAl?[0] !=null || changeCity_And_defoultMAl?[0]["idCity"] !=null){
//                             //     setState(() {
//                             //       id_city_id=changeCity_And_defoultMAl![0]["idCity"].toString();
//                             //       city_name_default=changeCity_And_defoultMAl![0]["nameCity"].toString();
//                             //     });
//                             //   }
//                             //
//                             //   if(changeCity_And_defoultMAl?[0]["idMal"] !=null){
//                             //     if(changeCity_And_defoultMAl?[0]["idMal"] !=id_location_id){
//                             //       setState(() {
//                             //         id_location_id=changeCity_And_defoultMAl![0]["idMal"].toString();
//                             //         location_name_default=changeCity_And_defoultMAl![0]["nameMAl"].toString();
//                             //
//                             //         getData_serive(changeCity_And_defoultMAl![0]["idMal"]);
//                             //         // data_offer,_All_Slider
//                             //         if(data_offer!=null){
//                             //           data_offer!.clear();
//                             //         }
//                             //         if(_All_Slider!=null){
//                             //           _All_Slider.clear();
//                             //         }
//                             //         if(_All_mainCatigry!=null){
//                             //           _All_mainCatigry.clear();
//                             //           data_mainCatigry!.clear();
//                             //         }
//                             //
//                             //         if(_All_SupCatigry.isNotEmpty){
//                             //           _All_SupCatigry.clear();
//                             //           data_SupCatigry!.clear();
//                             //           _All_SupCatigry.clear();
//                             //         }
//                             //         // if(_selecteSupCategorys_index.isNotEmpty){
//                             //         //   _selecteSupCategorys_index.clear();
//                             //         //   _selecteSupCategorys.clear();
//                             //         // }
//                             //         index_SubCategy=null;
//                             //         //........
//                             //         if(_All_allOffer!.isNotEmpty){
//                             //           _All_allOffer!.clear();
//                             //           _All_allOffer_old!.clear();
//                             //           data_allOffer!.clear();
//                             //         }
//                             //
//                             //
//                             //
//                             //         // getADS_inhome(changeCity_And_defoultMAl![0]["idMal"]);
//                             //         // getData_Slider(changeCity_And_defoultMAl![0]["idMal"],"no");
//                             //         // getData_MainCatigry(changeCity_And_defoultMAl![0]["idMal"],"not","appBar");
//                             //
//                             //
//                             //         setState(() {
//                             //           filtterChoce=null;
//                             //         });
//                             //       });
//                             //     }
//                             //
//                             //   }
//                             // });
//                           },
//
//                           child: Container(
//                             constraints: BoxConstraints(
//                                 maxWidth: 260,
//                                 minWidth:100
//                             ),
//                             // width: MediaQuery.of(context).size.width/1.4,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.location_on,
//                                   color: Colors.white,
//                                   size: 22,
//                                 ),
//                                 SizedBox(
//                                   width: 4,
//                                 ),
//
//
//
//                                 Flexible(
//                                   child:
//                                   Text(
// //                            truncateWithEllipsis(20,cityName),
//                                     location_name_default==null?"   "  :
//                                     // location_name_default.toString().length>25?location_name_default.toString().substring(0,23)+"..":
//                                     location_name_default.toString()
//                                     ,
//                                     style: TextStyle(fontSize: 19, color: Colors.white),
//                                     softWrap: false,
//                                     overflow: TextOverflow.ellipsis,
//                                     textAlign: TextAlign.start,
//
//                                   ),
//                                 ),
//
//
//
//                                 SizedBox(
//                                   width: 4,
//                                 ),
//                                 Image.asset(
//                                   'assets/images/icon_down.png',
//                                   height: 8,
//                                   width: 15,
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//
//                       InkWell(
//                           onTap: ()=>{
//                             //location_name_default,id_location_id
//                             Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>SearchAppNew(
//                               nameLcation: location_name_default.toString(),
//                               idLcation: id_location_id.toString(),
//                             )))
//                           },
//
//                           child:  Directionality(
//                               textDirection: TextDirection.ltr,
//                               child: Container(
//                                 width: 260,
//                                 height: 40,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(30),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Color(0x29000000),
//                                       blurRadius: 10,
//                                       spreadRadius: 1,
//                                       offset: Offset(0, 5),
//                                     ),
//                                   ],
//                                   color: Colors.white,
//                                 ),
//                                 child:TextField(
//                                   enabled: false,
//                                   // controller: serachField,
//                                   // textAlignVertical: TextAlignVertical.center,
//                                   onSubmitted: (_) => {
//                                     FocusScope.of(context).unfocus(),
//
//                                   },
//                                   // focusNode: searchBarFcous,
//                                   onTap: () {
//                                     // searchBarFcous!.requestFocus();
//                                   },
//                                   onChanged: (value) async {
//                                     if (value.length >= 0) {
//                                       // _filterCountries(value);
//                                     } else {
//
//                                     }
//                                   },
//                                   style: TextStyle(fontSize: 13, color: Color(0xffb5b5b5)),
//                                   textAlign: langApp == 'en' ? TextAlign.center : TextAlign.center,
//                                   decoration: InputDecoration(
//                                     contentPadding: EdgeInsets.fromLTRB(44, 4, 0, 0),
//                                     prefixIcon: Icon(
//                                       Icons.search,
//                                       size: 22,
//                                       color: Color(0xffb5b5b5),
//                                     ),
//                                     hintText:  SetLocalization.of(context)!.getTranslateValue('SearchStore'),
//                                     // hintText: SetLocalization.of(context).getTranslateValue('search_bar'),
//                                     hintStyle: TextStyle(fontSize: 15, color: Color(0xffb5b5b5)),
//                                     border: InputBorder.none,
//                                   ),
//                                 ),
//                               )
//                           )
//                       ),
//                     ],
//                   ),
//                 ),
//
//               )
//           ),
//
//
//           body: Stack(
//             children: [
//
//               RefreshIndicator(
//                 onRefresh: getRefrich,
//                 color: Colors.white,
//                 backgroundColor: Colors.black,
//                 child:SingleChildScrollView(
//                     controller: controller,
//                     child:
//                     bodyApp()
//                 ),
//               ),
//
//
//
//               Visibility(
//                 visible: isMainVisable,
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(
//                     sigmaX: 8.0,
//                     sigmaY: 8.0,
//                   ),
//                   child: Container(
//                     color: Colors.transparent,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//         )
//     );
//   }
//
//   Widget bodyApp(){
//     return  Container(
//
//       // color: Colors.black38,
//       child: ListView(
//         padding: EdgeInsets.only(
//             left: 15,right: 15,bottom: 5
//         ),
//         physics: NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         children: [
//
//           Visibility(
//               visible: _All_Slider.isEmpty?false:true,
//               child:  SliderNewHome(all_slider: _All_Slider,id_location_id: id_location_id,idCategry:idCategry ,
//                 index_categryAnd_SupCatigru:index_categryAnd_SupCatigru,index_SubCategy_id: index_SubCategy_id.toString()  ,)
//           ),
//
//           // SizedBox(height: 0,),
//           //
//           //
//           // // //اسويتش العروض النشطه والغير نشطه
//           // Visibility(
//           //   visible: numOfferNotActive !=null && numOfferNotActive>0? true :true,
//           //   child:Center(
//           //       child:  Row(
//           //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //         children: [
//           //           Text(
//           //
//           //             // SetLocalization.of(context).getTranslateValue('numOfferNotActive')+"$numOfferNotActive"+
//           //             SetLocalization.of(context)!.getTranslateValue('ShowOffersOnly')!
//           //             ,
//           //             style: TextStyle(fontSize: 16,
//           //                 color: Colors.black38
//           //             ),
//           //             textAlign: TextAlign.center,
//           //           ),
//           //
//           //
//           //           Switch(
//           //
//           //             onChanged: (val) {
//           //               print(val);
//           //
//           //               if (idUser != null) {
//           //                 if(isChecked_filteNotAvtiveOffer==true){
//           //                   setState(() {
//           //                     isChecked_filteNotAvtiveOffer=false;
//           //                   });
//           //                 }else{
//           //                   setState(() {
//           //                     isChecked_filteNotAvtiveOffer=true;
//           //                   });
//           //                 }
//           //
//           //                 try {
//           //                   _All_mainCatigry.clear();
//           //                   data_mainCatigry!.clear();
//           //                   _All_allOffer!.clear();
//           //                   _All_allOffer_old!.clear();
//           //                   data_allOffer!.clear();
//           //
//           //                   if(_All_SupCatigry.isNotEmpty){
//           //                     _All_SupCatigry.clear();
//           //                     _All_SupCatigry.clear();
//           //                     data_SupCatigry!.clear();
//           //                   }
//           //
//           //
//           //                   getData_MainCatigry(id_location_id, "switch","");
//           //
//           //
//           //                   Timer(
//           //                       Duration(seconds: 1),
//           //                           () {
//           //                         setState(() {
//           //                           numpage=1;
//           //                           _All_allOffer_testdata = null;
//           //                         });
//           //                         getData_allOffer_FromFiltter(id_location_id,"test");
//           //                       });
//           //                   // getData_allOffer_FromFiltter(id_location_id);
//           //                 }catch(e){}
//           //               } else {
//           //                 sign_in(context);
//           //               }
//           //
//           //             },
//           //             value:  isChecked_filteNotAvtiveOffer,
//           //             activeTrackColor: Color(0x3D00838f),
//           //             activeColor: Color(0xff00838f),
//           //           )
//           //         ],
//           //       )
//           //
//           //
//           //   ),
//           // ),
//           //
//           // SizedBox(height: 0,),
//           //
//           // Container(
//           //   // color: Colors.blue,
//           //   child: categryFiltter(),
//           // ),
//           //
//           // _All_mainCatigry.isEmpty ? Text("") :
//           // CtigryMain_List(),
//           // //
//           // SizedBox(height: 2,),
//           // _All_SupCatigry.isEmpty ? Text("") :
//           // Visibility(
//           //     visible: index_categry==0?false:true,
//           //     child:  SupCAtigry_List()
//           // ),
//           //
//           // Visibility(
//           //     visible:index_categry==0?true:false,
//           //     child:  SizedBox(height: 15,)
//           // ),
//           // //
//           // // _All_allOffer.isEmpty ?
//           // Stack(
//           //   children: [
//           //
//           //     Visibility(
//           //       visible: _All_allOffer!.isNotEmpty?true:false,
//           //       // true,
//           //       // visible: !isListLoading,
//           //       replacement: Container(
//           //         child: Center(child: Text("")),
//           //         // child: Center(child: CircularProgressIndicator()),
//           //       ),
//           //       child:  Container(
//           //
//           //         // height: MediaQuery.of(context).size.height/2,
//           //         child: ListView.builder(
//           //           physics: ScrollPhysics(),
//           //           shrinkWrap: true,
//           //           itemCount: _All_allOffer==null ? 0 : _All_allOffer!.length,
//           //           itemBuilder: (BuildContext context, int index) {
//           //             return InkWell(
//           //                 onTap: () async {
//           //                   print("offer ");
//           //                   var result = await  Navigator.push(
//           //                       context,
//           //                       MaterialPageRoute(
//           //                         builder: (context) => OfferScreen(
//           //                           offerID: _All_allOffer![index]["id"].toString(),
//           //                           offerName: _All_allOffer![index]["name"],
//           //                           offerFavorite:  _All_allOffer![index]["favorite"].toString(),
//           //                           locationid_mal: id_location_id.toString(),
//           //                           id_Catigry: idCategry.toString(),
//           //                           id_SubCatrgry: index_SubCategy_id.toString(),
//           //                           cat_id: index_categryAnd_SupCatigru.toString(),
//           //                           direction: "offer",
//           //                           indexrow: index,
//           //                         ),
//           //                       ));
//           //                   print(result.toString());
//           //                   print(result.toString());
//           //                   if(result!=null){
//           //                     setState(() {
//           //                       serachField.text="";
//           //                       // _filterCountries("");
//           //                     });
//           //                     print("Back offer to home : >>>>>>>>>>>>>>  $result");
//           //                     if(result["favorit"]!=null&& result["directio"]=="offer"){
//           //                       setState(() {
//           //                         _All_allOffer![int.parse(result["index"].toString())]["favorite"]=result["favorit"].toString();
//           //                       });
//           //                     }
//           //                     // _onRefresh();
//           //                   }
//           //                 },
//           //                 child: _getOffers(context, index,_All_allOffer!.length)
//           //
//           //             );
//           //
//           //           },
//           //         ),
//           //       ),
//           //
//           //     ),
//           //
//           //     Visibility(
//           //       visible:_All_allOffer==null|| _All_allOffer!.isEmpty?true:false,
//           //       child: Container(
//           //         margin: EdgeInsets.only(top: 15),
//           //         padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/4),
//           //         child:
//           //         _All_allOffer_testdata==null?Center(child:  CircularProgressIndicator(backgroundColor: Color(0x2900838f),
//           //           valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff00838f)),
//           //         ),):
//           //         Center(child: Text(SetLocalization.of(context)!.getTranslateValue('no_offer')!, style: TextStyle(
//           //           fontSize: 20,
//           //         ), textAlign: TextAlign.center,)),
//           //       ),
//           //     )
//           //   ],
//           // ),
//           //
//           // Container(
//           //
//           //   height:_All_allOffer!.length<5?MediaQuery.of(context).size.height/3:1,
//           // )
//         ],
//       ),
//     );
//   }
// }