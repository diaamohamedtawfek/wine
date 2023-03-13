import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wineapp/lang/localization/set_localization.dart';

import '../../URL_LOGIC.dart';

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'StepThree.dart';

class StepTwo extends StatefulWidget {
  final String? email;
  final Locale? locale;
  StepTwo({Key? key, this.email, this.locale}) : super(key: key);
  @override
  _StepTwoState createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> {

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    TextEditingController textEditingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff00838f),
        centerTitle: true,
        title: Text(SetLocalization.of(context)!.getTranslateValue('forget_password')!,
          style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(child: Icon(Icons.check, color: Colors.white,),
            onTap: (){
             // Navigator.pushNamed(context, '/step_three');

            },),
          )
        ],
      ),

      body: ListView(
        children: [
          Container(
            width:  MediaQuery.of(context).size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40,),
                  Icon(Icons.lock, color: Color(0xff00838f),size: 90,),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 17, right: 17),
                    child: Center(
                      child: Text(SetLocalization.of(context)!.getTranslateValue('pincode_txt')!, style: TextStyle(
                          fontSize: 14
                      ),
                        textAlign: TextAlign.center,),
                    ),
                  ),
                  SizedBox(height: 80,),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: PinCodeTextField(
                        autoFocus: true,
                        backgroundColor: Colors.transparent,
                        appContext: context,
                        length: 4,
//                  obsecureText: false,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                            shape: PinCodeFieldShape.underline,
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeFillColor: Colors.transparent,
                            inactiveFillColor: Colors.transparent,
                            activeColor: Color(0xff00838f),
                            selectedFillColor: Colors.white,
                            inactiveColor: Colors.grey,
                            selectedColor: Color(0xff00838f)
                        ),
                        animationDuration: Duration(milliseconds: 300),
                        enableActiveFill: true,
                        // errorAnimationController: errorController,
                        controller: textEditingController,
                        onCompleted: (v) {
                          print("Completed"+v.toString());
                          _login(v.toString());

//                    client.validatePin(widget.email, v).then((value) => {
//
//                      if(value.statusCode == 200){
//                        print('pin:  ${value.body}'),
//                        Navigator.pushReplacement(context, MaterialPageRoute(
//                          builder: (context) => StepThree(email: widget.email, code: v, locale: widget.locale,)
//                        )),
//                      }
//
//                    });

                        },
                        onChanged: (value) {
                          print(value);
                          setState(() {
                          });
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      ),
                    ),
                  )

                ]
            ),
          )
        ],
      ),


    );
  }


  //  "action":"form","code":"6748"

  Future<List?> _login(codevi) async {
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
        "action":"form",
        "code":codevi

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
      var userid=datauser["userid"];
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
      if(code.toString().trim() == "022"){
        print("object");
        print("object");
          Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => StepThree(email: widget.email!,userid: userid, code: codevi,)));
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
