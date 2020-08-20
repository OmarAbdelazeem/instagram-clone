import 'package:flutter/material.dart';

class EmailOrPhoneOption extends StatelessWidget {
  final bool isActive;
  final String optionType;
  EmailOrPhoneOption({this.isActive,this.optionType});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
      MediaQuery.of(context).size.width * 0.45,
      child: Column(
        children: <Widget>[
          Text(
            optionType,
            style: TextStyle(
                fontWeight: isActive
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: isActive
                    ? Colors.black87
                    : Colors.grey),
          ),
          Divider(
            thickness: 1.5,
            color: isActive
                ? Colors.black87
                : Colors.grey,
          )
        ],
      ),
    );
  }
}


