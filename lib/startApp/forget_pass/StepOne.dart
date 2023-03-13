import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wineapp/lang/localization/set_localization.dart';
import 'package:wineapp/startApp/forget_pass/StepTwo.dart';

import '../../URL_LOGIC.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class StepOne extends StatefulWidget {
  final Locale? locale;
  StepOne({Key? key, this.locale}) : super(key: key);
  @override
  _StepOneState createState() => _StepOneState();
}

class _StepOneState extends State<StepOne> {
  bool validateEmail = false;
  TextEditingController emailController = TextEditingController();

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
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
            ),
            Icon(
              Icons.lock,
              color: Color(0xff00838f),
              size: 90,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              SetLocalization.of(context)!.getTranslateValue('forget_password_txt1')!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17, right: 17),
              child: Center(
                child: Text(
                  SetLocalization.of(context)!.getTranslateValue('forget_password_txt2')!,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
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
                  controller: emailController,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.emailAddress,
//                  inputFormatters: [FilteringTextInputFormatter.deny(
//                      RegExp('[ ]'))],
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
                        Icons.email,
                        color: Color(0xff00838f),
                      ),
                      hintText: SetLocalization.of(context)!.getTranslateValue('email'),
                      errorText: validateEmail ? SetLocalization.of(context)!.getTranslateValue('email_valid') : null),
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
                          SetLocalization.of(context)!.getTranslateValue('send_pincode')!,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onPressed: () async {
                          if (EmailValidator.validate(emailController.text.trim())) {
                            setState(() {
                              validateEmail = false;
                            });


                            _login();

                          } else {
                            setState(() {
                              validateEmail = true;
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
    );
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
      Map<String, dynamic> body = {
        "lang":lang,
        "action":"send",
        "email":emailController.text.toString().trim()

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
      if(code.toString().trim() == "019"){
        Navigator.push(context, MaterialPageRoute(builder: (context) => StepTwo(email: emailController.text.toString().trim(),)),);
        _ackAlert(context,message);
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
