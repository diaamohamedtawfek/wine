import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wineapp/home/HomApp.dart';


class GistPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return UiGistPAJE();
  }

}

class UiGistPAJE extends State<GistPage> {

  @override
  void initState() {
    super.initState();
    getStringValuesSF();
  }

  String? langApp="en";
  String? idUser;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('lang');
    String? userid = prefs.getString('userid');
    print("idUser=> "+lang.toString());
    setState(() {
      langApp=lang;
      idUser=userid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(
              langApp=="ar"?
              "assets/images/splaenImagear2.png":"assets/images/splaenImage1.png",
            ),
              fit: BoxFit.fill,
            )
        ),

        child:
              Container(
                margin: EdgeInsets.only(top: 82),
                width: MediaQuery.of(context).size.width,
                height: 100,

                // ignore: deprecated_member_use
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('gist',"gist");
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>HomApp()),);
                  },
                  child: Text(""),
                ),
              )
      ),
    );
  }
}