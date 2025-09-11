import 'package:flutter/material.dart';

showSnackBar(
    {
      required BuildContext context,
      required String text,
      bool isError = true}){
    SnackBar snackBar = SnackBar(
      content: Text(text),
      backgroundColor: (isError)? Colors.red : Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      duration: const Duration(seconds: 4),
      action: SnackBarAction(
          label: "Ok",
          textColor: Colors.white,
          onPressed: (){
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }),
  );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
}