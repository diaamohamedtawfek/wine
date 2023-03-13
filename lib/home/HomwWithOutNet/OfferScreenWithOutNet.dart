import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart'
;
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:wineapp/lang/localization/set_localization.dart';
import 'dilogAoo/DilogApp.dart';

class OfferScreenWithOutNet extends StatefulWidget {
  final Map? indexRow;

  const OfferScreenWithOutNet({Key? key, this.indexRow}) : super(key: key);



  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreenWithOutNet>  with TickerProviderStateMixin {

  late Animation<double> animation;
  AnimationController? _animationController;
  int? itemFavortOrNot;

  final controller = PageController(initialPage: 0);
  late List<Widget> pages=[];
  // List<Widget> pages = List<Widget>();

  int _currentPage = 0;

  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getStringValuesSF();


  }

  late List<String> tag = [
  // SetLocalization.of(context)!.getTranslateValue('Menu')!,
  SetLocalization.of(context)!.getTranslateValue('info')!,
  // SetLocalization.of(context)!.getTranslateValue('location')!,
  // SetLocalization.of(context).getTranslateValue('info'),
  ];


  String? idUsers="";
  String? langApp;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('lang');
    String? idUser = prefs.getString('userid');

    setState(() {
      idUsers=idUser;
      langApp=lang;

    });
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, );
        return false;
      },
      child:

      Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff00838f),
          centerTitle: true,
          title: Text(
              widget.indexRow!["name"]!=null?
            widget.indexRow!["name"].toString():
              widget.indexRow!["trending_name"]!=null?widget.indexRow!["trending_name"].toString():"",
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
                  DilogApp.sign_in(context);
                },
                child: Icon(widget.indexRow!["favorite"] == '1' ? Icons
                      .favorite : Icons.favorite_border, color: Colors.white,)

            )
          ],
        ),


        body: Visibility(
            visible: true,
            // visible: adsLoading,
            replacement: Container(
              child: Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator()),
            ),
            child: Container(
              // color: Colors.white,
              // height: MediaQuery.of(context).size.height,
              child: ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                padding: EdgeInsets.only(bottom: 00),
                children: <Widget>[

                  Container(
                    // color: Colors.white,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height - 103,
                    child:
                    Stack(
                      fit: StackFit.passthrough,
                      alignment: Alignment.topLeft,
                      children: [

                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            // color: Colors.blue,
                              child: Column(
                                children: [


                                  // Container(
                                  //   padding: EdgeInsets.fromLTRB(
                                  //       0, 0, 0, 0),
                                  //   child: Container(
                                  //       width: MediaQuery
                                  //           .of(context)
                                  //           .size
                                  //           .width,
                                  //       height: 120 ,
                                  //       child: Column(
                                  //         children: [
                                  //           Container(
                                  //             height: MediaQuery
                                  //                 .of(context)
                                  //                 .size
                                  //                 .width ,
                                  //             child:CachedNetworkImage(
                                  //               // height: 20,
                                  //               // width:20,
                                  //               fit: BoxFit.fill,
                                  //               imageUrl: "${widget.indexRow!["offer_img"]}",
                                  //               placeholder: (context, url) => Container(),
                                  //               errorWidget: (context, url, error) => Image.asset("assets/images/no_image_avilable.png",height: 20,width:20,),
                                  //             ),
                                  //           ),
                                  //
                                  //         ],
                                  //       )),
                                  //   width: MediaQuery
                                  //       .of(context)
                                  //       .size
                                  //       .width,
                                  //
                                  // ),


                                  Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width ,
                                    height: 200 ,

                                    child:CachedNetworkImage(
                                      // height: 20,
                                      // width:20,
                                      fit: BoxFit.fill,
                                      imageUrl: "${widget.indexRow!["offer_img"]}",
                                      placeholder: (context, url) => Container(),
                                      errorWidget: (context, url, error) => Image.asset("assets/images/no_image_avilable.png",height: 20,width:20,),
                                    ),
                                  ),


                                  SizedBox(height: 0,),



                                  widget.indexRow!["offer_description"] ==
                                      null ? Divider(height: 1,) :
                                  Container(
                                    height:
                                    MediaQuery.of(context).size.height/4+5
                                    ,
                                    padding: EdgeInsets.only(
                                        left: 17,
                                        right: 17,
                                        top: 11,
                                        bottom: 11),
                                    // padding: EdgeInsets.fromLTRB(17, 0, 30, 20),
                                    child:
                                    Container(
                                        alignment:Alignment.center,
                                        padding: EdgeInsets.fromLTRB(
                                            0, 0, 0, 6),
                                        child:Scrollbar(
                                            child:ListView(
                                              physics: ScrollPhysics(),

                                              shrinkWrap: true,
                                              children: [
                                                Text(
                                                  widget.indexRow!["offer_description"]
                                                      .toString().replaceAll("&quot;", "\n"),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 17
                                                  ),
                                                ),
                                              ],
                                            ))
                                      //
                                    ),
                                  ),

                                  SizedBox(height: 10,),


                                ],
                              )),
                        ),

                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              // color: Colors.red,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center,
                                  mainAxisAlignment: MainAxisAlignment
                                      .start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [


                                    tag == null ? Divider(height: 1,) :
                                    Center(
                                      child:
                                      Container(
                                        // height: 43,
                                        // color: Colors.red,
                                        padding: EdgeInsets.fromLTRB(
                                            20, 8, 20, 20),
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
                                                onTap: () {
                                                  print(tag[index]);
                                                  if (tag[index] ==
                                                      SetLocalization.of(context)!.getTranslateValue('info')) {
                                                    // Navigator.push(context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (
                                                    //             context) =>
                                                    //             OfferInfoScreen(
                                                    //               data_Item: data_Item,
                                                    //               offername: widget
                                                    //                   .offerName,)
                                                    //     ));
                                                  } else if (tag[index] ==
                                                      SetLocalization.of(
                                                          context)!
                                                          .getTranslateValue(
                                                          'location')) {
                                                    // MapUtils.openMap(double.parse(offer.offer.lat),double.parse(offer.offer.long));
                                                    // data_Item["main"][1]["info"][0]["longitude"] !=null  && data_Item["main"][1]["info"][0]["latitude"]
                                                    // openMap(double.parse(
                                                    //     data_Item!["main"][1]["info"][0]["longitude"]
                                                    //         .toString()),
                                                    //     double.parse(
                                                    //         data_Item!["main"][1]["info"][0]["latitude"]
                                                    //             .toString()));
                                                  } else if (tag[index] ==
                                                      SetLocalization.of(
                                                          context)!

                                                          .getTranslateValue(
                                                          'Menu')) {
                                                    // _launchURL(data_Item!["main"][2]["menus"][0]["offer_menus"]);
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
                                                            ? Color(0xff00838f)
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
                                                              ? Color(0xff00838f)
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
                                                  child: Text(tag[index].toString() == "info" ? "Branches & Categories"
                                                      :
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


                                    //
                                    // // animation  and small icon
                                    Container(
                                      // color: Colors.red,
                                      // height: MediaQuery.of(context).size.height/4,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        // mainAxisAlignment: MainAxisAlignment.end,
                                        children: [


                                          SizedBox(height: 20,),
                                          Visibility(
                                              visible:
                                              widget.indexRow!["small_icon"]==null?false:
                                              widget.indexRow!["small_icon"]
                                                  .isNotEmpty ? true :
                                              widget.indexRow!["small_icon"]
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
                                                        fontSize: 18,
                                                      ),),
                                                  ),

                                                  SizedBox(height: 10,),
                                                ],
                                              )
                                          ),

                                          //
                                          //
                                          Visibility(
                                            visible:
                                            widget.indexRow!
                                                .isNotEmpty ? true :
                                            widget.indexRow!["small_icon"]
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
                                                          itemCount:
                                                          widget.indexRow!["small_icon"]==null?0:
                                                          widget.indexRow!["small_icon"].toString()=="null"?0:
                                                          widget.indexRow!["small_icon"]
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
                                                                      imageUrl: "${ widget.indexRow!["small_icon"][position]}",
                                                                        placeholder: (context, url) => Container(),
                                                                        errorWidget: (context, url, error) => Image.asset("assets/images/no_image_avilable.png",height: 120,width:120,),

                                                                    ),
                                                                    ),
                                                                  //   FadeInImage(
                                                                  //     image: NetworkImage(
                                                                  //         data_Item!["main"][0]["images"][1]["small_icon"][position]["icon_url"]),
                                                                  //     placeholder: AssetImage(
                                                                  //         'assets/images/no_image_avilable.png'),
                                                                  //     // height: 50,
                                                                  //     fit: BoxFit
                                                                  //         .fill,
                                                                  //   ),
                                                                  //   // ),
                                                                  // ),

                                                                  // Container(
                                                                  //   height: 50,
                                                                  //   decoration: BoxDecoration(
                                                                  //     shape: BoxShape.circle,
                                                                  //   ),
                                                                  //   child:
                                                                  // FadeInImage(
                                                                  //   image: NetworkImage(
                                                                  //       data_Item["main"][0]["images"][1]["small_icon"][position]["icon_url"]),
                                                                  //   placeholder: AssetImage(
                                                                  //       'assets/images/no_image_avilable.png'),
                                                                  //   height: 50,
                                                                  //   fit: BoxFit.fill,
                                                                  // ),
                                                                  // ),

                                                                  SizedBox(
                                                                    width: 11,),
                                                                  // Text(
                                                                  //     "${data_Item["main"][0]["images"][1]["small_icon"][position]["name"]}"),

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
                              ),
                            )
                        )

                      ],
                    ),
                  )


                ],
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
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


}