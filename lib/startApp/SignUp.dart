import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wineapp/home/HomApp.dart';
import 'package:wineapp/home/drawearPage/ClassWebView.dart';
import 'package:wineapp/lang/localization/set_localization.dart';
import 'package:http/http.dart' as http;
import '../URL_LOGIC.dart';

class SignUp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UniSignUp();
  }
}

class UniSignUp extends State<SignUp> {

  StreamController? phoneCodeController;
  final _formKey = GlobalKey<FormState>();


  bool acceptTerms = true;

  bool fullNameError=false;
  TextEditingController fullNameController = TextEditingController();

  bool emailError=false;
  TextEditingController emailController = TextEditingController();

  bool passwordError=false;
  TextEditingController passwordController = TextEditingController();

  bool repasswordError=false;
  TextEditingController repasswordController = TextEditingController();

  bool userphoneError=false;
  TextEditingController phoneController = TextEditingController();


  String? idAge;
  String? idNationality;
  String? idcountry_code;
  String? idgender;

  String? age;
  String? country_code;
  String? nationality;
  String? textGender="Male";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getStringValuesSF();

  }

  String? langApp;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    bool checkValue = prefs.containsKey('lang');
    String? lang = prefs.getString('lang');
    print("idUser=> "+lang.toString());

    setState(() {
      langApp=lang!;
      getData_NationalityApi();
      getData_age_group();
      getData_country_code("");
    });
