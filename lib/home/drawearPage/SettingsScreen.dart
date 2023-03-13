import 'dart:convert';
import 'package:ars_dialog/ars_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wineapp/home/drawearPage/AcountInfoScreenNew.dart';
import 'package:wineapp/home/drawearPage/ResetPassword.dart';
import 'package:wineapp/lang/localization/set_localization.dart';
import 'package:wineapp/main.dart';
import 'package:wineapp/startApp/Login.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../URL_LOGIC.dart';
import 'ChangeCity.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key, this.title}) : super(key: key);
  String? title;
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool englishIsChecked = false;
  bool arabicIsChecked = false;
  // String selectedCity = '1';
  String selectedName = 'Loading';
  late Map<String, dynamic> map;


  bool? isChecked=true ;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(">?>?>"+widget.title.toString());
  }
  @override
  void didUpdateWidget(SettingsScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print(">?>?>"+widget.title.toString());
  }

  CustomProgressDialog? progressDialog;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    progressDialog = CustomProgressDialog(context,blur: 10);

    getStringValuesSF();
    print(widget.title);
  }


  String idcity="";
  String namecity="";

  String? idUsers;
  String? langApp;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    bool checkValue = prefs.containsKey('lang');
    String? lang = prefs.getString('lang');
    String? idUser = prefs.getString('userid');
    // print("idUser=> "+lang.toString());

    setState(() {
      idUsers=idUser;
      langApp=lang;

      if(idUsers!=null){
        getData_User();
      }
    });
