

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_property/user/validate/inputUser.dart';

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'component/ButtonClick.dart';
import 'component/formField.dart';
import 'component/header.dart';
import 'component/richText.dart';
import 'registration.dart';

class ForgetPass extends StatefulWidget {

  @override
  _ForgetPassState createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  var pass = TextEditingController();
  var mail = TextEditingController();

  var userName = TextEditingController();

  final formKey = GlobalKey<FormState>();

  var scaf = GlobalKey<ScaffoldState>();
  var _token;
@override
  void initState() {

    // TODO: implement initState
    super.initState();
    getUserToken();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaf,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height + 130,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                HeaderText(txt: "Login"),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Column(
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              TextInput(
                                  controller: userName,
                                  hint: "UserName",
                                  icon: Icons.person,
                                  valid: Check.checkName),
                              TextInput(
                                  controller: mail,
                                  hint: "Email",
                                  icon: Icons.email,
                                  valid: Check.checkMail),
                              TextInput(
                                  controller: pass,
                                  hint: "New Password",
                                  icon: Icons.vpn_key,
                                  valid: Check.checkPass),
                              Container(
                                margin: EdgeInsets.only(top: 30.0),
                                child: Center(
                                  child: ButtonWidget(
                                    text: "CONFIRM",
                                    onClick: () {
                                      if (formKey.currentState.validate()) {
                                        print("Valid ");
                                        forgetPassUser();
                                        // Navigator.of(context).push(MaterialPageRoute(
                                        //     builder: (context) => Home()));
                                      } else {
                                        print("Not Valid");
                                      }
                                    },
                                  ),
                                ),
                              ),
                              RichTxt(
                                strOne: "A New member ? ",
                                strTwo: "create account ",
                                onClick: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => RegPage()));
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> forgetPassUser() async {
    var data = {
      "username": userName.text,
      "email": mail.text,
      "password": pass.text,
      "token": _token
    };
    print(data);
    try {
      var url = "https://propertymanagment.000webhostapp.com/forgetpass.php";
      var response = await http.post(Uri.parse(url), body: data);
      var req = jsonDecode(response.body);
      print(req);
      if (response.statusCode == 200) {
        if (req == "true") {
          showResult('Change Password Successfully');
        } else if (req == "false") {
          showResult('Error in change Password');
        } else {
          showResult('account not found, Please Create new account');
        }
      }
    } catch (e) {}
  }

  void showResult(String msg) {
    // ignore: deprecated_member_use
    scaf.currentState.showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
      ),
    );
  }
  Future<void>  getUserToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {

      _token = pref.getString("token")??"000";
    });

  }
}
