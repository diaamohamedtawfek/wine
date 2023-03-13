import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wineapp/lang/localization/set_localization.dart';



class OfferInfoScreen extends StatefulWidget {
  Map? data_Item;
  String? offername;

  OfferInfoScreen({Key? key, this.data_Item, this.offername,}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UnOfferInfoScreen();
  }
}

class UnOfferInfoScreen extends State<OfferInfoScreen> {

  final controller = PageController(initialPage: 0);
  late List<Widget> pages=[] ;
  // List<Widget> pages =  List<Widget>();
  // Timer? timer;
  // int _currentPage = 0;

  String replaced="";
  @override
  void initState() {
    super.initState();
    addDataIntoSlider();

    String xx=widget.data_Item!["main"][1]["info"][0]["opening hours"].toString();
    setState(() {
      // replaced = xx.replaceFirst(RegExp('TO'), '\n');
      replaced = xx.replaceAll('To ', '\n');
    });

    print("replaced  >"+replaced.toString());
    print("phone  >"+widget.data_Item!["main"][1]["info"][0]["phone"].toString());
  }
  bool showSlider=false;
  late List<String> tag ;
  addDataIntoSlider() {
    setState(() {
      for (var i = 0; i <widget.data_Item!["main"][0]["images"][0]["image_url"].length; i ++)
        // for (var i = 0; i < widget.events[0].eventsImg.length; i ++)
          {
        pages.add(FittedBox(
          child: FadeInImage(
            image: NetworkImage(
                widget.data_Item!["main"][0]["images"][0]["image_url"][i]),
            // image: NetworkImage(widget.events[0].eventsImg[i]),
            placeholder: AssetImage('assets/images/no_image_avilable.png'),
          ),
          fit: BoxFit.fill,
        ),
        );
      }
    });


    // timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
    //   if (_currentPage < widget.data_Item!["main"][0]["images"][0]["image_url"].length)
    //     // if (_currentPage < widget.events[0].eventsImg.length)
    //       {
    //     _currentPage++;
    //   } else {
    //     _currentPage = 0;
    //   }
    //
    //   try {
    //     controller.animateToPage(
    //       _currentPage,
    //       duration: Duration(milliseconds: 350),
    //       curve: Curves.easeIn,
    //     );
    //   } catch (e) {
    //
    //   }
    // });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff00838f),
        centerTitle: true,
        title: Text(widget.offername!,
          style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
      ),

      body: ListView(
        padding: EdgeInsets.only(bottom: 12),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [

          dataStore(),


          Visibility(
                  visible: widget.data_Item!["main"][4]["locations_offers"]==null?false:true,
                  child:textTypeStore(SetLocalization.of(context)!.getTranslateValue('StoreBranches')!)
                ),

          // * ---------------  StoreBranches  ------------------
          Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              Center(
                                child: Container(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                      spacing: 15.0,
                                      runSpacing: 15.0,
                                      children: List.generate(
                                        widget.data_Item!["main"][4]["locations_offers"]==null?0:
                                        widget.data_Item!["main"][4]["locations_offers"].length==0?0:
                                        widget.data_Item!["main"][4]["locations_offers"].length, (index) =>
                                          Container(
                                            padding: EdgeInsets.all(10),

                                            child: Text(
                                              widget.data_Item!["main"][4]["locations_offers"][index]["location_name"] ,
                                              style: TextStyle(color: Colors.black, fontSize: 13),
                                              textAlign: TextAlign.center,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(25),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(color: Color(0xff00838f), spreadRadius: 2),
                                              ],
                                            ),

                                          ),
                                      )
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                    )
                  ],
                ),

          SizedBox(height: 20,),


          // * --------------- Store Categories * ---------------
          Visibility(
                    visible: widget.data_Item!["main"][5]["categories_offers"]==null?false:true,
                      child: textTypeStore(SetLocalization.of(context)!.getTranslateValue('StoreCategories')!)
                ),
          Container(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Center(
                            child: Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 15.0,
                                  runSpacing: 15.0,
                                  children: List.generate(
                                    widget.data_Item!["main"][5]["categories_offers"]==null?0:
                                    widget.data_Item!["main"][5]["categories_offers"].length==0?0:
                                    widget.data_Item!["main"][5]["categories_offers"].length, (index) => Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      widget.data_Item!["main"][5]["categories_offers"][index]["category_name"] ,
                                      style: TextStyle(color: Colors.black, fontSize: 13),
                                      textAlign: TextAlign.center,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(color: Color(0xff00838f), spreadRadius: 2),
                                      ],
                                    ),

                                  ),)
                              ),
                            ),
                          ),
                        ],
                      )
                  ),

        ],
      ),
    );
  }
  _launchCaller(String phone) async {
    var url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  dataStore() {
    return Column(
      children: [
        // Container(
        //   padding: EdgeInsets.only(top: 5, left: 22,right: 22),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text(SetLocalization.of(context)!.getTranslateValue('open_hour')!,
        //       style: TextStyle(
        //         // fontWeight: FontWeight.bold
        //       ),
        //       ),
        //
        //     ],
        //   ),
        // ),

        // Container(
        //   padding: EdgeInsets.only(top: 5, left: 22,right: 22),
        //   child:Text(
        //     replaced.toString() ,
        //     maxLines: 4,
        //     textAlign: TextAlign.start,
        //   ) ,
        // ),
        // Container(
        //   padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
        //   child: Divider(
        //     color: Colors.black,
        //   ),
        // ),


        // Visibility(
        //   visible:
        //   widget.data_Item!["main"][1]["info"][0]["phone"].toString().isEmpty?false :
        //   widget.data_Item!["main"][1]["info"][0]["phone"].toString()==""?false :
        //   widget.data_Item!["main"][1]["info"][0]["phone"].toString().length < 1?false :
        //   widget.data_Item!["main"][1]["info"][0]["phone"].toString().length > 3?true :
        //   widget.data_Item!["main"][1]["info"][0]["phone"].toString() =="null"?false
        //       : false,
        //   child: Container(
        //     padding: EdgeInsets.only( left: 22,right: 22),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(SetLocalization.of(context)!.getTranslateValue('phone')!),
        //         GestureDetector(
        //             onTap: (){
        //               _launchCaller(widget.data_Item!["main"][1]["info"][0]["phone"]);
        //             },child: Container(child: Text(widget.data_Item!["main"][1]["info"][0]["phone"].toString()))),
        //       ],
        //     ),
        //   ),
        // ),
        //
        // Visibility(
        //   visible:
        //   widget.data_Item!["main"][1]["info"][0]["phone"].toString().isEmpty?false :
        //   widget.data_Item!["main"][1]["info"][0]["phone"].toString()==""?false :
        //   widget.data_Item!["main"][1]["info"][0]["phone"].toString().length < 1?false :
        //   widget.data_Item!["main"][1]["info"][0]["phone"].toString().length > 3?true :
        //   widget.data_Item!["main"][1]["info"][0]["phone"].toString() =="null"?false
        //       : false,
        //   child: Container(
        //     padding: EdgeInsets.fromLTRB(22, 16, 22, 16),
        //     child: Divider(
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
        //
        //
        // Visibility(
        //   visible:
        //   // widget.data_Item["main"][1]["info"][0]["email"].toString().isEmpty?false :
        //   widget.data_Item!["main"][1]["info"][0]["email"].toString()==""?false :
        //   widget.data_Item!["main"][1]["info"][0]["email"].toString().length < 1?false :
        //   widget.data_Item!["main"][1]["info"][0]["email"].toString().length > 3?true :
        //   widget.data_Item!["main"][1]["info"][0]["email"].toString() =="null"?false
        //       : false ,
        //   child: Container(
        //     padding: EdgeInsets.only( left: 22,right: 22),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(SetLocalization.of(context)!.getTranslateValue('email')!),
        //         Text(widget.data_Item!["main"][1]["info"][0]["email"].toString()),
        //       ],
        //     ),
        //   ),
        // ),
        //
        // Visibility(
        //   visible: widget.data_Item!["main"][1]["info"][0]["phone"].toString().length  > 2,
        //   child: Container(
        //     padding: EdgeInsets.fromLTRB(22, 16, 22, 0),
        //     child: Divider(
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
        //

        // SizedBox(height: 400,),
      ],
    );
  }

  textTypeStore(text) {
    return
      // //Store Branches
      Container(
        padding: EdgeInsets.only(top: 20, left: 22, right: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 8),
              child: Center(
                child: Text(text, style: TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                ),
                ),
              ),
            ),

          ],
        ),

      );
  }
}