//    return stringValue;
  }


  Map? data_User;
  List _All_City=[];

  Future getData_User() async {

    Map<String, String> timeOutMessage = {
      'state': 'timeout',
      'content': 'server is not responding'
    };
    // offer
    Map<String, Object> body = {
      "lang":langApp!,
      "action":"view",
      "userid":idUsers!
    };
    print("body is :"+body.toString());
    print("url is :"+URL_LOGIC.accountInfo_Setting.toString());
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};

    http.Response response_offer = await http.post(
      Uri.parse(URL_LOGIC.accountInfo_Setting!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    data_User = json.decode(response_offer.body);

//    userData_offer = data_offer["bestseller"];


    setState(() {
      print(data_User.toString());
      data_User = json.decode(response_offer.body);

      setState(() {
        idcity=data_User!["main"][1]["settings_info"][0]["city"];
        namecity=data_User!["main"][1]["settings_info"][0]["cityname"];
        print("_allCity  "+data_User!["main"][1]["settings_info"].toString());

        _All_City.addAll(data_User!["main"][0]["city"]);

        if(data_User!["main"][1]["settings_info"][0]["notification"].toString() =="1"){
          setState(() {
            isChecked=true;
          });
        }else if(data_User!["main"][1]["settings_info"][0]["notification"].toString()=="0"){
          setState(() {
            isChecked=false;
          });
        }
        print("_allCity  "+_All_City.toString());
      });

      // print("Nationality "+_All_nationality.toString());
    });
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      } ,
      child: Scaffold(

        appBar: AppBar(
          centerTitle: true,
          title: Text(
            SetLocalization.of(context)!.getTranslateValue('nav_settings')!,
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xff00838f),
        ),
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(left: 20,right: 20,top:35,bottom: 5 ),
              children: <Widget>[

                // account
                InkWell(
                  onTap: ()=>{
                    Navigator
                        .push(context, MaterialPageRoute(builder: (context) => AcountInfoScreenNew())),
                  },
                  child:  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                          SetLocalization.of(context)!.getTranslateValue('nav_settings_account')!,
                          style: const TextStyle(
                              color:  const Color(0xff000000),
                              fontWeight: FontWeight.w400,
                              fontFamily: "SFProText",
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0
                          ),
                          textAlign: TextAlign.center
                      ),

                      Icon(Icons.arrow_back_ios,textDirection:langApp=="ar"?TextDirection.ltr:TextDirection.rtl,color: Colors.black,size: 20,),

                    ],
                  ),
                ),




                SizedBox(height: 25,),

                // re password
                InkWell(
                  onTap: ()=>{
                    if(idUsers==null){
                      sign_in()
                    }else{
                      Navigator
                          .push(context, MaterialPageRoute(builder: (context) => ResetPassword())),
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                          SetLocalization.of(context)!.getTranslateValue('nav_settings_pass')!,
                          style: const TextStyle(
                              color:  const Color(0xff000000),
                              fontWeight: FontWeight.w400,
                              fontFamily: "SFProText",
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0
                          ),
                          textAlign: TextAlign.center
                      ),

                      Icon(Icons.arrow_back_ios,textDirection: langApp=="ar"?TextDirection.ltr:TextDirection.rtl,color: Colors.black,size: 20,),

                    ],
                  ),
                ),




                SizedBox(height: 25,),
                InkWell(
                  onTap: ()=>
                  {
                     showDialog<String>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Container(
                          height: 130,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 4,
                              color: Color(0xff00838f),
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white,
                          ),
                          child: Container(
                            // color: Colors.red,
                            padding: EdgeInsets.only(left: 15,right: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Expanded(
                                    child:Directionality(
                                        textDirection: TextDirection.ltr,
                                        child:  Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[

                                            Text(
                                                SetLocalization.of(context)!.getTranslateValue('delete_your_account1')!,
                                                style: const TextStyle(
                                                    color:  const Color(0xff000000),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "SFProText",
                                                    fontStyle:  FontStyle.normal,
                                                    fontSize: 16.0
                                                ),
                                                textAlign: TextAlign.center
                                            ),

                                            SizedBox(height: 15,),
                                            Row(
                                              children: [
                                                Expanded(child: InkWell(
                                                  onTap: (){
                                                    Navigator.pop(context);
                                                  },
                                                  child:  Container(
                                                    height: 40,
                                                    padding: EdgeInsets.only(left: 5,right: 5),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 1,
                                                        color: Color(0xff00838f),
                                                      ),
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      color: Colors.red,
                                                      // color: Color(0xff00838f),
                                                    ),
                                                    child: Center(child: Text("no",style: TextStyle(color: Colors.white)),),
                                                  ),
                                                ),
                                                ),


                                                SizedBox(width: 11,),

                                                Expanded(child: InkWell(

                                                  onTap: (){
                                                    Navigator.pop(context);
                                                    _delete_your_account();

                                                  },
                                                  child:  Container(
                                                    padding: EdgeInsets.only(left: 5,right: 5),
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 4,
                                                        color: Color(0xff00838f),
                                                      ),
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      color: Color(0xff00838f),
                                                    ),
                                                    child: Center(child:Text(SetLocalization.of(context)!.getTranslateValue('yes')!,
                                                      style: TextStyle(color: Colors.white),)),
                                                  ),
                                                ),
                                                ),
                                              ],
                                            ),

                                          ],

                                        )
                                    )
                                ),
                              ],
                            ),
                          )
                        ),
                      );
                    },
                  ).whenComplete(() =>
                  {
                    setState(() {

                    })
                  })
                  },
                  child:  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                          SetLocalization.of(context)!.getTranslateValue('delete_your_account')!,
                          style: const TextStyle(
                              color:  const Color(0xff000000),
                              fontWeight: FontWeight.w400,
                              fontFamily: "SFProText",
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0
                          ),
                          textAlign: TextAlign.center
                      ),


                    ],
                  ),
                ),


                SizedBox(height: 25,),

                Divider(height: 1,color: Color(0x80707070),),

                SizedBox(height: 25,),

                // lang
                InkWell(

                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder: (context, setState) {

                            if(langApp=="ar") {
                              setState(() {
                                _groupValue = 1;
                              });
                            }
                            else if(langApp=="en"){
                              setState(() {
                                _groupValue=0;
                              });
                            }else{
                              setState(() {
                                _groupValue=0;
                              });
                            }
                            return AlertDialog(
                              title: Center(
                                child: Text(SetLocalization.of(context)!.getTranslateValue('nav_settings')!),
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                              content:Container(
                                height: 120,
                                child: gender(),
                              ),
                            );
                          });
                        });

                  },
                  child:  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
