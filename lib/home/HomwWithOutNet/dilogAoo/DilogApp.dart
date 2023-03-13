
import 'package:flutter/material.dart';
import 'package:wineapp/lang/localization/set_localization.dart';

class DilogApp{

  // static dilogNoEnternet(context){
  //   AlertDialog alertDialog = new AlertDialog.Builder(context).create();
  //
  //   alertDialog.setTitle("Info");
  //   alertDialog.setMessage("Internet not available, Cross check your internet connectivity and try again");
  //   alertDialog.setIcon(android.R.drawable.ic_dialog_alert);
  //   alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
  //   public void onClick(DialogInterface dialog, int which) {
  //   finish();
  //
  //   }
  //   });
  //
  //   alertDialog.show();
  // }

 static  Future<void> sign_in(BuildContext context) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text(SetLocalization.of(context)!.getTranslateValue('error')!),
          content: Text(SetLocalization.of(context)!.getTranslateValue('errorNet')!),
          actions: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                FlatButton(
                  child: Text(SetLocalization.of(context)!.getTranslateValue('close')!),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],

        );
      },
    );
  }
}