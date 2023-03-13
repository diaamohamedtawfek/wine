import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wineapp/lang/localization/set_localization.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../URL_LOGIC.dart';

class AcountInfoScreenNew extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return UnAcountInfoScreenNew();
  }
}

class UnAcountInfoScreenNew extends State<AcountInfoScreenNew> {


  StreamController? phoneCodeController;
//isReceiveOffers,isReceiveNews
  bool isReceiveOffers = true;
  bool isReceiveNews = true;

  bool loading_lovly=true;
  final _formKey = GlobalKey<FormState>();

  bool fullNameError=false;
  TextEditingController fullNameController = TextEditingController();

  bool emailError=false;
  TextEditingController emailController = TextEditingController();

  bool userphoneError=false;
  TextEditingController phoneController = TextEditingController();

  bool userbirthdayError=false;
  TextEditingController birthdayController = TextEditingController();

  String? idAge;
  String? idNationality;
  String? idcountry_code;
  String? idgender;

  String? age;
  String? country_code;
  String? nationality;
  String textGender="Male";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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

      getData_User();
      getData_NationalityApi();
      getData_age_group();
      getData_country_code("");
    });
//    return stringValue;
  }


  Map? data_User;
  List _All_User=[];

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
    print("url is :"+URL_LOGIC.accountInfo.toString());
    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};

    http.Response response_offer = await http.post(
      Uri.parse(URL_LOGIC.accountInfo!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    data_User = json.decode(response_offer.body);

//    userData_offer = data_offer["bestseller"];


    setState(() {
   print("data_User  >>>???>>>  "+data_User.toString());
    loading_lovly=false;
      data_User = json.decode(response_offer.body);

    fullNameController.text=data_User!["username"];
    print(">>>>>>>>>> "+data_User!["name"].toString()+"<<<<<<<<<<<");

    if(data_User!["email"].toString()!="null"){
      emailController.text=data_User!["email"];
    }

    if(data_User!["phone_number"].toString()!="null"){
      phoneController.text=data_User!["phone_number"];
    }


    if(data_User!["date_of_birth"] !=null || data_User!["date_of_birth"].toString().trim() !="null"){
      print(data_User!["date_of_birth"].toString()+"?>?>?>");
      birthdayController.text=data_User!["date_of_birth"];
    }

   if(data_User!["receive_offer"].toString()!="1" ){
     setState(() {
       isReceiveOffers=false;
     });
   }else{
     isReceiveOffers=true;
   }

   if(data_User!["newsletter"].toString()!="1" ){
     setState(() {
       isReceiveNews=false;
     });;
   }else{
     isReceiveNews=true;
   }



   setState(() {
     idAge=data_User!["age_group"].toString();
     age=data_User!["age_group_name"].toString();

     idcountry_code=data_User!["country_code"];
     country_code=data_User!["idCodeCunt"];

     idNationality=data_User!["nationality"];
     nationality=data_User!["nationality_name"];
   });




   if(data_User!["gender"].toString()=="Male"){
     setState(() {
       _groupValue=0;
     });
   }else{
     setState(() {
       _groupValue=1;
     });
   }

   // String idNationality;
   String idgender;


      // print("Nationality "+_All_nationality.toString());
    });
  }




  Map? data_offer;
  List _All_nationality=[];
  List _All_nationality_old=[];

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

    http.Response response_offer = await http.post(
        Uri.parse(URL_LOGIC.Nationality!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    data_offer = json.decode(response_offer.body);

//    userData_offer = data_offer["bestseller"];


    setState(() {
//    print(data_offer.toString());

      data_offer = json.decode(response_offer.body);

      _All_nationality.addAll(data_offer!["nationality"]);
      _All_nationality_old.addAll(data_offer!["nationality"]);
      if(_All_nationality.isNotEmpty){
        setState(() {
          // _All_nationality_old.addAll(data_offer["nationality"]);
          // idNationality=_All_nationality[0]["id"].toString();
          // nationality=_All_nationality[0]["name"].toString();
        });

      }
      print("Nationality "+_All_nationality.toString());
    });
  }



  void _filterCountries(value) {
    print("meth filtter");
    print(_All_nationality_old.toString());
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

    http.Response response_offer = await http.post(
        Uri.parse(URL_LOGIC.age_group!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    data_offer = json.decode(response_offer.body);

//    userData_offer = data_offer["bestseller"];


    setState(() {
//    print(data_offer.toString());

      data_age_group = json.decode(response_offer.body);

      _All_age_group.addAll(data_age_group!["age_group"]);
      _All_age_group_old.addAll(data_age_group!["age_group"]);
      print("_All_age_group "+_All_age_group.toString());

      if(_All_age_group.isNotEmpty){
        setState(() {
          // idAge=_All_age_group[0]["id"].toString();
          // age=_All_age_group[0]["age_group"].toString();
        });

      }

    });
  }




  Map? data_country_code;
  List _All_country_code=[];
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

    http.Response response_offer = await http.post(
        Uri.parse(URL_LOGIC.country_code!),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    data_country_code = json.decode(response_offer.body);

//    userData_offer = data_offer["bestseller"];


    setState(() {
//    print(data_offer.toString());

      data_country_code = json.decode(response_offer.body);

      setState(() {
        data_country_code = json.decode(response_offer.body);
        _All_country_code.addAll(data_country_code!["age_group"]);
      });

      if(_All_country_code.isNotEmpty){
        setState(() {
          // idcountry_code=_All_country_code[0]["id"].toString();
          // country_code=_All_country_code[0]["code_country"].toString();

        });

        if(direction=="pop"){
          // dilogCode_country();
        }
      }
      print("getData_country_code() "+_All_country_code.toString());
    });
  }




  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff00838f),
        centerTitle: true,
        title: Text(
          SetLocalization.of(context)!.getTranslateValue('nav_settings_account')!,
          style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
      ),


      body: Stack(
        children: [


          LoadingOverlay(
              isLoading: loading_lovly,
              color: Color(0xFF00838f),
              child:
              Form(
                key: _formKey,

                child: ListView(
                  padding: EdgeInsets.only(bottom: 44),
                  children: [


                    Column(
                      children: [

                        SizedBox(height: 30,),

                        username(),

                        SizedBox(height: 30,),

                        useremail(),
                        SizedBox(height: 30,),

                        userbirthdar(),

                        SizedBox(height: 30,),

                        country_code==null?Text(""):
                        phone(),

                        SizedBox(height: 30,),
                        gender(),

                        SizedBox(height: 30,),

                        // age==null?Text(""):
                        InkWell(
                          onTap: ()=>{
                            dilogCode_adge(),
                          },
                          child: ageWidgit(),
                        ),


                        SizedBox(height: 30,),

                        // nationality==null?Text(""):
                        InkWell(
                          onTap: ()=>{
                            dilogCode_nationality(),
                          },
                          child: nationalityWidgit(),
                        ),


                        SizedBox(height: 30,),

                      ],
                    ),

                    Row(
                      children: [
                        Checkbox(

                          //title: Text("Yes, I want to receive offers"),
                          value: isReceiveOffers,
                          onChanged: (newValue) {
                            setState(() {
                              isReceiveOffers = newValue!;
                            });
                          },
                          //controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                        ),
                        Text(SetLocalization.of(context)!.getTranslateValue('recive_offer')!),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(

                          //title: Text("Yes, I want to receive offers"),
                          value: isReceiveNews,
                          onChanged: (newValue) {
                            setState(() {
                              isReceiveNews = newValue!;
                            });
                          },
                          //controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                        ),
                        Text(SetLocalization.of(context)!.getTranslateValue('recive_news')!),
                      ],
                    ),


                    //button signup
                    Container(
                      height: 45,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: RaisedButton(
                        child: Text(
                          SetLocalization.of(context)!.getTranslateValue('done')!,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if( EmailValidator.validate(emailController.text.trim())){
                              setState(() {
                                emailError = false;
                              });
                              if(loading==false) {
                                _login();
                              }

//                               if(acceptTerms==true && idAge!=null &&idNationality!=null &&idcountry_code!=null){
//
//                                 if(passwordController.text.length <6){
//                                   setState(() {
//                                     passwordError=true;repasswordError=true;
//                                   });
//
//                                 }else{
//                                   if(passwordController.text!=repasswordController.text){
//                                     setState(() {
//                                       repasswordError=true;
//                                       passwordError=true;
//                                     });
//
//                                   }else{
//                                     passwordError=false;
//                                     repasswordError=false;
//                                     print("object");
//                                     _login();
//                                   }
//
// //                            print("object");
//                                 }
//                               }else{
//
//                               }
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
                  ],
                ),
              )
          )

        ],
      ),
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
                    // return  null;
                   return  SetLocalization.of(context)!.getTranslateValue('login_email_phone');
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
                    // return  null;
                   return  SetLocalization.of(context)!.getTranslateValue('login_email_phone');
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


  String? x;
  Future _selectDate() async {
    print("object");


    DateTime selectedDate = DateTime.now();

    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1800, 10,9),
        lastDate: DateTime(2201,8));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        String v=picked.toString();
        v.substring(0,10);
        x="${v.substring(0,10)}";
        // email.text ="$x";

        print(">>>>>>>>>>>>>>$x");
        birthdayController.text ="$x";
        userbirthdayError=false;

      });
  }

  Widget userbirthdar(){
    return  InkWell(
      onTap: ()=>{
        _selectDate(),
      },
      child: Container(
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
                  enabled: false,
                  onTap: ()=>{
                    _selectDate(),
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      setState(() {
                        userbirthdayError = true;
                      });
                      return  SetLocalization.of(context)!.getTranslateValue('birthdar');
//                    return  SetLocalization.of(context).getTranslateValue('login_email_phone');
                    }

                    return null;
                  },
//                validator: (value)=>!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)?"Enter Valid Email like  info@gmail.com ":null,
                  controller: birthdayController,
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


                    prefixIcon: Icon(Icons.calendar_today_outlined, color: Color(0xff00838f),),
                    hintText:SetLocalization.of(context)!.getTranslateValue('birthdar'),

                  ),
                ),
              ),
              Visibility(
                visible: userbirthdayError,
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
                                SetLocalization.of(context)!.getTranslateValue('birthdar')!,
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
                      onChanged: (w){
                        setState(() {
                          userphoneError=false;

                        });
                      },
                      validator: (val){
                        if(val!.isEmpty){
                          setState(() {
                            userphoneError=true;
                          });

                          return SetLocalization.of(context)!.getTranslateValue('phone');
                          // return null;
                        }else{
                          setState(() {
                            userphoneError=false;
                          });

                          return null;
                        }

                        return null ;
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
  int _groupValue = 0;

  Widget gender(){
    return Container(
      padding: EdgeInsets.only(left: 19,right: 19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(padding: EdgeInsets.only(left: 0,right: 0),
            child: Text(SetLocalization.of(context)!.getTranslateValue("gender")!,
              style: TextStyle(
                fontFamily: 'SFProText',
                color: Color(0xff000000),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ) ,
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child:
              Transform(
              transform:
              langApp.toString()=="ar"?Matrix4.translationValues(25.0, 0.0, 20.0):
                Matrix4.translationValues(-25.0, 0.0, -20.0),
                child:
                Container(
                  // color: Colors.grey,
                  child: _myRadioButton(
                    title: SetLocalization.of(context)!.getTranslateValue("male"),
                    value: 0,
                    onChanged: (newValue) => setState(() =>{
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
              ),

              Expanded(
                child:  _myRadioButton(
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


            ],

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
      onChanged: onChanged,
      title:  Transform(
    transform: langApp=="ar"? Matrix4.translationValues(20.0, 0.0, 20.0)
        :
    Matrix4.translationValues(-20.0, 0.0, -20.0),
    child:Text(title!)),

    );
  }

  Widget ageWidgit(){
    return Container(
      padding: EdgeInsets.only(left: 19,right: 19),
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
              (age==null?" ${SetLocalization.of(context)!.getTranslateValue("optional")} " : age)!,
              // age.toString(),
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
      padding: EdgeInsets.only(left: 19,right: 19),
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
              (nationality==null?" ${SetLocalization.of(context)!.getTranslateValue("optional")} " : nationality)!,
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
                                            print(value);
                                           _filterCountries(value);
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
                                          icon: Icon(Icons.search),
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
                                            Text(
                                                "${_All_country_code[index]["country"]}",
                                                style: const TextStyle(
                                                    color:  const Color(0xff000000),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "SFProText",
                                                    fontStyle:  FontStyle.normal,
                                                    fontSize: 15.0
                                                ),
                                                textAlign: TextAlign.left
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
                                          icon: Icon(Icons.search),
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
                                            Text(
                                                "${_All_age_group[index]["age_group"]}",
                                                style: const TextStyle(
                                                    color:  const Color(0xff000000),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "SFProText",
                                                    fontStyle:  FontStyle.normal,
                                                    fontSize: 15.0
                                                ),
                                                textAlign: TextAlign.left
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
                                          icon: Icon(Icons.search),
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
    try{
      Map<String, dynamic> body ={
        "lang":langApp,
        "userid":idUsers,
        "username":fullNameController.text.toString().trim(),
        "email":emailController.text.toString().trim(),
        "age_group":idAge,
        "gender":textGender,
        "country_code":idcountry_code,
        "phone_number":phoneController.text.toString().trim(),
        "nationality":idNationality,
        "date_of_birth":birthdayController.text.toString().trim(),
        "receive_offer":isReceiveOffers,
        "newsletter":isReceiveNews
      };
      print(body.toString());

      print("body is <<<:"+body.toString());
      print("Url is <<<:"+URL_LOGIC.edit_accountinfo!);

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(Uri.parse(URL_LOGIC.edit_accountinfo!),
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
      if(code.toString().trim() == "010"){
//        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPhoneAuthCode(phone: phone.text.toString(),)),);
//         dilog_code_confirm_(message,"confirm");
      Navigator.pop(context);
      }
      else if(code.toString().trim() == "003"){
//        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPhoneAuthCode()),);
//         dilog_code_confirm_(message,"confirm");
      }else {
        // dilog_code_confirm_(message,"direction");
      }


    }catch(exception){
      Future.delayed(Duration(seconds: 1)).then((value) async {

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