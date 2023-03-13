import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wineapp/home/item/OfferScreen.dart';

class SliderNewHome extends StatefulWidget{

  final List? all_slider;
  final String?id_location_id;
  final String? idCategry;
  final String? index_SubCategy_id;
  final String? index_categryAnd_SupCatigru;

  const SliderNewHome({Key? key, this.all_slider, this.id_location_id, this.idCategry, this.index_SubCategy_id, this.index_categryAnd_SupCatigru}) : super(key: key);

  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiSliderNewHome();
  }
}

class UiSliderNewHome extends State<SliderNewHome>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    addDataIntoSlider();
  }

  addDataIntoSlider(){

    setState(() {
      for (var i = 0; i < widget.all_slider!.length; i++)
        print("i>>>>>>>>>"+ widget.all_slider![i]["offer_img"]);
    });
    setState(() {
      for (var i = 0; i < widget.all_slider!.length; i++)
        pages.add(
            Container(
                height: 100,
                child: InkWell(
                    onTap: (){

                      print("Slider Image ");
                      Navigator
                          .push(context, MaterialPageRoute(builder: (context) => OfferScreen(
                        offerID: widget.all_slider![i]["trending_offer"].toString(),
                        offerName:widget.all_slider![i]["trending_name"],
                        locationid_mal: widget.id_location_id!.toString(),
                        id_Catigry: widget.idCategry!.toString(),
                        id_SubCatrgry: widget.index_SubCategy_id.toString(),
                        cat_id: widget.index_categryAnd_SupCatigru!.toString(),
                        trending: widget.all_slider![i]["trending_id"].toString(),
                        // offerFavorite:  _All_Slider[i]["favorite"]==null?null: _All_Slider[i]["favorite"],
                      )));
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
                                        image:  widget.all_slider![i]["offer_img"],
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
                                              "${widget.all_slider![i]["trending_name"].toString().replaceAll("\n", "ضسا")}",
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
                                              "${widget.all_slider![i]["offer_description"].toString().replaceAll("[&line;]", "\n")}"
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

                                        Row(
                                          children: List.generate(widget.all_slider![i]["small_icon"]==null?0:widget.all_slider![i]["small_icon"].length, (index) {
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
                                                            NetworkImage(widget.all_slider![i]["small_icon"][index])
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
        // print(">>>>>>>>>>"+_currentPage.toString());
        if (_currentPage < widget.all_slider!.length-1)
          // if (_currentPage < widget.events[0].eventsImg.length)
            {
        } else {
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


  var controlleree = PageController(initialPage: 0);
  late List<Widget> pages=[];
  Timer? timer;
  int _currentPage = 0;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}