//    return stringValue;
  }

  Map? data_offer;
  List _All_nationality=[];
  List _All_nationality_old=[];

  List filteredCountries = [];

  void _filterCountries(value) {
    setState(() {
      var _results = _All_nationality_old.where((item) => item['name'].toLowerCase().contains(value.toLowerCase())).toList();
      print("><><><><><><><><><><><><><><"+ _results.toString()+"><><><><><><><><><><><><><><");
      setState(() {
        _All_nationality=_results;
      });
    });
  }


  void _filterAdge(value) {
    setState(() {
      var _results = _All_age_group_old.where((item) => item['age_group'].toLowerCase().contains(value.toLowerCase())).toList();
      print("><><><><><><><><><><><><><><"+ _results.toString()+"><><><><><><><><><><><><><><");
      setState(() {
        _All_age_group=_results;
      });
    });
  }


  void _filterCodePhone(value) {
    setState(() {//_All_country_code[index]["country"];


      // var filteredUsers = _All_country_code_old.where((u) =>
      // (u.name.toLowerCase().contains(string.toLowerCase()) ||
      //                 u.email.toLowerCase().contains(string.toLowerCase())))
      //                 .toList();



      var _results = _All_country_code_old.where((item) =>
          item['country'].toLowerCase().contains(value.toLowerCase()) ||
          item['code_country'].toLowerCase().contains(value.toLowerCase())

      ).toList()
      ;
      print("><><><><><><><><><><><><><><"+ _results.toString()+"><><><><><><><><><><><><><><");
      setState(() {
        _All_country_code=_results;
      });
    });
  }


  Future getData_NationalityApi() async {

    Map<String, String> timeOutMessage = {
      'state': 'timeout',
      'content': 'server is not responding'
    };
    // offer
    Map<String, Object> body = {
      "lang":langApp!,
    };
    print("body is :"+body.toString());
    print("url is :"+URL_LOGIC.Nationality.toString());
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};

    http.Response responseOffer = await http.post(
      Uri.parse(URL_LOGIC.Nationality!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    data_offer = json.decode(responseOffer.body);

//    userData_offer = data_offer["bestseller"];


    setState(() {
//    print(data_offer.toString());

    data_offer = json.decode(responseOffer.body);

    _All_nationality.addAll(data_offer!["nationality"]);
    _All_nationality_old.addAll(data_offer!["nationality"]);
    if(_All_nationality.isNotEmpty){
      setState(() {
        // idNationality=_All_nationality[0]["id"].toString();
        // nationality=_All_nationality[0]["name"].toString();


        // _filterCountries("eg");
      });

    }
    print("Nationality "+_All_nationality.toString());
    });
  }





  Map? data_age_group;
  List _All_age_group=[];
  List _All_age_group_old=[];

  Future getData_age_group() async {

    Map<String, String> timeOutMessage = {
      'state': 'timeout',
      'content': 'server is not responding'
    };
    // offer
    Map<String, Object> body = {
      "lang":langApp!,
    };
    print("body is :"+body.toString());
    print("url is :"+URL_LOGIC.age_group.toString());
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};

    http.Response responseOffer = await http.post(
      Uri.parse(URL_LOGIC.age_group!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    data_offer = json.decode(responseOffer.body);

//    userData_offer = data_offer["bestseller"];


    setState(() {
//    print(data_offer.toString());

      data_age_group = json.decode(responseOffer.body);

      _All_age_group.addAll(data_age_group!["age_group"]);
      _All_age_group_old.addAll(data_age_group!["age_group"]);
      print("_All_age_group "+_All_age_group.toString());

      if(_All_age_group.isNotEmpty){
        setState(() {
          idAge=_All_age_group[0]["id"].toString();
          age=_All_age_group[0]["age_group"].toString();
        });

      }

    });
  }




  Map? data_country_code;
  List _All_country_code=[];
  List _All_country_code_old=[];
  bool loading = false;
  Future getData_country_code(direction) async {

    Map<String, String> timeOutMessage = {
      'state': 'timeout',
      'content': 'server is not responding'
    };
    // offer
    Map<String, Object> body = {
      "lang":langApp!,
    };
    print("body is :"+body.toString());
    print("url is :"+URL_LOGIC.country_code.toString());
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};

    http.Response responseOffer = await http.post(
      Uri.parse(URL_LOGIC.country_code!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    data_country_code = json.decode(responseOffer.body);

//    userData_offer = data_offer["bestseller"];


    setState(() {
//    print(data_offer.toString());

      data_country_code = json.decode(responseOffer.body);

      setState(() {
        data_country_code = json.decode(responseOffer.body);
        _All_country_code.addAll(data_country_code!["age_group"]);
        _All_country_code_old.addAll(data_country_code!["age_group"]);
      });

      if(_All_country_code.isNotEmpty){
        setState(() {
          idcountry_code=_All_country_code[0]["id"].toString();
          country_code=_All_country_code[0]["code_country"].toString();

        });

        if(direction=="pop"){
          dilogCode_country();
        }
      }
      print("getData_country_code() "+_All_country_code.toString());
    });
  }


















  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      body:  LoadingOverlay(
          isLoading: loading,
          color: Color(0xFF00838f),
          child: Form(
          key: _formKey,

          child: ListView(
//            padding: EdgeInsets.only(left: 22,right: 22),
              children: [

                startPage(),


                SizedBox(height: 20,),

                username(),

                SizedBox(height: 20,),

                useremail(),

                SizedBox(height: 20,),

                userpassword(),

                SizedBox(height: 20,),

                userrepassword(),

                SizedBox(height: 20,),

                country_code==null?Text(""):
                phone(),

                SizedBox(height: 20,),
                gender(),

                SizedBox(height: 0,),

                age==null?Text(""):
                    InkWell(
                      onTap: ()=>{
                        dilogCode_adge(),
                      },
                      child: ageWidgit(),
                    ),


                SizedBox(height: 10,),

                // nationality==null?Text(""):
                    InkWell(
                      onTap: ()=>{
                        dilogCode_nationality(),
                      },
                      child: nationalityWidgit(),
                    ),


                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        acceptTerms = !acceptTerms;
                      });
                    },
                    child:
                        InkWell(
                          onTap: (){
                            Navigator
                                .push(context, MaterialPageRoute(builder: (context) => WebViewExample(
                              lang: langApp??"en",
                              direction: "privacypolicy",
                              urlLink: "https://wainsale.com/apps_api/pages/privacy.php?lang=",)));
                          },
                          child:  Row(
                            children: [
                              Icon(acceptTerms ? Icons.check_circle :  Icons.radio_button_unchecked,
                                color: acceptTerms ? Color(0xff00838f): Colors.grey,),
                              SizedBox(width: 5,),
                              Flexible(
                                child:
                                // Text(SetLocalization.of(context).getTranslateValue('signup_terms'), style: TextStyle(
                                //     fontSize: 12
                                // ),),
                                // RichText(
                                //     text: new TextSpan(
                                //         children: [
                                //
                                //           new TextSpan(
                                //               text: SetLocalization.of(context)!.getTranslateValue('signup_terms'),
                                //               style: TextStyle(
                                //                 fontFamily: 'Almarai',
                                //                 color: Color(0xff000000),
                                //                 fontSize: 12,
                                //                 fontWeight: FontWeight.w400,
                                //                 fontStyle: FontStyle.normal,
                                //
                                //
                                //               )
                                //           ),
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
                                // )


                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignmentsAlignment: MainAxisAlignment.center,
                                  children: [

                                    Text(
                                         SetLocalization.of(context)!.getTranslateValue('signup_terms')!,
                                        style: TextStyle(
                                          fontFamily: 'Almarai',
                                          color: Color(0xff000000),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,

                                        )
                                    ),

                                    InkWell(
                                        onTap: (){
                                          Navigator
                                              .push(context, MaterialPageRoute(builder: (context) => WebViewExample(
                                            lang: langApp??"en",
                                            direction: "privacypolicy",
                                            urlLink: "https://wainsale.com/apps_api/pages/privacy.php?lang=",)));
                                        },

                                        child: Text(
                                            SetLocalization.of(context)!.getTranslateValue('privacy')!,
                                            style: TextStyle(
                                              fontFamily: 'Almarai',
                                              color: Color(0xFF00838f),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
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
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,

                                        )
                                    ),

                                    InkWell(
                                        onTap: (){
                                          Navigator
                                              .push(context, MaterialPageRoute(builder: (context) => WebViewExample(
                                            direction: "terms",
                                            lang: langApp??"en",
                                            urlLink: "https://wainsale.com/apps_api/pages/terms.php?lang=",)));
                                          // Navigator
                                          //     .push(context, MaterialPageRoute(builder: (context) => TermsConditions()));
                                        },

                                        child: Text(
                                            SetLocalization.of(context)!.getTranslateValue('terms2')!,
                                            style: TextStyle(
                                              fontFamily: 'Almarai',
                                              color: Color(0xFF00838f),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
                                                decoration: TextDecoration.underline

                                            )
                                        )
                                      //,
                                    ),


                                  ],
                                )
                              ),
                            ],
                          ),
                        )
                  ),
                ),

                SizedBox(height: 30,),



                //button signup
                Container(
                  height: 45,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: RaisedButton(
                    child: Text(
                      SetLocalization.of(context)!.getTranslateValue('signup')!,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if( EmailValidator.validate(emailController.text.trim())){
                          setState(() {
                            emailError = false;
                          });


                        if(acceptTerms==true && idAge!=null ){

                          if(passwordController.text.length <6){
                            setState(() {
                              passwordError=true;repasswordError=true;
                            });

                          }else{
                            if(passwordController.text!=repasswordController.text){
                              setState(() {
                                repasswordError=true;
                                passwordError=true;
                              });

                            }else{
                              passwordError=false;
                              repasswordError=false;
                              print("object");
                              if(phoneController.text.toString().length>5){
                                _login();
                              }

                            }

//                            print("object");
                          }
                        }else{

                        }
                        }else{
                          setState(() {
                            emailError = true;;
                          });
                        }
//                check(),
                      }
//                setState(() {
//                  validateEmail = true;
//                });

                    },
                    color: Color(0xff00838f),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),


                SizedBox(height: 30,),

                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(SetLocalization.of(context)!.getTranslateValue('already_have_account')!,),
                        Text(SetLocalization.of(context)!.getTranslateValue('sign_in')!,style: TextStyle(
                          color: Color(0xff00838f),
                        ),),
                      ],
                    ),
                  ),
                ),


                SizedBox(height: 50,),
              ]
          )
      )),
    );
  }

  Widget startPage(){
    return  Column(
      children: [

        SizedBox(height: 22,),
        Image.asset('assets/images/logo2.png',
          height: 85,
          width: 85,),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
          crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
          children: <Widget>[
            // Text(SetLocalization.of(context)!.getTranslateValue('intro1')!),
            SizedBox(width: 6,),
            Image.asset('assets/images/wain_logo_title.png',
              height: 19,
              width: 62,),
            SizedBox(width: 6,),
            // Text(SetLocalization.of(context)!.getTranslateValue('intro2')!),
          ],
        ),
      ],
    );
  }

  Widget username(){
    return  Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 40,
      child: Stack(
          alignment: Alignment.topRight,
          overflow: Overflow.visible,
          children : [
            Material(
              elevation: 20.0,
              shadowColor: Colors.grey.withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),

              child: TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    setState(() {
                      fullNameError = true;
                    });
                    return  null;
//                    return  SetLocalization.of(context).getTranslateValue('login_email_phone');
                  }
                  return null;
                },
                controller: fullNameController,
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


                  prefixIcon: Icon(Icons.person, color: Color(0xff00838f),),
                  hintText:SetLocalization.of(context)!.getTranslateValue('full_name'),

                ),
              ),
            ),
            Visibility(
              visible: fullNameError,
              child: PositionedDirectional(
                bottom: 25,
                child: Container(
                  height: 50,
                  child: Stack(
                    children: [
                      Image.asset("assets/images/pop_up.png",
//                        width: MediaQuery.of(context).size.width/1.5,
                        fit: BoxFit.cover,
                      ),
                      PositionedDirectional(
                        top: 15,
                        start: 20,
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(start: 5),
                            child: Text(
                              SetLocalization.of(context)!.getTranslateValue('full_name_err')!,
                              style: TextStyle(
                                  fontSize: 9
                              ),
                            ),
                          ),
                        ),
                      ),],


                  ),
                ) ,
              ),
            ),
            Visibility(
              visible: fullNameError,
              child: Padding(
                padding: const EdgeInsets.only(right: 24, top: 8),
                child: Icon(Icons.error,color:  Color(0xff9f0000)),
              ),
            ),
          ]
      ),
    );
  }


  Widget useremail(){
    return  Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 40,
      child: Stack(
          alignment: Alignment.topRight,
          overflow: Overflow.visible,
          children : [
            Material(
              elevation: 20.0,
              shadowColor: Colors.grey.withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),

              child: TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    setState(() {
                      emailError = true;
                    });
                    return  null;
//                    return  SetLocalization.of(context).getTranslateValue('login_email_phone');
                  }else if( !EmailValidator.validate(emailController.text.trim())){
                  setState(() {
                  emailError = true;
                  });
                  return null;
                  }

                  return null;
                },
//                validator: (value)=>!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)?"Enter Valid Email like  info@gmail.com ":null,
                controller: emailController,
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


                  prefixIcon: Icon(Icons.email, color: Color(0xff00838f),),
                  hintText:SetLocalization.of(context)!.getTranslateValue('email'),

                ),
              ),
            ),
            Visibility(
              visible: emailError,
              child: PositionedDirectional(
                bottom: 25,
                child: Container(
                  height: 50,
                  child: Stack(
                    children: [
                      Image.asset("assets/images/pop_up.png",
//                        width: MediaQuery.of(context).size.width/1.5,
                        fit: BoxFit.cover,
                      ),
                      PositionedDirectional(
                        top: 15,
                        start: 20,
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(start: 5),
                            child: Text(
                              SetLocalization.of(context)!.getTranslateValue('email_valid')!,
                              style: TextStyle(
                                  fontSize: 9
                              ),
                            ),
                          ),
                        ),
                      ),],


                  ),
                ) ,
              ),
            ),
            Visibility(
              visible: emailError,
              child: Padding(
                padding: const EdgeInsets.only(right: 24, top: 8),
                child: Icon(Icons.error,color:  Color(0xff9f0000)),
              ),
            ),
          ]
      ),
    );
  }



  Widget userpassword(){
    return  Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 40,
      child: Stack(
          alignment: Alignment.topRight,
          overflow: Overflow.visible,
          children : [
            Material(
              elevation: 20.0,
              shadowColor: Colors.grey.withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),

              child: TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    setState(() {
                      passwordError = true;
                    });
                    return  null;
//                    return  SetLocalization.of(context).getTranslateValue('login_email_phone');
                  }
                  else if (val.length <5 ) {
                    setState(() {
                      passwordError = true;
                    });
                    return  null;
//                    return  SetLocalization.of(context).getTranslateValue('login_email_phone');
                  }
                  return null;
                },
                obscureText: true,
                controller: passwordController,
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


                  prefixIcon: Icon(Icons.lock, color: Color(0xff00838f),),
                  hintText:SetLocalization.of(context)!.getTranslateValue('passworde'),

                ),
              ),
            ),
            Visibility(
              visible: passwordError,
              child: PositionedDirectional(
                bottom: 25,
                child: Container(
                  height: 50,
                  child: Stack(
                    children: [
                      Image.asset("assets/images/pop_up.png",
//                        width: MediaQuery.of(context).size.width/1.5,
                        fit: BoxFit.cover,
                      ),
                      PositionedDirectional(
                        top: 15,
                        start: 20,
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(start: 5),
                            child: Text(
                              SetLocalization.of(context)!.getTranslateValue('password_err')!,
                              style: TextStyle(
                                  fontSize: 9
                              ),
                            ),
                          ),
                        ),
                      ),],


                  ),
                ) ,
              ),
            ),
            Visibility(
              visible: passwordError,
              child: Padding(
                padding: const EdgeInsets.only(right: 24, top: 8),
                child: Icon(Icons.error,color:  Color(0xff9f0000)),
              ),
            ),
          ]
      ),
    );
  }


  Widget userrepassword(){
    return  Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 40,
      child: Stack(
          alignment: Alignment.topRight,
          overflow: Overflow.visible,
          children : [
            Material(
              elevation: 20.0,
              shadowColor: Colors.grey.withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),

              child: TextFormField(
                obscureText: true,
                validator: (val) {
                  if (val!.isEmpty) {
                    setState(() {
                      repasswordError = true;
                    });
                    return  null;
//                    return  SetLocalization.of(context).getTranslateValue('login_email_phone');
                  }else  if (val.isNotEmpty) {
                    if(passwordController.text == repasswordController.text){
                      setState(() {
                        repasswordError = true;
                      });
                      return  null;
                    }

//                    return  SetLocalization.of(context).getTranslateValue('login_email_phone');
                  }

                  return null;
                },
                controller: repasswordController,
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


                  prefixIcon: Icon(Icons.lock, color: Color(0xff00838f),),
                  hintText:SetLocalization.of(context)!.getTranslateValue('re_password'),

                ),
              ),
            ),
            Visibility(
              visible: repasswordError,
              child: PositionedDirectional(
                bottom: 25,
                child: Container(
                  height: 50,
                  child: Stack(
                    children: [
                      Image.asset("assets/images/pop_up.png",
//                        width: MediaQuery.of(context).size.width/1.5,
                        fit: BoxFit.cover,
                      ),
                      PositionedDirectional(
                        top: 15,
                        start: 20,
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(start: 5),
                            child: Text(
                              SetLocalization.of(context)!.getTranslateValue('password_match_err')!,
                              style: TextStyle(
                                  fontSize: 9
                              ),
                            ),
                          ),
                        ),
                      ),],


                  ),
                ) ,
              ),
            ),
            Visibility(
              visible: repasswordError,
              child: Padding(
                padding: const EdgeInsets.only(right: 24, top: 8),
                child: Icon(Icons.error,color:  Color(0xff9f0000)),
              ),
            ),
          ]
      ),
    );
  }




  Widget phone(){
    return   Container(
      height: 40,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          Material(
            elevation: 20.0,
            shadowColor: Colors.grey.withOpacity(0.5),
            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
            child: FlatButton(
              onPressed: (){
//                phoneCodeController = new StreamController();
//                getCountryData();
//                _All_country_code.clear();
//                data_country_code.clear();
//                getData_country_code("pop");
              dilogCode_country();

              },
              child: Row(
                children: [
                  Text(country_code ?? '+962', style: TextStyle(
                      fontSize: 12,
                      color: Color(0x80000000)
                  ),),
                  Icon(Icons.arrow_drop_down, color: Color(0x80000000))
                ],
              ),
            ),
          ),
          SizedBox(width: 5,),

          Expanded(
            child: Stack(
                alignment: Alignment.topRight,
                overflow: Overflow.visible,
                children : [
                  Material(
                    elevation: 20.0,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
                    child: TextFormField(
                      validator: (val){
                        if(val!.isEmpty){
                          setState(() {
                            userphoneError=true;
                          });

                          return null;
                        }else{
                          setState(() {
                            userphoneError=false;
                          });

                          return null;
                        }
                      },
//                                  inputFormatters: [FilteringTextInputFormatter.deny(
//                                      RegExp('[ ]'))],
                      controller: phoneController,
                      keyboardType: TextInputType.number,
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


                        prefixIcon: Icon(Icons.phone, color: Color(0xff00838f),),
                        hintText: SetLocalization.of(context)!.getTranslateValue('phone'),

                      ),
                    ),
                  ),

                  Visibility(
                    visible: userphoneError,
                    child: PositionedDirectional(
                      bottom: 25,
                      child: Container(
                        height: 50,
                        child: Stack(
                          children: [
                            Image.asset('assets/images/pop_up.png',
                          fit: BoxFit.cover,),

//                            SvgPicture.asset('assets/images/pop_up.svg',
//                              fit: BoxFit.cover, allowDrawingOutsideViewBox: true,
//                              width: MediaQuery.of(context).size.width/1.5,),
                            PositionedDirectional(
                              top: 15,
                              start: 20,
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.only(start: 5),
                                  child: Text(
                                    SetLocalization.of(context)!.getTranslateValue('phone_err')!,
                                    style: TextStyle(
                                        fontSize: 9
                                    ),
                                  ),
                                ),
                              ),
                            ),],


                        ),
                      ) ,
                    ),
                  ),
                  Visibility(
                    visible: userphoneError,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 24, top: 8),
                      child: Icon(Icons.error,color:  Color(0xff9f0000)),
                    ),
                  ),
                ]
            ),
          ),

        ],
      ),
    );
  }

  List genderlist=["Male","Female"];
  List genderlistid=[0,1,2];
  int _groupValue = 3;

  Widget gender(){
    return Container(
      padding: EdgeInsets.only(left: 15,right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(SetLocalization.of(context)!.getTranslateValue("gender")!+"  (${SetLocalization.of(context)!.getTranslateValue("optional")}) ",
              style: TextStyle(
                fontFamily: 'SFProText',
                color: Color(0xff000000),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
      ),


              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  Expanded(
                    child:Transform(
                  transform:
                  langApp.toString()=="ar"?Matrix4.translationValues(25.0, 0.0, 20.0):
                    Matrix4.translationValues(-25.0, 0.0, -20.0),
                    child:
                    _myRadioButton(
                    title: SetLocalization.of(context)!.getTranslateValue("male"),
                    value: 0,
                    onChanged: (newValue) => setState(() =>{
                      if(_groupValue == newValue){
                        setState((){
                          _groupValue=3;
                        })

                      }else{
                        _groupValue = newValue,
                        print(_groupValue),
                        print(genderlist[_groupValue]),
                        idgender=_groupValue.toString(),
                        textGender=genderlist[_groupValue],
                      },

                    }
                    ),
                  ),
                  ),
                  ),

                  Expanded(
                      child: Transform(
                        transform:
                        langApp.toString()=="ar"?Matrix4.translationValues(25.0, 0.0, 20.0):
                        Matrix4.translationValues(-25.0, 0.0, -20.0),
                        child: _myRadioButton(
                        title: SetLocalization.of(context)!.getTranslateValue("female"),
                        value: 1,
                        onChanged: (newValue) => setState(() => {
                          _groupValue = newValue,
                          print(_groupValue),
                          print(genderlist[_groupValue]),
                          idgender=_groupValue.toString(),
                          textGender=genderlist[_groupValue],
                        }
                        ),
                        ),
                      ),
                  ),




                ],

          ),

          Visibility(
            visible: false,
            child: _myRadioButton(
              title: "Later",
              value: 3,
              onChanged: (newValue) => setState(() => {
                _groupValue = newValue,
                print(">>>>>>>>>>${_groupValue}"),
                print(genderlist[_groupValue]),
                idgender=null,
                textGender=null,
              }
              ),
              // ),
            ),),
          // Expanded(
          //   child:

        ],
      ),
    );
  }
  Widget _myRadioButton({String? title, int? value, ValueChanged? onChanged}) {
    return RadioListTile(
      activeColor: Color(0xff00838f),
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title:
    Transform(
    transform: langApp=="ar"? Matrix4.translationValues(20.0, 0.0, 20.0)
        :
    Matrix4.translationValues(-20.0, 0.0, -20.0),
    child:Text(title!)
    ),

    );
  }


  Widget ageWidgit(){
    return Container(
      padding: EdgeInsets.only(left: 15,right: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(
              SetLocalization.of(context)!.getTranslateValue('age_group')!,
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
              age!,
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
    );
  }

  Widget nationalityWidgit(){
    return Container(
      padding: EdgeInsets.only(left: 15,right: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(
              SetLocalization.of(context)!.getTranslateValue('nationality')!,
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
              nationality==null?"(${SetLocalization.of(context)!.getTranslateValue("optional")})":nationality!,
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
    );
  }








  dilogCode_country(){

    phoneCodeController = new StreamController();

    showDialog(context: context,
        barrierDismissible: false,
        builder: (context){
          return StatefulBuilder(
              builder: (context, setState) {
                return Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color(0x14b5b5b5),
                                    ),

                                    child: TextField(
                                      onChanged: (value) {
                                        print(value);
                                        if (value.length >= 0) {
                                          setState(() {
                                            _filterCodePhone(value);
//                                            phoneCodeController.add( countrySearch.where((CountryCodeList item) => item.country.toLowerCase().startsWith(value.toLowerCase())).toList());
                                          });
                                        }else{
                                          setState((){
//                                            print(baseCountrySearch.length);
//                                            phoneCodeController.add(baseCountrySearch);
                                          });
                                        }
                                      },
                                      style: TextStyle(fontSize: 13, color: Color(0xffb5b5b5)),
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                        prefixIcon: IconButton(
                                          icon: Icon(Icons.search,color: Color(0xFF00838f)),
                                          onPressed: () {
                                          },
                                        ),
                                        hintText:SetLocalization.of(context)!.getTranslateValue('search_loc'),
                                        hintStyle: TextStyle(fontSize: 12, color: Color(0xffb5b5b5)),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),

                                InkWell(
                                  onTap:(){
                                    Navigator.pop(context);
                                  },
                                  child: Text(SetLocalization.of(context)!.getTranslateValue('close')!),
                                )
                              ],
                            ),
                          ),


                          //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   listView
                          Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height/2,
                            child: StreamBuilder(
//                              stream: phoneCodeController.stream,
                              builder: (context, countyCode){
//                                if (!countyCode.hasData) {
//                                  //print('project snapshot data is: ${projectSnap.data}');
//                                  return Center(child: CircularProgressIndicator());
//                                }

//                                countrySearch = countyCode.data;
                                return
                                  _All_country_code==null?CircularProgressIndicator()
                                  :
                                  ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(15),
                                  scrollDirection: Axis.vertical,
//            itemCount: 15,
                                  itemCount: _All_country_code == null ? 0
                                      : _All_country_code.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: ()=>{
                                        setState(() {
                                          idcountry_code=_All_country_code[index]["country"];
                                          country_code=_All_country_code[index]["code_country"].toString();
                                          Navigator.pop(context);
                                        }),
                                      },
                                      child:Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                      Flexible(child: Text(
                                              "${_All_country_code[index]["country"]}",
                                              style: const TextStyle(
                                                  color:  const Color(0xff000000),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "SFProText",
                                                  fontStyle:  FontStyle.normal,
                                                  fontSize: 15.0
                                              ),
                                              textAlign: TextAlign.left
                                          )
                                      ),


                                          Text(
                                              "${_All_country_code[index]["code_country"]}",
                                              style: const TextStyle(
                                                  color:  const Color(0xff000000),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "SFProText",
                                                  fontStyle:  FontStyle.normal,
                                                  fontSize: 15.0
                                              ),
                                              textAlign: TextAlign.left
                                          )
                                        ],
                                      ),

                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10,),
                          GestureDetector(
                            onTap:(){
                              Navigator.pop(context);
                            },
                            child: Container(
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  SetLocalization.of(context)!.getTranslateValue('done')!,
                                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                );
              }
          );
        }).then((value) => {
      setState(() {
//        selectedCode = selectedCode;
      })

    });
  }



  dilogCode_adge(){

    phoneCodeController = new StreamController();

    showDialog(context: context,
        barrierDismissible: false,
        builder: (context){
          return StatefulBuilder(
              builder: (context, setState) {
                return Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width/2,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color(0x14b5b5b5),
                                    ),

                                    child: TextField(
                                      onChanged: (value) {
                                        print(value);
                                        if (value.length >= 0) {
                                          setState(() {
                                            _filterAdge(value);
//                                            phoneCodeController.add( countrySearch.where((CountryCodeList item) => item.country.toLowerCase().startsWith(value.toLowerCase())).toList());
                                          });
                                        }else{
                                          setState((){
//                                            print(baseCountrySearch.length);
//                                            phoneCodeController.add(baseCountrySearch);
                                          });
                                        }
                                      },
                                      style: TextStyle(fontSize: 13, color: Color(0xffb5b5b5)),
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                        prefixIcon: IconButton(
                                          icon: Icon(Icons.search,color: Color(0xFF00838f)),
                                          onPressed: () {
                                          },
                                        ),
                                        hintText:SetLocalization.of(context)!.getTranslateValue('search_loc'),
                                        hintStyle: TextStyle(fontSize: 12, color: Color(0xffb5b5b5)),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),

                                InkWell(
                                  onTap:(){
                                    Navigator.pop(context);
                                  },
                                  child: Text(SetLocalization.of(context)!.getTranslateValue('close')!),
                                )
                              ],
                            ),
                          ),


                          //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   listView
                          Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height/2,
                            child: StreamBuilder(
//                              stream: phoneCodeController.stream,
                              builder: (context, countyCode){
//                                if (!countyCode.hasData) {
//                                  //print('project snapshot data is: ${projectSnap.data}');
//                                  return Center(child: CircularProgressIndicator());
//                                }

//                                countrySearch = countyCode.data;
                                return
                                  _All_age_group==null?CircularProgressIndicator()
                                      :
                                  ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.all(15),
                                    scrollDirection: Axis.vertical,
//            itemCount: 15,
                                    itemCount: _All_age_group == null ? 0
                                        : _All_age_group.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: ()=>{
                                          setState(() {

                                            idAge=_All_age_group[index]["id"];
                                            age=_All_age_group[index]["age_group"];
                                            Navigator.pop(context);

                                          }),
                                        },
                                        child:Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 5,),

                                            Flexible(child:  Text(
                                                "${_All_age_group[index]["age_group"]}",
                                                style: const TextStyle(
                                                    color:  const Color(0xff000000),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "SFProText",
                                                    fontStyle:  FontStyle.normal,
                                                    fontSize: 15.0
                                                ),
                                                textAlign: TextAlign.left
                                            )),
                                            SizedBox(height: 5,),
                                          ],
                                        ),

                                      );
                                    },
                                  );
                              },
                            ),
                          ),
                          SizedBox(height: 10,),
                          GestureDetector(
                            onTap:(){
                              Navigator.pop(context);
                            },
                            child: Container(
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  SetLocalization.of(context)!.getTranslateValue('done')!,
                                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                );
              }
          );
        }).then((value) => {
      setState(() {
//        selectedCode = selectedCode;
      })

    });
  }




  dilogCode_nationality(){

    phoneCodeController = new StreamController();

    showDialog(context: context,
        barrierDismissible: false,
        builder: (context){
          return StatefulBuilder(
              builder: (context, setState) {
                return Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width/4*3,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color(0x14b5b5b5),
                                    ),

                                    child: TextField(
                                      onChanged: (value) {
                                        print(value);
                                        if (value.length >= 0) {
                                          setState(() {
                                            _filterCountries(value);
                                           // phoneCodeController.add( countrySearch.where((CountryCodeList item) => item.country.toLowerCase().startsWith(value.toLowerCase())).toList());
                                          });
                                        }else{
                                          setState((){
//                                            print(baseCountrySearch.length);
//                                            phoneCodeController.add(baseCountrySearch);
                                          });
                                        }
                                      },
                                      style: TextStyle(fontSize: 13, color: Color(0xffb5b5b5)),
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                        prefixIcon: IconButton(
                                          icon: Icon(Icons.search,color: Color(0xFF00838f)),
                                          onPressed: () {
                                          },
                                        ),
                                        hintText:SetLocalization.of(context)!.getTranslateValue('search_loc'),
                                        hintStyle: TextStyle(fontSize: 12, color: Color(0xffb5b5b5)),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),

                                InkWell(
                                  onTap:(){
                                    Navigator.pop(context);
                                  },
                                  child: Text(SetLocalization.of(context)!.getTranslateValue('close')!),
                                )
                              ],
                            ),
                          ),


                          //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   listView
                          Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height/2,
                            child: StreamBuilder(
//                              stream: phoneCodeController.stream,
                              builder: (context, countyCode){
//                                if (!countyCode.hasData) {
//                                  //print('project snapshot data is: ${projectSnap.data}');
//                                  return Center(child: CircularProgressIndicator());
//                                }

//                                countrySearch = countyCode.data;
                                return
                                  _All_nationality==null?CircularProgressIndicator()
                                      :
                                  ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.all(15),
                                    scrollDirection: Axis.vertical,
//            itemCount: 15,
                                    itemCount: _All_nationality == null ? 0
                                        : _All_nationality.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: ()=>{
                                          setState(() {

                                            idNationality=_All_nationality[index]["id"];
                                            nationality=_All_nationality[index]["name"];
                                            Navigator.pop(context);

                                          }),
                                        },
                                        child:Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 5,),
                                        Flexible(child:
                                        Text(
                                                "${_All_nationality[index]["name"]}",
                                                style: const TextStyle(
                                                    color:  const Color(0xff000000),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "SFProText",
                                                    fontStyle:  FontStyle.normal,
                                                    fontSize: 15.0
                                                ),
                                                textAlign: TextAlign.left
                                            )
                                        ),
                                            SizedBox(height: 5,),
                                          ],
                                        ),

                                      );
                                    },
                                  );
                              },
                            ),
                          ),
                          SizedBox(height: 10,),
                          GestureDetector(
                            onTap:(){
                              Navigator.pop(context);
                            },
                            child: Container(
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  SetLocalization.of(context)!.getTranslateValue('done')!,
                                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                          )

                        ],
                      ),
                    ),
                  ),
                );
              }
          );
        }).then((value) => {
      setState(() {
//        selectedCode = selectedCode;
      })

    });
  }


  Future<List?> _login() async {
    setState(() {
      loading=true;
    });
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
//      SharedPreferences prefsa=await SharedPreferences.getInstance();
//      String lang = prefsa.getString('lang');
//
//      print("user name"+useremail.text.trim());
      Map<String, dynamic> body = {
        "lang":langApp,
        "name":fullNameController.text.toString().trim(),
        "email":emailController.text.toString().trim(),
        "password":passwordController.text.toString().trim(),
        "gender":textGender,
        "age_group":idAge,
        "phone_number":phoneController.text.toString().trim(),
        "country_code":idcountry_code.toString().trim(),
        "nationality":idNationality.toString().trim()
      };
      print(body.toString());

      print("body is <<<:"+body.toString());
      print("Url is <<<:"+URL_LOGIC.new_Sign_Up!);

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(Uri.parse(URL_LOGIC.new_Sign_Up!),
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
        loading=false;
      });
