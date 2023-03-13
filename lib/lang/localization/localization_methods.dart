
import 'package:flutter/material.dart';
import 'package:wineapp/lang/localization/set_localization.dart';

String? getTranslated(BuildContext context, String key) {
  return SetLocalization.of(context)!.getTranslateValue(key);
}
