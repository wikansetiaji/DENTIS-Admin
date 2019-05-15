import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:dent_is_admin/screens/error.dart';

class Statistik extends StatefulWidget {
  @override
  _StatistikState createState() => _StatistikState();
}

class _StatistikState extends State<Statistik> {
  String selected ="status";
  double height = 0;
  List<Widget> body=[];
  List<Widget> status=[];
  List<Widget> ohis=[];
  List<Widget> statusOrang=[];
  List<Widget> ohisOrang=[];

  error()async{
    await Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
          builder: (BuildContext context) =>
          new ErrorScreen()
        )
      );
  }

  load()async{
    try{
    setState(() {
      this.height=MediaQuery.of(context).size.height/2;
    });
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    
    PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
    List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://api-dentis.herokuapp.com/dokter-login/")));
    var responseStatus =  await http.get(
      'http://api-dentis.herokuapp.com/statistics/kondisi/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value
      },
    );
    var bodyStatus = json.decode(responseStatus.body);
    var listStatus = json.decode(bodyStatus["result"]);
    
    var responseOhis =  await http.get(
      'http://api-dentis.herokuapp.com/statistics/ohis/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value
      },
    );
    var bodyOhis = json.decode(responseOhis.body);
    var listOhis = json.decode(bodyOhis["result"]);

    var responseStatusOrang =  await http.get(
      'http://api-dentis.herokuapp.com/statistics/kondisiOrang/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value
      },
    );
    var bodyStatusOrang = json.decode(responseStatusOrang.body);
    var listStatusOrang = json.decode(bodyStatusOrang["result"]);
    
    var responseOhisOrang =  await http.get(
      'http://api-dentis.herokuapp.com/statistics/ohisOrang/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value
      },
    );
    var bodyOhisOrang = json.decode(responseOhisOrang.body);
    var listOhisOrang = json.decode(bodyOhisOrang["result"]);
    
    status = [
      Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("http://api-dentis.herokuapp.com${bodyStatus["image"]}")
                )
              ),
            )
          ],
        )
      ),
      Container(height: 10,),
      ListTile(
        title: Text("Sound"),
        trailing: Text("${listStatus[0]}" + "%"),
      ),
      ListTile(
        title: Text("Caries"),
        trailing: Text("${listStatus[1]}" + "%"),
      ),
      ListTile(
        title: Text("Filled with Caries"),
        trailing: Text("${listStatus[2]}" + "%"),
      ),
      ListTile(
        title: Text("Filled no Caries"),
        trailing: Text("${listStatus[3]}" + "%"),
      ),
      ListTile(
        title: Text("Missing due to Caries"),
        trailing: Text("${listStatus[4]}" + "%"),
      ),
      ListTile(
        title: Text("Missing for Another Reason"),
        trailing: Text("${listStatus[5]}" + "%"),
      ),
      ListTile(
        title: Text("Fissure Sealant"),
        trailing: Text("${listStatus[6]}" + "%"),
      ),
      ListTile(
        title: Text("Fix dental prosthesis / crown, abutment, veneer "),
        trailing: Text("${listStatus[7]}" + "%"),
      ),
      ListTile(
        title: Text("Unerupted"),
        trailing: Text("${listStatus[8]}" + "%"),
      ),
      ListTile(
        title: Text("Persistance"),
        trailing: Text("${listStatus[9]}" + "%"),
      ),
      ListTile(
        title: Text("Whitespot"),
        trailing: Text("${listStatus[10]}" + "%"),
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
                  image: NetworkImage("http://api-dentis.herokuapp.com${bodyOhis["image"]}")
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
    statusOrang = [
      Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("http://api-dentis.herokuapp.com${bodyStatusOrang["image"]}")
                )
              ),
            )
          ],
        )
      ),
      Container(height: 10,),
      ListTile(
        title: Text("Sound"),
        trailing: Text("${listStatusOrang[0]}" + " orang"),
      ),
      ListTile(
        title: Text("Caries"),
        trailing: Text("${listStatusOrang[1]}" + " orang"),
      ),
      ListTile(
        title: Text("Filled with Caries"),
        trailing: Text("${listStatusOrang[2]}" + " orang"),
      ),
      ListTile(
        title: Text("Filled no Caries"),
        trailing: Text("${listStatusOrang[3]}" + " orang"),
      ),
      ListTile(
        title: Text("Missing due to Caries"),
        trailing: Text("${listStatusOrang[4]}" + " orang"),
      ),
      ListTile(
        title: Text("Missing for Another Reason"),
        trailing: Text("${listStatusOrang[5]}" + " orang"),
      ),
      ListTile(
        title: Text("Fissure Sealant"),
        trailing: Text("${listStatusOrang[6]}" + " orang"),
      ),
      ListTile(
        title: Text("Fix dental prosthesis / crown, abutment, veneer "),
        trailing: Text("${listStatusOrang[7]}" + " orang"),
      ),
      ListTile(
        title: Text("Unerupted"),
        trailing: Text("${listStatusOrang[8]}" + " orang"),
      ),
      ListTile(
        title: Text("Persistance"),
        trailing: Text("${listStatusOrang[9]}" + " orang"),
      ),
      ListTile(
        title: Text("Whitespot"),
        trailing: Text("${listStatusOrang[10]}" + " orang"),
      ),
    ];

    ohisOrang=[
      Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("http://api-dentis.herokuapp.com${bodyOhisOrang["image"]}")
                )
              ),
            )
          ],
        )
      ),
      Container(height: 10,),
      ListTile(
        title: Text("Baik"),
        trailing: Text("${listOhisOrang[0]}" + " orang"),
      ),
      ListTile(
        title: Text("Sedang"),
        trailing: Text("${listOhisOrang[1]}" + " orang"),
      ),
      ListTile(
        title: Text("Buruk"),
        trailing: Text("${listOhisOrang[2]}" + " orang"),
      ),
    ];
    setState(() {
      body=status;
      this.height=0.0;
    });
    }
    catch(e){
      print(e);
      error();
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/wallpapers/wallpaper3.png"),
          fit: BoxFit.cover
        )
      ),
      child: Padding(
        padding: EdgeInsets.all(0),
        child: ListView(
          padding: EdgeInsets.only(left: 35,right: 35),
          children: <Widget>[
            Container(height: 40.0,),
            Text(
              "Statistik",
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            Container(height: 15,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height:10),
                new DropdownButton(
                  isExpanded: true,
                  value: selected,
                  items: <DropdownMenuItem<String>>[
                    DropdownMenuItem(
                      value: "statusOrang",
                      child: Text("Status Prevalensi",style: TextStyle(color: Colors.grey[700]),),
                    ),
                    DropdownMenuItem(
                      value: "ohisOrang",
                      child: Text("Ohis Prevalensi",style: TextStyle(color: Colors.grey[700]),),
                    ),
                    DropdownMenuItem(
                      value: "status",
                      child: Text("Status",style: TextStyle(color: Colors.grey[700]),),
                    ),
                    DropdownMenuItem(
                      value: "ohis",
                      child: Text("Ohis",style: TextStyle(color: Colors.grey[700]),),
                    ),
                  ],
                  onChanged: (String a){
                    setState(() {
                      selected=a; 
                      if(a=="ohis"){
                        body=ohis;
                      }
                      else if (a=="status"){
                        body=status;
                      }
                      else if(a=="ohisOrang"){
                        body=ohisOrang;
                      }
                      else if (a=="statusOrang"){
                        body=statusOrang;
                      }
                    });
                  },
                ),
                Container(height: 10,),
                Stack(
                  children: <Widget>[
                    Column(
                      children: body,
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
          ]
        )
      )
    );
  }
}