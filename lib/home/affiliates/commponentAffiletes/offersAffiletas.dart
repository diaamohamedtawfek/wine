import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wineapp/backEndAndModels/model/DataAffiliates.dart';
import 'package:http/http.dart' as http;
import 'package:wineapp/home/drawearPage/wepNewWEP.dart';
import 'package:wineapp/lang/localization/set_localization.dart';

import '../../../startApp/Login.dart';


class OffersAffilets extends StatefulWidget {
 final  List<AffiliatesOffers> offers;
  const OffersAffilets({Key? key, required this.offers}) : super(key: key);

  @override
  _OffersAffiletsState createState() => _OffersAffiletsState();
}

class _OffersAffiletsState extends State<OffersAffilets> {

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


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.offers.isEmpty? notFoundStore(SetLocalization.of(context)!.getTranslateValue('no_offer')!)
            :
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.offers.isEmpty ? 0 : widget.offers.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () async {
                print("offer ");
                if(widget.offers[index].offerType.toString()=="redeem"){
                  popUpDilog(context,widget.offers[index].offerWebview,widget.offers[index].offerUrl);
                }else{
                  _launchURL(widget.offers[index].offerUrl);
                }

              },
              child: _getOffers(context, widget.offers[index]),
            );
          },
        )
      ],
    );
  }


  Widget notFoundStore(text){
    return Container(
      padding: EdgeInsets.only(
          bottom: 10
        // MediaQuery
        // .of(context)
        // .size
        // .height / 4
      ),
      child:
      Center(
          child: Text(
            // text
            ""
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

  Widget _getOffers(BuildContext context, AffiliatesOffers offer,) {
    return
      Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                // * -------------   image ----------------
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  width: 70,
                  height: 70,
                  child:   FittedBox(
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      // imageUrl: "_All_allOffer[inde",
                      imageUrl: offer.offerImg.toString(),
                      placeholder: (context, url) => Container(),
                      errorWidget: (context, url, error) =>  Container()
                          // Image.asset("assets/images/no_image_avilable.png",height: 70,width:70,),
                    ),
                  ),
                ),


                SizedBox(
                  width: 5,
                ),

                // * ------------- ---------------    Data ------
                Expanded(
                  child:Container(
                    height: 80,
                    padding: EdgeInsets.only(top: 2),
                    child:  Column(
                      children: <Widget>[

                        Expanded(child:
                        Row(
                          children: <Widget>[

                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child:Text(
                                      offer.offerName.toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.visible,
                                    ),
                                  )
                                ],
                              ),
                            ),


                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: Icon(
                                      offer.favorite.toString() == 'null' ? Icons.favorite_border :
                                      offer.favorite.toString() == '0' ? Icons.favorite_border :
                                      Icons.favorite,
                                      color:
                                      offer.favorite.toString() == '0' ? Colors.grey :
                                      offer.favorite.toString() == '1' ? Colors.red :
                                      Colors.grey,
                                    ),
                                    onTap: () {
                                      if (idUser != null) {
                                        if (offer.favorite.toString() == '1') {
                                          _sendItemData_favorite(direction: "un_fav",
                                              offerId: offer.offer_id,
                                              offer:offer
                                          );
                                          // client.addFavorite(PreferenceUtils.getUserEmail(), allOffer[index].id, PreferenceUtils.getUserSessionID()).then((value) => {if (value.statusCode != 200) {}});
                                        } else {
                                          _sendItemData_favorite(direction:"fav",
                                              offerId: offer.offer_id,
                                              offer:offer
                                          );
                                          // client
                                          //     .deleteFavorite(PreferenceUtils.getUserEmail(), allOffer[index].id, PreferenceUtils.getUserSessionID())
                                          //     .then((value) => {if (value.statusCode != 200) {}});
                                        }
                                      } else {
                                        sign_in(context);
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        ),

                        SizedBox(height: 6,),
                        Stack(
                          children: [

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[

                                Container(
                                  width: MediaQuery.of(context).size.width-110,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child:
                                        Text(

                                          offer.offerDescription.toString().length>76 ?
                                          offer.offerDescription.toString().substring(0,76)+"...." :
                                          offer.offerDescription.toString()
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


                            // * small Icon
                            Align(
                              alignment: langApp=="ar"?Alignment.bottomLeft:Alignment.bottomRight,
                              child:
                              // Container(
                              //   height: 27,
                              //   padding: EdgeInsets.only(right: 6),
                              //   width: 27,
                              //   child:
                              //
                              //   Container(
                              //     height: 27,
                              //     width: 27,
                              //     margin: EdgeInsets.only(left: 1,right: 1),
                              //     decoration: BoxDecoration(
                              //       shape: BoxShape.circle,
                              //       border: Border.all(color: const Color(0x33A6A6A6)),
                              //       boxShadow: [
                              //         BoxShadow(
                              //           color: Colors.grey.withOpacity(0.1),
                              //           spreadRadius: 1,
                              //           blurRadius: 1,
                              //           offset: Offset(0, 1), // changes position of shadow
                              //         ),
                              //       ],
                              //     ),
                              //     child: ClipOval(
                              //       child: FadeInImage(
                              //           image:
                              //           NetworkImage(offer.offerSmallIcon!),
                              //           width: 34,
                              //           height: 34,
                              //           placeholder: AssetImage('assets/images/no_image_avilable.png'),
                              //           fit: BoxFit.cover
                              //       ),
                              //     ),
                              //   ),
                              // ),



                              Container(
                                height: 47,
                                child:Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      height: 27,
                                      width: 27,
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
                                      child:  ClipRRect(
                                        borderRadius:BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          height: 27,
                                          width:27,
                                          fit: BoxFit.fill,
                                          imageUrl: offer.offerSmallIcon??"",
                                          placeholder: (context, url) => Container(),
                                          errorWidget: (context, url, error) => Container()
                                              // Image.asset("assets/images/no_image_avilable.png",height: 27,width:27,),
                                        ),
                                      )
                                  ),
                                ],
                              ),
                              ),
                            )
                          ],
                        ),



                        SizedBox(height: 2,),



                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsetsDirectional.only(top: 2, bottom: 2),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(height: 1,
                        color: Color(0x80000000)),
                  ),
                ],
              ),
            )
          ],
        ),
      );
  }


  _launchURL(url) async {
    if (await canLaunch(url))
      await launch(url);
    else
      // can't launch url, there is some error
      throw "Could not launch $url";
  }



  Future<void> popUpDilog(BuildContext context,url,shopUrl) async{
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

                                    Expanded(child: WepScreenNew(urlNoti: url,)),
                                    // Expanded(child: WebViewExample(direction: "pop",lang: langApp,urlLink: url,)),

                                    TextButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                          _launchURL(shopUrl);

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
                  child: Text(
                    SetLocalization.of(context)!.getTranslateValue('sign_in')!,
                    style: TextStyle(
                        color: Color(0xff00838f)
                    ),
                  ),
                  onPressed: () {
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


  Future<List?> _sendItemData_favorite({direction, offerId, AffiliatesOffers? offer}) async {
    late Map<String, Object> body;
    if(direction.toString()=="un_fav"){

      setState(() {
        body={"lang":langApp!,"userid":idUser??0,"offer_id":offerId,"action":"delete"};
        offer!.favorite="0";
      });

    } else if(direction.toString()=="fav"){


      setState(() {
        body={"lang":langApp!,"userid":idUser??0,"offer_id":offerId,"action":"add"};
        offer!.favorite="1";
      });
    }

    print(body);

    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(
      Uri.parse("http://wainsale.com/apps_api/offers/affiliates_favorite.php"),
      body: jsonBody,
      encoding: encoding,
      headers: headers,
    );
    var datauser = json.decode(response.body);
    print(datauser.toString());
    setState(() {
    });
    debugPrint(datauser.toString());
  }
}
