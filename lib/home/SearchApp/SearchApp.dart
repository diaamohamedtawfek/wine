// import 'dart:async';
// import 'dart:convert';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wineapp/home/item/OfferScreen.dart';
// import 'package:wineapp/lang/localization/set_localization.dart';
// import 'package:http/http.dart' as http;
//
// import '../CurvedClipper.dart';
//
// class SearchApp extends StatefulWidget{
//   final String? idLcation;
//   final String? nameLcation;
//
//   const SearchApp({Key? key, this.idLcation, this.nameLcation}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return UnSearchApp();
//   }
// }
//
// class UnSearchApp extends State<SearchApp> {
//
//   FocusNode? searchBarFcous;
//   TextEditingController serachField = TextEditingController();
//   @override
//   // ignore: must_call_super
//   void dispose() {
//     if(searchBarFcous!=null){
//       searchBarFcous?.dispose();
//     }
//
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getStringValuesSF();
//     print(widget.nameLcation);
//     print(widget.idLcation);
//   }
//
//   String? langApp;
//   String? idUser;
//   getStringValuesSF() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
// //    bool checkValue = prefs.containsKey('lang');
//     String? lang = prefs.getString('lang');
//     String? userid = prefs.getString('userid');
//     print("idUser=> "+lang.toString());
//     setState(() {
//       langApp=lang;
//       idUser=userid;
//       getData_allOffer();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return
//       SafeArea(
//           child: Scaffold(
//               appBar: PreferredSize(
//                   key: null,
//                   preferredSize: Size.fromHeight(105.0),
//                   child: AppBar(
//                     backgroundColor: Color(0xFF00838f),
//                     shape: CurvedClipper(),
//
//                     flexibleSpace: Container(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//
//
//                           Container(
//                             alignment: Alignment.center,
//                             padding: EdgeInsets.only(top: 14, bottom: 6),
//                             child: InkWell(
//                               splashColor: Colors.transparent,
//                               highlightColor: Colors.transparent,
//                               //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//                               onTap: () async {
//
//                               },
//
//                               child: Container(
//                                 constraints: BoxConstraints(
//                                     maxWidth: 260,
//                                     minWidth: 100
//                                 ),
//                                 // width: MediaQuery.of(context).size.width/1.4,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     Icon(
//                                       Icons.location_on,
//                                       color: Colors.white,
//                                       size: 22,
//                                     ),
//                                     SizedBox(
//                                       width: 4,
//                                     ),
//                                     Flexible(
//                                       // fit:FlexFit.loose,
//                                         child: Text(
//                                           widget.nameLcation!,
//                                           style: TextStyle(fontSize: 15,
//                                               color: Colors.white),
//                                           softWrap: false,
//                                           overflow: TextOverflow.ellipsis,
//                                           textAlign: TextAlign.start,
//
//                                         )
//                                     ),
//
//                                     SizedBox(
//                                       width: 4,
//                                     ),
//                                     Image.asset(
//                                       'assets/images/icon_down.png',
//                                       height: 8,
//                                       width: 15,
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//
//
//                           Directionality(textDirection: TextDirection.ltr,
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
//                                 child: InkWell(
//                                   child: TextField(
//                                     textInputAction: TextInputAction.send,
//                                     autofocus: true,
//                                     enabled: true,
//                                     controller: serachField,
//                                     onSubmitted: (_) =>
//                                     {
//                                       FocusScope.of(context).unfocus(),
//                                     },
//                                     focusNode: searchBarFcous,
//                                     onTap: () {
//                                       searchBarFcous?.requestFocus();
//                                     },
//
//
//                                     onChanged: (value) async {
//                                       if (value.length >= 0) {
//                                         getData_allOffer();
//                                         // print(value);
//                                         print(value +
//                                             ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//                                         // _filterCountries(value);
//                                       } else if (value.length == 0) {
//                                         // getData_allOffer();
//                                         print(value + ">>>>>");
//                                         try {
//                                           _All_allOffer.clear();
//                                           _All_allOffer.clear();
//                                           _All_allOffer.clear();
//                                         } catch (r) {}
//                                       }
//                                     },
//                                     // onEditingComplete: () {
//                                     //   print(serachField.text.toString().trim());
//                                     // },
//                                     style: TextStyle(
//                                         fontSize: 13, color: Color(0xffb5b5b5)),
//                                     textAlign: langApp == 'en' ? TextAlign
//                                         .center : TextAlign.center,
//                                     decoration: InputDecoration(
//                                       contentPadding: EdgeInsets.fromLTRB(
//                                           44, 8, 0, 0),
//                                       prefixIcon: Icon(
//                                         Icons.search,
//                                         color: Color(0xffb5b5b5),
//                                       ),
//                                       hintText: SetLocalization.of(context)!
//                                           .getTranslateValue('SearchStore'),
//                                       // hintText: SetLocalization.of(context).getTranslateValue('search_bar'),
//                                       hintStyle: TextStyle(fontSize: 13,
//                                           color: Color(0xffb5b5b5)),
//                                       border: InputBorder.none,
//                                     ),
//                                   ),
//                                 ),
//                               )),
//                         ],
//                       ),
//                     ),
//
//                   )
//               ),
//
//
//               // appBAr(),
//
//               body: Container(
//                 child: ListView(
//                   padding: EdgeInsets.only(
//                       left: 15, right: 15, bottom: 5, top: 12
//                   ),
//
//                   children: <Widget>[
//
//
//                     Stack(
//                       children: [
//
//                         Visibility(
//                           visible:
//                           serachField.text
//                               .toString()
//                               .isEmpty ? false :
//                           _All_allOffer != null || _All_allOffer.isNotEmpty
//                               ? true
//                               : false,
//                           child: ListView.builder(
//                             physics: NeverScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             itemCount: _All_allOffer == null ? 0 : _All_allOffer
//                                 .length,
//                             itemBuilder: (BuildContext context, int index) {
//                               return InkWell(
//                                 onTap: () async {
//                                   print("offer ");
//                                   var result = await Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             OfferScreen(
//                                               offerID: _All_allOffer[index]["id"]
//                                                   .toString(),
//                                               offerName: _All_allOffer[index]["name"],
//                                               offerFavorite: _All_allOffer[index]["favorite"]
//                                                   .toString(),
//                                               locationid_mal: widget.idLcation
//                                                   .toString(),
//                                               // id_Catigry: idCategry.toString(),
//                                               // id_SubCatrgry: index_SubCategy_id.toString(),
//                                               // cat_id: index_categryAnd_SupCatigru.toString(),
//                                               direction: "offer",
//                                               indexrow: index,
//                                             ),
//                                       ));
//                                   print(result.toString());
//                                   print(result.toString());
//                                   if (result != null) {
//                                     setState(() {
//                                       // serachField.text="";
//                                       // _filterCountries("");
//                                     });
//                                     print(
//                                         "Back offer to home : >>>>>>>>>>>>>>  $result");
//                                     try {
//                                       _All_allOffer.clear();
//                                       _All_allOffer.clear();
//                                       _All_allOffer.clear();
//                                     } catch (r) {}
//                                     setState(() {
//                                       serachField.text="";
//                                     });
//
//                                     if (result["favorit"] != null &&
//                                         result["directio"] == "offer") {
//                                       setState(() {
//                                         // serachField.text="";
//                                         // _filterCountries("");
//                                         _All_allOffer[int.parse(result["index"]
//                                             .toString())]["favorite"] =
//                                             result["favorit"].toString();
//                                       });
//                                     }
//                                     // _onRefresh();
//                                   }
//                                 },
//                                 child: _getOffers(context, index),
//                               );
//                             },
//                           ),
//                         ),
//
//
//
//                         //  *  text list is empty
//                         Visibility(
//                           visible:
//                           serachField.text
//                               .toString()
//                               .isEmpty ? true :
//                           _All_allOffer == null || _All_allOffer.isEmpty
//                               ? true
//                               : false,
//                           child: Container(
//                             padding: EdgeInsets.only(bottom: MediaQuery
//                                 .of(context)
//                                 .size
//                                 .height / 4),
//                             child:
//                             serachField.text
//                                 .toString()
//                                 .trim()
//                                 .isEmpty ? Center(
//                               child: Text(""
//                                   // SetLocalization.of(context)!
//                                   // .getTranslateValue('SearchStore')!
//                               ),
//                             ) :
//                             Center(
//                                 child: Text(
//                                   SetLocalization.of(context)!
//                                       .getTranslateValue('no_offer')!
//                                   ,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontSize: 20
//                                   ),
//                                 )
//                             ),
//                           ),
//                         )
//                       ],
//                     )
//
//                   ],
//                 ),
//               )
//
//           )
//       );
//   }
//
//   List _All_allOffer=[];
//   // List? _All_allOffer_testdata=null;
//   // List _All_allOffer_old=[];
//   Map? data_allOffer;
//   int numOfferNotActive=0;
//
//   Future getData_allOffer() async {
//
//     if(serachField.text.toString().trim().isEmpty){
//       setState(() {
//         _All_allOffer.clear();
//         _All_allOffer.clear();
//         _All_allOffer.clear();
//       });
//
//     }else{
//       Map<String, dynamic> body = {
//         "lang":langApp,
//         "locationid":widget.idLcation,
//         "keyword":serachField.text.toString().trim(),
//         "userid":idUser
//       };
//
//
//       final encoding = Encoding.getByName('utf-8');
//       String jsonBody = json.encode(body);
//       final headers = {'Content-Type': 'application/json'};
//       print("URL_LOGIC  "+"http://wainsale.com/apps_api/home/search.php");
//       print("body  "+jsonBody.toString());
//       final response_offer = await http.post(Uri.parse("http://wainsale.com/apps_api/home/search.php"),
//         body:jsonBody,
//         encoding: encoding,
//         headers: headers,
//       );
//       data_allOffer = json.decode(response_offer.body);
//       print("data_allOffer  "+data_allOffer.toString());
//       setState(()  {
//         data_allOffer = json.decode(response_offer.body);
//
//         print("data_allOffer  "+data_allOffer.toString());
//
//         setState(() {
//           try{
//             if(data_allOffer!["offers"][0]["id"]!=null){
//               setState(() {
//                 _All_allOffer=data_allOffer!["offers"];
//               });
//
//             }else {
//               setState(() {
//
//                 _All_allOffer.clear();
//                 _All_allOffer=[];
//                 // _All_allOffer_testdata = [];
//               });
//             }
//           }catch(e){
//             _All_allOffer.clear();
//             _All_allOffer=[];
//           }
//         });
//       });
//     }
//
//   }
//
//
//
//
//   Widget _getOffers(BuildContext context, int index) {
//     return
//       // GestureDetector(
//       InkWell(
//         child: Container(
//           child: Column(
//             children: <Widget>[
//               Row(
//                 children: <Widget>[
//                   //image
//                   Container(
//                     decoration: BoxDecoration(
//                       // color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.1),
//                           spreadRadius: 3,
//                           blurRadius: 3,
//                           offset: Offset(0, 2), // changes position of shadow
//                         ),
//                       ],
//                     ),
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                     width: 70,
//                     height: 70,
//                     child:   FittedBox(
//                        child: CachedNetworkImage(
//                           height: 20,
//                           width:20,
//                           fit: BoxFit.fill,
//                           imageUrl: "${_All_allOffer[index]["offer_img"]}",
//                           placeholder: (context, url) => Container(),
//                           errorWidget: (context, url, error) => Image.asset("assets/images/no_image_avilable.png",height: 20,width:20,),
//                           ),
//                     ),
//
//                     // FittedBox(
//                     //   child: FadeInImage(
//                     //
//                     //     image: NetworkImage(_All_allOffer[index]["offer_img"]),
//                     //     placeholder: AssetImage('assets/images/loadimage.gif'),
//                     //     // placeholder: AssetImage('assets/images/no_image_avilable.png'),
//                     //   ),
//                     //   fit: BoxFit.fill,
//                     // ),
//                   ),
//                   SizedBox(
//                     width: 5,
//                   ),
//
//                   Expanded(
//                     child:Container(
//                       height: 80,
//                       padding: EdgeInsets.only(top: 2),
//                       child:  Column(
//                         children: <Widget>[
//
//                           Row(
//                             children: <Widget>[
//
//                               Expanded(
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: <Widget>[
//                                     Expanded(
//                                       child:Text(
//                                         _All_allOffer[index]["name"],
//                                         style: TextStyle(
//                                           fontSize: 15,
//                                           color: Colors.black,
//                                         ),
//                                         maxLines: 1,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               // Expanded(
//                               //   child:
//                               // Padding(
//                               //   padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
//                               //   child: Row(
//                               //     mainAxisAlignment: MainAxisAlignment.end,
//                               //     children: <Widget>[
//                               //       InkWell(
//                               //         splashColor: Colors.transparent,
//                               //         highlightColor: Colors.transparent,
//                               //         child: Icon(
//                               //           _All_allOffer[index]["favorite"].toString() == 'null' ? Icons.favorite_border :
//                               //           _All_allOffer[index]["favorite"].toString() == '0' ? Icons.favorite_border :
//                               //           Icons.favorite,
//                               //           color: _All_allOffer[index]["favorite"].toString() == '0' ? Colors.grey :
//                               //           _All_allOffer[index]["favorite"].toString() == '1' ? Colors.red :
//                               //           Colors.grey,
//                               //         ),
//                               //         onTap: () {
//                               //           if (idUser !=null) {
//                               //             if ( _All_allOffer[index]["favorite"].toString() == '1') {
//                               //               _sendItemData_favorite("un_fav",_All_allOffer[index]["id"],index);
//                               //               // client.addFavorite(PreferenceUtils.getUserEmail(), allOffer[index].id, PreferenceUtils.getUserSessionID()).then((value) => {if (value.statusCode != 200) {}});
//                               //             } else {
//                               //               _sendItemData_favorite("fav",_All_allOffer[index]["id"],index);
//                               //               // client
//                               //               //     .deleteFavorite(PreferenceUtils.getUserEmail(), allOffer[index].id, PreferenceUtils.getUserSessionID())
//                               //               //     .then((value) => {if (value.statusCode != 200) {}});
//                               //             }
//                               //             //   setState(() {
//                               //             //     allOffer[index].favorite = allOffer[index].favorite == '1' ? '0' : '1';
//                               //             //   });
//                               //           } else {
//                               //             sign_in(context);
//                               //           }
//                               //         },
//                               //       )
//                               //     ],
//                               //   ),
//                               // ),
//                               // )
//                             ],
//                           ),
//
//                           Stack(
//                             children: [
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//
//                                   Container(
//                                     // color: Colors.blue,
//                                     // padding: EdgeInsets.only(bottom: 10),
//                                     width: MediaQuery.of(context).size.width-110,
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       children: <Widget>[
//                                         Expanded(
//                                           child:
//                                           Text(
//                                             _All_allOffer[index]["offer_description"].toString().length>76 ?
//                                             _All_allOffer[index]["offer_description"].toString().substring(0,76)+"...." :
//                                             _All_allOffer[index]["offer_description"]
//                                             ,maxLines: 2,
//                                             style: TextStyle(fontSize: 13,
//                                               color: Color(0xff9b9b9b),),
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//
//                               Align(
//                                 alignment: langApp=="ar"?Alignment.bottomLeft:Alignment.bottomRight,
//                                 child:  Container(
//                                   height: 50,
//                                   padding: EdgeInsets.only(right: 6),
//                                   width: MediaQuery.of(context).size.width/4.5,
//                                   child: ListView.builder(
//                                     reverse: true,
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount:
//                                     _All_allOffer==null?0:
//                                     _All_allOffer[index]==null?0:
//                                     _All_allOffer[index]["small_icon"]==null?0:
//                                     _All_allOffer[index]["small_icon"].length,
//                                     itemBuilder: (BuildContext context, int position) {
//                                       return Container(
//                                         // color: Colors.red,
//                                         // _All_allOffer[index]["small_icon"][position]
//                                           child: Row(
//                                             crossAxisAlignment: CrossAxisAlignment.end,
//                                             children: <Widget>[
//                                               // SizedBox(width: 5,),
//
//                                               Container(
//                                                 height: 27,
//                                                 width: 27,
//                                                 margin: EdgeInsets.only(left: 1,right: 1),
//                                                 decoration: BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                   border: Border.all(color: const Color(0x33A6A6A6)),
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                       color: Colors.grey.withOpacity(0.1),
//                                                       spreadRadius: 1,
//                                                       blurRadius: 1,
//                                                       offset: Offset(0, 1), // changes position of shadow
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 child: ClipOval(
//                                                   child: FadeInImage(
//                                                       image:
//                                                       // _All_allOffer==null?AssetImage('assets/images/no_image_avilable.png'):
//                                                       // _All_allOffer[index]==null?AssetImage('assets/images/no_image_avilable.png'):
//                                                       // _All_allOffer[index]["small_icon"]==null?AssetImage('assets/images/no_image_avilable.png'):
//                                                       // _All_allOffer[index]["small_icon"][position]==null?AssetImage('assets/images/no_image_avilable.png'):
//
//                                                       NetworkImage(_All_allOffer[index]["small_icon"][position]),
//                                                       width: 34,
//                                                       height: 34,
//                                                       placeholder: AssetImage('assets/images/no_image_avilable.png'),
//                                                       fit: BoxFit.cover
//                                                   ),
//                                                 ),
//                                               ),
//
//
//                                             ],
//                                           ));
//                                     },
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 padding: EdgeInsetsDirectional.only(top: 0, bottom: 2),
//                 child: Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: Divider(height: 1,
//                           color: Color(0x80000000)),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       );
//   }
//
//
//
//   Widget appBAr() {
//     return PreferredSize(
//       key: null,
//         preferredSize: Size.fromHeight(100.0),
//         child: AppBar(
//           backgroundColor: Color(0xFF00838f),
//           shape: CurvedClipper(),
//
//           flexibleSpace: Container(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//
//
//                 Container(
//                   alignment: Alignment.center,
//                   padding: EdgeInsets.only(top: 18, bottom: 10),
//                   child: InkWell(
//                     splashColor: Colors.transparent,
//                     highlightColor: Colors.transparent,
//                     //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//                     onTap: () async {
//
//                     },
//
//                     child: Container(
//                       constraints: BoxConstraints(
//                           maxWidth: 260,
//                           minWidth:100
//                       ),
//                       // width: MediaQuery.of(context).size.width/1.4,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Icon(
//                             Icons.location_on,
//                             color: Colors.white,
//                             size: 22,
//                           ),
//                           SizedBox(
//                             width: 4,
//                           ),
//                           Flexible(
//                             // fit:FlexFit.loose,
//                               child:   Text(
//                                 widget.nameLcation!,
//                                 style: TextStyle(fontSize: 19, color: Colors.white),
//                                 softWrap: false,
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.start,
//
//                               )
//                           ),
//
//                           SizedBox(
//                             width: 4,
//                           ),
//                           Image.asset(
//                             'assets/images/icon_down.png',
//                             height: 8,
//                             width: 15,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//
//
//                 Directionality(textDirection: TextDirection.ltr,child:Container(
//                   width: 260,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(30),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color(0x29000000),
//                         blurRadius: 10,
//                         spreadRadius: 1,
//                         offset: Offset(0, 5),
//                       ),
//                     ],
//                     color: Colors.white,
//                   ),
//                   child:InkWell(
//                     child:  TextField(
//                       autofocus: true,
//                       enabled: true,
//                       controller: serachField,
//                       onSubmitted: (_) => {
//                         FocusScope.of(context).unfocus(),
//                       },
//                       focusNode: searchBarFcous,
//                       onTap: () {
//                         searchBarFcous!.requestFocus();
//                       },
//
//                       onChanged: (value) async {
//                         if (value.length > 0) {
//                           getData_allOffer();
//                           // print(value);
//                           // _filterCountries(value);
//                         } else {
//                           Timer(
//                               Duration(seconds: 4),
//                                   () async {
//                                 setState(() {
//                                   _All_allOffer.clear();
//                                   _All_allOffer.clear();
//                                   _All_allOffer.clear();
//                                 });
//                               });
//                         }
//                       },
//                       onEditingComplete: () {
//                         print(serachField.text.toString().trim());
//                       },
//                       style: TextStyle(fontSize: 13, color: Color(0xffb5b5b5)),
//                       textAlign: langApp == 'en' ? TextAlign.center : TextAlign.center,
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.fromLTRB(44, 8, 0, 0),
//                         prefixIcon: Icon(
//                           Icons.search,
//                           color: Color(0xffb5b5b5),
//                         ),
//                         hintText: SetLocalization.of(context)!.getTranslateValue('SearchStore'),
//                         // hintText: SetLocalization.of(context).getTranslateValue('search_bar'),
//                         hintStyle: TextStyle(fontSize: 13, color: Color(0xffb5b5b5)),
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 )),
//               ],
//             ),
//           ),
//
//         )
//     );
//   }
// }