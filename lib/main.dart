

import 'package:cron/cron.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wineapp/startApp/SplashScrean.dart';
import 'lang/localization/set_localization.dart';

import 'package:http/http.dart' as http;




Widget buildError(BuildContext context, FlutterErrorDetails error) {
  return Scaffold(
    appBar: AppBar(title: Text(""),
      backgroundColor: Color(0xff4f008d),
      iconTheme: new IconThemeData(color: Color(0xffffffff)),
      elevation: 2.0,
    ),
    body: Center(
      child: Text(
        "Error appeared.",
        style: Theme.of(context).textTheme.subtitle2,
      ),
    ),
  );
}


Future<void> callbackDispatcher() async {
  print("service");

    print("granted Main");
  String? token = '';
  // String? email = '';
  String? idUser;
  var long;
  var lang;
    try {

      geolocator.Position position = await geolocator.Geolocator
          .getCurrentPosition(
          desiredAccuracy: geolocator.LocationAccuracy.high);
      lang = position.latitude;
      long = position.longitude;
      final SharedPreferences prefs = await SharedPreferences?.getInstance();
      token = (prefs.get("token") ?? "") as String?;
      idUser = prefs.getString('userid');


        try{
          await http.get(
              Uri.parse("https://wainsale.com/apps_api/firebase.php?lang=en&token=$token&send_notification=1&latitude=$lang&longitude=$long&userid=$idUser")
          ).then((value)  {
            print('https://wainsale.com/apps_api/firebase.php?lang=en&token=$token&send_notification=1&latitude=$lang&longitude=$long&userid=$idUser');

            print(value.statusCode);
            print('response body : ${value.body.toString()}');
            //
            // Map? dataItem = json.decode(value.body);
          }).catchError((onError){
            print("::::::::::::::::::::${onError.toString()}");
          });
          print("Native called lang= $lang and long = $long");
        }catch(e){
          print(e.toString());
          print(":::::????????:::::::${e.toString()}");
        }
        // email = await prefs.get("USER_EMAIL") ?? "";
      } catch (err) {
        print(err);
      }



    print("\n\n\n\n\n");
    print(" token $token \n  lang $lang \n long $long");
    print("\n\n\n\n\n");

}


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  // 'This channel is used for important notifications.', // description
  importance: Importance.high,
);

Future<void> main()  async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // callbackDispatcher();
  //   try{
  //     final cron = Cron();
  //     cron.schedule(Schedule.parse('*/15 * * * *'), () async {
  //       print('every one minutes???????????');
  //       // callbackDispatcher();
  //     });
  //     cron.schedule(Schedule.parse('1-2 * * * *'), () async {
  //       print('between every 8 and 11 minutes');
  //     });
  //
  //   }catch(e){}
  //
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );


  runApp(MyApp(),);


}






class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    UIMyApp state = context.findAncestorStateOfType<UIMyApp>()!;
    state.setLocale(locale);
  }


  // @override
  // State<StatefulWidget> createState() {
  //   return UIMyApp();
  // }

  @override
  UIMyApp createState() => UIMyApp();
}



class UIMyApp extends State<MyApp>{
  Locale? _local;

  void setLocale(Locale locale) {
    setState(() {
      _local = locale;
    });
  }



  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'wain',
        theme: ThemeData(
          primaryColor: Color(0xFF00838f),
          primarySwatch: Colors.blue,
          // primarySwatch: Colors.blue,
        ),

        locale: _local,
        // onGenerateRoute: CustomRoute.allRoutes,
        // initialRoute: homeRoute,
        // use with all error on screen
        builder: (BuildContext? context, Widget? widget) {
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return buildError(context!, errorDetails);
          };

          return widget!;
        },
        // use with lang
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ar', 'EG')
        ],
        localizationsDelegates: [
          SetLocalization.localizationsDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // localeResolutionCallback: (deviceLocal, supportedLocales) {
        //   for(var local in supportedLocales) {
        //     if(local.languageCode == deviceLocal!.languageCode && local.countryCode == deviceLocal.countryCode) {
        //       return deviceLocal;
        //     }
        //   }
        //   return supportedLocales.first;
        // },
        // home: X(),
        // home: Login(),
        // home: SignInDemo(),
        // home: MyAppList(),
        home: SplashScrean(),
    );
  }
}

class X extends StatefulWidget {
  const X({Key? key}) : super(key: key);

  @override
  _XState createState() => _XState();
}

class _XState extends State<X> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("datadatadata"),
      ),
    );
  }
}






