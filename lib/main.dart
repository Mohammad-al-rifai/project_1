import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:background_app_bar/background_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:project_property/API.dart';
import 'package:project_property/Basic%20Ui/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:project_property/page/Home.dart';
import 'package:project_property/page/myPosts.dart';
import 'package:project_property/propertydetails/property.dart';
import 'package:provider/provider.dart';
import 'package:project_property/Basic Ui/PropertyDetail.dart';
import 'package:project_property/Admin/PropertyDetailAdmin.dart';
import 'package:project_property/newProperty/addNewHome.dart';
import 'package:project_property/user/login.dart';
import 'package:project_property/user/registration.dart';
import 'package:project_property/user/splash_screen.dart';
import 'package:dcdg/dcdg.dart';

import 'blocs/theme.dart';
import 'drawers.dart';
void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host,
          int port) => true;
  }
}





class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (context) => ThemeChanger(ThemeData.dark()),

      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:SplashPage(),
      theme: theme.getTheme(),
    );
  }
}

