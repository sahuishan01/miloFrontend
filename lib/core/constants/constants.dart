import 'package:flutter/widgets.dart';

class Constants {
  static String backendUri = "http://192.168.1.10:8000";

  static height(BuildContext context){
    return MediaQuery.of(context).size.height;
  }

  static width(BuildContext context){
    return MediaQuery.of(context).size.width;
  }
}