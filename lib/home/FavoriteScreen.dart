import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../URL_LOGIC.dart';
import 'item/OfferScreen.dart';
import '../lang/localization/set_localization.dart';

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:wineapp/lang/localization/set_localization.dart';

class FavoriteScreen extends StatefulWidget {
  final String? locationid_mal;
  FavoriteScreen({Key? key, this.locationid_mal}) : super(key: key);


  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  void initState() {
    super.initState();

    getStringValuesSF();
  }

  String? idUsers;
  String? langApp;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    bool checkValue = prefs.containsKey('lang');
    String? lang = prefs.getString('lang');
    String? idUser = prefs.getString('userid');
    // print("idUser=> "+lang.toString());

    setState(() {
      idUsers=idUser;
      langApp=lang;

      if(idUsers!=null){
        getData_Item();
      }
    });
//    return stringValue;
  }

  Map? data_Item;
  List _All_Item=[];

  Future getData_Item() async {

    // offer
    Map<String, Object> body ={
      "lang":langApp!,
      "userid":idUsers!,
    };
    // {
    //   "lang":"en",
    //   "userid":"58",
    //   "offer_id":"11"
    // };
    print("body is :"+body.toString());
    print("url is :"+URL_LOGIC.myfavorite.toString());
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};

    http.Response responseOffer = await http.post(
      Uri.parse("${URL_LOGIC.myfavorite}"),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    data_Item = json.decode(responseOffer.body);

//    userData_offer = data_offer["bestseller"];
    print(data_Item.toString());

    setState(() {
      data_Item = json.decode(responseOffer.body);
      if(data_Item!["myfavorite"][0]["code"] ==null){
        _All_Item.addAll(data_Item!["myfavorite"]);
      }

      // print(data_Item["main"][0]["images"]);


    });
  }

  int fav=0;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, fav);
        return false;
      } ,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff00838f),
          centerTitle: true,
          title: Text(SetLocalization.of(context)!.getTranslateValue('nav_fav')!,
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),),
        ),

        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child:_All_Item ==null || idUsers==null || _All_Item.isEmpty  ?
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(child: Text(
              idUsers==null?SetLocalization.of(context)!.getTranslateValue('sign_in_err')! :
              SetLocalization.of(context)!.getTranslateValue('no_fav_offer')!
              ,style: TextStyle(
              fontSize: 18,
            ),)),
          )
          :
          ListView.builder(
            padding: EdgeInsets.all(11),
            itemCount:_All_Item ==null?0: _All_Item.isEmpty?0 :  _All_Item.length,
            itemBuilder: (BuildContext context, int index) {
              return _getOffers(context, index);
            },
          ),
        ),
      ),
    );
  }

  Widget _getOffers(BuildContext context, int index) {
    return GestureDetector(
      onTap: () async {

        var result = await  Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OfferScreen(
                offerID: _All_Item[index]["id"].toString(),
                offerName: _All_Item[index]["name"],
                offerFavorite:  _All_Item[index]["favorite"].toString(),
                locationid_mal: _All_Item[index]["locationid"],
                // widget.locationid_mal.toString(),
                direction: "fav",
                indexrow: index,

              ),
            ));
        if(result!=null){
          print("Back offer to home : >>>>>>>>>>>>>>  $result");
          if(result["favorit"]!=null&& result["favorit"].toString()=="0"){
            setState(() {
            _All_Item.removeAt(int.parse(result["index"].toString()));
              // _All_allOffer[int.parse(result["index"].toString())]["favorite"]=result["favorit"].toString();
            });
          }
          // _onRefresh();
        }

      },
      child: Column(
        children: <Widget>[


          Row(
            children: <Widget>[

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
                child:
                FittedBox(
                  child: CachedNetworkImage(
                    height: 70,
                    width:70,
                    fit: BoxFit.fill,
                    imageUrl: "${_All_Item[index]["offer_img"]}",
                    placeholder: (context, url) => Container(),
                    errorWidget: (context, url, error) => Container()
                        // Image.asset("assets/images/no_image_avilable.png",height: 120,width:120,),
                  ),
                  // FadeInImage(
                  //   image: NetworkImage(_All_Item[index]["offer_img"]),
                  //   placeholder: AssetImage('assets/images/no_image_avilable.png'),
                  // ),
                  fit: BoxFit.fill,
                ),
              ),

              SizedBox(
                width: 5,
              ),

              Expanded(
                child:Container(
                  height: 80,
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
                                    _All_Item[index]["name"],
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
                                    Icons.favorite,
                                    color:  Colors.red,
                                  ),
                                  onTap: () {
                                    _sendItemData_favorite("un_fav",_All_Item[index]["id"],index);
                                  },
                                )
                              ],
                            ),
                          ),
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
                                        _All_Item[index]["offer_description"].toString().length>76 ?
                                        _All_Item[index]["offer_description"].toString().substring(0,76)+"...." :
                                        _All_Item[index]["offer_description"]
                                        ,maxLines: 2,
                                        style: TextStyle(fontSize: 13,
                                          color: Color(0xff9b9b9b),),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Align(
                            alignment:langApp=="ar" ?Alignment.bottomLeft:Alignment.bottomRight,
                            child:  Container(
                              height: 54,
                              padding: EdgeInsets.only(right: 6),
                              width: MediaQuery.of(context).size.width/4.5,
                              child: ListView.builder(
                                reverse: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: _All_Item==null?0 :
                                _All_Item[index]==null?0 :
                                _All_Item[index]["small_icon"]==null?0 :
                                _All_Item[index]["small_icon"].length,
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
                                              child: CachedNetworkImage(
                                                  height: 70,
                                                  width:70,
                                                  fit: BoxFit.fill,
                                                  imageUrl: "${_All_Item[index]["small_icon"][position]}",
                                                  placeholder: (context, url) => Container(),
                                                  errorWidget: (context, url, error) => Container()
                                                // Image.asset("assets/images/no_image_avilable.png",height: 120,width:120,),
                                              )

                                              // FadeInImage(
                                              //     image:
                                              //     NetworkImage(_All_Item[index]["small_icon"][position]),
                                              //     width: 34,
                                              //     height: 34,
                                              //     placeholder: AssetImage('assets/images/no_image_avilable.png'),
                                              //     fit: BoxFit.cover
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

                    ],
                  ),
                ),
              ),


            ],
          ),


          Row(
            children: <Widget>[
              Expanded(
                child: Divider(color: Color(0x80000000)),
              ),
            ],
          )
        ],
      ),
    );
  }



  Future<List?> _sendItemData_favorite(direction,id,index) async {

    setState(() {
      fav=1;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('lang');

    print(URL_LOGIC.favorit_unfavorit);
    Map<String, Object> body;
    body = {
      "lang":lang!,
      "action":"delete",
      "userid":idUsers!,
      "offer_id":id
    };


    print(body);
    // _All_Item.remove(index);

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
      if(datauser["code"].toString().trim()!=null){

        setState(() {
          _All_Item.removeAt(index);
        });

//        getRefrich();
      }
    });
    debugPrint(datauser.toString());
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        return   AlertDialog(
//          title: null,
//          content: Text(""+datauser["message"]),
//          actions: [
////            okButton,
//          ],
//        );
//      },
//    );

    // pr.hide().then((isHidden) {
    //   print(isHidden);
    // });


    return null;
  }

}