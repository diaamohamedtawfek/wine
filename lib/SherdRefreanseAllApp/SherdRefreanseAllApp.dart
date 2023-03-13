
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class SherdRefreanseAllApp{

  String nameMole="nameMole" ;
  String allEventsSherd="allEvents" ;
  String allSliderSherd="allSliderSherd" ;
  String allFiltterSherd="allFiltterSherd" ;
  String allCategrySherd="allCategrySherd";
  String allOffersSherd="allOffersSherd";

  SharedPreferences? prefs;



  Future setNameeMole_SherdRefreanse({nameMoaledd}) async {

    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    await prefs?.setString(nameMole, "$nameMoaledd");
  }


Future setAllEvents({allEvents}) async {
  if (prefs == null) {
    prefs = await SharedPreferences.getInstance();
  }
  await prefs?.setString(allEventsSherd, "$allEvents");
}



Future setAllSlider({allSlider}) async {
  if (prefs == null) {
    prefs = await SharedPreferences.getInstance();
  }
  await prefs?.setString(allSliderSherd, "$allSlider");
}



Future setAllFilter({allFiltter}) async {
  if (prefs == null) {
    prefs = await SharedPreferences.getInstance();
  }
  await prefs?.setString(allFiltterSherd, "$allFiltter");
}


Future setAllCatigry({allCategry}) async {
  if (prefs == null) {
    prefs = await SharedPreferences.getInstance();
  }

  await prefs?.setString(allCategrySherd, "$allCategry");
}


Future setAllOffers({allOffers}) async {
  if (prefs == null) {
    prefs = await SharedPreferences.getInstance();
  }
  await prefs?.setString(allOffersSherd, "$allOffers");
}



//// # -------------------------------  get sherd  ------------------------------------- # //
// * >>>>>>>>>>>>>>>>>>>>>>>>>>>>>  get sherd

String? nameMaleNalue="";

Future<String?> getNameeMole_SherdRefreanse(BuildContext context,) async {
    // save the chosen locale
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    nameMaleNalue = prefs?.getString(nameMole)!;

    return nameMaleNalue;
  }


String? allEventString="";
Future<String?> getAllEvent(BuildContext context,) async {
  // save the chosen locale
  if (prefs == null) {
    prefs = await SharedPreferences.getInstance();
  }
  allEventString = prefs?.getString(allEventsSherd)!;

  return allEventString;
}



String? allSliderString="";
Future<String?> getAllSlider(BuildContext context,) async {
  // save the chosen locale
  if (prefs == null) {
    prefs = await SharedPreferences.getInstance();
  }
  allSliderString = prefs?.getString(allSliderSherd)!;

  return allSliderString;
}



String? allFiltterString="";
Future<String?> getAllFiltter(BuildContext context,) async {
  // save the chosen locale
  if (prefs == null) {
    prefs = await SharedPreferences.getInstance();
  }
  allFiltterString = prefs?.getString(allFiltterSherd)!;

  return allFiltterString;
}



String? allCatigryString="";
Future<String?> getAllCatigry(BuildContext context,) async {
  // save the chosen locale
  if (prefs == null) {
    prefs = await SharedPreferences.getInstance();
  }
  allCatigryString = prefs?.getString(allCategrySherd)!;

  return allCatigryString;
}



String? allOffersString="";
Future<String?> getAllOffers(BuildContext context,) async {
  // save the chosen locale
  if (prefs == null) {
    prefs = await SharedPreferences.getInstance();
  }
  allOffersString = prefs?.getString(allOffersSherd)!;

  return allOffersString;
}





// }