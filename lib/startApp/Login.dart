import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wineapp/home/drawearPage/ClassWebView.dart';
import 'package:wineapp/lang/localization/set_localization.dart';
import 'package:wineapp/startApp/GistPage.dart';
import 'package:wineapp/startApp/SignUp.dart';


import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../URL_LOGIC.dart';
import '../main.dart';
import 'forget_pass/StepOne.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return UnLogin();
  }

}

class UnLogin extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  bool isRemmberMeSelected = true;
  bool loading = false;
  bool validateEmail = false;
  bool validatePassword = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var contextApp;
  String? langApp;
  bool showDialogs=false;
  @override
  void initState() {
    super.initState();

    showLang();



    getStringValuesSF();
    // getDataLogin();
    // nameController.text="z@gmail.com";
    // passwordController.text="123456";

  }

  showLang(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)  {
      print("::::::::::::::::::::::::::::::::::::::::::::::::::");
         showDialog<String>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context){
           return Dialog(
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.all(Radius.circular(22.0))),
              // contentPadding: EdgeInsets.only(top: 10.0),
              backgroundColor: Colors.transparent,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 4,
                    color: Color(0xff00838f),
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    gender(context),

                  ],
                ),
              ),
            );
          },
        ).whenComplete(() => {
        // setState(() {
        // showDialogs=true;
        // })
        });

    });
  }

  Map? data_cityHome;
  bool enable_value=false;

  Future getDataLogin() async {

    print("url is :"+URL_LOGIC.get_cityHome_new.toString());
    final encoding = Encoding.getByName('utf-8');
    // String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};

    http.Response response_offer = await http.get(
      Uri.parse("http://wainsale.com/apps_api/enable.php"),
      // body:jsonBody,
      // encoding: encoding,
      headers: headers,
    );
    data_cityHome = json.decode(response_offer.body);
    print(response_offer.body);

    setState(() {
        var text=data_cityHome!["enable_value"];
        if(text.toString()=="true"){
          enable_value=true;
        }else{
          enable_value=false;
        }

    });
  }



  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('lang');
    print("idUser=> "+lang.toString());

    setState(() {
      langApp=lang;
    });

