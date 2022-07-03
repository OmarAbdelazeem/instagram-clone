import 'package:flutter/material.dart';
import 'package:instagramapp/src/res/app_strings.dart';

Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async {

  return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
                key: key,
                backgroundColor: Colors.black54,
                children: <Widget>[
                  Center(
                    child: Column(children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppStrings.pleaseWait,
                        style: TextStyle(color: Colors.blueAccent),
                      )
                    ]),
                  )
                ]));
      });
}
