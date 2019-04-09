import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Statistik extends StatefulWidget {
  @override
  _StatistikState createState() => _StatistikState();
}

class _StatistikState extends State<Statistik> {
  String selected ="status";
  double height = 0;
  List<Widget> status=[];
  List<Widget> ohis=[];

  load()async{
    setState(() {
      this.height=MediaQuery.of(context).size.height/2;
    });
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    
    PersistCookieJar cj = new PersistCookieJar(dir:tempPath);
    List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://10.0.2.2:8000/dokter-login/")));
    var responseStatus =  await http.get(
      'http://10.0.2.2:8000/statistics/kondisi/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value
      },
    );
    var bodyStatus = json.decode(responseStatus.body);
    var listStatus = json.decode(bodyStatus["result"]);
    
    var responseOhis =  await http.get(
      'http://10.0.2.2:8000/statistics/ohis/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value
      },
    );
    var bodyOhis = json.decode(responseOhis.body);
    var listOhis = json.decode(bodyOhis["result"]);
    
    status = [
      Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("http://10.0.2.2:8000${bodyStatus["image"]}")
                )
              ),
            )
          ],
        )
      ),
      Container(height: 10,),
      ListTile(
        title: Text("Normal"),
        trailing: Text("${listStatus[0]}" + "%"),
      ),
      ListTile(
        title: Text("Sound"),
        trailing: Text("${listStatus[1]}" + "%"),
      ),
      ListTile(
        title: Text("Caries"),
        trailing: Text("${listStatus[2]}" + "%"),
      ),
      ListTile(
        title: Text("Filled with Caries"),
        trailing: Text("${listStatus[3]}" + "%"),
      ),
      ListTile(
        title: Text("Filled no Caries"),
        trailing: Text("${listStatus[4]}" + "%"),
      ),
      ListTile(
        title: Text("Missing due to Caries"),
        trailing: Text("${listStatus[5]}" + "%"),
      ),
      ListTile(
        title: Text("Missing for Another Reason"),
        trailing: Text("${listStatus[6]}" + "%"),
      ),
      ListTile(
        title: Text("Fissure Sealant"),
        trailing: Text("${listStatus[7]}" + "%"),
      ),
      ListTile(
        title: Text("Fix dental prosthesis / crown, abutment, veneer "),
        trailing: Text("${listStatus[8]}" + "%"),
      ),
      ListTile(
        title: Text("Unerupted"),
        trailing: Text("${listStatus[9]}" + "%"),
      ),
      ListTile(
        title: Text("Not recorded"),
        trailing: Text("${listStatus[10]}" + "%"),
      ),
      ListTile(
        title: Text("Whitespot"),
        trailing: Text("${listStatus[11]}" + "%"),
      ),
    ];

    ohis=[
      Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("http://10.0.2.2:8000${bodyOhis["image"]}")
                )
              ),
            )
          ],
        )
      ),
      Container(height: 10,),
      ListTile(
        title: Text("Baik"),
        trailing: Text("${listOhis[0]}" + "%"),
      ),
      ListTile(
        title: Text("Sedang"),
        trailing: Text("${listOhis[1]}" + "%"),
      ),
      ListTile(
        title: Text("Buruk"),
        trailing: Text("${listOhis[2]}" + "%"),
      ),
    ];
    setState(() {
      this.height=0.0;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    load();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(left:40,right:40),
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(height:40),
            Text(
              "Statistik",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold
              ),
            ),
            Container(height: 40,),
            Row(
              children: <Widget>[
                InkWell(
                  onTap: (){
                    setState(() {
                      selected="status";
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 165,
                        height: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/tabs/status-selected.png")
                          )
                        ),
                      ),
                      Container(
                        width: 165,
                        height: selected=="ohis"?40:0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/tabs/status.png")
                          )
                        ),
                      ),
                    ],
                  )
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      selected="ohis";
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 165,
                        height: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/tabs/ohis.png")
                          )
                        ),
                      ),
                      Container(
                        width: 165,
                        height: selected=="ohis"?40:0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/tabs/ohis-selected.png")
                          )
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
            Container(height: 36,),
            Stack(
              children: <Widget>[
                Column(
                  children: selected=="status"?status:ohis,
                ),
                Container(
                  height: this.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
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
        )
      ],
    );
  }
}