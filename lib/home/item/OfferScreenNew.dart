import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wineapp/backEndAndModels/connect_apis.dart';
import 'package:wineapp/backEndAndModels/model/DataDetilesItem.dart';
import 'package:wineapp/lang/localization/set_localization.dart';
import 'package:wineapp/startApp/Login.dart';
import 'package:wineapp/widgetApp/witting_shimmer_list.dart';

class OfferScreenNew extends StatefulWidget {

  final String? offerID;
  final String? offerName;
  final String? offerFavorite;
  final String? locationid_mal;

  final String? id_Catigry;
  final String? id_SubCatrgry;
  final String? cat_id;


  final String? direction;
  final int? indexrow;

  final String? trending;

  OfferScreenNew({Key? key, this.offerID, this.offerName, this.offerFavorite, this.locationid_mal,
    this.id_Catigry, this.id_SubCatrgry, this.cat_id, this.direction, this.indexrow, this.trending}) : super(key: key);

  @override
  _OfferScreenNewState createState() => _OfferScreenNewState();
}

class _OfferScreenNewState extends State<OfferScreenNew> {
  int? itemFavortOrNot;

  Future<DataDetilesItem?>? getDataDetilesItem;

  @override
  void initState() {
    super.initState();

    getStringValuesSF();
  }

  String? langApp;
  String? idUsers;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('lang');
    String? userid = prefs.getString('userid');
    print("idUser=> "+lang.toString());
    setState(() {
      langApp=lang;
      idUsers=userid;
      getData_Item();
    });
  }


  getData_Item(){

    Map<String, Object> body;
    if(widget.direction=="related_id"){
      body ={
        "lang":langApp!,
        "userid":"$idUsers",
        "offer_id":widget.offerID!,
        "locationid":widget.locationid_mal!,
        "cat_id":widget.cat_id.toString() == "all"?"" : widget.cat_id.toString() ,
        "related_id":widget.trending! ,
        // "main_id":widget.id_Catigry.toString() == "all"?null : widget.id_Catigry.toString() ,
        // "sub_id":widget.id_SubCatrgry,
      };
    }else{
      body ={
        "lang":langApp!,
        "userid":"$idUsers",
        "offer_id":widget.offerID!,
        "locationid":widget.locationid_mal!,
        "cat_id":widget.cat_id.toString() == "all" ? "null" : widget.cat_id.toString() ,
        "trending_id":"${widget.trending}" ,
        // "main_id":widget.id_Catigry.toString() == "all"?null : widget.id_Catigry.toString() ,
        // "sub_id":widget.id_SubCatrgry,
      };
    }

    print(body.toString());

    getDataDetilesItem=ConnectApis.fetchDataDetailesItem(body);
    getDataDetilesItem!.then((value)  {
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, {
          "index": widget.indexrow,
          "favorit": itemFavortOrNot,
          "directio": widget.direction
        });
        return false;
      },
      child:

      Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff00838f),
          centerTitle: true,
          title: Text(widget.offerName!,
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),),
          actions: <Widget>[
            FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  if (idUsers != null) {
                    // if (data_Item!["main"][1]["info"][0]["favorite"]
                    //     .toString() == '1') {
                    //   _sendItemData_favorite("un_fav", widget.offerID, 0);
                    // } else {
                    //   _sendItemData_favorite("fav", widget.offerID, 0);
                    // }
                  } else {
                    sign_in(context);
                  }
                },
                child: Icon(
                  // data_Item!["main"][1]["info"][0]["favorite"] == '1' ? Icons.favorite :
                  Icons.favorite_border, color: Colors.white,)

            )
          ],
        ),


        body: futureBuilder_fetchCatagy()
      ),
    );
  }


  Widget futureBuilder_fetchCatagy() {
    return FutureBuilder<DataDetilesItem?>(
        future: getDataDetilesItem, // async work
        builder: (BuildContext context, snapshot) {
          if(snapshot.hasData ){
            return
              Column(
                  children: [



                  ]
              );
          }else if(snapshot.hasError){
            return  Scaffold(
              body:  SizedBox(
                child: Center(child:  notFoundStore("Error Data")),
              ) ,
            );
          }
          return  WitingShimmerList();
        });
  }

  Widget notFoundStore(text){
    return Container(
      padding: EdgeInsets.only(
          bottom: 10
      ),
      child:
      Center(
          child: Text(
            text
            ,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          )
      ),
    );
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
                  child: Text(SetLocalization.of(context)!.getTranslateValue('sign_in')!,
                    style: TextStyle(
                        color: Color(0xff00838f)
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
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

}
