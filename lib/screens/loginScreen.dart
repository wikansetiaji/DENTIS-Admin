import 'package:flutter/material.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'admin/adminHome.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  LoginScreen(
    {
      @required this.role
    }
  );
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double opacity=0.0;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String alert = "";

  login() async{
    setState(() {
      opacity=MediaQuery.of(context).size.height;
    });
    var response =  await http.post(
      'http://10.0.2.2:8000/${widget.role}-login/',
      headers: {
        "Content-Type":"application/x-www-form-urlencoded",
      },
      body: {
        "username":usernameController.text,
        "password":passwordController.text
      }
    );
    if (response.statusCode==200){
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      
      PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
      cj.delete(Uri.parse("http://10.0.2.2:8000/${widget.role}-login/"));
      print(response.headers["set-cookie"].split(",")[0].split(";")[0].split("=")[1]);
      Cookie csrf = Cookie(response.headers["set-cookie"].split(",")[0].split(";")[0].split("=")[0],response.headers["set-cookie"].split(",")[0].split(";")[0].split("=")[1]);
      Cookie sessionid = Cookie(response.headers["set-cookie"].split(",")[2].split(";")[0].split("=")[0],response.headers["set-cookie"].split(",")[2].split(";")[0].split("=")[1]);
      cj.saveFromResponse(Uri.parse("http://10.0.2.2:8000/${widget.role}-login/"), [csrf,sessionid]);
      List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://10.0.2.2:8000/${widget.role}-login/")));
      print("this is the cookies: ${cookies}");
      
       Navigator.pushReplacement(
        context, 
        new MaterialPageRoute(
            builder: (BuildContext context) =>
            new AdminHome()
          )
        );

      setState(() {
        alert="";
      });
    }
    else{
      setState(() {
        alert="Username atau password salah";
      });
    }
    setState(() {
      opacity=0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          GestureDetector(
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
                                controller: usernameController,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              width: 200,
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: "password"
                                ),
                                controller: passwordController,
                                obscureText: true,
                              ),
                            ),
                            Text("${alert}",style: TextStyle(color: Colors.red, fontSize: 12),),
                            Container(height:30),
                            ButtonGradient(height: 48,width: 100,text: "Masuk",onTap:
                              login
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
              //]
            //),
          ),
          new Opacity(
            opacity: 0.5,
            child: new Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: opacity,
            ),
          ),
          new Container(
            child: new Center(
              child:new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              )
            ),
            height: opacity,
          )
        ],
      )
    );
  }
}