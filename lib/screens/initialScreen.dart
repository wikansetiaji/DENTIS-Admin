import 'package:flutter/material.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'loginScreen.dart';

class InitialScreen extends StatefulWidget {
  InitialScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 30.0),
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.contain,image: AssetImage("assets/logo.png"))),
                  ),
                  ButtonGradient(
                    height: 48,
                    width: 200,
                    text: "Masuk Sebagai Admin",
                    onTap: (){
                      Navigator.pushReplacement(
                      context, 
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new LoginScreen(role:"admin")
                        )
                      );
                    },
                  ),
                  Container(height: 10.0,),
                  ButtonGradient(
                    height: 48,
                    width: 200,
                    text: "Masuk Sebagai Dokter",
                    onTap: (){
                      Navigator.pushReplacement(
                      context, 
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new LoginScreen(role:"dokter")
                        )
                      );
                    },
                  ),
                  Container(height: 10.0,),
                  ButtonGradient(
                    height: 48,
                    width: 200,
                    text: "Masuk Sebagai Manajer",
                    onTap: (){
                      Navigator.pushReplacement(
                      context, 
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new LoginScreen(role:"manajer")
                        )
                      );
                    },
                  ),
                ],
              ),
            ),
            Stack(
              children: <Widget>[
                Image.asset("assets/gradient-footer.png"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
