import 'package:flutter/material.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dent_is_admin/screens/initialScreen.dart';
import 'dart:convert';

class ManajerHome extends StatefulWidget {
  @override
  _ManajerHomeState createState() => _ManajerHomeState();
}

class _ManajerHomeState extends State<ManajerHome> {
  String selected ="status";
  double height = 0;
  List<Widget> status=[];
  List<Widget> ohis=[];
  List<Widget> pengunjung=[];
  List<Widget> body;

  load()async{
    setState(() {
      this.height=MediaQuery.of(context).size.height/2;
    });
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    
    PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
    List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://10.0.2.2:8000/manajer-login/")));
    var responseStatus =  await http.get(
      'http://10.0.2.2:8000/statistics/kondisi/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value
      },
    );
    var bodyStatus = json.decode(responseStatus.body);
    var listStatus = json.decode(bodyStatus["result"]);
    print(listStatus[0]);
    var responseOhis =  await http.get(
      'http://10.0.2.2:8000/statistics/ohis/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value
      },
    );
    var bodyOhis = json.decode(responseOhis.body);
    var listOhis = json.decode(bodyOhis["result"]);
    var responsePengunjung =  await http.get(
      'http://10.0.2.2:8000/statistics/pengunjung/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value
      },
    );
    var bodyPengunjung = json.decode(responsePengunjung.body);
    var listPengunjung = json.decode(bodyPengunjung["result"]);
    pengunjung = [
      Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("http://10.0.2.2:8000${bodyPengunjung["image"]}")
                )
              ),
            )
          ],
        )
      ),
      Container(height: 10,),
      ListTile(
        title: Text("Senin"),
        trailing: Text("${listPengunjung[0]}" + " orang"),
      ),
      ListTile(
        title: Text("Selasa"),
        trailing: Text("${listPengunjung[1]}" + " orang"),
      ),
      ListTile(
        title: Text("Rabu"),
        trailing: Text("${listPengunjung[2]}" + " orang"),
      ),
      ListTile(
        title: Text("Kamis"),
        trailing: Text("${listPengunjung[3]}" + " orang"),
      ),
      ListTile(
        title: Text("Jumat"),
        trailing: Text("${listPengunjung[4]}" + " orang"),
      ),
      ListTile(
        title: Text("Sabtu"),
        trailing: Text("${listPengunjung[5]}" + " orang"),
      ),
      ListTile(
        title: Text("Minggu"),
        trailing: Text("${listPengunjung[6]}" + " orang"),
      ),
    ];
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
    super.didChangeDependencies();
    load();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    body=status;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("DENT-IS",style: TextStyle(color:Colors.black54),),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert,color: Colors.black,),
            padding: EdgeInsets.zero,
            onSelected: (String a)async{
              Directory tempDir = await getTemporaryDirectory();
              String tempPath = tempDir.path;
              
              PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
              cj.delete(Uri.parse("http://10.0.2.2:8000/manajer-login/"));
              Navigator.pushReplacement(context, new MaterialPageRoute(
                builder: (BuildContext context) =>
                new InitialScreen()
              )
            );
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              PopupMenuItem<String>(
                value: "logout",
                child: const Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 35,right: 35),
        child: ListView(
          children: <Widget>[
            Container(height: 40.0,),
            Text(
              "Halo,\nManajer!",
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            Container(height: 30,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height:10),
                new DropdownButton(
                  isExpanded: true,
                  value: selected,
                  items: <DropdownMenuItem<String>>[
                    DropdownMenuItem(
                      value: "status",
                      child: Text("Status",style: TextStyle(color: Colors.grey[700]),),
                    ),
                    DropdownMenuItem(
                      value: "ohis",
                      child: Text("Ohis",style: TextStyle(color: Colors.grey[700]),),
                    ),
                    DropdownMenuItem(
                      value: "pengunjung",
                      child: Text("Pengunjung",style: TextStyle(color: Colors.grey[700]),),
                    )
                  ],
                  onChanged: (String a){
                    setState(() {
                      selected=a; 
                      if(a=="pengunjung"){
                        body=pengunjung;
                      }
                      else if(a=="ohis"){
                        body=ohis;
                      }
                      else{
                        body=status;
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