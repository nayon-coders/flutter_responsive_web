import 'package:flutter/material.dart';

class AppLoading{
  static Future<void> showMyDialog(context) async {
    var size = MediaQuery.of(context).size; 
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(
          height: 40, width: 40,
          color: Colors.black.withOpacity(0.3),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(padding: EdgeInsets.all(10), height: 40, width: 40, child: CircularProgressIndicator(strokeWidth: 1, color: Colors.white,)),
          ),
        );
      },
    );
  }
}