//    || message.toString().trim() != "Your Mobile Has Been Confirmed !"
//      print("code is $code");
      if(code.toString().trim() == "001"){
//        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPhoneAuthCode(phone: phone.text.toString(),)),);
//         dilog_code_confirm_(message,"confirm",datauser);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userid',datauser["userid"].toString());
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>HomApp()),);

      }
      else if(code.toString().trim() == "003"){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userid',datauser["userid"].toString());
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>HomApp()),);

//        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPhoneAuthCode()),);
//         dilog_code_confirm_(message,"confirm",datauser);
      }else {
        dilog_code_confirm_(message,"direction",datauser);
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

  dilog_code_confirm_(message,direction,Map datauser){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return   AlertDialog(
          title: null,
          content: Text(message.toString()),
          actions: [
            FlatButton(
                child: Text(SetLocalization.of(context)!.getTranslateValue('ok')!),
                onPressed: () async {
                  print(direction);
                  if(direction.toString()!="confirm"){
                    print("==");
//                    Navigator.of(context).pop(true);
//                     Navigator.pop(context);
//                     Navigator.pop(context);
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('userid',datauser["userid"].toString());
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>HomApp()),);

                    // Navigator.pop(context);
                  }else if(direction.toString()=="confirm") {
                    // Navigator.pop(context);
                    Navigator.pop(context);
                    print("!=");
//                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPhoneAuthCode()),);
                  }
                }),
          ],
        );
      },
    );
  }

}