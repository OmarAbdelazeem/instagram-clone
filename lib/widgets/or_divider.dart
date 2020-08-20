import 'package:flutter/material.dart';

Row orWithDivider(BuildContext context){
  return  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Divider(
          color: Colors.grey,
        ),
        margin: EdgeInsets.only(right: 15),
      ),
      Text('OR',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
      Container(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Divider(
          color: Colors.grey,
        ),
        margin: EdgeInsets.only(left: 15),
      ),
    ],
  );
}