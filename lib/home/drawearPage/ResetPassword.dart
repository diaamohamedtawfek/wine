import 'dart:convert';

import 'package:ars_dialog/ars_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tip_dialog/tip_dialog.dart';
import 'package:wineapp/lang/localization/set_localization.dart';

import '../../URL_LOGIC.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  final Locale? locale;
  ResetPassword({Key? key, this.locale}): super(key: key);
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool validatePassword = false;
  TextEditingController passwordController = TextEditingController();

  bool validateRePassword = false;
  TextEditingController rePasswordController = TextEditingController();

  bool validateOldPassword = false;
  TextEditingController oldPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  CustomProgressDialog? progressDialog;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff00838f),
        centerTitle: true,
        title: Text(SetLocalization.of(context)!.getTranslateValue('reset_pass')!,
          style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child:Form(
            key: _formKey,
            child:Stack(
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    SizedBox(height: 20,),
                    //password
                    password(),

                    //newPassword
                    SizedBox(height: 20,),
                    newPassword(),
                    SizedBox(height: 20,),
                    confiermNewPassword(),


                    //button done
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
                                  if (_formKey.currentState!.validate()) {
                                    if(passwordController.text.toString() ==rePasswordController.text.toString() ){
                                      _login();
                                    }else{
                                      setState(() {
                                        validatePassword=true;
                                        validateRePassword=true;
                                      });
                                    }
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

                // TipDialogContainer(
                //     duration: const Duration(seconds: 2),
                //     outsideTouchable: true,
                //     onOutsideTouch: (Widget tipDialog) {
                //       if (tipDialog is TipDialog &&
                //           tipDialog.type == TipDialogType.LOADING) {
                //         TipDialogHelper.dismiss();
                //       }
                //     }
                //     ),

              ],
            )
        )


      ),
    );
  }


  password(){
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 45,
      child: Material(
        elevation: 20.0,
        shadowColor: Colors.grey.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
        child:  TextFormField(
          validator: (val) {
            if (val!.isEmpty) {
              setState(() {
                validateOldPassword=true;
              });
              return  null;
//                    return  SetLocalization.of(context).getTranslateValue('login_email_phone');
            }else{
              setState(() {
                validateOldPassword=false;
              });
            }
            return null;
          },
          controller: oldPasswordController,
//                  inputFormatters: [FilteringTextInputFormatter.deny(
//                      RegExp('[ ]'))],
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
              hintText: SetLocalization.of(context)!.getTranslateValue('oldpassword'),
              errorText: validateOldPassword ?SetLocalization.of(context)!.getTranslateValue('password_err') : null),
        ),
      ),
    );
  }

  newPassword() {
    return  Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 45,
      child: Material(
        elevation: 20.0,
        shadowColor: Colors.grey.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
        child: TextFormField(
          validator: (val) {
            if (val!.isEmpty) {
              setState(() {
                validatePassword=true;
              });
              return  null;
//                    return  SetLocalization.of(context).getTranslateValue('login_email_phone');
            }else{
              setState(() {
                validatePassword=false;
              });
            }
            return null;
          },
          controller: passwordController,
//                  inputFormatters: [FilteringTextInputFormatter.deny(
//                      RegExp('[ ]'))],
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
              errorText: validatePassword ? SetLocalization.of(context)!.getTranslateValue('password_match_err') : null),
        ),
      ),
    );
  }

  confiermNewPassword() {
    return  Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        height: 45,
        child: Material(
          elevation: 20.0,
          shadowColor: Colors.grey.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
          child: TextFormField(
            validator: (val) {
              if (val!.isEmpty) {
                setState(() {
                 validateRePassword=true;
                });
                return  null;
//                    return  SetLocalization.of(context).getTranslateValue('login_email_phone');
              }else{
                setState(() {
                  validateRePassword=false;
                });
              }
              return null;
            },
            controller: rePasswordController,
//                  inputFormatters: [FilteringTextInputFormatter.deny(
//                      RegExp('[ ]'))],
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
      ) ;
  }

  void initState() {
    // TODO: implement initState
    super.initState();

    progressDialog = CustomProgressDialog(context,blur: 10);
    getStringValuesSF();

  }

  String? langApp;
  String? idUsers;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    bool checkValue = prefs.containsKey('lang');
    String? lang = prefs.getString('lang');
    String? idUser = prefs.getString('userid');
    print("idUser=> "+lang.toString());

    setState(() {
      langApp=lang;
      idUsers=idUser;
    });
//    return stringValue;
  }


  Future<List?> _login() async {
    setState(() {
      // TipDialogHelper.loading("Loading");
      progressDialog!.setLoadingWidget(
          CircularProgressIndicator(backgroundColor: Color(0x2900838f),
              valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff00838f),
              )
            // (CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.red)
          )
      );
      progressDialog!.show(useSafeArea: false);
    });
    try{
//      SharedPreferences prefsa=await SharedPreferences.getInstance();
//      String lang = prefsa.getString('lang');
//
//      print("user name"+useremail.text.trim());
      Map<String, dynamic> body = {
        "lang":langApp,
      "action":"save",
      "userid":idUsers,
      "currentpassword":oldPasswordController.text.toString().trim(),
      "newpassword":passwordController.text.toString().trim(),
      "confirmnewpassword":rePasswordController.text.toString().trim()
      };
      print(body.toString());

      print("body is <<<:"+body.toString());
      print("Url is <<<:"+URL_LOGIC.resetPssword!);

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(Uri.parse(URL_LOGIC.resetPssword!),
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


      setState(() {
        progressDialog!.dismiss();
        // TipDialogHelper.dismiss();
      });
//    || message.toString().trim() != "Your Mobile Has Been Confirmed !"
//      print("code is $code");
      if(code.toString().trim() == "010"){

//        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPhoneAuthCode(phone: phone.text.toString(),)),);
//         dilog_code_confirm_(message,"confirm");
        done(  message);
      } else {
        _ackAlert(message);
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
          progressDialog!.dismiss();
          // TipDialogHelper.dismiss();
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



  Future<void> _ackAlert(String err) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(SetLocalization.of(context)!.getTranslateValue('error')!),
          content: Text(SetLocalization.of(context)!.getTranslateValue('error_reason')!+' $err'),
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
  Future<void> done( String err) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(SetLocalization.of(context)!.getTranslateValue('done')!),
          content: Text(SetLocalization.of(context)!.getTranslateValue('password_changed')!),
          actions: <Widget>[
            FlatButton(
              child: Text(SetLocalization.of(context)!.getTranslateValue('ok')!),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);

              },
            ),
          ],
        );
      },
    );
  }
}