//    return stringValue;
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    contextApp=context;
    return  Scaffold(

            body: LoadingOverlay(
                isLoading: loading,
                color: Color(0xFF00838f),
                child:
                Form(
                  key: _formKey,

                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [

                      startPage(),

                      SizedBox(
                        height: 20,
                      ),
                      //??? TextField


                      emailForm(),


                      SizedBox(
                        height: 20,
                      ),


                      passwordForm(),

                      SizedBox(
                        height: 20,
                      ),

                      //isRemmberMeSelected  forgetPassword
                      Container(
                        padding: EdgeInsets.only(left: 25, right: 23),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            InkWell(
                              onTap: () {
                                setState(() {
                                  isRemmberMeSelected = !isRemmberMeSelected;
                                  print("isRemmberMeSelected   " +
                                      isRemmberMeSelected.toString());
                                });
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Icon(isRemmberMeSelected
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                      color: isRemmberMeSelected ? Color(
                                          0xff00838f) : Colors.grey,),
//                        Image.asset(isRemmberMeSelected ?
//                        'assets/images/drawer/graphics_navbar_toolbar_icons_white_info.svg'
//                            : 'assets/images/drawer/controls_small_checkboxes_empty.svg'),

//                        SvgPicture.asset(isRemmberMeSelected ?
//                        'assets/images/drawer/graphics_navbar_toolbar_icons_white_info.svg'
//                            : 'assets/images/drawer/controls_small_checkboxes_empty.svg'),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      SetLocalization.of(context)!
                                          .getTranslateValue('remmber_me')!,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => StepOne()));
                              },
                              child: Container(
                                child: Text(
                                  SetLocalization.of(context)!.getTranslateValue(
                                      'forget_pass')!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff00838f),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),


                      Container(
                        height: 45,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: RaisedButton(
                          child: Text(
                            SetLocalization.of(context)!.getTranslateValue(
                                'sign_in')!,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if(nameController.text.toString().length>2 && passwordController.text.toString().length>2 ){
                                _login();
                              }
                            }
                          },
                          color: Color(0xff00838f),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),


                      SizedBox(height: 27,),

                      designOr(),

                      SizedBox(height: 27,),

                      // * ------------------------
                      buttonLogin(),

                      Visibility(
                        visible: enable_value!=false?false:false,
                        child:   FlatButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () async {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) =>GistPage()),);
                            },
                            padding: EdgeInsets.all(0.0),
                            child: Image.asset(
                              'assets/images/mail_button.png',
                              height: 60,
                              width: 60,
                            )),
                      ),

                      SizedBox(height: 13,),


                      loginByApple(),

                      SizedBox(height: 27,),

                      signUpText(),
                      SizedBox(height: 15,),

                      InkWell(
                          child:Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            InkWell(
                                onTap: (){
                                  Navigator
                                      .push(context, MaterialPageRoute(builder: (context) => WebViewExample(
                                    direction: "privacypolicy",
                                     lang: langApp??"en",
                                    urlLink: "https://wainsale.com/apps_api/pages/privacy.php?lang=",)));
                                },

                              child: Text(
                                  SetLocalization.of(context)!.getTranslateValue('privacy')!,
                                        style:  TextStyle(
                                          fontFamily: 'SFProText',
                                          color: Color(0xFF00838f),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                            decoration: TextDecoration.underline

                                        )

                                        )
                          //,
                            ),


                            Text(
                                SetLocalization.of(context)!.getTranslateValue('&')!,
                                style: TextStyle(
                                  fontFamily: 'Almarai',
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,

                                )
                            ),

                            InkWell(
                                onTap: (){
                                    Navigator
                                        .push(context, MaterialPageRoute(builder: (context) => WebViewExample(
                                      lang: langApp??"en",
                                      direction: "terms",
                                      urlLink: "https://wainsale.com/apps_api/pages/terms.php?lang=",)));
                                    // Navigator
                                    //     .push(context, MaterialPageRoute(builder: (context) => TermsConditions()));
                                  },

                                child: Text(
                                    SetLocalization.of(context)!.getTranslateValue('terms2')!,
                                    style:
                                    TextStyle(
                                        fontFamily: 'SFProText',
                                        color: Color(0xFF00838f),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        decoration: TextDecoration.underline

                                    )

                                )
                              //,
                            ),


                          ],
                        )

                        // RichText(
                        //     text: new TextSpan(
                        //         children: [
                        //
                        //           new TextSpan(
                        //               text: SetLocalization.of(context)!.getTranslateValue('signup_terms1'),
                        //               style: TextStyle(
                        //                 fontFamily: 'Almarai',
                        //                 color: Color(0xFF00838f),
                        //                 fontSize: 14,
                        //                 fontWeight: FontWeight.w700,
                        //                 fontStyle: FontStyle.normal,
                        //
                        //
                        //               )
                        //           ),
                        //         ]
                        //     )
                        // ),
                      )),
                      SizedBox(height: 57,),

                    ],
                  ),
                )
            )

    );
  }


  Widget startPage(){
    return Column(

      mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        SizedBox(
          height: 35,
        ),
        Image.asset(
          'assets/images/logo2.png',
          height: 100,
          width: 100,
        ),
        SizedBox(
          height: 10,
        ),

        Container(
          padding: EdgeInsetsDirectional.only(start: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
            crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
            children: <Widget>[


              // Padding(
              //   padding: const EdgeInsets.only(bottom: 5),
              //   child: Image.asset(
              //     'assets/images/wain_logo_title.png',
              //     height: 19,
              //     width: 64,
              //   ),
              // ),
              SizedBox(
                width: 6,
              ),
            ],
          ),
        ),


      ],
    );
  }

  Widget emailForm(){
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          height: 40,
          child: Material(
            elevation: 20.0,
            shadowColor: Colors.grey.withOpacity(0.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
            child: TextFormField(
              validator: (val) {
                if (val!.isEmpty) {
                  setState(() {
                    validateEmail = true;
                  });
                  return  null;
//                    return  SetLocalization.of(context).getTranslateValue('login_email_phone');
                }
                return null;
              },
              controller: nameController,
              keyboardType: TextInputType.emailAddress,
//                        inputFormatters: [FilteringTextInputFormatter.deny(
//                            RegExp('[ ]'))],



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
                  Icons.email,
                  color: Color(0xff00838f),
                ),
                hintText: SetLocalization.of(context)!.getTranslateValue('email'),
              ),
            ),
          ),
        ),

        Visibility(
          visible: validateEmail,
          child: Container(
              padding: EdgeInsets.only(left: 30, right: 20, top: 5),
              alignment: Alignment.centerLeft,
              child: Text(SetLocalization.of(context)!.getTranslateValue('email_valid')!, style: TextStyle(
                  color: Colors.red
              ),)),
        ),
      ],
    );
  }


  Widget passwordForm(){
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          height: 40,
          child: Material(
            elevation: 20.0,
            shadowColor: Colors.grey.withOpacity(0.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
            child: TextFormField(
              validator: (val) {
                if (val!.isEmpty) {
                  setState(() {
                    validatePassword = true;
                  });
                  return  null;
//                    return  SetLocalization.of(context).getTranslateValue('login_email_phone');
                }
                return null;
              },
              controller: passwordController,
              keyboardType: TextInputType.emailAddress,
//                        inputFormatters: [FilteringTextInputFormatter.deny(
//                            RegExp('[ ]'))],



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
                hintText: SetLocalization.of(context)!.getTranslateValue('passworde'),
              ),
            ),
          ),
        ),

        Visibility(
          visible: validatePassword,
          child: Container(
              padding: EdgeInsets.only(left: 30, right: 20, top: 5),
              alignment: Alignment.centerLeft,
              child: Text(SetLocalization.of(context)!.getTranslateValue('password_valid')!, style: TextStyle(
                  color: Colors.red
              ),)),
        ),
      ],
    );
  }

  Widget designOr(){
    return Container(
        padding: EdgeInsets.only(left: 30, right: 20, top: 0),
    alignment: Alignment.centerLeft,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Expanded(

          child: Divider(color: Colors.black,height: 1,),
        ),

        Text(
            " or  ",
            style: const TextStyle(
                color:  const Color(0xff707070),
                fontWeight: FontWeight.w400,
                fontFamily: "SFProText",
                fontStyle:  FontStyle.normal,
                fontSize: 12.0
            ),
            textAlign: TextAlign.center
        ),
        Expanded(
          child: Divider(color: Colors.black,height: 1,),
        )

      ],
    )
    );
  }


  final FirebaseAuth? _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn? _googlSignIn = new GoogleSignIn();


  Future<void> linkGoogleAndTwitter() async {

    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request.
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      // Create a new credential.
      final GoogleAuthCredential? googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ) as GoogleAuthCredential?;
      // Sign in to Firebase with the Google [UserCredential].
      final UserCredential googleUserCredential =
      await FirebaseAuth.instance.signInWithCredential(googleCredential!);
      _login_face_gmail(
        googleUserCredential.user!.email.toString(),
        googleUserCredential.user!.displayName.toString(),
        googleUserCredential.user!.displayName.toString(),
        googleUserCredential.user!.phoneNumber.toString(),
      );
    }catch(e){
      print("error login gmail");
      print(e.toString());
    }


   }


  Widget buttonLogin() {
    return Container(
        padding: EdgeInsets.only(left: 30, right: 20, top: 0),
        alignment: Alignment.centerLeft,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              
              Visibility(
                  visible: enable_value==true?true:true,
                  child:  FlatButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () async {

                        // signInWithGoogle(context: context);
                        linkGoogleAndTwitter();
                        // _signIn(context);


                      },
                      padding: EdgeInsets.all(0.0),
                      child: Image.asset(
                        'assets/images/gmail_button.png',
                        height: 60,
                        width: 60,
                      )),
              ),

              // Visibility(
              //     visible: enable_value==true?true:true,
              //     child:  //facebook_button
              //     FlatButton(
              //         splashColor: Colors.transparent,
              //         highlightColor: Colors.transparent,
              //         onPressed: () async {
              //           // final facebookLogin = FacebookLogin();
              //           try{
              //             // facebookLogin.logOut();
              //             // FacebookAuth.instance.logOut();
              //
              //           }catch(e){}
              //
              //           // _checkIfIsLogged();
              //           _loginfacebook();
              //
              //
              //
              //           // final facebookLogin = FacebookLogin();
              //           // final result = await facebookLogin.logIn(['email']);
              //           // final token = result.accessToken.token;
              //           // final graphResponse = await http.get(
              //           //     Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}'));
              //           // print("facebook data >> "+graphResponse.body);
              //           // var datauser = json.decode(graphResponse.body);
              //           // if (result.status == FacebookLoginStatus.loggedIn) {
              //           //   //{"name":"Diaa Mohamed","first_name":"Diaa","last_name":"Mohamed","id":"3621521294563647"}
              //           //   // final credential = FacebookAuthProvider.getCredential(accessToken: token);
              //           //   // _auth.signInWithCredential(credential);
              //           //
              //           //   _login_face_gmail(
              //           //       datauser["email"],
              //           //       datauser["first_name"],
              //           //       datauser["last_name"],
              //           //      null
              //           //   );
              //           // }
              //
              //         },
              //         padding: EdgeInsets.all(0.0),
              //         child: Image.asset(
              //           'assets/images/facebook_button.png',
              //           height: 60,
              //           width: 60,
              //         )),
              // ),





        Visibility(
            visible: enable_value==true?true:true,
            child:   FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>GistPage()),);
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //     builder: (BuildContext context) =>GistPage()),);
                  },
                  padding: EdgeInsets.all(0.0),
                  child: Image.asset(
                    'assets/images/mail_button.png',
                    height: 60,
                    width: 60,
                  )),
        )

            ]
        )
    );
  }


  Future<void> _loginfacebook() async {
    // try {
    //
    //   final result = await FacebookAuth.instance.login(
    //     permissions: ['email'],
    //    );
    //
    //
    //   final accessToken = result.accessToken;
    //  if (accessToken != null) {
    //     print(">>>>>>>>>>>>");
    //   }else{
    //     print("cant find tooken");
    //   }
    //   print(accessToken.toString());
    //
    //     final userData = await FacebookAuth.instance.getUserData();
    //     print(userData);
    //     _login_face_gmail(
    //         userData["email"],
    //         userData["name"],
    //         // userData["last_name"],
    //         "",
    //         "null"
    //     );
    // }  catch (e) {
    // }
  }
  Widget signUpText(){
    return  InkWell(

      onTap: ()=>{
      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp())),
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
              text: new TextSpan(
                  children: [

                    new TextSpan(
                        text:SetLocalization.of(context)!.getTranslateValue( "no_account"),
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          color: Color(0x73000000),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,


                        )
                    ),
                    new TextSpan(
                        text: SetLocalization.of(context)!.getTranslateValue( "signup_now"),
                        style: TextStyle(
                          fontFamily: 'SFProText',
                          color: Color(0xff00838f),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,


                        )
                    ),
                  ]
              )
          )
        ],
      ),
    );
  }

  Future<List?> _login() async {
    setState(() {
      loading=true;
    });
    try{
      Map<String, dynamic> body = {
        "lang":langApp,
        "email":nameController.text.toString().trim(),
        "password":passwordController.text.toString().trim()
      };
      print(body.toString());

      print("body is <<<:"+body.toString());
      print("Url is <<<:"+URL_LOGIC.login!);

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(Uri.parse(URL_LOGIC.login!),
        body:jsonBody,
        encoding: encoding,
        headers: headers,
      );
      debugPrint("response.body >>> "+response.body);
      var datauser = json.decode(response.body);
      var code=datauser["code"];
      var message=datauser["message"];
      debugPrint("response.body >>> "+response.body);

      setState(() {
        loading=false;
      });
      if(code.toString().trim() == "001"){
        if(isRemmberMeSelected==true){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userid',datauser["userid"].toString());
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) =>GistPage()),);
        }else{
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => GistPage()),);
        }
      }
      else if(code.toString().trim() == "003"){
//        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPhoneAuthCode()),);
        dilog_code_confirm_(message,"confirm");
      }else {
        dilog_code_confirm_(message,"direction");
      }


    }catch(exception){
      print("exception   ${exception.toString()}");
      Future.delayed(Duration(seconds: 1)).then((value) async {
//        pr.hide();
//        print("object ??"+exception.toString());
//        pr.hide().then((isHidden) {
//          print(isHidden);
//        });
        setState(() {
          loading=false;
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

  dilog_code_confirm_(message,direction){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return   AlertDialog(
          title: null,
          content: Text(message.toString()),
          actions: [
            FlatButton(
                child: Text(SetLocalization.of(context)!.getTranslateValue('ok')!),
                onPressed: () {
                  print(direction);
                  if(direction.toString()!="confirm"){
                    print("==");
//                    Navigator.of(context).pop(true);
                    Navigator.pop(context);
//                    Navigator.pop(context);
                  }else if(direction.toString()=="confirm") {
                    Navigator.pop(context);
//                    Navigator.pop(context);
                    print("!=");
//                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPhoneAuthCode()),);
                  }
                }),
          ],
        );
      },
    );
  }


  Future<List?> _login_face_gmail(email,first_name,last_name,phone) async {
    setState(() {
      loading=true;
    });
    try{
//      SharedPreferences prefsa=await SharedPreferences.getInstance();
//      String lang = prefsa.getString('lang');
//
//      print("user name"+useremail.text.trim());
      Map<String, dynamic> body ={
        "lang":langApp,
        "email":email.toString().trim(),
        "first_name":first_name.toString().trim(),
        "last_name":last_name.toString().trim(),
        "phone":phone.toString().trim()
      };
      print(body.toString());

      print("body is <<<:"+body.toString());
      print("Url isسيي <<<:"+URL_LOGIC.login_fb_google!);

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(Uri.parse(URL_LOGIC.login_fb_google!),
        body:jsonBody,
        encoding: encoding,
        headers: headers,
      );
      print("body is <<<:"+response.body.toString());
      var datauser = json.decode(response.body);
      var code=datauser["code"];
      var userid=datauser["userid"];
      var message=datauser["message"];
      debugPrint("response.body >>> "+response.body);

      setState(() {
        loading=false;
      });
//    || message.toString().trim() != "Your Mobile Has Been Confirmed !"
//      print("code is $code");
      if(userid.toString().trim() != "null"){
//         if(isRemmberMeSelected==true){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userid',datauser["userid"].toString());
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) =>GistPage()),);
        }

    }catch(exception){
      Future.delayed(Duration(seconds: 1)).then((value) async {
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

  loginByApple() {

    return Platform.isIOS ? Padding(
      padding: const EdgeInsets.all(18.0),
      child: SignInWithAppleButton(
        onPressed: () async {
          final appleIdCredential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );
          final oAuthProvider = OAuthProvider('apple.com');
          final credential =   oAuthProvider.credential(
            idToken: appleIdCredential.identityToken,
            accessToken: appleIdCredential.authorizationCode,
          );

          // final credential = oAuthProvider.getCredential(
          //   idToken: appleIdCredential.identityToken,
          //   accessToken: appleIdCredential.authorizationCode,
          // );


          // final oAuthProvider = OAuthProvider(providerId: 'apple.com');
          // final credential = oAuthProvider.getCredential(
          //   idToken: appleIdCredential.identityToken,
          //   accessToken: appleIdCredential.authorizationCode,
          // );


          // await FirebaseAuth.instance.signInWithCredential(credential);
          // print(credential);

          // AuthResult firebaseResult = await _auth.signInWithCredential(credential);
          // FirebaseUser user = firebaseResult.user;
          //
          // // Optional, Update user data in Firestore
          // updateUserData(user);

          final UserCredential googleUserCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

          _login_face_gmail(
            googleUserCredential.user!.email.toString(),
            googleUserCredential.user!.displayName.toString(),
            googleUserCredential.user!.displayName.toString(),
            googleUserCredential.user!.phoneNumber.toString(),
          );



          // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
          // after they have been validated with Apple (see `Integration` section for more information on how to do this)
        },
      ),
    ) : Text('');
  }









  // * Lang

  List genderlist=["English","العربية"];
  int? _groupValue ;

  Widget gender(context){

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Row(
                        children: [

                          Expanded(child: InkWell(
                            // color: Colors.white,
                            // elevation: 0,
                            onTap: (){
                              Navigator.pop(context);
                              getlang ("en");
                              getStringValuesSF();
                            },
                            child:  Container(
                              height: 40,
                              padding: EdgeInsets.only(left: 5,right: 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 6,
                                  color: Color(0xff00838f),
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                                color: Color(0xff00838f),
                              ),
                              child: Center(child: Text("English",style: TextStyle(color: Colors.white)),),
                            ),
                          ),
                          ),


                          SizedBox(width: 11,),

                          Expanded(child: InkWell(
                            // color: Colors.white,
                            // elevation: 0,
                            onTap: (){
                              Navigator.pop(context);
                              getlang ("ar");
                              getStringValuesSF();
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
                              child: Center(child:Text("العربية",style: TextStyle(color: Colors.white),)),
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

  getlang (langApp) async {

    print(langApp);
    Locale _temp;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? stringValue = prefs.getString('lang');


    if(langApp!="ar"){
      setState(() {
        _temp = Locale("en", 'EG');
        MyApp.setLocale(context, _temp);
        prefs.setString('lang',"en");
        // Navigator.pop(context);
      });

    }else{
      _temp = Locale("ar", 'EG');
      MyApp.setLocale(context, _temp);

      prefs.setString('lang',"ar");
      // Navigator.pop(context);
    }
  }
}