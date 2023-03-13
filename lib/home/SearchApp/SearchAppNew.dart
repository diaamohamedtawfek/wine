import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wineapp/backEndAndModels/connect_apis.dart';
import 'package:wineapp/backEndAndModels/model/DataSearchApp.dart';
import 'package:wineapp/home/SearchApp/commponentSearchApp/offersSearch.dart';
import 'package:wineapp/home/SearchApp/commponentSearchApp/otherOffersSearch.dart';
import 'package:wineapp/lang/localization/set_localization.dart';
import 'package:wineapp/widgetApp/witting_shimmer_list.dart';

import '../CurvedClipper.dart';

class SearchAppNew extends StatefulWidget{
  final String? idLcation;
  final String? nameLcation;

  const SearchAppNew({Key? key, this.idLcation, this.nameLcation}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UnSearchApp();
  }
}

class UnSearchApp extends State<SearchAppNew> {

  FocusNode? searchBarFcous;
  TextEditingController serachField = TextEditingController();
  @override
  void dispose() {
    if(searchBarFcous!=null){
      searchBarFcous?.dispose();
    }
    super.dispose();
  }
  @override
  void initState() {
    super.initState();

    getStringValuesSF();
  }

  String? langApp;
  String? idUser;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('lang');
    String? userid = prefs.getString('userid');
    print("idUser=> "+lang.toString());
    setState(() {
      langApp=lang;
      idUser=userid;

    });
  }



  Future<DataSearchApp?>? getDataSearch;
  getDataFROMBackEnd(){

    Map<String, dynamic> body = {
      "lang":langApp,
      "locationid":widget.idLcation,
      "keyword":serachField.text.toString().trim(),
      "userid":idUser
    };


    getDataSearch=ConnectApis.fetchDataSearch(body);
    getDataSearch!.then((value)  {
      setState(() {
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    return
      SafeArea(
          child: Scaffold(

            // *----------------      AppBar ----------------------------
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(105.0),
                  child: appBar()
              ),



              body: Container(
                child: ListView(
                  padding: EdgeInsets.only(
                      left: 15, right: 15, bottom: 5, top: 12
                  ),

                  children: <Widget>[

                    serachField.text.toString().length>0?
                    futureBuilder_fetchCatagy():
                        Container()

                  ],
                ),
              )

          )
      );
  }





  Widget futureBuilder_fetchCatagy() {
    return FutureBuilder<DataSearchApp?>(
        future: getDataSearch, // async work
        builder: (BuildContext context, snapshot) {
          if(snapshot.hasData ){
            if(snapshot.data!.offers!.isEmpty&&snapshot.data!.other!.isEmpty){
              return notFoundStore(SetLocalization.of(context)!.getTranslateValue('otherLocations2')!,null,null);
            }else{
              return
                Column(
                    children: [

                      OffersSerach(offers:snapshot.data!.offers!,idLcation: widget.idLcation!,),

                      SizedBox(height: 22,),

                      if(snapshot.data!.other==null||snapshot.data!.other!.isNotEmpty)
                        notFoundStore(SetLocalization.of(context)!.getTranslateValue('otherLocations')!,true,FontWeight.w700),


                      snapshot.data!.other!.isEmpty? Container():
                      OtherOffersSearch(offers: snapshot.data!.other!, idLcation: widget.idLcation!),


                    ]
                );
            }

          }else if(snapshot.hasError){
            return  Scaffold(
              body:  SizedBox(
                child: Center(child:  notFoundStore("Error Data",null,null)),
              ) ,
            );
          }
          return  WitingShimmerList();
        });
  }






  Widget notFoundStore(text,under,fontWeight){
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
              fontWeight: fontWeight!=null?FontWeight.w700:FontWeight.w400,
              decoration: under!=null?TextDecoration.underline:null,
              decorationColor: Color(0xff00838f)
            ),
          )
      ),
    );
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: Color(0xFF00838f),
      shape: CurvedClipper(),

      flexibleSpace: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[


            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 14, bottom: 6),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                },

                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: 260,
                      minWidth: 100
                  ),
                  // width: MediaQuery.of(context).size.width/1.4,
                  child:
                    // Text(
                    //   SetLocalization.of(context)!.getTranslateValue('disSearch')!,
                    //         style: TextStyle(fontSize: 15,
                    //             color: Colors.white),
                    //         softWrap: false,
                    //         overflow: TextOverflow.ellipsis,
                    //         textAlign: TextAlign.start,
                    //
                    //       )
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 22,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Flexible(
                        // fit:FlexFit.loose,
                          child: Text(
                            widget.nameLcation!,
                            style: TextStyle(fontSize: 15,
                                color: Colors.white),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,

                          )
                      ),

                      SizedBox(
                        width: 4,
                      ),
                      // Image.asset(
                      //   'assets/images/icon_down.png',
                      //   height: 8,
                      //   width: 15,
                      // )
                    ],
                  ),
                ),
              ),
            ),


            Directionality(textDirection: TextDirection.ltr,
                child: Container(
                  width: 260,
                  height: 40,
                  decoration: BoxDecoration(
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
                    color: Colors.white,
                  ),
                  child: InkWell(
                    child: TextField(
                      textInputAction: TextInputAction.send,
                      autofocus: true,
                      enabled: true,
                      controller: serachField,
                      onSubmitted: (_) =>
                      {
                        FocusScope.of(context).unfocus(),
                      },
                      focusNode: searchBarFcous,
                      onTap: () {
                        searchBarFcous?.requestFocus();
                      },


                      onChanged: (value) async {
                        if (value.length >= 0) {
                          getDataFROMBackEnd();
                        } else if (value.length == 0) {
                          print(value + ">>>>>");
                          try {
                            setState(() {
                              getDataSearch=null;
                            });

                          } catch (r) {}
                        }
                      },
                      style: TextStyle(
                          fontSize: 13, color: Color(0xffb5b5b5)),
                      textAlign: langApp == 'en' ? TextAlign
                          .center : TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(
                            44, 8, 0, 0),
                        prefixIcon:
                        serachField.text.toString().length==0?
                        Icon(
                          Icons.search,
                          color: Color(0xffb5b5b5),
                        ):IconButton(onPressed: (){
                          setState(() {
                            serachField.text="";
                          });
                        }, icon: Icon(
                          Icons.cancel_outlined,
                          color: Color(0xffb5b5b5),
                        )),
                        hintText: SetLocalization.of(context)!
                            .getTranslateValue('SearchStore'),
                        // hintText: SetLocalization.of(context).getTranslateValue('search_bar'),
                        hintStyle: TextStyle(fontSize: 13,
                            color: Color(0xffb5b5b5)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),

    );
  }
}