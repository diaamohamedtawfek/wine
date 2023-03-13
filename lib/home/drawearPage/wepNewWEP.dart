import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';



class WepScreenNew extends StatefulWidget {

  final String urlNoti;

  const WepScreenNew({Key? key,required this.urlNoti}) : super(key: key);
  @override
  _InAppWebViewExampleScreenState createState() =>
      new _InAppWebViewExampleScreenState();
}




class _InAppWebViewExampleScreenState extends State<WepScreenNew> {

  final GlobalKey webViewKey = GlobalKey();


  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));




  late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;
  String? url ;
  String urlstart = "";
  double progress = 0;
  final urlController = TextEditingController();

  Map _source = {ConnectivityResult.none: true};


  // *  showNativeApp = 0;
  int? showNativeApp;

  @override
  void initState() {
    super.initState();
    url=widget.urlNoti;

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );

  }

  var appLinker;

  Future<bool> _exitApp(BuildContext context) async {
    webViewController!.goBack();
    return Future.value(true);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int ceckNetNummer=0;
  bool neterroro=true;



  @override
  Widget build(BuildContext context) {
    print(_source.keys.toList()[0]);
    // ceckNet();
    //  * Bailed  Home >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return
       SafeArea(
           top: false,
           bottom: false,
           child:  Directionality(
           textDirection: TextDirection.rtl,
           child: WillPopScope(
               onWillPop: () => _exitApp(context),
               child:Scaffold(
                   backgroundColor: Colors.white,
                   key: _scaffoldKey,

                   body:
                   SafeArea(
                       top: false,
                       bottom: false,
                       child:
                       Column(children: <Widget>[
                         Expanded(
                           child: Stack(
                             children: [


                               Container(
                                   padding: EdgeInsets.all(0.0),
                                   child: progress < 1.0
                                       ? Center(
                                     child: CircularProgressIndicator(),)
                                       : Container()),



                               InAppWebView(
                                 onLongPressHitTestResult: (controller, hitTestResult) => {
                                   print(hitTestResult.toString())
                                 },
                                 key: webViewKey,
                                 initialUrlRequest:URLRequest(url: Uri.parse(url??"")),
                                 initialUserScripts: UnmodifiableListView<
                                     UserScript>([
                                 ]),
                                 initialOptions: options,

                                 pullToRefreshController: pullToRefreshController,
                                 onWebViewCreated: (controller) {
                                   webViewController = controller;
                                 },
                                 onLoadStart: (controller, url) {
                                   setState(() {
                                     // this.url = url.toString();
                                     // urlController.text = this.url;
                                   });
                                 },
                                 androidOnPermissionRequest: (controller, origin,
                                     resources) async {
                                   return PermissionRequestResponse(
                                       resources: resources,
                                       action: PermissionRequestResponseAction
                                           .GRANT);
                                 },

                                 shouldOverrideUrlLoading: (controller,
                                     navigationAction) async {
                                   var uri = navigationAction.request.url!.toString();
                                   print("||||||||||||||||" + uri.toString());

                                   // *  ??????????????????????????????????????????????????????????????????????
                                   // var _canLoad = urls.where((item) =>
                                   //     navigationAction.request.url!
                                   //         .toString().startsWith(item)).toList();

                                   if (url.toString()!=navigationAction.request.url!.toString()) {
                                     print("_canLoad.length");
                                     if(uri.contains("tel:")){

                                     }
                                     _launchURLgg(uri);
                                     print(uri);
                                     return NavigationActionPolicy.CANCEL;
                                   } else {
                                     print(
                                         "000000000000000000000000000000000000000000000");
                                     return NavigationActionPolicy.ALLOW;
                                   }
                                 },


                                 onLoadStop: (controller, url) async {
                                   // addClipboardHandlersOnly(webViewController!);

                                   pullToRefreshController.endRefreshing();
                                   // setState(() {
                                   //   this.url = url.toString();
                                   //   urlController.text = this.url!;
                                   // });
                                 },
                                 onLoadError: (controller, url, code, message) {
                                   print(message.toString()+">>>>> eerrorrr >>>>>>>>");
                                   print(code.toString()+">>>>> eerrorrr >>>>>>>>");
                                   pullToRefreshController.endRefreshing();
                                 },
                                 onProgressChanged: (controller, progress) {
                                   if (progress == 100) {
                                     pullToRefreshController.endRefreshing();
                                   }
                                   setState(() {
                                     this.progress = progress / 100;
                                     urlController.text = url!;
                                   });
                                 },
                                 onUpdateVisitedHistory: (controller, url,
                                     androidIsReload) {
                                   // setState(() {
                                   //   this.url = url.toString();
                                   //   urlController.text = this.url!;
                                   // });
                                 },
                                 onConsoleMessage: (controller, consoleMessage) {
                                   print(consoleMessage);
                                 },
                               ),


                             ],
                           ),
                         )
                       ]
                       )
                   )
               )// * body App >>>>>>>>>>>>>>>>>>>>
           )
       )

    )
    ;
  }



  _launchURLgg(urls) async {
    print("?????????????????");
    if (await canLaunch(urls)) {
      if(Platform.isIOS){
        await launch(urls,forceSafariVC: false,);
      }else{
        await launch(urls);
    }
    } else {
      print(">>>>>>>>>>>>>>>>>>>");
      throw 'Could not launch $urls';
    }
  }

}
