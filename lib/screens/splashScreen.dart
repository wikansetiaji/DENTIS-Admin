import 'package:flutter/material.dart';
import 'initialScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void load() async{
    await new Future.delayed(const Duration(seconds: 3));
    print("haha");
    Navigator.pushReplacement(
      context, 
      new MaterialPageRoute(
        builder: (BuildContext context) =>
        new InitialScreen(title:"Login Screen")
      )
    );
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