//العربية,,English
                      Text(
                          SetLocalization.of(context)!.getTranslateValue('nav_settings_lang')!,
                          style: const TextStyle(
                              color:  const Color(0xff000000),
                              fontWeight: FontWeight.w400,
                              fontFamily: "SFProText",
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0
                          ),
                          textAlign: TextAlign.center
                      ),

                      Text(
                          langApp=="en"?"English":
                          langApp=="ar"?"العربية":
                          "English",
                          style: const TextStyle(
                              color:  const Color(0xff00838f),
                              fontWeight: FontWeight.w400,
                              fontFamily: "SFProText",
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0
                          ),
                          textAlign: TextAlign.center
                      ),

                    ],
                  ),
                ),


                SizedBox(height: 25,),


                // city
                cityWdgit(),


                SizedBox(height: 25,),

                Divider(height: 1,color: Color(0x80707070),),

                SizedBox(height: 25,),

                // nav_settings_notifiy
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
//العربية,,English
                    Text(
                        SetLocalization.of(context)!.getTranslateValue('nav_settings_notifiy')!,
                        style: const TextStyle(
                            color:  const Color(0xff000000),
                            fontWeight: FontWeight.w400,
                            fontFamily: "SFProText",
                            fontStyle:  FontStyle.normal,
                            fontSize: 16.0
                        ),
                        textAlign: TextAlign.center
                    ),

                    // idUsers==null?Text("")  :
                    // isChecked==null?Text("")  :
                    Switch(
                      onChanged: (val) {
                        print(val);

                        _updateNotification(isChecked==true ? '0' : '1');
                        // setState(() {
                        //   isChecked = !isChecked;
                        // });
                        // client.updateNotfication(PreferenceUtils.getUserEmail(), PreferenceUtils.getUserSessionID(), isChecked ? '1' : '0').then((value) => {

                        },

                      value:  isChecked==true?true : false,
                      activeTrackColor: Color(0x3D00838f),
                      activeColor: Color(0xff00838f),
                    )
                  ],
                ),


                SizedBox(height: 25,),

              ],
            ),

            // TipDialogContainer(
            //     duration: const Duration(seconds: 2),
            //     outsideTouchable: true,
            //     onOutsideTouch: (Widget tipDialog) {
            //       if (tipDialog is TipDialog &&
            //           tipDialog.type == TipDialogType.LOADING) {
            //         TipDialogHelper.dismiss();
            //       }
            //     }
            // ),
          ],
        ),
      ),
    );
  }


  Future<void> sign_in() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(SetLocalization.of(context)!.getTranslateValue('error')!),
          content: Text(SetLocalization.of(context)!.getTranslateValue('sign_in_err')!),
          actions: <Widget>[
            FlatButton(
              child: Text(SetLocalization.of(context)!.getTranslateValue('sign_in')!),
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
        );
      },
    );
  }

  List genderlist=["English","العربية"];
  int? _groupValue ;
  Widget gender(){

    return Container(
      // color: Colors.red,
      padding: EdgeInsets.only(left: 15,right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
              child:Directionality(
                  textDirection: TextDirection.ltr,
                  child:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Transform(
                    transform: langApp=="en"?
                    Matrix4.translationValues(-20.0, 0.0, -20.0):Matrix4.translationValues(-20.0, 0.0, -20.0),
                    child:
                    _myRadioButton(
                      title: "English",
                      value: 0,
                      onChanged: (newValue) => setState(() =>{
                        _groupValue = newValue,
                        print(_groupValue),
                        print("titel "+genderlist[_groupValue!]),
                        // idgender=_groupValue.toString(),
                        // textGender=genderlist[_groupValue],

                        Navigator.pop(context),
                        Navigator.pop(context),
                        getlang (),
                      }
                      ),
                    ),
                  ),


                  Transform(
                    transform: langApp=="en"? Matrix4.translationValues(-20.0, 0.0, -20.0):Matrix4.translationValues(-20.0, 0.0, -20.0),
                    child:_myRadioButton(
                      title: "العربية",
                      value: 1,
                      onChanged: (newValue) => setState(() => {
                        _groupValue = newValue,
                        print(_groupValue),
                        print("titel "+genderlist[_groupValue!]),
                        // idgender=_groupValue.toString(),
                        // textGender=genderlist[_groupValue],
                        Navigator.pop(context),
                        Navigator.pop(context),
                        getlang (),

                      }
                      ),
                    ),
                  ),


                ],

              )
              )
          ),
        ],
      ),
    );
  }
  Widget _myRadioButton({String? title, int? value, ValueChanged? onChanged}) {
    return RadioListTile(
      activeColor: Color(0xff00838f),
      value: value,
      groupValue: _groupValue,
      // ValueChanged<T?>?:onChanged
      onChanged: onChanged,
      title: Text(title!),

    );
  }

   getlang () async {
    Locale _temp;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('lang');

    print(stringValue);
    print(stringValue);
    print("؟؟؟؟؟؟؟؟؟؟؟؟؟؟؟؟؟");
    print("؟؟؟؟؟؟؟؟؟؟؟؟؟؟؟؟؟");

    bool CheckValue = prefs.containsKey('lang');
    print("lang check => "+CheckValue.toString());
    if(CheckValue== true){
      print(">>>>>>>>>>>>>$CheckValue");
      if(stringValue=="ar"){
      _temp = Locale("en", 'US');
      MyApp.setLocale(context, _temp);
      Navigator.pushReplacementNamed(context, '/');

      prefs.setString('lang',"en");

      setState(() {
        langApp="en";
      });

      }else{
        _temp = Locale("ar", 'EG');
        MyApp.setLocale(context, _temp);
        print(">>>>>>>>>>>>>${CheckValue}");


         Navigator.pushReplacementNamed(context, '/');
        setState(() {
          langApp="ar";
        });
        prefs.setString('lang',"ar");
      }

    }
    else if(CheckValue== false){
      prefs.setString('lang',"en");
      _temp = Locale("en", 'US');
      MyApp.setLocale(context, _temp);
      print(">>>>>>>>>>>>>${false}");
//        Navigator.pushReplacementNamed(context, '/');
    }


  }


  List? city_new;
  cityWdgit() {
    return InkWell(
        onTap: () async=>
        {

          city_new = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    // title: Center(
                    //   child: Text(SetLocalization.of(context)!
                    //       .getTranslateValue('nav_settings')!),
                    // ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Container(
                      height: 350,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        child: ChangeCIty(mapCity: data_User!["main"][0]["city"],idCity: idcity,),
                      )

                      // gender(),
                    ),
                  );
                });
              }),

          setState(() {
          print(city_new);
          if(city_new![0]["idcity"].toString()==idcity.toString()){
            print("new equal old");
          }else{
            _login();
          }

          }),
        },

        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                SetLocalization.of(context)!.getTranslateValue(
                    'nav_settings_city')!,
                style: const TextStyle(
                    color: const Color(0xff000000),
                    fontWeight: FontWeight.w400,
                    fontFamily: "SFProText",
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0
                ),
                textAlign: TextAlign.center
            ),

            Text(
                namecity == null ? "" :
                "$namecity",
                style: const TextStyle(
                    color: const Color(0xff00838f),
                    fontWeight: FontWeight.w400,
                    fontFamily: "SFProText",
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0
                ),
                textAlign: TextAlign.center
            ),

          ],
        )
    );
  }

  Future<List?> _login() async {
    setState(() {
      try{
        // TipDialogHelper.loading("Loading");
        // progressDialog!.setLoadingWidget(
        //     CircularProgressIndicator(backgroundColor: Color(0x2900838f),
        //         valueColor:  AlwaysStoppedAnimation<Color>(Color(0xff00838f),
        //         )
        //       // (CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red)
        //     )
        // );
        // progressDialog!.show(useSafeArea: false);
      }catch(c){

      }

    });
    try{
      Map<String, dynamic> body = {
        "lang":langApp,
        "action":"save",
        "userid":idUsers,
        "city":city_new![0]["idcity"]
      };
      print(body.toString());

      print("body is <<<:"+body.toString());
      print("Url is <<<:"+URL_LOGIC.updateCity!);

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(Uri.parse(URL_LOGIC.updateCity!),
        body:jsonBody,
        encoding: encoding,
        headers: headers,
      );
      var datauser = json.decode(response.body);
      var code=datauser["code"];
      var message=datauser["message"];
      debugPrint("response.updateCity >>> "+response.body);

      if(code.toString().trim() == "010"){
        setState(() {
          idcity=city_new![0]["idcity"];
          namecity=city_new![0]["namecity"];
          try{
            // TipDialogHelper.success("Success");
            progressDialog!.dismiss();
          }catch(c){

          }

        });

      } else {
        setState(() {
          try{
            progressDialog!.dismiss();
            // TipDialogHelper.fail("failed");
          }catch(c){

          }

        });
        // dilog_code_confirm_(message,"direction");
      }


    }catch(exception){

      Future.delayed(Duration(seconds: 1)).then((value) async {
//        pr.hide();
//        print("object ??"+exception.toString());
//        pr.hide().then((isHidden) {
//          print(isHidden);
//        });
        setState(() {
          try{
            progressDialog!.dismiss();
            // TipDialogHelper.dismiss();
          }catch(c){

          }

        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return   AlertDialog(
              title: null,
              content: Text("يوجد مشكله في تسجيل الدخول"),
              actions: [
//            okButton,
              ],
            );
          },
        );
      });

    }
  }


  Future<dynamic> _delete_your_account() async {
    try{
      Map<String, dynamic> body = {
        "lang":langApp,
        // "userid":2518,
        "userid":idUsers,
      };


      print("body is <<<:"+body.toString());
      print("Url is <<<:"+URL_LOGIC.delete!);

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
      print(jsonBody.toString());
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(Uri.parse(URL_LOGIC.delete!),
        body:jsonBody,
        encoding: encoding,
        headers: headers,
      );
      var datauser = json.decode(response.body);
      var code=datauser["code"];
      // var message=datauser["message"];
      debugPrint("response.updateCity >>> "+response.body);
if(code!=null){
  SharedPreferences prefsa=await SharedPreferences.getInstance();
  prefsa.clear();
  prefsa.setString('lang',"$langApp");
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => Login()),
      ModalRoute.withName('/')
  );
}


    }catch(exception){

      Future.delayed(Duration(seconds: 1)).then((value) async {
        setState(() {
          try{
            progressDialog!.dismiss();
            // TipDialogHelper.dismiss();
          }catch(c){

          }

        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return   AlertDialog(
              title: null,
              content: Text("يوجد مشكله"),
              actions: [
//            okButton,
              ],
            );
          },
        );
      });

    }
  }


  Future<List?> _updateNotification(check) async {
    setState(() {
      try{
        // TipDialogHelper.loading("Loading");
        // progressDialog!.setLoadingWidget(
        //     CircularProgressIndicator(backgroundColor: Color(0x2900838f),
        //         valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff00838f),
        //         )
        //       // (CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red)
        //     )
        // );
        // progressDialog!.show(useSafeArea: true);
      }catch(c){

      }

    });
    try{
      Map<String, dynamic> body = {
        "lang":langApp,
        "action":"save",
        "userid":idUsers,
        "notification":check
      };
      print(body.toString());

      print("body is <<<:"+body.toString());
      print("Url is <<<:"+URL_LOGIC.updateCity!);

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(Uri.parse(URL_LOGIC.updateNotification!),
        body:jsonBody,
        encoding: encoding,
        headers: headers,
      );
      var datauser = json.decode(response.body);
      var code=datauser["code"];
      var message=datauser["message"];
      debugPrint("response.updateCity >>> "+response.body);

      if(code.toString().trim() == "010"){
        setState(() {
         isChecked=!isChecked!;
         try{
           progressDialog!.dismiss();
           // TipDialogHelper.success("Success");
         }catch(c){

         }

        });

      } else {
        setState(() {
          try{
            progressDialog!.dismiss();
            // TipDialogHelper.fail("failed");
          }catch(c){

          }

        });
        // dilog_code_confirm_(message,"direction");
      }


    }catch(exception){

      Future.delayed(Duration(seconds: 1)).then((value) async {
//        pr.hide();
//        print("object ??"+exception.toString());
//        pr.hide().then((isHidden) {
//          print(isHidden);
//        });
        setState(() {
          try{
            progressDialog!.dismiss();
            // TipDialogHelper.dismiss();
          }catch(c){

          }

        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return   AlertDialog(
              title: null,
              content: Text("يوجد مشكله في تسجيل الدخول"),
              actions: [
//            okButton,
              ],
            );
          },
        );
      });

    }
  }

}
