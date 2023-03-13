import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wineapp/SherdRefreanseAllApp/SherdRefreanseAllApp.dart';
import 'package:wineapp/home/EventsScreen/EventsScreen.dart';
import 'package:wineapp/home/HomwWithOutNet/DrawerNewHome.dart';
import 'package:wineapp/home/HomwWithOutNet/OfferScreenWithOutNet.dart';
import 'package:wineapp/home/HomwWithOutNet/dilogAoo/DilogApp.dart';
import 'package:wineapp/lang/localization/set_localization.dart';

import '../CurvedClipper.dart';

class HomwWithOutNet extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiHomwWithOutNet();
  }
}

class UiHomwWithOutNet  extends State<HomwWithOutNet>{


  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late ScrollController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //  * _scrollListener
    controller = new ScrollController()..addListener(_scrollListener);

    getStringValuesSF();
    getNmaeMaleFromSerd();
    getAllEvents();
    getData_Slider();
    getData_defultFiltter();
    getData_MainCatigry();
    getData_allOffer();

  }

  double positionList=0;
  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      startLoader();
    }

    // print(MediaQuery.of(context).size.height);
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
      _onLoading();
    });
  }

  bool isrefrech=false;

  void _onLoading() async{
    // print("_refreshController");
    // if(directionPajenation=="offers"){
    //   getData_allOffer(id_location_id,idCategry,"categry",numpage);
    // }else{
    //   setState(() {
    //     _All_allOffer_testdata = null;
    //   });
    //   getData_allOffer_FromFiltter(id_location_id, "sss");
    // }
    // await Future.delayed(Duration(milliseconds: 1000));
    //await client.getMain(position.latitude.toString(),position.longitude.toString(),myLocale.languageCode,session: PreferenceUtils.getUserSessionID(), email: PreferenceUtils.getUserEmail()).then((value) => {
    // _refreshController.loadComplete();
  }

  Future getRefrich() async {
    // setState(() {
    //   numpage=1;
    // });
    //
    // if(data_defultLocation!.isNotEmpty){
    //   data_defultLocation!.clear;
    // }
    // getData_Slider(id_location_id,"filtter");
    // // getData_Slider(changeCity_And_defoultMAl[0]["idMal"]);
    //
    // print("index_SubCategy $index_SubCategy");
    // print("filtterChoce $filtterChoce");
    // if(index_SubCategy!=null){
    //   if(_All_allOffer!.isNotEmpty){
    //     _All_allOffer!.clear();
    //     _All_allOffer_old!.clear();
    //     data_allOffer!.clear();
    //   }
    //   print("index_SubCategy $index_SubCategy");
    //   print("index_SubCategy $filtterChoce");
    //
    //   setState(() {
    //     _All_allOffer_testdata = null;
    //   });
    //   getData_allOffer_FromFiltter(id_location_id,"test");
    //
    // }else if(filtterChoce!=null){
    //   if(_All_allOffer!.isNotEmpty){
    //     _All_allOffer!.clear();
    //     _All_allOffer_old!.clear();
    //     data_allOffer!.clear();
    //   }
    //   print("index_SubCategy $index_SubCategy");
    //   print("index_SubCategy $filtterChoce");
    //
    //   setState(() {
    //     _All_allOffer_testdata = null;
    //   });
    //   getData_allOffer_FromFiltter(id_location_id,"test");
    //
    // }else{
    //   getData_MainCatigry(id_location_id,"re","");
    // }

    isrefrech=true;

    // await Future.delayed(Duration(seconds: 3));
  }

  String? langApp;
  String? idUser;
  // bool showStartImage=true;
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




  String nameMale="";

  getNmaeMaleFromSerd(){
    getNameeMole_SherdRefreanse(context).then((value) {
      setState(() {
        nameMale=value.toString();
      });
    });
  }



  List _All_event=[];
  String allEnectSherd="";
  int viewEvent=0;
  bool serviceWatched=false;
  getAllEvents(){
    getAllEvent(context).then((value) {
      setState(() {
        allEnectSherd=value.toString();
        print(">>>>>>>>>>>> ${json.decode(allEnectSherd)}");

       Map data_event_mal = json.decode(allEnectSherd);
        setState(() {
          if(data_event_mal["main"]!=null){
            setState(() {
              serviceWatched=true;
              viewEvent=0;
              // _All_event.addAll(data_event_mal["main"][0]["events"]);
              _All_event.addAll(data_event_mal["main"]);
            });
          }else{
            setState(() {
              viewEvent=1;
              serviceWatched=false;
            });
          }
        });


      });
    });
  }



  // * All Slider
  Map? data_offer;
  List _All_Slider = [];
  bool showSlider = true;
  late List<Widget> pages=[];
  // List<Widget> pages = List<Widget>();
  var controlleree = PageController(initialPage: 0);
  addDataIntoSlider(){

    setState(() {
      for (var i = 0; i < _All_Slider.length; i++)
        print("i>>>>>>>>>"+ _All_Slider[i]["offer_img"]);
    });
    setState(() {
      for (var i = 0; i < _All_Slider.length; i++)
        pages.add(
            Container(
                height: 100,
                child: InkWell(
                    onTap: (){
                      print("Slider Image ");
                      // Navigator
                      //     .push(context, MaterialPageRoute(builder: (context) => OfferScreen(
                      //   offerID: _All_Slider[i]["trending_offer"].toString(),
                      //   offerName:_All_Slider[i]["trending_name"],
                      //   locationid_mal: id_location_id!.toString(),
                      //   id_Catigry: idCategry!.toString(),
                      //   id_SubCatrgry: index_SubCategy_id.toString(),
                      //   cat_id: index_categryAnd_SupCatigru!.toString(),
                      //   trending: _All_Slider[i]["trending_id"].toString(),
                      //   // offerFavorite:  _All_Slider[i]["favorite"]==null?null: _All_Slider[i]["favorite"],
                      // )));
                    },
                    child: Stack(
                      children: <Widget>[

                        Container(
                          height: 100,
                          decoration: new BoxDecoration(
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(0),
                          ),

                          child: Stack(
                            children: [
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    // SizedBox(width: 5,),
                                    //Image offer
                                    Container(
//                              height: 120,
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 2,
                                            offset: Offset(0, 2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: FadeInImage.assetNetwork(
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.fill,
                                        placeholder: 'assets/images/logo2.png',
                                        image:  _All_Slider[i]["offer_img"],
                                      ),
                                    ),
                                    SizedBox(width: 5,),

                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
//                                  crossAxisAlignment: WrapCrossAlignment.start,
//                                  direction: Axis.vertical,
                                          children: [

                                            // SizedBox(height: 10,),
                                            Text(
                                              "${_All_Slider[i]["trending_name"].toString().replaceAll("\n", "ضسا")}",
                                              style: const TextStyle(
                                                  color: const Color(0xff000000),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "SFProText",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 15.0
                                              ),
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),

                                            SizedBox(height: 5,),


                                            Text(
                                              "${_All_Slider[i]["offer_description"].toString().replaceAll("[&line;]", "\n")}"
                                              ,
                                              style: const TextStyle(
                                                  color: const Color(0xff9b9b9b),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "SFProText",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 12.0
                                              ),
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                            // SizedBox(height: 10,),
                                          ],
                                        )
                                    ),

                                  ]
                              ),



                              Container(
                                padding: EdgeInsets.only(left: 15,right: 7,),
                                child:
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(width: 1,),

                                        Row(
                                          children: List.generate(_All_Slider[i]["small_icon"]==null?0:_All_Slider[i]["small_icon"].length, (index) {
                                            return Row(
                                              children: [
                                                Container(
                                                  height: 27, width: 27,

                                                  margin: EdgeInsets.only(left: 1,right: 1),
                                                  // padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    // color: Colors.cyan
                                                  ),
                                                  child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(25.0),
                                                          child:
                                                          FadeInImage(
                                                            image:
                                                            NetworkImage(_All_Slider[i]["small_icon"][index])
                                                            ,
                                                            height: 27, width: 27,
                                                            placeholder: AssetImage('assets/images/no_image_avilable.png'),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        )
                                                      ]
                                                  ),
                                                ),

                                              ],
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1,),


                                  ],
                                ) ,
                              ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    )
                )
            )
        );
    });




    setState(() {
      _currentPage=0;
    });

    setState(() {
      timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
        if (_currentPage < _All_Slider.length-1)
          // if (_currentPage < widget.events[0].eventsImg.length)
            {
          // try{
          //   setState(() {
          //     _currentPage++;
          //   });
          // }catch(e){
          //
          // }


        } else {
          //   try{
          //   setState(() {
          //   _currentPage = 0;
          //   });
          // }catch(e){
          //
          // }

        }

        try {
          controlleree.animateToPage(_currentPage,
            duration: Duration(milliseconds: 1350),
            curve: Curves.easeIn,
          );
        }catch(e){

        }
      });
    });

  }

  Timer? timer;
  int _currentPage = 0;
  Future getData_Slider() async {

    getAllSlider(context).then((value){
      setState(()  {
        data_offer = json.decode(value.toString());
        print(data_offer.toString()+">>>>>> Slider");

        try{
          if(data_offer!["trending_offers"][0]["trending_id"]!=null){
            setState(() {
              _All_Slider.addAll(data_offer!["trending_offers"]);
              print(_All_Slider.length);
              showSlider=true;

              addDataIntoSlider();
            });

          }else{
            showSlider=true;
          }


        }catch(e){

        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        return onWillPop(context);
        // searchBarFcous!.unfocus();
        // print(_scaffoldKey.currentState!.isDrawerOpen);
        // if (_scaffoldKey.currentState!.isDrawerOpen) {
        //   print("?>>>>>>>>>>>>>>>>>");
        //   print("object");
        //   // return true;
        //   return popup(context);
        // } else {
        //   print("onWillPop");
        //   return onWillPop(context);
        // }
      },
      child:

      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
          // searchBarFcous.unfocus();
        },
        child: Stack(
          children: [
            SafeArea(
                bottom: false,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  key: _scaffoldKey,

                  drawer: DrawerWithOutNet(),





                  appBar: PreferredSize(
                      preferredSize: Size.fromHeight(105.0),
                      child: AppBar(
                        backgroundColor: Color(0xFF00838f),
                        shape: CurvedClipper(),
                        actions: <Widget>[
                          Container(
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsetsDirectional.only(top: 15, end: 15, start: 0, bottom: 0),
                                  child:

                                  // to go to EventsScreen
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      print(_All_event.toString());
                                      if(_All_event!=null && _All_event.isNotEmpty){
                                        print("_All_event :> "+_All_event.toString());
                                        setState(() {
                                          viewEvent=1;
                                        });
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => EventsScreen(events:_All_event ,nameMAl: nameMale.toString(),)));

                                      }else{
                                        try{

                                          // TipDialogHelper.fail(SetLocalization.of(context)!.getTranslateValue('NoEventsavailablerightnow'));
                                        }catch(e){}

                                      }
                                    },
                                    child: Container(
                                      width: 43,
                                      padding: EdgeInsets.all(0.0),
                                      child: Image.asset(
                                        'assets/images/event_and_services_icon.png',
                                        height: 27,
                                        width: 27,
                                      ),
                                    ),
                                  ),
                                ),

                                Visibility(
                                  visible: serviceWatched==true && viewEvent==0, //serviceWatched,
                                  child: Positioned(
                                    left: langApp == 'en' ? 28 : null,
                                    right: langApp == 'en' ? null : 28,
                                    top: 16,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: EdgeInsets.all(1),
                                        decoration: new BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        constraints: BoxConstraints(
                                          minWidth: 7,
                                          minHeight: 7,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],

                            ),
                          ),
                        ],

                        flexibleSpace: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[


                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(top: 14, bottom: 7),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                                  onTap: () async {
                                    DilogApp.sign_in(context);
                                  },

                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 260,
                                        minWidth:100
                                    ),
                                    // width: MediaQuery.of(context).size.width/1.4,
                                    child: Row(
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
                                          child:
                                          Text(
//                            truncateWithEllipsis(20,cityName),
                                            nameMale==null?"   "  :
                                            // location_name_default.toString().length>25?location_name_default.toString().substring(0,23)+"..":
                                            nameMale.toString()
                                            ,
                                            style: TextStyle(fontSize: 19, color: Colors.white),
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,

                                          ),
                                        ),



                                        SizedBox(
                                          width: 4,
                                        ),
                                        Image.asset(
                                          'assets/images/icon_down.png',
                                          height: 8,
                                          width: 15,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),


                              InkWell(
                                  onTap: ()=>{
                                  DilogApp.sign_in(context)
                                    //location_name_default,id_location_id
                                    // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>SearchApp(
                                    //   nameLcation: location_name_default.toString(),
                                    //   idLcation: id_location_id.toString(),
                                    // )))
                                  },

                                  child:  Directionality(
                                      textDirection: TextDirection.ltr,
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
                                        child:TextField(
                                          enabled: false,
                                          // controller: serachField,
                                          // textAlignVertical: TextAlignVertical.center,
                                          onSubmitted: (_) => {
                                            FocusScope.of(context).unfocus(),

                                          },
                                          // focusNode: searchBarFcous,
                                          onTap: () {
                                            // searchBarFcous!.requestFocus();
                                          },
                                          onChanged: (value) async {
                                            if (value.length >= 0) {
                                              // _filterCountries(value);
                                            } else {

                                            }
                                          },
                                          style: TextStyle(fontSize: 13, color: Color(0xffb5b5b5)),
                                          textAlign: langApp == 'en' ? TextAlign.center : TextAlign.center,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(44, 4, 0, 0),
                                            prefixIcon: Icon(
                                              Icons.search,
                                              size: 22,
                                              color: Color(0xffb5b5b5),
                                            ),
                                            hintText:  SetLocalization.of(context)!.getTranslateValue('SearchStore'),
                                            // hintText: SetLocalization.of(context).getTranslateValue('search_bar'),
                                            hintStyle: TextStyle(fontSize: 15, color: Color(0xffb5b5b5)),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      )
                                  )
                              ),
                            ],
                          ),
                        ),

                      )
                  ),











                  body:

                  // *& ??????????????\

                  RefreshIndicator(
                    onRefresh: getRefrich,
                    color: Colors.white,
                    backgroundColor: Colors.black,
                    child:SingleChildScrollView(
                        // controller: controller,
                        child:

                        bodyApp()
                    ),
                  ),

                )
            ),
          ],
        ),
      ),
    );
  }


  Widget bodyApp(){
    return  Container(

      // color: Colors.black38,
      child: ListView(
        padding: EdgeInsets.only(
            left: 15,right: 15,bottom: 5
        ),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [

          Visibility(
              visible: _All_Slider.isEmpty?false:true,
              child:  sliderOffers()
          ),

          SizedBox(height: 0,),


          // //اسويتش العروض النشطه والغير نشطه
          Visibility(
            visible: true,
            child:Center(
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(

                      // SetLocalization.of(context).getTranslateValue('numOfferNotActive')+"$numOfferNotActive"+
                      SetLocalization.of(context)!.getTranslateValue('ShowOffersOnly')!
                      ,
                      style: TextStyle(fontSize: 16,
                          color: Colors.black38
                      ),
                      textAlign: TextAlign.center,
                    ),


                    Switch(

                      onChanged: (val) {
                        DilogApp.sign_in(context);
                      },
                      value:  false,
                      activeTrackColor: Color(0x3D00838f),
                      activeColor: Color(0xff00838f),
                    )
                  ],
                )


            ),
          ),



          SizedBox(height: 0,),

          Container(
            // color: Colors.blue,
            child: categryFiltter(),
          ),


          _All_mainCatigry.isEmpty ? Text("") :
          CtigryMain_List(),
          //
          SizedBox(height: 2,),

          Visibility(
              visible:index_categry==0?true:false,
              child:  SizedBox(height: 15,)
          ),

          // _All_allOffer.isEmpty ?
          Stack(
            children: [

              Visibility(
                visible: _All_allOffer!.isNotEmpty?true:false,
                // true,
                // visible: !isListLoading,
                replacement: Container(
                  child: Center(child: Text("")),
                  // child: Center(child: CircularProgressIndicator()),
                ),
                child:  Container(

                  // height: MediaQuery.of(context).size.height/2,
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _All_allOffer==null ? 0 : _All_allOffer!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onTap: () async {

                            print(_All_allOffer![index]);


                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OfferScreenWithOutNet(
                                        indexRow: _All_allOffer![index] ,
                                      ),
                                    ));

                            // var result = await  Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => OfferScreen(
                            //         offerID: _All_allOffer![index]["id"].toString(),
                            //         offerName: _All_allOffer![index]["name"],
                            //         offerFavorite:  _All_allOffer![index]["favorite"].toString(),
                            //         locationid_mal: id_location_id.toString(),
                            //         id_Catigry: idCategry.toString(),
                            //         id_SubCatrgry: index_SubCategy_id.toString(),
                            //         cat_id: index_categryAnd_SupCatigru.toString(),
                            //         direction: "offer",
                            //         indexrow: index,
                            //       ),
                            //     ));
                            // print(result.toString());
                            // print(result.toString());
                            // if(result!=null){
                            //   setState(() {
                            //     serachField.text="";
                            //     // _filterCountries("");
                            //   });
                            //   print("Back offer to home : >>>>>>>>>>>>>>  $result");
                            //   if(result["favorit"]!=null&& result["directio"]=="offer"){
                            //     setState(() {
                            //       _All_allOffer![int.parse(result["index"].toString())]["favorite"]=result["favorit"].toString();
                            //     });
                            //   }
                            //   // _onRefresh();
                            // }
                          },
                          child: _getOffers(context, index,_All_allOffer!.length)

                      );

                    },
                  ),
                ),

              ),

              Visibility(
                visible:_All_allOffer==null|| _All_allOffer!.isEmpty?true:false,
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/4),
                  child:
                  _All_allOffer_testdata==null?Center(child:  CircularProgressIndicator(backgroundColor: Color(0x2900838f),
                    valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff00838f)),
                  ),):
                  Center(child: Text(SetLocalization.of(context)!.getTranslateValue('no_offer')!, style: TextStyle(
                    fontSize: 20,
                  ), textAlign: TextAlign.center,)),
                ),
              )
            ],
          ),

          Container(

            height:_All_allOffer!.length<5?MediaQuery.of(context).size.height/3:1,
          )
        ],
      ),
    );
  }

  Widget sliderOffers() {
    return Column(
        children: [

          InkWell(
            onTap: () =>
            {
              setState(() {
                showSlider = !showSlider;
                print(showSlider);
              }),
            },
            child:
            Container(
              // color: Colors.cyan,
                height: 35,
                padding: EdgeInsets.only(left: 0,right: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        SetLocalization.of(context)!.getTranslateValue('trending')!,
                        style: TextStyle(fontSize: 19),
                        textAlign: TextAlign.left
                    ),

                    Icon(showSlider == true ? Icons.keyboard_arrow_up : Icons
                        .keyboard_arrow_down,
                      size: 30,
                      color: Colors.black,
                    ),
                  ],
                )
            ),
          ),

          SizedBox(height: 0,),

          Visibility(
            visible: showSlider,
            child: Container(
              margin: EdgeInsets.all(0),
              height: 120,
              decoration: new BoxDecoration(
                // color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [BoxShadow(
                    color: Color(0x0a000000),
                    offset: Offset(0, 8),
                    blurRadius: 12,
                    spreadRadius: 0
                )
                ],
              ),
              child:
              _All_Slider.isEmpty ?
              Center(child: Text(
                  SetLocalization.of(context)!.getTranslateValue("no_offer")!),)
                  :
              sliderOffer(),

            ),
          ),

          Visibility(
              visible: showSlider,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _All_Slider.map((url) {
                  int index = _All_Slider.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //0xff00838f :0x29000000
                      color:
                      _current==index
                      // _currentPage == index
                          ? Color(0xff00838f)
                          : Color(0x2900838f),
                      // ? Color.fromRGBO(0, 0, 0, 0.9)
                      //   : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList(),
              ))

        ]

    );
  }

  int _current=0;

  // slider move
  Widget sliderOffer() {
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: showSlider,
      child: CarouselSlider(
        options: CarouselOptions(
          viewportFraction: 1.0,// max height
          autoPlay: true,
          enlargeCenterPage: true,
          height: 100,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(milliseconds: 1000),
          scrollDirection: Axis.horizontal,
          enableInfiniteScroll: true,
          reverse: true,
          onPageChanged: (index, reason) {
            setState(() {
              _current=index;
            });
          },
        ),
        carouselController: CarouselControllerImpl(
        ),

        items: <Widget>[
          for (var i = 0; i < _All_Slider.length; i++)
            InkWell(
                onTap: (){
                  print(_All_Slider[i]);

                  Navigator
                      .push(context, MaterialPageRoute(builder: (context) => OfferScreenWithOutNet(
                    indexRow: _All_Slider[i],
                  )));

                  // Navigator
                  //     .push(context, MaterialPageRoute(builder: (context) => OfferScreen(
                  //   offerID: _All_Slider[i]["trending_offer"].toString(),
                  //   offerName:_All_Slider[i]["trending_name"],
                  //   locationid_mal: id_location_id.toString(),
                  //   id_Catigry: idCategry.toString(),
                  //   id_SubCatrgry: index_SubCategy_id.toString(),
                  //   cat_id: index_categryAnd_SupCatigru.toString(),
                  //   trending: _All_Slider[i]["trending_id"].toString(),
                  //   // offerFavorite:  _All_Slider[i]["favorite"]==null?null: _All_Slider[i]["favorite"],
                  // )));
                },
                child: Stack(
                  children: <Widget>[

                    Container(
                      decoration: new BoxDecoration(
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(0),
                      ),

                      child: Stack(
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                //Image offer
                                Container(
//                              height: 120,
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(0, 2), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child:
                                    CachedNetworkImage(
                                      height: 120,
                                      width:120,
                                      fit: BoxFit.fill,
                                      imageUrl: "${_All_Slider[i]["offer_img"]}",
                                      placeholder: (context, url) => Container(),
                                      errorWidget: (context, url, error) => Image.asset("assets/images/no_image_avilable.png",height: 120,width:120,),
                                    )
                                  // FadeInImage.assetNetwork(
                                  //   width: 120,
                                  //   height: 120,
                                  //   imageErrorBuilder:
                                  //       (context, error, stackTrace) {
                                  //     return Image.asset(
                                  //         'assets/images/logo2.png',
                                  //         fit: BoxFit.fitWidth);
                                  //   },
                                  //   fit: BoxFit.fill,
                                  //   placeholder: 'assets/images/logo2.png',
                                  //   image:  _All_Slider[i]["offer_img"],
                                  // ),
                                ),
                                SizedBox(width: 5,),

                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${_All_Slider[i]["trending_name"].toString().replaceAll("[&line;]", "\n").trim()}",
                                          style: const TextStyle(
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "SFProText",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.0
                                          ),
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),

                                        SizedBox(height: 5,),


                                        Text(
                                          "${_All_Slider[i]["offer_description"].toString().replaceAll("[&line;]", "\n").trim()}"
                                          ,
                                          style: const TextStyle(
                                              color: const Color(0xff9b9b9b),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "SFProText",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.0
                                          ),
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                        // SizedBox(height: 10,),
                                      ],
                                    )
                                ),

                              ]
                          ),

                          // Expanded(
                          //   child:
                          Container(
                            padding: EdgeInsets.only(left: 15,right: 7,),
                            child:
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(width: 1,),
                                    _All_Slider[i]["small_icon"]==null?Container() :
                                    Row(
                                      children: List.generate(_All_Slider[i]["small_icon"].toString()=="null"?0 :_All_Slider[i]["small_icon"]==null?0 :
                                      _All_Slider[i]["small_icon"].length, (index) {
                                        return Row(
                                          children: [
                                            Container(
                                              height: 27, width: 27,

                                              margin: EdgeInsets.only(left: 1,right: 1),
                                              // padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                // color: Colors.cyan
                                              ),
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius: BorderRadius.circular(25.0),
                                                        child: CachedNetworkImage(
                                                          height: 27,
                                                          width:27,
                                                          fit: BoxFit.fill,
                                                          imageUrl: "${_All_Slider[i]["small_icon"][index]}",
                                                          placeholder: (context, url) => Container(),
                                                          errorWidget: (context, url, error) => Image.asset("assets/images/no_image_avilable.png",height: 120,width:120,),
                                                        )
                                                      // FadeInImage(
                                                      //   image:
                                                      //   NetworkImage(_All_Slider[i]["small_icon"][index])
                                                      //   ,
                                                      //   height: 27, width: 27,
                                                      //   placeholder: AssetImage('assets/images/no_image_avilable.png'),
                                                      //   fit: BoxFit.fill,
                                                      // ),
                                                    )
                                                  ]
                                              ),
                                            ),

                                          ],
                                        );
                                      }),
                                    ),
                                  ],
                                ),

                                // SizedBox(height: 10,),
                                // InkWell(
                                //   // onTap: (){
                                //   //   print("Slider Image button ");
                                //   //   Navigator
                                //   //       .push(context, MaterialPageRoute(builder: (context) => OfferScreen(
                                //   //     offerID: _All_Slider[i]["trending_offer"].toString(),
                                //   //     offerName:_All_Slider[i]["trending_name"],
                                //   //     // offerFavorite:  _All_Slider[i]["favorite"]==null?null: _All_Slider[i]["favorite"],
                                //   //   )));
                                //   //   // MaterialPageRoute(
                                //   //   //   builder: (context) => OfferScreen(
                                //   //   //     offerID: _All_Slider[i]["trending_offer"].toString(),
                                //   //   //     offerName:_All_Slider[i]["trending_name"],
                                //   //   //     // offerFavorite:  _All_Slider[i]["favorite"]==null?null: _All_Slider[i]["favorite"],
                                //   //   //   ),
                                //   //   // );
                                //   // },
                                //     child:Container(
                                //       width: 78.5919189453125,
                                //       height: 25,
                                //       margin: EdgeInsets.only(left: 0,right: 0),
                                //       decoration: new BoxDecoration(
                                //         borderRadius: BorderRadius.circular(
                                //             32.0),
                                //         color: Color(0xffffffff),
                                //         boxShadow: [BoxShadow(
                                //             color: Color(0x29000000),
                                //             offset: Offset(0, 3),
                                //             blurRadius: 6,
                                //             spreadRadius: 0
                                //         )
                                //         ],
                                //       ),
                                //       child: Center(child: Text(
                                //           "View",
                                //           style: const TextStyle(
                                //               color: const Color(
                                //                   0xff00838f),
                                //               fontWeight: FontWeight.w500,
                                //               fontFamily: "SFProText",
                                //               fontStyle: FontStyle.normal,
                                //               fontSize: 11.0
                                //           ),
                                //           textAlign: TextAlign.center
                                //       ),),
                                //     )
                                // ),

                                SizedBox(height: 1,),


                              ],
                            ) ,
                          ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                )
            )
        ],
      ),
    );
  }



  categryFiltter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              SetLocalization.of(context)!.getTranslateValue('categories')!,
              style: TextStyle(fontSize: 19),
              textAlign: TextAlign.left,
            )
          ],
        ),

        Visibility(
            visible: idUser==null ?true  :true ,
            child: Container(
              height: 40,
              child: Row(
                  children: <Widget>[
                    _All_filttercategry.isEmpty?Text("")  :
                    Theme(
                        data: Theme.of(context).copyWith(
                          cardColor: Colors.white,
                          shadowColor: Color(0xFF00838f),
                          dividerColor: Color(0xFF00838f),
                          highlightColor:Color(0xFF00838f) ,

                          textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black),
                        ),
                        child:PopupMenuButton<String>(
                          onSelected: (String result) {
                            print(result);
                            DilogApp.sign_in(context);
                          },
                          icon: Image.asset(
                            'assets/images/icon_filter_hor.png',
                            height: 22,
                            width: 22,
                            color: Colors.black,
                          ),
                          elevation: 15,
                          // offset: Offset(11, 11),
                          itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                            for(int i=0 ; i<_All_filttercategry.length;i++)
                              PopupMenuItem<String>(
                                value: _All_filttercategry[i]["id"].toString(),
                                child: Text(_All_filttercategry[i]["type_name"],
                                  style: TextStyle(
                                      color:
                                      // filtterChoce.toString()=="all"?Colors.black:
                                      // filtterChoce.toString()=="null"?Colors.black:
                                      // idfiltterDefult.toString()==_All_filttercategry[i]["id"].toString()?
                                      // Color(0xFF00838f):
                                      Colors.black
                                  ),
                                ),
                              ),
                          ],
                        )),
                  ]
              ),
            )
        ),


      ],
    );
  }

  Map? data_defultFiltter;
  List _All_filttercategry=[];

  Future getData_defultFiltter() async {

    getAllFiltter(context).then((value){
      setState(()  {
        setState(()  {
          data_defultFiltter = json.decode(value.toString());
          print("data_defultFiltter  "+data_defultFiltter.toString());
          setState(() {
            print(data_defultFiltter!["filter"].toString());
            _All_filttercategry.addAll(data_defultFiltter!["filter"]);

          });

        });
      });
    });

  }


  List _All_mainCatigry=[];
  Map? data_mainCatigry;

  Future getData_MainCatigry() async {

    getAllCatigry(context).then((value){
      data_mainCatigry = json.decode(value.toString());
      setState(()  {
        print("data_mainCatigry  "+data_mainCatigry.toString());

        setState(() {
          if(data_mainCatigry!["categories"][0]["id"]!=null){
            setState(() {
              // _All_mainCatigry.add
              _All_mainCatigry.addAll([
                {
                  "id": 8,
                  "category_name": langApp=="ar"? "الكل":"All",
                  "offer_img": "https://prestige.sa/uploads/categories/categories4227-132.png",
                  "locations":""
                }
              ]);
              // serviceWatched=true;
              _All_mainCatigry.addAll(data_mainCatigry!["categories"]);
            });
          }
        });

      });

    });

  }

  String? idCategry="all";
  String? idfiltterDefult;
  var index_categry=0;

  Widget CtigryMain_List() {
    return
      Container(
        child: new Container(
          // margin: EdgeInsets.all(4),
          height: 110,
          child:
          new ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
//            itemCount: 15,
            itemCount: _All_mainCatigry == null ||
                _All_mainCatigry.length < 1 || _All_mainCatigry.isEmpty
                ? 0
                : data_mainCatigry?["categories"].length + 1,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () => {
                  if(index!=0){
                  DilogApp.sign_in(context)
                  }
                },
                child:
                Container(
                  margin: EdgeInsets.only(
                      left: 10, right: 10, bottom: 0, top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),

                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
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
                                            color: Color(index_categry == index
                                                ? 0xff00838f
                                                : 0x29000000),
                                            offset: Offset(0, 3),
                                            blurRadius: 6,
                                            spreadRadius: 0
                                        )
                                        ],
                                      ),
                                      child: Container(
                                          margin: index == 0 ? EdgeInsets.all(
                                              14) : EdgeInsets.all(11),
                                          height: 35, width: 35,
                                          child: index == 0 ? Image.asset(
                                            "assets/images/allc.png",
                                          )
                                              :
                                          CachedNetworkImage(
                                            // height: 120,
                                            // width:120,
                                            fit: BoxFit.fill,
                                            imageUrl: "${_All_mainCatigry[index]["image"]}",
                                            placeholder: (context, url) => Container(),
                                            errorWidget: (context, url, error) => Image.asset("assets/images/no_image_avilable.png",height: 120,width:120,),

                                          )
                                      ),
                                    ),

                                    SizedBox(height: 17,),


                                    Flexible(child: Container(
                                      // width: 67,
                                        child: Center(
                                          child: Text(
                                            _All_mainCatigry[index]["category_name"],
                                            style: TextStyle(
                                              fontFamily: 'SFProText',
                                              color: Color(
                                                  index_categry == index
                                                      ? 0xff00838f
                                                      : 0xff000000),
                                              fontSize: 13,
                                              // backgroundColor: Colors.redAccent,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                            ),
                                            textAlign: TextAlign.center,
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
      );
  }



  List? _All_allOffer=[];
  List? _All_allOffer_testdata=null;
  List? _All_allOffer_old=[];
  Map? data_allOffer;
  int numOfferNotActive=0;
  Future getData_allOffer() async {
    getAllOffers(context).then((value){
      setState(() {
        try{
          data_allOffer = json.decode(value.toString());
          if(data_allOffer!["offers"][0]["id"]!=null){
            setState(() {

              _All_allOffer!.addAll(data_allOffer!["offers"]);
              for(int active=0 ; active<_All_allOffer!.length ;active++){
                if(_All_allOffer![active]["active"].toString() =="null" ||_All_allOffer![active]["active"].toString() !="1" ){
                  numOfferNotActive=numOfferNotActive+1;
                }
                print("numOfferNotActive  >>>??  "+numOfferNotActive.toString());
              }
            });

          }else {
            setState(() {
              _All_allOffer_testdata = [];
            });
          }
        }catch(e){}

      });

    });

  }

  Widget _getOffers(BuildContext context, int index,lengh) {
    return
      InkWell(
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  //image
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
                    child: FittedBox(
                      child:
                      CachedNetworkImage(
                        height: 70,
                        width:70,
                        fit: BoxFit.fill,
                        imageUrl: "${_All_allOffer![index]["offer_img"]}",
                        placeholder: (context, url) => Container(),
                        errorWidget: (context, url, error) => Image.asset("assets/images/no_image_avilable.png",height: 120,width:120,),
                      ),
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
                                        _All_allOffer![index]["name"],
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
                                        _All_allOffer![index]["favorite"].toString() == 'null' ? Icons.favorite_border :
                                        _All_allOffer![index]["favorite"].toString() == '0' ? Icons.favorite_border :
                                        Icons.favorite,
                                        color: _All_allOffer![index]["favorite"].toString() == '0' ? Colors.grey :
                                        _All_allOffer![index]["favorite"].toString() == '1' ? Colors.red :
                                        Colors.grey,
                                      ),
                                      onTap: () {
                                        DilogApp.sign_in(context);
                                        // DilogApp.sign_in("Internet not available, Cross check your internet connectivity and try again", true);
                                        // if (idUser != null) {
                                        //   if (_All_allOffer![index]["favorite"]
                                        //       .toString() == '1') {
                                        //     _sendItemData_favorite("un_fav",
                                        //         _All_allOffer![index]["id"],
                                        //         index);
                                        //     // client.addFavorite(PreferenceUtils.getUserEmail(), allOffer[index].id, PreferenceUtils.getUserSessionID()).then((value) => {if (value.statusCode != 200) {}});
                                        //   } else {
                                        //     _sendItemData_favorite("fav",
                                        //         _All_allOffer![index]["id"],
                                        //         index);
                                        //     // client
                                        //     //     .deleteFavorite(PreferenceUtils.getUserEmail(), allOffer[index].id, PreferenceUtils.getUserSessionID())
                                        //     //     .then((value) => {if (value.statusCode != 200) {}});
                                        //   }
                                        // } else {
                                        //   sign_in(context);
                                        // }
                                      },
                                    )
                                  ],
                                ),
                              ),
                              // )
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
                                            _All_allOffer![index]["offer_description"].toString().length>76 ?
                                            _All_allOffer![index]["offer_description"].toString().substring(0,76)+"...." :
                                            _All_allOffer![index]["offer_description"]
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
                                alignment: langApp=="ar"?Alignment.bottomLeft: Alignment.bottomRight,
                                child:  Container(
                                  height: 50,
                                  padding: EdgeInsets.only(right: 6),
                                  width: MediaQuery.of(context).size.width/4.5,
                                  child: ListView.builder(
                                    reverse: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                    _All_allOffer==null?0:
                                    _All_allOffer![index]==null?0:
                                    _All_allOffer![index]["small_icon"]==null?0:
                                    _All_allOffer![index]["small_icon"].length,
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
                                                  child:
                                                  CachedNetworkImage(
                                                    height: 34,
                                                    width:34,
                                                    fit: BoxFit.fill,
                                                    imageUrl: "${_All_allOffer![index]["small_icon"][position]}",
                                                    placeholder: (context, url) =>
                                                        Center(child: Image.asset(
                                                          "assets/images/loadimage.gif",
                                                          height: 34, width: 34,),),
                                                    errorWidget: (context, url,
                                                        error) =>
                                                        Image.asset(
                                                          "assets/images/loadimage.gif",
                                                          height: 34, width: 34,),
                                                  ),
                                                  // FadeInImage(
                                                  //     image:
                                                  //     NetworkImage(_All_allOffer![index]["small_icon"][position]),
                                                  //     width: 34,
                                                  //     height: 34,
                                                  //     placeholder: AssetImage('assets/images/no_image_avilable.png'),
                                                  //     fit: BoxFit.cover,
                                                  //   imageErrorBuilder:
                                                  //       (context, error, stackTrace) {
                                                  //     return Image.asset(
                                                  //         'assets/images/logo2.png',
                                                  //         fit: BoxFit.fitWidth);
                                                  //   },
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
              Container(
                padding: EdgeInsetsDirectional.only(top: 0, bottom: 2),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(height: 1,
                          color: Color(0x80000000)),
                    ),
                  ],
                ),
              ),

              // lengh>5?Text(""):Container(height: MediaQuery.of(context).size.height/2,)
            ],
          ),
        ),
      );
  }


  static Future<bool> onWillPop(BuildContext context) async {
    return (await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        title: Text(SetLocalization.of(context)!.getTranslateValue('are_you_sure')!),
        titlePadding: EdgeInsets.only(left: 5.0,right: 5.0,top: 5.0),
        contentPadding: EdgeInsets.only(left: 5.0,right: 5.0,top: 5.0,bottom: 0),
        content: Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(SetLocalization.of(context)!.getTranslateValue('no')!,style: TextStyle(
                    color: Color(0xff00838f)
                ),),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                padding: EdgeInsets.all(0.0),
              ),
              FlatButton(
                onPressed: () {

                  try{
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  }catch(e){

                  }
                  exit(0);
                  // Navigator.of(context).pop(true);
                },
                child: new Text(SetLocalization.of(context)!.getTranslateValue('yes')!,style: TextStyle(
                    color: Color(0xff00838f)
                ),),
                padding: EdgeInsets.all(0.0),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ), // button 2
            ]
        ),
      ),
    )) ?? false;
  }
}