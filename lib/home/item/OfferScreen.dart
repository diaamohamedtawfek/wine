import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart'
;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wineapp/home/drawearPage/wepNewWEP.dart';
import 'package:wineapp/lang/localization/set_localization.dart';
import 'package:wineapp/startApp/Login.dart';
import '../../URL_LOGIC.dart';
import 'OfferInfoScreen.dart';

class OfferScreen extends StatefulWidget {

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

  OfferScreen({Key? key, this.offerID, this.offerName, this.offerFavorite, this.locationid_mal,
    this.id_Catigry, this.id_SubCatrgry, this.cat_id, this.direction, this.indexrow, this.trending}) : super(key: key);

  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen>  with TickerProviderStateMixin {

  late Animation<double> animation;
  AnimationController? _animationController;
  int? itemFavortOrNot;

  final controller = PageController(initialPage: 0);
  late List<Widget> pages=[];

  int _currentPage = 0;

  Timer? timer;
  @override
  void initState() {
    super.initState();

    getStringValuesSF();
    print("offerFavorite  : "+widget.offerFavorite.toString());

    _animationController = new AnimationController(
        duration:  Duration(milliseconds: 3000), vsync: this)..repeat();
    animation = Tween<double>(begin: 0.0, end: 1.5).animate(_animationController!);
    _animationController!.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _animationController!.reverse();
      }
      else if(status == AnimationStatus.dismissed){
        _animationController!.forward();
      }
    });
    _animationController!.forward();
  }


  void dispose() {
    timer!.cancel();
    _animationController!.dispose();
    controller.dispose();
    super.dispose();

  }

  String? idUsers="";
  String? langApp;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('lang');
    String? idUser = prefs.getString('userid');

    setState(() {
      idUsers=idUser;
      langApp=lang;
      getData_Item();

    });
  }

  Map? data_Item;
  List _All_Item_ratetg=[];


  Future getData_Item() async {

    print (">>>"+idUsers.toString());

if(data_Item !=null){
  _currentPage=0;
  data_Item!.clear();
}

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


    print("body is :"+body.toString());
    print("url is :"+URL_LOGIC.itemDetales2.toString());
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};

    http.Response responseOffer = await http.post(
      Uri.parse(URL_LOGIC.itemDetales2!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    print(responseOffer.body.toString());
    data_Item = json.decode(responseOffer.body);


    setState(() {
      data_Item = json.decode(responseOffer.body);

      // print(">>>>>>>>>>>>>>>>");
      // print(data_Item!["main"][6]["shop_online"]);
      // print(data_Item!["main"][6]["shop_online"][0]["shop_webview"]);
      try{
        if( data_Item!["main"][3]["related_offers"]!=null){
          setState(() {
            _All_Item_ratetg= data_Item!["main"][3]["related_offers"];
          });

        }
      }catch(e){}


      addDataIntoSlider();
    });
  }

  // bool showSlider=false;
  late List<String> tag ;

  addDataIntoSlider(){
    _currentPage=0;
    pages.clear();
    setState(() {
      for (var i = 0; i < data_Item!["main"][0]["images"][0]["image_url"].length; i ++)
          {
        pages.add(FittedBox(
          child:  CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: "${data_Item!["main"][0]["images"][0]["image_url"][i]}",
            placeholder: (context, url) => Container(),
            errorWidget: (context, url, error) => Image.asset("assets/images/no_image_avilable.png",height: 120,width:120,),

          ),
          fit: BoxFit.fill,
        ),
        );

      }
    });


    setState(() {
      _currentPage=0;
    });
    timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < data_Item!["main"][0]["images"][0]["image_url"].length-1)
          {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      try {
        controller.animateToPage(_currentPage,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }catch(e){

      }
    });


    tag = [
      "redeem",
      SetLocalization.of(context)!.getTranslateValue('Menu')!,
      SetLocalization.of(context)!.getTranslateValue('info')!,
      SetLocalization.of(context)!.getTranslateValue('location')!,

    ];



    if(data_Item!["main"][2]["menus"][0]["offer_menus"]  == null || data_Item!["main"][2]["menus"][0]["offer_menus"].toString()  == "null"){
      tag.remove(SetLocalization.of(context)!.getTranslateValue('Menu'));
    }
    if(data_Item!["main"][1]["info"].toString() == '0'){
      tag.remove(SetLocalization.of(context)!.getTranslateValue('info'));
    }
    if(data_Item!["main"][1]["info"][0]["longitude"] ==null  && data_Item!["main"][1]["info"][0]["latitude"] ==null ||
        data_Item!["main"][1]["info"][0]["longitude"].toString() =="null"  && data_Item!["main"][1]["info"][0]["latitude"].toString() =="null"){
      // tag.removeAt(2);
      tag.remove(SetLocalization.of(context)!.getTranslateValue('location'));
    }

    print("??????????????????");
    print("tag -<< $tag");
    print("tag -<< ${data_Item!["main"][6]["shop_online"][0]["shop_active"]}");
    print("tag shop_type -<< ${data_Item!["main"][6]["shop_online"][0]["shop_type"].toString().trim()}");
    print("??????????????????");
    if(data_Item!["main"][6]["shop_online"][0]["shop_active"].toString().trim()=="1"){
      if(data_Item!["main"][6]["shop_online"][0]["shop_type"].toString().trim() !="redeem" ){
        // tag.removeAt(2);
        // tag.remove("redeem");
        // tag.add("Shop Online");
        tag[0]="Shop Online";
      }else{
        print("tag shop_type -<< ${data_Item!["main"][6]["shop_online"][0]["shop_type"].toString().trim()}");
      }
    }else{
      tag.remove("redeem");
    }


    // print(data_Item!["main"][6]["shop_online"][0]["shop_type"].toString());
    print("??????????????????");
    print("tag -<< $tag");
    print("??????????????????");


  }


  Future getRefrich() async {
    if(data_Item!.isNotEmpty){
      data_Item!.clear;
    }
   getData_Item();
    await Future.delayed(Duration(seconds: 3));
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
      data_Item == null ? Scaffold(

          appBar: AppBar(
            backgroundColor: Color(0xff00838f),
            centerTitle: true,
            title: Text(widget.offerName!,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),),
          ),
          body:
          Center(child: CircularProgressIndicator(),)
      ) :

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
                    if (data_Item!["main"][1]["info"][0]["favorite"]
                        .toString() == '1') {
                      _sendItemData_favorite("un_fav", widget.offerID, 0,idMal: widget.locationid_mal);
                    } else {
                      _sendItemData_favorite("fav", widget.offerID, 0,idMal: widget.locationid_mal);
                    }
                  } else {
                    sign_in(context);
                  }
                },
                child: Icon(
                  data_Item!["main"][1]["info"][0]["favorite"] == '1' ? Icons
                      .favorite : Icons.favorite_border, color: Colors.white,)

            )
          ],
        ),


        body:
        data_Item == null ? Center(child: CircularProgressIndicator(),) :
        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: RefreshIndicator(
            onRefresh: getRefrich,
            // color: Colors.b,
            backgroundColor: Colors.black,
            child: Visibility(
              visible: data_Item == null ? false : true,
              // visible: adsLoading,
              replacement: Container(
                child: Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator()),
              ),
              child:SafeArea(
                  bottom: true,
                  child:Container(
                    // color: Colors.white,
                    // height: MediaQuery.of(context).size.height,

                    // height: MediaQuery
                    //     .of(context)
                    //     .size
                    //     .height ,
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 00),
                      children: <Widget>[
                        Container(
                          // color: Colors.white,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height-AppBar().preferredSize.height ,
                          child:
                          Stack(
                            fit: StackFit.passthrough,
                            alignment: Alignment.topLeft,
                            children: [
                              SizedBox(height:  MediaQuery
                                  .of(context)
                                  .size
                                  .height,),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  // color: Colors.blue,
                                    child: Column(
                                      children: [
                                        data_Item == null
                                            ? Divider(height: 1,)
                                            : data_Item!["main"][0] == null
                                            ? Divider(height: 1,)
                                            :
                                        data_Item!["main"][0]["images"][0]["image_url"] ==
                                            null
                                            ? Divider(height: 1,)
                                            :
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              0, 0, 0, 0),
                                          child: Container(
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width / 2 + 30,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width / 2,
                                                    child: PageView(
                                                      children: pages,
                                                      controller: controller,
                                                    ),
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    // padding: EdgeInsets.fromLTRB(17, 5, 0, 11),
                                                    child: SmoothPageIndicator(
                                                      controller: controller,
                                                      count: data_Item!["main"][0]["images"][0]["image_url"]
                                                          .length,
                                                      onDotClicked: (index) {
                                                        print(index);
                                                      },
                                                      effect: WormEffect(
                                                          activeDotColor: Color(
                                                              0xff00838f),
                                                          dotColor: Color(
                                                              0x2900838f),
                                                          //0x80f2f2f2
                                                          dotHeight: 10,
                                                          dotWidth: 10,
                                                          spacing: 5
                                                      ),
                                                    ),
                                                  ),
                                                  // ),)
                                                ],
                                              )),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,

                                        ),


                                        SizedBox(height: 0,),
                                        // Visibility(
                                        //   // visible:true ,
                                        //   visible:
                                        //   data_Item["main"][1]["info"][0]["active"] ==null ?true:
                                        //   data_Item["main"][1]["info"][0]["active"].toString()=="null"?true:
                                        //   data_Item["main"][1]["info"][0]["active"]=="0"?true:
                                        //   data_Item["main"][1]["info"][0]["active"]==0?true:
                                        //   false,
                                        //   child: Column(
                                        //     children: [
                                        //       Center(
                                        //         child: Text(
                                        //           SetLocalization.of(context)
                                        //               .getTranslateValue(
                                        //               'numOfferNotActive3'),
                                        //           style: TextStyle(fontSize: 14,
                                        //               color: Colors.black38
                                        //           ),
                                        //           textAlign: TextAlign.center,
                                        //         ),
                                        //       ),
                                        //       SizedBox(height: 5,),
                                        //     ],
                                        //   ),
                                        // ),


                                        // *  offer_description

                                        data_Item!["main"][1]["info"][0]["offer_description"] ==
                                            null ? Divider(height: 1,) :
                                        Container(
                                          height:
                                          data_Item!["main"][1]["info"][0]["active"]==0?MediaQuery.of(context).size.height/5:
                                          MediaQuery.of(context).size.height/4-10
                                          ,
                                          padding: EdgeInsets.only(
                                              left: 17,
                                              right: 17,
                                              top: 0,
                                              bottom: 4),
                                          // padding: EdgeInsets.fromLTRB(17, 0, 30, 20),
                                          child:
                                          Container(
                                              // color: Colors.red,
                                              alignment:
                                              data_Item!["main"][1]["info"][0]["active"] ==null ?Alignment.center:
                                              data_Item!["main"][1]["info"][0]["active"].toString()=="null"?Alignment.center:
                                              data_Item!["main"][1]["info"][0]["active"]=="0"?Alignment.center:
                                              data_Item!["main"][1]["info"][0]["active"]==0?Alignment.center
                                                  :Alignment.center,
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 6),
                                              child:Scrollbar(
                                                  interactive: true,
                                                  hoverThickness: 22,
                                                  // isAlwaysShown: true,
                                                  showTrackOnHover: true,
                                                  child:ListView(
                                                    physics: ScrollPhysics(),
                                                    shrinkWrap: true,
                                                    children: [
                                                      Text(
                                                        data_Item!["main"][1]["info"][0]["offer_description"]
                                                            .toString().replaceAll("&quot;", "\n"),
                                                        textAlign: data_Item!["main"][1]["info"][0]["active"].toString()!="1"?TextAlign.center
                                                            :TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 16
                                                        ),
                                                      ),
                                                    ],
                                                  ))
                                            //
                                          ),
                                        ),

                                        SizedBox(height: 2,),


                                      ],
                                    )),
                              ),

                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    // color: Colors.red,
                                    constraints: BoxConstraints(
                                      maxHeight:  MediaQuery
                                          .of(context)
                                          .size
                                          .height - (MediaQuery.of(context).size.height/5+MediaQuery
                                          .of(context)
                                          .size
                                          .width / 2)-130,
                                      // maxHeight:  MediaQuery
                                      //   .of(context)
                                      //   .size
                                      //   .height - (MediaQuery.of(context).size.height/5+MediaQuery
                                      //     .of(context)
                                      //     .size
                                      //     .width / 2 + 30),
                                    ),
                                    child: ListView(
                                      // reverse: true,
                                      padding: EdgeInsets.only(bottom: 42),
                                      physics:ScrollPhysics(),
                                      children: [
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [


                                              tag == null ? Divider(height: 1,) :
                                              Center(
                                                child:
                                                Container(
                                                  // height: 43,
                                                  // color: Colors.red,
                                                  padding: EdgeInsets.fromLTRB(
                                                      20, 8, 20, 10),
                                                  // padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                                  child:
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .center,
                                                    children: List.generate(
                                                        tag.length, (index) {
                                                      return Container(
                                                        padding: EdgeInsets.only(right: 10),
                                                        child: InkWell(

                                                          highlightColor: Colors.transparent,
                                                          splashColor: Colors.transparent,
                                                          onTap: () {
                                                            print(tag[index]);
                                                            if (tag[index] ==
                                                                SetLocalization.of(context)!.getTranslateValue('info')) {
                                                              Navigator.push(context,
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) =>
                                                                          OfferInfoScreen(
                                                                            data_Item: data_Item,
                                                                            offername: widget
                                                                                .offerName,)
                                                                  ));
                                                            } else if (tag[index] ==
                                                                SetLocalization.of(
                                                                    context)!
                                                                    .getTranslateValue(
                                                                    'location')) {
                                                              openMap(double.parse(
                                                                  data_Item!["main"][1]["info"][0]["longitude"]
                                                                      .toString()),
                                                                  double.parse(
                                                                      data_Item!["main"][1]["info"][0]["latitude"]
                                                                          .toString()));
                                                            } else if (tag[index] ==
                                                                SetLocalization.of(
                                                                    context)!
                                                                    .getTranslateValue(
                                                                    'Menu')) {
                                                              _launchURL(data_Item!["main"][2]["menus"][0]["offer_menus"]);
                                                            }else if (tag[index] ==
                                                                "Shop Online") {
                                                              print("??"+data_Item!["main"][6]["shop_online"][0]["shop_url"]);
                                                              _launchURL(data_Item!["main"][6]["shop_online"][0]["shop_url"]);
                                                              // popUpDilog(context,data_Item!["main"][6]["shop_online"][0]["shop_webview"]);
                                                            }else if (tag[index] ==
                                                                "redeem") {
                                                              popUpDilog(
                                                                context,data_Item!["main"][6]["shop_online"][0]["shop_webview"],
                                                                data_Item!["main"][6]["shop_online"][0]["shop_url"],
                                                              );
                                                            }
                                                          },
                                                          child: Container(
                                                            padding: tag.length > 2 ?
                                                            EdgeInsets.fromLTRB(
                                                                15, 5, 15, 5) :
                                                            EdgeInsets.fromLTRB(
                                                                20, 5, 20, 5),

                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border.all(
                                                                  color: tag[index]
                                                                      .toString() ==
                                                                      "info"
                                                                      ? Color(0xff00838f) .withOpacity(
                                                                      0.5)
                                                                      : Color(
                                                                      0xff00838f),
                                                                  width: 0.1,

                                                                ),
                                                                borderRadius: BorderRadius
                                                                    .circular(15),
                                                                boxShadow: <
                                                                    BoxShadow>[
                                                                  BoxShadow(
                                                                    color: tag[index]
                                                                        .toString() ==
                                                                        "info"
                                                                        ? Color(0xff00838f).withOpacity(
                                                                        0.5)
                                                                        : Color(0xff00838f)
                                                                        .withOpacity(
                                                                        0.5),
                                                                    spreadRadius: 1,
                                                                    blurRadius: 7,
                                                                    offset: Offset(
                                                                        0, 3),
                                                                  )
                                                                ]
                                                            ),
                                                            child: Text(
                                                              tag[index].toString() == "info" ? "Branches" :
                                                              tag[index].toString() == "redeem" ? SetLocalization.of(context)!.getTranslateValue('redeem')! :
                                                              tag[index].toString() == "Shop Online" ? SetLocalization.of(context)!.getTranslateValue('Shoponline')! :
                                                              tag[index]
                                                              , style: TextStyle(
                                                              fontSize: 13,
                                                              color: Color(
                                                                  0x99000000),
                                                            ),),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                ),
                                              ),


                                              // // animation  and small icon
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [

                                                    // animation
                                                    Visibility(
                                                      // visible: true,
                                                      visible: _All_Item_ratetg ==
                                                          null ||
                                                          _All_Item_ratetg.isEmpty
                                                          ? false
                                                          : true,
                                                      child: InkWell(
                                                        child: Stack(
                                                          children: [
                                                            FadeTransition(
                                                              opacity: animation,
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(left: 17,
                                                                    right: 17),
                                                                // padding: EdgeInsetsDirectional.fromSTEB(13, 0, 7, 0),
                                                                color: Colors.grey
                                                                    .withOpacity(0.5),
                                                                height:80,
                                                              ),

                                                            ),

                                                            data_Item!["main"][3]["related_offers"] ==
                                                                null ? Divider(
                                                              height: 1,) :
                                                            _All_Item_ratetg.isEmpty
                                                                ? Divider(height: 1,)
                                                                :
                                                            Container(
                                                              height: 80,
                                                              margin: EdgeInsets.only(
                                                                  left: 17,
                                                                  right: 17),
                                                              width: MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width - 35,
                                                              color: Color(
                                                                  0x0d000000),
                                                              child: ListView.builder(

                                                                // shrinkWrap: true,
                                                                  physics: AlwaysScrollableScrollPhysics(),
                                                                  scrollDirection: Axis
                                                                      .horizontal,
                                                                  itemCount:
                                                                  // 3,
                                                                  data_Item!["main"][3]["related_offers"] ==
                                                                      null
                                                                      ? 0
                                                                      : data_Item!["main"][3]["related_offers"]
                                                                      .length,
                                                                  itemBuilder: (
                                                                      BuildContext context,
                                                                      int index) {
                                                                    return InkWell(
                                                                      onTap: () =>
                                                                      {
                                                                        Navigator.of(
                                                                            context)
                                                                            .pushReplacement(
                                                                            MaterialPageRoute(
                                                                              builder: (
                                                                                  BuildContext context) =>
                                                                                  OfferScreen(
                                                                                    offerID: data_Item!["main"][3]["related_offers"][index]["offer_id"],
                                                                                    offerName: data_Item!["main"][3]["related_offers"][index]["offer_name"],
                                                                                    offerFavorite: data_Item!["main"][1]["info"][0]["favorite"],
                                                                                    locationid_mal: widget
                                                                                        .locationid_mal
                                                                                        .toString(),
                                                                                    trending: data_Item!["main"][3]["related_offers"][index]["related_id"],
                                                                                    direction: "related_id",
                                                                                  ),
                                                                            ))
                                                                      },

                                                                      child: Container(
                                                                        width: MediaQuery
                                                                            .of(
                                                                            context)
                                                                            .size
                                                                            .width -
                                                                            35,
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment
                                                                              .spaceBetween,
                                                                          children: <
                                                                              Widget>[

                                                                            Expanded(
                                                                                child: Container(
                                                                                  padding: EdgeInsets
                                                                                      .only(
                                                                                      top: 3,
                                                                                      left: 5,
                                                                                      right: 5),
                                                                                  child:
                                                                                  // Expanded(child:
                                                                                  Column(
                                                                                    mainAxisAlignment: MainAxisAlignment
                                                                                        .start,
                                                                                    crossAxisAlignment: CrossAxisAlignment
                                                                                        .start,
                                                                                    children: <
                                                                                        Widget>[

                                                                                      SizedBox(
                                                                                        height: 20,
                                                                                        child:
                                                                                        // Flexible(
                                                                                        //   flex: 1,
                                                                                        //   fit: FlexFit
                                                                                        //       .loose,
                                                                                        //   child:
                                                                                          Text(
                                                                                            data_Item!["main"][3]["related_offers"][index]["offer_name"],
                                                                                            textAlign: TextAlign
                                                                                                .start,
                                                                                            maxLines: 2,
                                                                                            overflow: TextOverflow
                                                                                                .visible,
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.w700,
                                                                                                fontSize: 15
                                                                                            // ),
                                                                                          ),),
                                                                                      ),



                                                                                      // Expanded(child:
                                                                                      SizedBox(
                                                                                          height: 55,
                                                                                          child:
                                                                                          // Flexible(
                                                                                          //   flex: 1,
                                                                                          //   fit: FlexFit
                                                                                          //       .loose,
                                                                                          //   child:
                                                                                            Text(
                                                                                              data_Item!["main"][3]["related_offers"][index]["offer_description"].toString()
                                                                                                  .replaceAll(
                                                                                                  "&quot;",
                                                                                                  "\n"),
                                                                                              textAlign: TextAlign
                                                                                                  .start,
                                                                                              maxLines: 2,
                                                                                              overflow: TextOverflow
                                                                                                  .ellipsis,
                                                                                              style: TextStyle(
                                                                                                  fontWeight: FontWeight.w400,
                                                                                                  fontSize: 15
                                                                                              // ),
                                                                                            ),
                                                                                          )),

                                                                                    ],
                                                                                  ),
                                                                                  // )
                                                                                )),

                                                                            // Image
                                                                            Container(
                                                                              height: 80,
                                                                              decoration: BoxDecoration(
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: Colors
                                                                                        .grey
                                                                                        .withOpacity(
                                                                                        0.1),
                                                                                    spreadRadius: 3,
                                                                                    blurRadius: 3,
                                                                                    offset: Offset(
                                                                                        0,
                                                                                        1), // changes position of shadow
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              margin: EdgeInsets
                                                                                  .only(
                                                                                  right: 0),
                                                                              padding: EdgeInsets
                                                                                  .all(
                                                                                  0),
                                                                              width: 82,
                                                                              child:
                                                                              CachedNetworkImage(
                                                                                // height: 34,
                                                                                // width:34,
                                                                                fit: BoxFit.fill,
                                                                                imageUrl: "${data_Item!["main"][3]["related_offers"][index]["offer_img"]}",
                                                                                placeholder: (context, url) => Container(),
                                                                                errorWidget: (context, url, error) => Image.asset("assets/images/no_image_avilable.png",height: 120,width:120,),
                                                                                // height: 34, width: 34,
                                                                                //                   ),
                                                                              ),
                                                                            ),

                                                                            // ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }

                                                              ),


                                                            ),
                                                          ],
                                                        ),
                                                        onTap: () {
                                                        },
                                                      ),
                                                    ),


                                                    SizedBox(height: 5,),

                                                    Visibility(
                                                        visible:
                                                        data_Item!["main"][0]["images"][1]["small_icon"]
                                                            .isNotEmpty ? true :
                                                        data_Item!["main"][0]["images"][1]["small_icon"]
                                                            .length > 0 ? true :
                                                        false,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              padding: langApp == 'en'
                                                                  ? EdgeInsets
                                                                  .fromLTRB(
                                                                  17, 0, 0, 0)
                                                                  : EdgeInsets
                                                                  .fromLTRB(
                                                                  0, 0, 17, 0),
                                                              child: Text(
                                                                SetLocalization.of(
                                                                    context)!
                                                                    .getTranslateValue(
                                                                    'loyality_program')!,
                                                                style: TextStyle(
                                                                  fontSize: 17,

                                                                ),),
                                                            ),

                                                            SizedBox(height: 2,),
                                                          ],
                                                        )
                                                    ),

                                                    //
                                                    //
                                                    Visibility(
                                                      visible:
                                                      data_Item!["main"][0]["images"][1]["small_icon"]
                                                          .isNotEmpty ? true :
                                                      data_Item!["main"][0]["images"][1]["small_icon"]
                                                          .length > 0 ? true :
                                                      false,
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .center,
                                                        children: [
                                                          Container(
                                                            // color: Colors.red,
                                                            width: MediaQuery
                                                                .of(context)
                                                                .size
                                                                .width,
                                                            height: MediaQuery
                                                                .of(context)
                                                                .size
                                                                .width / 5,
                                                            child: Center(
                                                              child: Scrollbar(
                                                                child: ListView
                                                                    .separated(
                                                                    shrinkWrap: true,
                                                                    padding: EdgeInsetsDirectional
                                                                        .only(
                                                                        start: 17,
                                                                        end: 17),
                                                                    scrollDirection: Axis
                                                                        .horizontal,
                                                                    itemCount: data_Item!["main"][0]["images"][1]["small_icon"]
                                                                        .length,
                                                                    separatorBuilder: (
                                                                        BuildContext context,
                                                                        int index) {
                                                                      return SizedBox(
                                                                        width: 10,);
                                                                    },
                                                                    itemBuilder: (
                                                                        BuildContext context,
                                                                        int position) {
                                                                      return
                                                                        // Container(
                                                                        // // color: Colors.blue,
                                                                        // child:
                                                                        Row(
                                                                          crossAxisAlignment: CrossAxisAlignment
                                                                              .center,
                                                                          mainAxisAlignment: MainAxisAlignment
                                                                              .center,
                                                                          children: [

                                                                            Container(
                                                                              width: 130.0,
                                                                              height: 80.0,
                                                                              decoration: BoxDecoration(
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: Colors
                                                                                        .grey
                                                                                        .withOpacity(
                                                                                        0.3),
                                                                                    spreadRadius: 3,
                                                                                    blurRadius: 3,
                                                                                    offset: Offset(
                                                                                        0,
                                                                                        1), // changes position of shadow
                                                                                  ),
                                                                                ],
                                                                              ),

                                                                              child:
                                                                              CachedNetworkImage(
                                                                                height: 34,
                                                                                width:34,
                                                                                fit: BoxFit.fill,
                                                                                imageUrl: "${ data_Item!["main"][0]["images"][1]["small_icon"][position]["icon_url"]}",
                                                                                placeholder: (context, url) => Container(),
                                                                                errorWidget: (context, url, error) => Image.asset("assets/images/no_image_avilable.png",height: 120,width:120,),

                                                                              ),
                                                                            ),

                                                                            SizedBox(
                                                                              width: 11,),
                                                                          ],
                                                                        )
                                                                      ;
                                                                    }

                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),


                                                  ],
                                                ),
                                              )

                                            ]
                                        )
                                      ],
                                    ),
                                  )
                              )

                            ],
                          ),
                        )


                      ],
                    ),
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }


  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  _launchURL(url) async {
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }

    // const url = "https://flutter.io";
    if (await canLaunch(url))
      await launch(url);
    else
      // can't launch url, there is some error
      throw "Could not launch $url";
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


  Future<void> popUpDilog(BuildContext context,url, urlShop) async{
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return  StatefulBuilder(builder: (context, setState){
            return
              Material(
                  color: Colors.black12,
                  child:
                  Center(
                    // Aligns the container to center
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          // A simplified version of dialog.
                            margin: EdgeInsets.only(
                                left: 15, right: 15),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(
                                  12),
                            ),

                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                    12),
                              ),
                              child: Center(child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:MediaQuery.of(context).size.height-200 ,
                                // color: Colors.white,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      12),
                                  border: Border.all(
                                    color: Color(0xFF00838f),
                                    width: 4
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [

                                    InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Icons.close,color: Color(0xFF00838f),size: 35,),
                                    ),

                                    Expanded(child: WepScreenNew(urlNoti: url,)
                                    // WebViewExample(direction: "pop",lang: langApp,urlLink: url,)
                                    ),

                                    TextButton(
                                        onPressed: (){
                                          _launchURL(urlShop);

                                        },
                                        child: Center(child: Text(
                                          SetLocalization.of(context)!.getTranslateValue('continue').toString(),
                                          style: TextStyle(decoration: TextDecoration.underline,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500
                                        ),),))

                                  ],
                                ),
                              ),),
                            )
                        )
                        // ),
                      ],
                    ),
                  )
              );
          });

        }
    ).then((val) {
      setState(() {


      });
    });
  }

  Future<List?> _sendItemData_favorite(direction,id,index,{required idMal}) async {
    print(URL_LOGIC.favorit_unfavorit);
   late Map<String, Object> body;
    if(direction.toString()=="un_fav"){
      itemFavortOrNot=0;
      body = {
        "lang":langApp!,
        "action":"delete",
        "userid":idUsers!,
        "offer_id":id,
        "locationid":idMal
      };


      setState(() {
        data_Item =
        {
          "main": [
            {
              "images": data_Item!["main"][0]["images"]
            },
            {
              "info": [
                {
                  "offer_name": data_Item!["main"][1]["info"][0]["offer_name"],
                  "offer_description": data_Item!["main"][1]["info"][0]["offer_description"],
                  "longitude": data_Item!["main"][1]["info"][0]["longitude"],
                  "latitude": data_Item!["main"][1]["info"][0]["latitude"],
                  "offer_img": data_Item!["main"][1]["info"][0]["offer_img"],
                  "opening hours": data_Item!["main"][1]["info"][0]["opening hours"],
                  "phone": data_Item!["main"][1]["info"][0]["phone"],
                  "email": data_Item!["main"][1]["info"][0]["email"],
                  "favorite": "0",
                }
              ]
            },
            {
              "menus": data_Item!["main"][2]["menus"]
            },
            {
              "related_offers": data_Item!["main"][3]["related_offers"]
            }
          ]
        };

        print( data_Item.toString());
      });

    } else if(direction.toString()=="fav"){
      itemFavortOrNot=1;
      body = {
        "lang":langApp!,
        "action":"add",
        "userid":idUsers!,
        "offer_id":id,
        "locationid":idMal
      };

//       if(direction_section=="offer") {
      setState(() {
        data_Item =
        {
          "main": [
            {
              "images": data_Item!["main"][0]["images"]
            },
            {
              "info": [
                {
                  "offer_name": data_Item!["main"][1]["info"][0]["offer_name"],
                  "offer_description": data_Item!["main"][1]["info"][0]["offer_description"],
                  "longitude": data_Item!["main"][1]["info"][0]["longitude"],
                  "latitude": data_Item!["main"][1]["info"][0]["latitude"],
                  "offer_img": data_Item!["main"][1]["info"][0]["offer_img"],
                  "opening hours": data_Item!["main"][1]["info"][0]["opening hours"],
                  "phone": data_Item!["main"][1]["info"][0]["phone"],
                  "email": data_Item!["main"][1]["info"][0]["email"],
                  "favorite": "1"
                }
              ]
            },
            {
              "menus": data_Item!["main"][2]["menus"]
            },
            {
              "related_offers": data_Item!["main"][3]["related_offers"]
            }
          ]
        };

        print( data_Item.toString());
      });
    }

    print(body);

    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(
      Uri.parse(URL_LOGIC.favorit_unfavorit!),
      body: jsonBody,
      encoding: encoding,
      headers: headers,
    );
    var datauser = json.decode(response.body);
    print(datauser.toString());
    setState(() {
      if(datauser["code"].toString().trim()=="1"||datauser["code"].toString().trim()=="2"||datauser["code"].toString().trim()=="3"){
      }
    });
    debugPrint(datauser.toString());
  }
}