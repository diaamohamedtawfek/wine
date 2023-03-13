import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wineapp/backEndAndModels/connect_apis.dart';
import 'package:wineapp/backEndAndModels/model/DataAffiliates.dart';
import 'package:wineapp/backEndAndModels/model/DataCatigry.dart';
import 'package:wineapp/home/affiliates/commponentAffiletes/offersAffiletas.dart';
import 'package:wineapp/home/affiliates/favorite_affilet.dart';
import 'package:wineapp/lang/localization/set_localization.dart';
import 'package:wineapp/widgetApp/witting_shimmer_list.dart';

import '../CurvedClipper.dart';

class Affiliates extends StatefulWidget {
  const Affiliates({Key? key}) : super(key: key);

  @override
  _AffiliatesState createState() => _AffiliatesState();
}

class _AffiliatesState extends State<Affiliates> {

  FocusNode? searchBarFcous;
  TextEditingController serachField = TextEditingController();
  late ScrollController controller;
  String ?cat;

  @override
  void dispose() {
    if(searchBarFcous!=null){
      searchBarFcous?.dispose();
    }
  }
  double positionList=0;
  void _scrollListener() {
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
      getStringValuesSF();
    });
  }


  @override
  void initState() {
    super.initState();
    getStringValuesSF();

    controller = new ScrollController()..addListener(_scrollListener);

    Timer(
        Duration(milliseconds: 1),
            () async {

              setState(() {
                FocusManager.instance.primaryFocus?.unfocus();
                FocusScope.of(context).requestFocus(new FocusNode());
                searchBarFcous = FocusNode();
              });
        });

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
      getDataCatigryFROMBackEnd();


    });
  }

  Future<DataCatigry?>? getDataCatigry;
  getDataCatigryFROMBackEnd(){
    Map<String, dynamic> body = {
      "lang":langApp,
      "cat":"all"
      // "userid":idUser
    };


    getDataCatigry=ConnectApis.fetchDataCatigryElefent(body);
    getDataCatigry!.then((value)  {
      setState(() {
        getDataFROMBackEnd();
      });
    }).catchError((onError){
      getDataFROMBackEnd();
    });
  }


  Future<DataAffiliates?>? getDataAffiliates;
  int index_categry=0;
  getDataFROMBackEnd(){
    Map<String, dynamic> body = {
      "lang":langApp,
      "keyword":serachField.text.toString().trim(),
      "cat":cat==null?"all":cat,
      "userid":idUser
    };
    getDataAffiliates=ConnectApis.fetchDataAffiliates(body);
    getDataAffiliates!.then((value)  {
      setState(() {
      });
    });
  }



  Future getRefrich() async {
    getDataFROMBackEnd();
    // await Future.delayed(Duration(seconds: 3));
  }
  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
            // searchBarFcous.unfocus();
          },
          child:SafeArea(
          child: Scaffold(
            // *----------------      AppBar ----------------------------
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(105.0),
                  child: appBar()
              ),

              // floatingActionButton: FloatingActionButton(
              //   onPressed: () {
              //     // Add your onPressed code here!
              //     controller.jumpTo(0);
              //     setState(() {
              //       positionList=0;
              //     });
              //   },
              //   child:  Icon(Icons.navigation,color: Colors.white,),
              //   backgroundColor:Color(0xff00838f).withOpacity(.3),
              //   // backgroundColor:Colors.teal.shade200,
              // ),



              body:  RefreshIndicator(
                  onRefresh: getRefrich,
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  child:Container(
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*.75,
                      width: MediaQuery.of(context).size.width,
                    ),
                    ListView(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      controller:controller,
                      padding: EdgeInsets.only(
                          left: 15, right: 15, bottom: 5, top: 0
                      ),

                      children: <Widget>[
                        Stack(
                          children: [
                            // Container(
                            //   height: MediaQuery.of(context).size.height,
                            //   width: MediaQuery.of(context).size.width,
                            // ),

                            Column(
                              children: [
                                if(serachField.text.isEmpty)
                                futureBuilder_fetchCatagy3(),
                                SizedBox(height: 05,),
                                futureBuilder_fetchCaAffilets(),
                              ],
                            ),
                          ],
                        ),

                      ],
                    ),



                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: FloatingActionButton(
                      onPressed: () {
                        // Add your onPressed code here!
                        controller.jumpTo(0);
                        setState(() {
                          positionList=0;
                        });
                      },
                      child: const Icon(Icons.navigation,),
                      backgroundColor:Color(0xff00838f).withOpacity(.3),
                      // backgroundColor:Color(0xff00838f),
                    ),
                    )
                  ],
                ),
              )
              )

          )
      )
    );
  }



  Widget futureBuilder_fetchCatagy3() {
    return FutureBuilder<DataCatigry?>(
        future: getDataCatigry, // async work
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return
              Column(
                  children: [
                    Container(

                      // color: Colors.black,
                      child: new Container(
                        margin: EdgeInsets.all(0),
                        height: 100,
                        child:
                        new ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 3),
                          scrollDirection: Axis.horizontal,
//            itemCount: 15,
                          itemCount:snapshot.data?.categories?.length??0,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () =>
                              {
                                  setState(() {
                                    index_categry=index;
                                    cat=snapshot.data?.categories?[index].id;
                                    getDataFROMBackEnd();

                                  })
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
                                    padding: const EdgeInsets.only(
                                        left: 0.0, right: 0.0),
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
                                                          color: Color(
                                                              index_categry ==
                                                                  index
                                                                  ? 0xff00838f
                                                                  : 0x29000000),
                                                          offset: Offset(0, 3),
                                                          blurRadius: 6,
                                                          spreadRadius: 0
                                                      )
                                                      ],
                                                    ),
                                                    child: Container(
                                                        margin: index == 0
                                                            ? EdgeInsets.all(
                                                            14)
                                                            : EdgeInsets.all(
                                                            11),
                                                        height: 35, width: 35,
                                                        child: index == 0
                                                            ? Image.asset(
                                                          "assets/images/allc2.png",
                                                        )
                                                            :
                                                        CachedNetworkImage(
                                                          // height: 120,
                                                          // width:120,
                                                          fit: BoxFit.fill,
                                                          imageUrl: "${snapshot.data?.categories?[index].image}",
                                                          placeholder: (context,
                                                              url) =>
                                                              Container(),
                                                          errorWidget: (context,
                                                              url, error) =>
                                                              Image.asset(
                                                                "assets/images/no_image_avilable.png",
                                                                height: 120,
                                                                width: 120,),

                                                        )
                                                    ),
                                                  ),

                                                  SizedBox(height: 10,),


                                                  Flexible(child: Container(
                                                    // width: 67,
                                                      child: Center(
                                                        child: Text(
                                                          snapshot.data?.categories?[index].categoryName??"",
                                                          style: TextStyle(
                                                            fontFamily: 'SFProText',
                                                            color: Color(
                                                                index_categry ==
                                                                    index
                                                                    ? 0xff00838f
                                                                    : 0xff000000),
                                                            fontSize: 13,
                                                            // backgroundColor: Colors.redAccent,
                                                            fontWeight: FontWeight
                                                                .w400,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                          textAlign: TextAlign
                                                              .center,
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
                    ),
                  ]
              );
          } else if (snapshot.hasError) {
            return SizedBox(
            );
          }
          return Container();
        });
  }


  Widget futureBuilder_fetchCaAffilets() {
    return FutureBuilder<DataAffiliates?>(
        future: getDataAffiliates, // async work
        builder: (BuildContext context, snapshot) {
          if(snapshot.hasData ){
            return
              Column(
                  children: [
                    OffersAffilets(offers:snapshot.data!.affiliatesOffers!,),
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
              fontWeight: FontWeight.w400,
            ),
          )
      ),
    );
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: Color(0xFF00838f),
      shape: CurvedClipper(),

      actions: [
         IconButton(
            onPressed: () async{
            var x=await  Navigator.push(context, MaterialPageRoute(builder: (context) =>FAvoritAffilet()));
            if(x!=null){
              getStringValuesSF();
            }
            },
            icon: Icon(Icons.favorite,color: Colors.red,size: 30,),
        )
      ],

      flexibleSpace: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Container(
              // color: Colors.yellow,
              height: 43,
              // margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(top: 7, bottom: 0),
              alignment: Alignment.center,
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
                  child://قسائم الخصم والعروض
                 Center(
                   child:  Text(
                     SetLocalization.of(context)!.getTranslateValue('disSearch')!,
                     style: TextStyle(fontSize: 19,
                         fontWeight: FontWeight.w700,
                         color: Colors.white
                     ),
                     softWrap: false,
                     overflow: TextOverflow.ellipsis,
                     textAlign: TextAlign.start,

                   ),
                 )

                ),
              ),
            ),




            Directionality(textDirection: TextDirection.ltr,
                child: Container(
                  width: 260,
                  height: 40,
                  margin: EdgeInsets.only(bottom: 0,top: 5),
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
                          setState(() {
                            getDataAffiliates=null;
                          });
                          setState(() {
                            positionList=0;
                          });
                          getDataFROMBackEnd();
                        } else if (value.length == 0) {
                          print(value + ">>>>>");
                          try {
                            setState(() {
                              // getDataSearch=null;
                              positionList=0;
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
                        ):IconButton(
                          onPressed: (){
                          setState(() {
                            serachField.text="";
                            getDataFROMBackEnd();
                          });
                        }, icon: Icon(
                            Icons.cancel_outlined,
                            color: Color(0xffb5b5b5),
                          ),
                        ),
                        hintText: SetLocalization.of(context)!
                            .getTranslateValue('Search'),
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
