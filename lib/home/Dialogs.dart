
import 'package:flutter/material.dart';
import 'package:wineapp/lang/localization/set_localization.dart';

class Dialogs{
  static Future<void> showErrorDialog(BuildContext context, String err) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
              children:[
                Icon(Icons.error, color: Colors.red,),
                Text(SetLocalization.of(context)!.getTranslateValue('error')!)
              ]
          ),
          content: Text(SetLocalization.of(context)!.getTranslateValue('error_reason')!+' $err'),
          actions: <Widget>[
            FlatButton(
              child: Text(SetLocalization.of(context)!.getTranslateValue('ok')!,style: TextStyle(color: Color(0xff00838f)),),
              onPressed: () {
                //Put your code here which you want to execute on Yes button click.
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }

  static Future<bool?> popup(BuildContext context) async {
    Navigator.of(context).pop(true);
  }

  static Future<bool> onWillPop(BuildContext context) async {
    return (await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        title: Text(SetLocalization.of(context)!.getTranslateValue('are_you_sure')!),
        titlePadding: EdgeInsets.all(5.0),
        contentPadding: EdgeInsets.all(5.0),
        content: Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
               FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(SetLocalization.of(context)!.getTranslateValue('no')!,style: TextStyle(
                  color: Color(0xff00838f)
                ),),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                 padding: EdgeInsets.all(0.0),
              ),
               FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: new Text(SetLocalization.of(context)!.getTranslateValue('yes')!,style: TextStyle(
                    color: Color(0xff00838f)
                ),),
                padding: EdgeInsets.all(0.0),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ), // button 2
            ]
        ),
      ),
    )) ?? false;
  }
}