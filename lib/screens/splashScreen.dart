import 'package:flutter/material.dart';
import 'initialScreen.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:dent_is_admin/screens/admin/adminHome.dart';
import 'package:dent_is_admin/screens/dokter/dokterTabs.dart';
import 'package:dent_is_admin/screens/manajer/manajerHome.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void load() async{
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    
    PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
    List<Cookie> cookiesDokter = (cj.loadForRequest(Uri.parse("http://dent-is.herokuapp.com/dokter-login/")));
    List<Cookie> cookiesAdmin = (cj.loadForRequest(Uri.parse("http://dent-is.herokuapp.com/admin-login/")));
    List<Cookie> cookiesManajer = (cj.loadForRequest(Uri.parse("http://dent-is.herokuapp.com/admin-login/")));
    await new Future.delayed(const Duration(seconds: 3));
    if (cookiesAdmin.length!=0){
      Navigator.pushReplacement(
      context, 
      new MaterialPageRoute(
        builder: (BuildContext context) =>
        new AdminHome()
      )
    );
    }
    else if (cookiesDokter.length!=0){
      Navigator.pushReplacement(
        context, 
        new MaterialPageRoute(
          builder: (BuildContext context) =>
          new DokterTabs()
        )
      );
    }
    else if (cookiesManajer.length!=0){
      Navigator.pushReplacement(
        context, 
        new MaterialPageRoute(
          builder: (BuildContext context) =>
          new ManajerHome()
        )
      );
    }
    else{
      print("haha");
      Navigator.pushReplacement(
        context, 
        new MaterialPageRoute(
          builder: (BuildContext context) =>
          new InitialScreen(title:"Login Screen")
        )
      );
    }
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/logo.png"),width: 125,height: 144.56,)
          ],
        ),
      ),
    );
  }
}