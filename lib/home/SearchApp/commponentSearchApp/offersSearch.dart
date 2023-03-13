import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wineapp/backEndAndModels/model/DataSearchApp.dart';
import 'package:wineapp/home/item/OfferScreen.dart';
import 'package:wineapp/lang/localization/set_localization.dart';


class OffersSerach extends StatefulWidget {
 final  List<Offers> offers;
 final String idLcation;
  const OffersSerach({Key? key,required this.offers,required this.idLcation}) : super(key: key);

  @override
  _OffersSerachState createState() => _OffersSerachState();
}

class _OffersSerachState extends State<OffersSerach> {

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
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OfferScreen(
                            offerID: widget.offers[index].id.toString(),
                            offerName: widget.offers[index].name,
                            offerFavorite: widget.offers[index].favorite.toString(),
                            locationid_mal: widget.idLcation
                                .toString(),
                            direction: "offer",
                            indexrow: index,
                          ),
                    ));
                print(result.toString());
                print(result.toString());
                // if (result != null) {
                //   setState(() {
                //     // serachField.text="";
                //     // _filterCountries("");
                //   });
                //   print(
                //       "Back offer to home : >>>>>>>>>>>>>>  $result");
                //   try {
                //     _All_allOffer.clear();
                //     _All_allOffer.clear();
                //     _All_allOffer.clear();
                //   } catch (r) {}
                //   setState(() {
                //     serachField.text="";
                //   });
                //
                //   if (result["favorit"] != null &&
                //       result["directio"] == "offer") {
                //     setState(() {
                //       // serachField.text="";
                //       // _filterCountries("");
                //       _All_allOffer[int.parse(result["index"]
                //           .toString())]["favorite"] =
                //           result["favorit"].toString();
                //     });
                //   }
                //   // _onRefresh();
                // }
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

  Widget _getOffers(BuildContext context, Offers offers) {
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
                      imageUrl: offers.offerImg.toString(),
                      placeholder: (context, url) => Container(),
                      errorWidget: (context, url, error) =>Container(),
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
                    height: 82,
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
                                      offers.name.toString(),
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
                          ],
                        )),

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
                                          offers.offerDescription.toString().length>76 ?
                                          offers.offerDescription.toString().substring(0,76)+"...." :
                                          offers.offerDescription.toString()
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
                              child:  Container(
                                height: 54,
                                padding: EdgeInsets.only(right: 6),
                                width: MediaQuery.of(context).size.width/4.5,
                                child: ListView.builder(
                                  reverse: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                  offers.smallIcon!.isEmpty?0:
                                  offers.smallIcon!.length,
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
                                                  width: 34,
                                                  height: 34,
                                                  fit: BoxFit.fill,
                                                  // imageUrl: "_All_allOffer[inde",
                                                  imageUrl: offers.smallIcon![position].toString(),
                                                  placeholder: (context, url) => Container(),
                                                  errorWidget: (context, url, error) =>Container(),
                                                  // Image.asset("assets/images/no_image_avilable.png",height: 70,width:70,),
                                                ),

                                                // FadeInImage(
                                                //     image:
                                                //     NetworkImage(offers.smallIcon![position]),
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
                        SizedBox(height: 2,),

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
            )
          ],
        ),
      );
  }
}
