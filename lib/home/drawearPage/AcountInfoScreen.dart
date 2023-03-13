// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:tip_dialog/tip_dialog.dart';
// import 'package:wineapp/lang/localization/set_localization.dart';
//
//
// class AcountInfoScreen extends StatefulWidget {
//   final Locale? locale;
//   AcountInfoScreen({Key? key, this.locale}) : super(key: key);
//   @override
//   _AcountInfoScreenState createState() => _AcountInfoScreenState();
// }
//
// class _AcountInfoScreenState extends State<AcountInfoScreen> {
//   TextEditingController emailController = TextEditingController()..text = 'example_user123@gmail.com';
//   TextEditingController fullNameController = TextEditingController()..text = 'hassan';
//   TextEditingController phoneController = TextEditingController()..text = '012345678';
//
//   StreamController? phoneCodeController;
//   StreamController? ageGroupController;
//   StreamController? nationalityController;
//   Color? emailColor;
//   Color? fullNameColor;
//   Color? phoneColor;
//   int? selectedGender;
//   Locale? myLocale;
//   bool isReceiveOffers = true;
//   bool isReceiveNews = true;//isReceiveNews،isReceiveOffers
//   bool userLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     myLocale = widget.locale;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xff00838f),
//         centerTitle: true,
//         title: Text(SetLocalization.of(context)!.getTranslateValue('nav_settings_account')!,
//           style: TextStyle(
//               fontSize: 18,
//               color: Colors.white,
//               fontWeight: FontWeight.bold
//           ),),
//       ),
//       body: Stack(
//         children: [
//
//           Visibility(
//             visible: true,
//             // replacement: Container(
//             //   child: Container(
//             //       alignment: Alignment.center,
//             //       child: CircularProgressIndicator()),
//             // ),
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//               child: ListView(
//                 children: [
//                   SizedBox(height: 30,),
//                   //email
//                   Container(
//                     padding: EdgeInsets.only(left: 20, right: 20),
//                     child: Material(
//                       child: Focus(
//                         onFocusChange: (value) {
//                           if(value){
//                             setState(() {
//                               emailColor = Colors.black;
//                             });
//                           }else{
//                             setState(() {
//                               emailColor = Colors.grey;
//                             });
//                           }
//                         },
//                         child: TextField(
//                           controller: emailController,
//                           keyboardType: TextInputType.emailAddress,
// //                          inputFormatters: [FilteringTextInputFormatter.deny(
// //                              RegExp('[ ]'))],
//                           textAlign: TextAlign.start,
//                           style: TextStyle(
//                             fontSize: 16.0,
//                             color: emailColor,
//                           ),
//                           decoration:  InputDecoration(
//                               labelText: SetLocalization.of(context)!.getTranslateValue('email'),
//                               labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             focusedBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             border: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             disabledBorder:  UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20,),
//
//                   //fullname
//                   Container(
//                     padding: EdgeInsets.only(left: 20, right: 20),
//                     child: Material(
//                       child: Focus(
//                         onFocusChange: (value) {
//                           if(value){
//                             setState(() {
//                               fullNameColor = Colors.black;
//                             });
//                           }else{
//                             setState(() {
//                               fullNameColor = Colors.grey;
//                             });
//                           }
//                         },
//                         child: TextField(
//                           controller: fullNameController,
//                           textAlign: TextAlign.start,
//                           style: TextStyle(
//                             fontSize: 16.0,
//                             color: fullNameColor,
//                           ),
//                           decoration:  InputDecoration(
//                             labelText: SetLocalization.of(context)!.getTranslateValue('full_name'),
//                             labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             focusedBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             border: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                             disabledBorder:  UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.grey),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20,),
//
//                   //phone
//                   Container(
//                     padding: EdgeInsets.only(left: 20, right: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           child: Text(SetLocalization.of(context)!.getTranslateValue('phone')!,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey
//                           ),),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//
//                             Container(
//                               decoration: BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(width: 1.0, color: Colors.grey),
//                                 )),
//                               child: FlatButton(
//                                 padding: EdgeInsets.all(0),
//                                 onPressed: (){
//                                   phoneCodeController = new StreamController();
//                                   // getCountryData();
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Text("+999",style: TextStyle(color: Colors.grey),),
//                                     // Text(selectedCode.code,style: TextStyle(color: Colors.grey),),
//                                     Icon(Icons.keyboard_arrow_down, color: Colors.grey,)
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Container(
//                                 padding: EdgeInsets.only(left: 20, right: 20),
//                                 child: Material(
//                                   child: Focus(
//                                     onFocusChange: (value) {
//                                       if(value){
//                                         setState(() {
//                                           phoneColor = Colors.black;
//                                         });
//                                       }else{
//                                         setState(() {
//                                           phoneColor = Colors.grey;
//                                         });
//                                       }
//                                     },
//                                     child: TextField(
//                                       controller: phoneController,
// //                                      inputFormatters: [FilteringTextInputFormatter.deny(
// //                                          RegExp('[ ]'))],
//                                       textAlign: TextAlign.start,
//                                 keyboardType: TextInputType.number,
//
//                                 style: TextStyle(
//                                               fontSize: 16.0,
//                                         color: phoneColor,
//                                       ),
//                                       decoration:  InputDecoration(
//                                         enabledBorder: UnderlineInputBorder(
//                                           borderSide: BorderSide(color: Colors.grey),
//                                         ),
//                                         focusedBorder: UnderlineInputBorder(
//                                           borderSide: BorderSide(color: Colors.grey),
//                                         ),
//                                         border: UnderlineInputBorder(
//                                           borderSide: BorderSide(color: Colors.grey),
//                                         ),
//                                         disabledBorder:  UnderlineInputBorder(
//                                           borderSide: BorderSide(color: Colors.grey),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//
//                   SizedBox(height: 20,),
//
//                   Container(
//                     padding: "myLocale.languageCode.toLowerCase()" =="en"? EdgeInsets.only(left: 20) : EdgeInsets.only(right: 20),
//                     child: Text(SetLocalization.of(context)!.getTranslateValue('gender')!, style: TextStyle(
//                         fontSize: 16
//                     ),),
//                   ),
//                   SizedBox(height: 10,),
//                   Container(
//                     padding: EdgeInsets.only(left: 20, right: 20),
//                     child: Row(
//                       children: [
//                         GestureDetector(
//                           onTap: (){
//                             setState(() {
//                               selectedGender = 0;
//                             });
//                           },
//                           child: Row(
//                             children: [
//                               Icon(selectedGender == 0 ? Icons.check_circle :  Icons.radio_button_unchecked, color: selectedGender == 0 ? Color(0xff00838f): Colors.grey,),
//
//                               SizedBox(width: 5,),
//                               Text(SetLocalization.of(context)!.getTranslateValue('male')!, style: TextStyle(
//                                   fontSize: 14
//                               ),)
//                             ],
//                           ),
//                         ),
//                         SizedBox(width: 15,),
//                         GestureDetector(
//                           onTap: (){
//                             setState(() {
//                               selectedGender = 1;
//                             });
//                           },
//                           child: Row(
//                             children: [
//                               Icon(selectedGender == 1 ? Icons.check_circle :  Icons.radio_button_unchecked, color: selectedGender == 1 ? Color(0xff00838f): Colors.grey,),
//
//                               SizedBox(width: 5,),
//                               Text(SetLocalization.of(context)!.getTranslateValue('female')!, style: TextStyle(
//                                   fontSize: 14
//                               ),)
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//
//                   SizedBox(height: 20,),
//                   Container(
//                     padding: EdgeInsets.only(left: 20, right: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(SetLocalization.of(context)!.getTranslateValue('age_group')!, style: TextStyle(
//                             fontSize: 16
//                         ),),
//                         GestureDetector(
//                           onTap: (){
//
//                             ageGroupController = new StreamController();
//                             // getAgeGroup();
//                             showDialog(context: context,
//                                 barrierDismissible: false,
//                                 builder: (context){
//                                   return StatefulBuilder(
//                                       builder: (context, setState) {
//                                         return Material(
//                                           type: MaterialType.transparency,
//                                           child: Center(
//                                             child: Container(
//                                               padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width/2)/2, right: (MediaQuery.of(context).size.width/2)/2),
//                                               child: ListView(
//                                                 shrinkWrap: true,
//                                                 children: [
//                                                   Container(
//                                                     decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
//                                                         color: Colors.white
//                                                     ),
//                                                     padding: EdgeInsets.only(left: 5, right: 5, top: 5),
//                                                     child: Row(
//                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                       children: [
//
//                                                         Text('Select Age Group', style: TextStyle(
//                                                         ),),
//
//                                                         SizedBox(width: 5,),
//
//                                                         InkWell(
//                                                           onTap:(){
//                                                             Navigator.pop(context);
//                                                           },
//                                                           child: Container(
//                                                               width: 50,child: Center(child: Text(SetLocalization.of(context)!.getTranslateValue('close')!))),
//                                                         )
//                                                       ],
//                                                     ),
//
//                                                   ),
//                                                   Container(child: Divider(color: Colors.black,),color: Colors.white,),
//                                                   Center(
//                                                     child: Container(
//                                                       decoration: BoxDecoration(
//                                                           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
//                                                           color: Colors.white
//                                                       ),
//                                                       height: MediaQuery.of(context).size.height/4,
//                                                       padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 20),
//                                                       child: StreamBuilder(
//                                                         stream: ageGroupController!.stream,
//                                                         builder: (context, ageGroup)
//                                                         {
//                                                           if (!ageGroup.hasData) {
//                                                             //print('project snapshot data is: ${projectSnap.data}');
//                                                             return Center(child: CircularProgressIndicator());
//                                                           }
//                                                           return Container();
//                                                         },
//
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 10,),
//                                                   GestureDetector(
//                                                     onTap:(){
//                                                       Navigator.pop(context);
//                                                     },
//                                                     child: Container(
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.white,
//                                                         borderRadius: BorderRadius.circular(12),
//                                                       ),
//                                                       child: Center(
//                                                         child: Text(
//                                                           SetLocalization.of(context)!.getTranslateValue('done')!,
//                                                           style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
//                                                         ),
//                                                       ),
//                                                       padding: EdgeInsets.all(10),
//                                                     ),
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       }
//                                   );
//                                 }).then((value) => {
//                               setState((){
//                                 // selectedAge.id = selectedAge.id;
//                                 // selectedAge.group = selectedAge.group;
//                               })
//                             });
//
//
//                           },
//                           child: Text("3333" , style: TextStyle(
//                               fontSize: 16,
//                               color: Color(0xff00838f)
//                           ),),
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 12,),
//                   Container(
//                     padding: EdgeInsets.only(left: 20, right: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(SetLocalization.of(context)!.getTranslateValue('nationality')!, style: TextStyle(
//                             fontSize: 16
//                         ),),
//                         GestureDetector(
//                           onTap: (){
//                             nationalityController = new StreamController();
//                             // getNntionality();
//                             showDialog(context: context,
//                                 barrierDismissible: false,
//                                 builder: (context){
//                                   return StatefulBuilder(
//                                       builder: (context, setState) {
//                                         return Material(
//                                           type: MaterialType.transparency,
//                                           child: Center(
//                                             child: Container(
//
//                                               padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width/2)/2, right: (MediaQuery.of(context).size.width/2)/2),
//                                               child: ListView(
//                                                 shrinkWrap: true,
//                                                 children: [
//                                                   Container(
//                                                     decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
//                                                         color: Colors.white
//                                                     ),
//                                                     padding: EdgeInsets.only(left: 5, right: 5, top: 5),
//                                                     child: Row(
//                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                       children: [
//
//                                                         Text('Select Nationality', style: TextStyle(
//                                                         ),),
//
//                                                         SizedBox(width: 5,),
//
//                                                         InkWell(
//                                                           onTap:(){
//                                                             Navigator.pop(context);
//                                                           },
//                                                           child: Container(
//                                                               width: 50,child: Center(child: Text(SetLocalization.of(context)!.getTranslateValue('close')!))),
//                                                         )
//                                                       ],
//                                                     ),
//
//                                                   ),
//                                                   Container(child: Divider(color: Colors.black,),color: Colors.white,),
//                                                   Center(
//                                                     child: Container(
//                                                       decoration: BoxDecoration(
//                                                           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
//                                                           color: Colors.white
//                                                       ),
//                                                       height: MediaQuery.of(context).size.height/4,
//                                                       padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 20),
//                                                       child: StreamBuilder(
//                                                         stream: nationalityController!.stream,
//                                                         builder: (BuildContext context, nationality)
//                                                         {
//                                                           if (!nationality.hasData) {
//                                                             //print('project snapshot data is: ${projectSnap.data}');
//                                                             return Center(child: CircularProgressIndicator());
//                                                           }
//                                                           return Container();
//                                                         },
//
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 10,),
//                                                   GestureDetector(
//                                                     onTap:(){
//                                                       Navigator.pop(context);
//                                                     },
//                                                     child: Container(
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.white,
//                                                         borderRadius: BorderRadius.circular(12),
//                                                       ),
//                                                       child: Center(
//                                                         child: Text(
//                                                           SetLocalization.of(context)!.getTranslateValue('done')!,
//                                                           style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
//                                                         ),
//                                                       ),
//                                                       padding: EdgeInsets.all(10),
//                                                     ),
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       }
//                                   );
//                                 }).then((value) => {
//                               setState((){
//                                 // selectedNationality.id = selectedNationality.id ;
//                                 // selectedNationality.nationalityName =  selectedNationality.nationalityName;
//                               })
//                             });
//
//                           },
//                           child: Text("selectedNationality.nationalityName ", style: TextStyle(
//                               fontSize: 16,
//                               color: Color(0xff00838f)
//                           ),),
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20,),
//                   SizedBox(height: 20,),
//                   Row(
//                     children: [
//                       Checkbox(
//
//                         //title: Text("Yes, I want to receive offers"),
//                         value: isReceiveOffers,
//                         onChanged: (newValue) {
//                           setState(() {
//                             isReceiveOffers = newValue!;
//                           });
//                         },
//                         //controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
//                       ),
//                       Text(SetLocalization.of(context)!.getTranslateValue('recive_offer')!),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Checkbox(
//                         //title: Text("Yes, I want to receive offers"),
//                         value: isReceiveNews,
//                         onChanged: (newValue) {
//                           setState(() {
//                             isReceiveNews = newValue!;
//                           });
//                         },
//                         //controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
//                       ),
//                       Text(SetLocalization.of(context)!.getTranslateValue('recive_news')!),
//                     ],
//                   ),
//
//
//                   // check boox
//
//                   Row(
//                     children: [
//                       Checkbox(
//
//                         //title: Text("Yes, I want to receive offers"),
//                         value: isReceiveOffers,
//                         onChanged: (newValue) {
//                           setState(() {
//                             isReceiveOffers = newValue!;
//                           });
//                         },
//                         //controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
//                       ),
//                       Text(SetLocalization.of(context)!.getTranslateValue('recive_offer')!),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Checkbox(
//
//                         //title: Text("Yes, I want to receive offers"),
//                         value: isReceiveNews,
//                         onChanged: (newValue) {
//                           setState(() {
//                             isReceiveNews = newValue!;
//                           });
//                         },
//                         //controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
//                       ),
//                       Text(SetLocalization.of(context)!.getTranslateValue('recive_news')!),
//                     ],
//                   ),
//
//                   SizedBox(height: 15,),
//                   Container(
//                     height: 45,
//                     padding: EdgeInsets.only(left: 20, right: 20),
//                     child: RaisedButton(
//                       child: Text(
//                         SetLocalization.of(context)!.getTranslateValue('done')!,style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.white
//                       ),
//                       ),
//                       onPressed: () async{
//
//
//                       },
//                       color: Color(0xff00838f),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25.0),
//
//                       ),
//                     ),
//                   ),
//
//
//                 ],
//               ),
//             ),
//           ),
//           // TipDialogContainer(
//           //     duration: const Duration(seconds: 2),
//           //     outsideTouchable: true,
//           //     onOutsideTouch: (Widget tipDialog) {
//           //       if (tipDialog is TipDialog &&
//           //           tipDialog.type == TipDialogType.LOADING) {
//           //         TipDialogHelper.dismiss();
//           //       }
//           //     })
//         ],
//       ),
//
//     );
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     }
//
//
//
//
//
// }
