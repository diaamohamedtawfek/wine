

import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:wineapp/lang/localization/set_localization.dart';

class WebViewExample extends StatefulWidget {
  final String? urlLink;
  final String? direction;
  final String lang;

  const WebViewExample({Key? key, this.urlLink, this.direction,required this.lang}) : super(key: key);
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getStringValuesSF();
  }
  String? langApp;
 Future<String> getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   bool checkValue = prefs.containsKey('lang');
   if(checkValue==false){
     // setState(() {
       langApp="en";
       return "en";
     // });

   }else{
     String? lang = prefs.getString('lang');
     print("idUser=> "+lang.toString());
     // setState(() {
       langApp=lang;
       return lang!;
       print(widget.urlLink!);
     // });
   }
    return "en";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar:
      widget.direction.toString()!="pop"?
      AppBar(
        backgroundColor: Color(0xff00838f),
        centerTitle: true,
        title: Text(
          (widget.direction.toString()=="aboutApp"?
          SetLocalization.of(context)!.getTranslateValue('nav_about_us'):
          widget.direction.toString()=="terms"?
          SetLocalization.of(context)!.getTranslateValue('nav_terms'):
          widget.direction.toString()=="joinus"?
          SetLocalization.of(context)!.getTranslateValue('nav_join'):
          SetLocalization.of(context)!.getTranslateValue('privacypolicy'))!
          ,
          style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
      ):null,


      body:
      Stack(
        children: <Widget>[
          SafeArea(
              child: WebView(
            // key: _key,
            // ignore: unnecessary_null_comparison
                allowsInlineMediaPlayback: true,
            debuggingEnabled: true,
            gestureNavigationEnabled: true,
            initialUrl:
            widget.direction.toString()=="pop"?
            '${widget.urlLink!}':
            '${widget.urlLink!}'+"${widget.lang}",
            // '${widget.urlLink!+"$langApp"}',
            javascriptMode: JavascriptMode.unrestricted,
            onWebResourceError: (e){
              print("????????");
              print(e.errorType);
              print(e.description);
              print(e.domain);
            },
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
                print(finish);
              });
            },
          )
          ),
          isLoading ? Center(child: CircularProgressIndicator(backgroundColor: Color(0x2900838f),
              valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff00838f),
              )))
              : Stack(),
        ],
      )
    );
  }
}
