import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'dokterNewsWebview.dart';
import 'package:dent_is_admin/screens/error.dart';


class DokterNews extends StatefulWidget {
  @override
  _DokterNewsState createState() => _DokterNewsState();
}

class _DokterNewsState extends State<DokterNews> {
  double height=0;
  List<Widget> body=[];
  error()async{
    await Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
          builder: (BuildContext context) =>
          new ErrorScreen()
        )
      );
  }

  load() async{
    setState(() {
      this.height=MediaQuery.of(context).size.height/2;
    });
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    
    PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
    List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://dent-is.herokuapp.com/dokter-login/")));
    var response =  await http.get(
      'http://dent-is.herokuapp.com/news/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value
      },
    );
    if (response.statusCode!=201 && response.statusCode!=200){
      error();
    }
    var body = json.decode(response.body);
    var articles = body["articles"];
    this.body=[];
    for (var a in articles){
      this.body.addAll(
        [
           InkWell(
             onTap: ()async{
                await launch(
                  a["url"]
                );
                //Navigator.push(
                //  context, 
                //  new MaterialPageRoute(
                //      builder: (BuildContext context) =>
                //      new DokterNewsWebview(url: a["url"],)
                //    )
                //  );
              },
             child: Container(
              padding: EdgeInsets.all(15),
              width: 330,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Colors.white,
                border: Border.all(
                  color: Theme.of(context).accentColor,
                  width: 2.0
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: a["urlToImage"]!=null?NetworkImage(a["urlToImage"]):NetworkImage("")),
                    ),
                  ),
                  Container(width: 10,),
                  Column(
                    children: <Widget>[
                      Container(
                        width:200,
                        child: Text(
                          a["title"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                          ),
                        )
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        width:200,
                        child: Text(
                          a["author"]!=null?a["author"]:"Anonymous",
                          style: TextStyle(
                            fontSize: 14
                          ),
                        )
                      )
                    ],
                  ),
                ],
              )
            ),
           ),
           Container(height: 20,),
        ]
      );
    }
    setState(() {
      this.height=0;
    });
  }

  @override
  void didChangeDependencies() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/wallpapers/wallpaper1.png"),
          fit: BoxFit.cover
        )
      ),
      child: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.only(top:0, left:40, right:40),
            children: <Widget>[
              Container(height: 40,),
              Text(
                "Health\nNews",
                style: TextStyle(
                  fontWeight:FontWeight.bold,
                  fontSize: 40
                ),
              ),
              Container(height: 35,),
              Stack(
                children: <Widget>[
                  Column(
                    children: this.body,
                  ),
                  Container(
                    height: this.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    height: this.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
              ),
              
            ],
          ),
        ],
      )
    );
  }
}