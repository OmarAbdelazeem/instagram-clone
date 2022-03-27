import 'package:flutter/material.dart';
import 'package:instagramapp/widgets/email_or_phone_option.dart';
import 'bottom_of_signup_page.dart';
import 'name_and_password.dart';
import 'package:instagramapp/services/navigation_functions.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isEmailActive = true;
  bool isPhoneActive = false;
  TextEditingController emailAndPhoneController = TextEditingController();
  String inputVal = '';

  void clearEmailAndPhoneController() {
    emailAndPhoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        body: Align(
          alignment: Alignment.bottomCenter,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(
                          Icons.person_pin,
                          size: 160,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    isPhoneActive = true;
                                    isEmailActive = false;

                                  });
                                },
                                child: EmailOrPhoneOption(
                                  isActive: isPhoneActive,
                                  optionType: 'Phone',
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    isEmailActive = true;
                                    isPhoneActive = false;
                                  });
                                },
                                child: EmailOrPhoneOption(
                                  isActive: isEmailActive,
                                  optionType: 'Email',
                                ),
                              ),

                            ],
                          )
                        ),
                        customTextField(),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 40,
                          child: RaisedButton(
                            disabledColor: Color(0xffb6e2fa),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                  color: inputVal != ''
                                      ? Colors.white
                                      : Colors.white70),
                            ),
                            onPressed: inputVal != ''
                                ? () {
                                    NavigationFunctions.navigateToPage(
                                      context,
                                      NameAndPassword(
                                        email: emailAndPhoneController.text,
                                      ),
                                    );
                                  }
                                : null,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    BottomOfSignUpPage()
                  ],
                ),
              )
            ],
          ),
        ));
//    );
  }

  Widget customTextField(){
    return  Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 38,
        margin: EdgeInsets.all(2),
        child: TextFormField(
          onChanged: (val) {
            setState(() {
              inputVal = val;
              print(inputVal);
            });
          },
          keyboardType: isEmailActive
              ? TextInputType.emailAddress
              : TextInputType.number,
          controller: emailAndPhoneController,
          decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfffafafa),
              hintText: isEmailActive ? "Email" : 'Phone',
              filled: true,
              suffixIcon: IconButton(
                color: Colors.grey,
                icon: Icon(Icons.clear),
                onPressed: clearEmailAndPhoneController,
              ),
              icon:
              !isEmailActive ? Text('EG +20 ') : null),
        ),
      ),
    );
  }
}
