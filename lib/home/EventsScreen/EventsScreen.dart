
import 'dart:convert';

// import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wineapp/lang/localization/set_localization.dart';
import 'package:http/http.dart' as http;
import '../../URL_LOGIC.dart';

class EventsScreen extends StatefulWidget {

  final List? events;
  final String? nameMAl;
  EventsScreen({Key? key,this.events,this.nameMAl,}) : super(key: key);


  @override
  _EventsScreenState createState() => _EventsScreenState();
}


class _EventsScreenState extends State<EventsScreen> {

  final controller = PageController(initialPage: 0);
  late List<Widget> pages=[] ;
  // List<Widget> pages = List<Widget>();
  Timer? timer;
  int _currentPage = 0;


  List _All_dataService=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // pages= List<Widget>();
    _login();

    getStringValuesSF();

    addDataIntoSlider();


    try {
      setState(() {
        _All_dataService = widget.events![1]["service"];
      });
    }catch(e){}

    print(widget.events.toString());
  }


  Future _login() async {

    try{
      Map<String, dynamic> body = {
        "event_id":widget.events![2]["event_id"][0],
      };
      print(body.toString());


      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(Uri.parse(URL_LOGIC.click_event!),
        body:jsonBody,
        encoding: encoding,
        headers: headers,
      );
      print("body is <<<:"+body.toString());
      print("Url is <<<:"+URL_LOGIC.click_event!);
      debugPrint("response.body click_event>>> "+response.body.toString());


    }catch(exception){
      print("exception   ${exception.toString()}");
    }
  }




  // String idUsers;
  String? langApp;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('lang');

    setState(() {
      langApp=lang;
    });
  }


  List? image_slider;
  addDataIntoSlider(){
    try {
      image_slider = widget.events![0]["events"][0]["image_url"];
      print("image >>>>>>>>>>>  ${image_slider!.length}");

      setState(() {
        for (var i = 0; i < image_slider!.length; i ++)
          // for (var i = 0; i < widget.events[0].eventsImg.length; i ++)
            {
          pages.add(
            FittedBox(
              fit: BoxFit.fill,
              child: CachedNetworkImage(
                // height: 20,
                // width:20,
                fit: BoxFit.fill,
                imageUrl: "${image_slider![i]}",
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) =>
                    Image.asset(
                      "assets/images/no_image_avilable.png", height: 20,
                      width: 20,),
              ),
            ),
          );
        }
      });

      timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
        if (_currentPage < image_slider!.length - 1)
          // if (_currentPage < widget.events[0].eventsImg.length)
            {
          print("\n");
          print("\n");
          // print(_currentPage++);
          print("\n");
          print("\n");
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        try {
          controller.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        } catch (e) {

        }
      });
    }catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
     return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff00838f),
        centerTitle: true,
        title: Text(SetLocalization.of(context)!.getTranslateValue('event_services')!,style: TextStyle(color: Colors.white,
            fontSize: 18),),
      ),
      
      body:  Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // SizedBox(height: 10,),

            // ignore: unnecessary_null_comparison
            pages==null?Container():
            image_slider==null?Container():
            image_slider!.isEmpty?Container():
            Container(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child:PageView(
                  children: pages,
                  controller: controller,
                ),


                // SliderOffer(),
              ),
            ),
            SizedBox(height: 10,),

            image_slider==null?Container():
            controller==null?Container():
            image_slider!.length==0?Container():
            Container(
              child: Center(
                child: SmoothPageIndicator(
                  controller: controller,
                  count: image_slider!.length>0?image_slider!.length:0,
                  onDotClicked: (index){
                    print(index);

                  },
                  effect: WormEffect(
                      activeDotColor: Color(0xff00838f),
                      dotColor: Color(0x4000838f),
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 5
                  ),
                ),
              ),
            ),




            SizedBox(height: 10,),
            Container(
              padding:  EdgeInsets.only(right: 10,left: 10),
              width: MediaQuery.of(context).size.width,
              height: 50,
              color: Color(0xff00838f),
              child: Align(
                alignment: langApp =="en"? Alignment.centerLeft:Alignment.centerRight,
                child: Text(SetLocalization.of(context)!.getTranslateValue('service_of')!+' ${widget.nameMAl}',
                  style: TextStyle(fontSize: 17,
                      color: Colors.white),),
              ),
            ),


            _All_dataService==null?Text("") :
            _All_dataService.isEmpty?Text("") :
            Container(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Column(
                children: List.generate(_All_dataService.length, (index) {
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            // FadeInImage(
                            //   imageErrorBuilder:
                            //     (context, error, stackTrace) {
                            //   return Image.asset(
                            //       'assets/images/logo2.png',
                            //       fit: BoxFit.fitWidth,height: 20,width: 20,);
                            // },
                            //   image: NetworkImage(_All_dataService[index]["icon"]),height: 20, width: 20,
                            //   placeholder: AssetImage('assets/images/no_image_avilable.png'),
                            // ),

                            FittedBox(
                              child: CachedNetworkImage(
                                height: 20,
                                width:20,
                                fit: BoxFit.fill,
                                imageUrl: "${_All_dataService[index]["icon"]}",
                                placeholder: (context, url) => Container(),
                                errorWidget: (context, url, error) => Image.asset("assets/images/no_image_avilable.png",height: 20,width:20,),
                              ),
                              // FadeInImage(
                              //   image: NetworkImage(_All_Item[index]["offer_img"]),
                              //   placeholder: AssetImage('assets/images/no_image_avilable.png'),
                              // ),
                              fit: BoxFit.fill,
                            ),

                            SizedBox(width: 15,),
                            Expanded(child:
                            Text(_All_dataService[index]["name"],
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xa6000000),
                              ),
                              maxLines: 2,
                            ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                      )
                    ],
                  );
                }),
              ),
            )
          ],
        ),
      )
      
    );
  }





  @override
  void dispose() {
    timer!.cancel();
    controller.dispose();
    super.dispose();

  }


}