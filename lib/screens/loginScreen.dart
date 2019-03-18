import 'package:flutter/material.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child://ListView(
          //children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          height: 100.0,
                          width: 100.0,
                          decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.contain,image: AssetImage("assets/logo.png"))),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          width: 200,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "username",
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 30),
                          width: 200,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "password"
                            ),
                            obscureText: true,
                          ),
                        ),
                        ButtonGradient(height: 48,width: 100,text: "Masuk",onTap:(){Navigator.of(context).pop();}),
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
          //]
        //),
      )
    );
  }
}