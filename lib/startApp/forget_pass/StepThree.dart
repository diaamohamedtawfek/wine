// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:ars_dialog/ars_dialog.dart';
import 'package:flutter/material.dart';
// import 'package:tip_dialog/tip_dialog.dart';
import 'package:wineapp/lang/localization/set_localization.dart';

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../../URL_LOGIC.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Login.dart';

class StepThree extends StatefulWidget {
  final String? email;
  final String userid;
  final String? code;
  final Locale? locale;

  StepThree({Key? key, this.email, this.code, this.locale,required this.userid}) : super(key: key);

  @override
  _StepThreeState createState() => _StepThreeState();
}

class _StepThreeState extends State<StepThree> {

  bool validatePassword=false;
  bool validateRePassword=false;
  TextEditingController passwordController=new TextEditingController();
  TextEditingController rePasswordController=new TextEditingController();

  CustomProgressDialog? progressDialog;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff00838f),
        centerTitle: true,
        title: Text(
          SetLocalization.of(context)!.getTranslateValue('forget_password')!,
          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 40,
                  child: Material(
                    elevation: 20.0,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
                    child: TextField(
                      controller: passwordController,
//                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[ ]'))],
                      obscureText: true,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xff00838f),
                          ),
                          hintText: SetLocalization.of(context)!.getTranslateValue('password'),
                          errorText: validatePassword ? SetLocalization.of(context)!.getTranslateValue('password_err') : null),
                    ),
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 40,
                  child: Material(
                    elevation: 20.0,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
                    child: TextField(
                      controller: rePasswordController,
//                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[ ]'))],
                      obscureText: true,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xff00838f),
                          ),
                          hintText: SetLocalization.of(context)!.getTranslateValue('re_password'),
                          errorText: validateRePassword ? SetLocalization.of(context)!.getTranslateValue('password_match_err') : null),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          height: 80,
                          padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                          child: RaisedButton(
                            child: Text(
                              SetLocalization.of(context)!.getTranslateValue('done')!,
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            onPressed: () async {

                              if (passwordController.text.isNotEmpty && passwordController.text.trim().length > 5) {
                                setState(() {
                                  validatePassword = false;
                                });
                                if (rePasswordController.text.trim() == passwordController.text.trim()) {
                                  setState(() {
                                    validateRePassword = false;
                                  });
                                  // TipDialogHelper.loading('Logging with new Password....');

                                  progressDialog!.setLoadingWidget(
                                      CircularProgressIndicator(backgroundColor: Color(0x2900838f),
                                          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff00838f),
                                          )
                                        // (CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red)
                                      )
                                  );
                                  progressDialog!.show(useSafeArea: false);

                                  _login();

                                } else {
                                  setState(() {
                                    validateRePassword = true;
                                  });
                                }
                              } else {
                                setState(() {
                                  validatePassword = true;
                                });
                              }
                            },
                            color: Color(0xff00838f),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          // TipDialogContainer(
          //     duration: const Duration(seconds: 2),
          //     outsideTouchable: true,
          //     onOutsideTouch: (Widget tipDialog) {
          //       if (tipDialog is TipDialog && tipDialog.type == TipDialogType.LOADING) {
          //         TipDialogHelper.dismiss();
          //       }
          //     })
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //PreferenceUtils.init();

    progressDialog = CustomProgressDialog(context,blur: 10);
  }

  Future<void> _ackAlert(BuildContext context, String err) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text(SetLocalization.of(context)!.getTranslateValue('error')!),
          content: Text(' $err'),
          actions: <Widget>[
            FlatButton(
              child: Text(SetLocalization.of(context)!.getTranslateValue('ok')!),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


  Future<List?> _login() async {
//    setState(() {
//      loading=true;
//    });
//    ProgressDialog pr = new ProgressDialog(context);
//    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true,
//        customBody:
//        Container(
//          padding: EdgeInsets.only(left: 11, right: 11),
//          height: 60,
//          child: Row(
//            children: [
//
//              Center(child: Image.asset(
//                "assets/loading.gif",
//                height: 105.0,
//                width: 105.0,
//              )),
////          Center(child: new CircularProgressIndicator(backgroundColor: Colors.black,)),
//              SizedBox(width: 11,),
//              Text(SetLocalization.of(context).getTranslateValue('wait'),
//                  style: const TextStyle(
//                      color: Colors.black54,
//                      fontWeight: FontWeight.w400,
//                      fontFamily: "Roboto",
//                      fontStyle: FontStyle.normal,
//                      fontSize: 14.0
//                  ),
//                  textAlign: TextAlign.center
//              ),
//
//            ],
//          ),
//        )
//    );
//    pr.show();
    try{
      SharedPreferences prefsa=await SharedPreferences.getInstance();

      String? lang = prefsa.getString('lang');
//
//      print("user name"+useremail.text.trim());
      Map<String, dynamic> body =
//      {
//        "lang":lang,
//        "action":"form",
//        "code":codevi
//
//      };

      {
        "lang":lang,
        "action":"save",
        "userid":widget.userid,
        "password":passwordController.text.toString().trim()
      };
      print(body.toString());

      print("body is <<<:"+body.toString());
      print("Url is <<<:"+URL_LOGIC.loginforget1!);

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(Uri.parse(URL_LOGIC.loginforget1!),
        body:jsonBody,
        encoding: encoding,
        headers: headers,
      );
      var datauser = json.decode(response.body);
      var code=datauser["code"];
      var message=datauser["message"];
      debugPrint("response.body >>> "+response.body);
//
//      pr.hide().then((isHidden) {
//        print(isHidden);
//      });


//      setState(() {
//        loading=false;
//      });
//    || message.toString().trim() != "Your Mobile Has Been Confirmed !"
//      print("code is $code");
      _ackAlert( context,  message);
      if(code.toString().trim() == "021"){
        print("object");
        print("object");
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            Login()), (Route<dynamic> route) => false);
        _ackAlert( context,  message);
//        Navigator.pushReplacement(context, MaterialPageRoute(
//            builder: (context) => (email: widget.email, code: codevi,)));
//        Navigator.push(context, MaterialPageRoute(builder: (context) => StepTwo(email: emailController.text.toString().trim(),)),);
//        _ackAlert(context,message);
//        SharedPreferences prefs = await SharedPreferences.getInstance();
//        prefs.setString('userid',datauser["userid"].toString());

//        dilog_code_confirm_(message,"confirm");
      }
      else if(code.toString().trim() == "003"){
//        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPhoneAuthCode()),);
//        dilog_code_confirm_(message,"confirm");
      }else {
//        dilog_code_confirm_(message,"direction");
      }


    }catch(exception){
      Future.delayed(Duration(seconds: 1)).then((value) async {
//        pr.hide();
//        print("object ??"+exception.toString());
//        pr.hide().then((isHidden) {
//          print(isHidden);
//        });
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
