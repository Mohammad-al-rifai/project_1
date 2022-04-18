import 'package:flutter/material.dart';
import 'package:project_property/Basic%20Ui/home.dart';
import 'package:project_property/page/Home.dart';
import 'package:project_property/user/splash_screen.dart';
import 'package:project_property/user/validate/inputUser.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'component/ButtonClick.dart';
import 'component/formField.dart';
import 'component/header.dart';
import 'component/richText.dart';
import 'login.dart';

class RegPage extends StatefulWidget {
  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  var fname = TextEditingController();
  var lname = TextEditingController();
  var mail = TextEditingController();
  var userName = TextEditingController();
  var pass = TextEditingController();

  final formKey = GlobalKey<FormState>();
  var scaf = GlobalKey<ScaffoldState>();

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
            height: MediaQuery.of(context).size.height + 160,
            padding: EdgeInsets.only(bottom: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                HeaderText(txt: "Register"),

                //headerText(),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Column(
                      children: <Widget>[
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextInput(
                                  controller: fname,
                                  hint: "First name",
                                  icon: Icons.person,
                                  valid: Check.checkName),
                              TextInput(
                                  controller: lname,
                                  hint: "Last name",
                                  icon: Icons.person,
                                  valid: Check.checkName),
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
                                  hint: "Password",
                                  icon: Icons.vpn_key,
                                  valid: Check.checkPass),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30.0),
                          child: Center(
                            child: ButtonWidget(
                                text: "REGISTER",
                                onClick: () async{
                                  if (formKey.currentState.validate()) {
                                    print("Valid ");
                                 var req= await registerUser();
                                 try {
                                   print(req);
                                   if (req['msg'] == "true") {
                                     Navigator.of(context).push(
                                         MaterialPageRoute(
                                             builder: (context) => Home()));
                                   }
                                 }
                                 catch(e)
                                  {
                                  print("107");
                                  }

                                  }
                                  else {
                                    print("Not Valid");
                                  }
                                }),
                          ),
                        ),
                        RichTxt(
                          strOne: "Already a member ? ",
                          strTwo: "Login",
                          onClick: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LogPage(type: false,)));
                          },
                        )
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

 registerUser() async {
    var data = {
      "first_name": fname.text,
      "last_name": lname.text,
      "username": userName.text,
      "email": mail.text,
      "password": pass.text
    };
    try {
      var url = "https://propertymanagment.000webhostapp.com/register.php";
      var response = await http.post(Uri.parse(url), body: data);
      var req = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (req['msg'] == "account already exists") {
          showResult('account already exists, Please login');
        } else {
          if (req['msg'] == "true") {
            setData(req["id"], req["first_name"], req["last_name"], req["email"],req['token']);
            showResult('account Created successfully!');
          } else {
            showResult('Error in Created  account,Try again!');
          }
        }
      }
      return req;
    } catch (e) {
      print(e.toString());
    }
  }

  void showResult(String msg) {
    // ignore: deprecated_member_use
    scaf.currentState.showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
      ),
    );
  }
  void setData(String id, String firstName, String lastName, String email,String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("id", id);
    pref.setString("firstName", firstName);
    pref.setString("lastName", lastName);
    pref.setString("email", email);
    pref.setString("token", token);


  }
}
