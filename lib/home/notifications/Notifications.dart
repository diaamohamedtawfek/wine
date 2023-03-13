// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart'as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wineapp/URL_LOGIC.dart';
// import 'package:wineapp/home/item/OfferScreen.dart';
// import 'package:wineapp/home/notifications/DataNotification.dart';
// class NotificationsUsers extends StatefulWidget{
//   final String? idUser;
//
//   const NotificationsUsers({Key? key, this.idUser}) : super(key: key);
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return UiNotificationsUsers();
//   }
// }
//
// class UiNotificationsUsers extends State<NotificationsUsers> {
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     // fetchApi();
//   }
//
//   Future<DataNotification> fetchApi() async {
//     try {
//
//       SharedPreferences preferences=await SharedPreferences.getInstance();
//       String? lang=preferences.getString("lang");
//
//       // Map<String,dynamic> body={"lang":"$lang","userid":"57"};
//       Map<String,dynamic> body={"lang":"$lang","userid":"${widget.idUser}"};
//
//       final encoding = Encoding.getByName('utf-8');
//       var jsonBody=json.encode(body);
//       print(jsonBody.toString());
//
//
//       print(URL_LOGIC.notificationApi);
//       var uriResponse = await http.post(Uri.parse(URL_LOGIC.notificationApi!),
//           encoding: encoding,
//           body: jsonBody
//           );
//
//       if(uriResponse.statusCode == 200){
//         // print(uriResponse.body.toString());
//         DataNotification da= DataNotification.fromJson(json.decode(uriResponse.body)!);
//         print(da.notifications[0].message.toString());
//         return da;
//       }else{
//         throw Exception('Can not load posts >>');
//       }
//
//     }catch(e){
//       throw Exception('${e.toString()}>>>>');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xff00838f),
//         centerTitle: true,
//         title: Text(
//         "Notifications",
//           style: TextStyle(
//               fontSize: 18,
//               color: Colors.white,
//               fontWeight: FontWeight.bold
//           ),),
//       ),
//
//
//       body: FutureBuilder<DataNotification>(
//         future: fetchApi(),
//           builder: (context,snp){
//           if(snp.hasData &&snp.data!.notifications[0].code!=null){
//             return Center(
//               child: Text(snp.data!.notifications[0].message.toString()),
//             );
//           }else if(snp.hasData &&snp.data!.notifications[0].code==null){
//             return Center(
//               child: ListView.builder(
//                 itemCount: snp.data!.notifications.length,
//                 itemBuilder: (context,index){
//                   return  InkWell(
//                     onTap: (){
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (BuildContext builder)=>
//                               OfferScreen(offerID: snp.data!.notifications[index].offer.toString(),
//                                 offerName: snp.data!.notifications[index].offer_name.toString(),))
//                       );
//                     },
//                     child: Card(
//                       elevation: 3.0,
//                       shadowColor: Color(0xff00838f),
//                       child:Container(
//                         padding: EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//
//
//                             Icon(Icons.notifications_none, color: Color(0xff00838f),size: 38,),
//
//                             SizedBox(width: 6,),
//
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//
//                                   Text(
//                                     snp.data!.notifications[index].dateadd.toString(),
//                                     style: TextStyle(
//                                         fontSize: 15,
//                                         color: Colors.grey
//                                     ),
//
//                                   ),
//
//                                   SizedBox(height: 8,),
//
//                                   Text(
//                                     snp.data!.notifications[index].message.toString(),
//                                     style: TextStyle(
//                                         fontSize: 15,
//                                         color: Colors.black
//                                     ),
//
//                                   )
//
//                                 ],
//                               ),
//                             ),
//
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           }else if(snp.hasError){
//             return Center(
//                 child:Text(snp.error.toString()
//                 ),);
//           }
//             return Container(child: Center(child: CircularProgressIndicator(backgroundColor: Color(0x2900838f),
//               valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff00838f)),
//             )
//             )
//             );
//
//
//           }
//       ),
//
//     );
//   }
// }