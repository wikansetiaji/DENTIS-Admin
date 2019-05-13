import 'package:flutter/material.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dent_is_admin/screens/initialScreen.dart';
import 'dart:convert';
import 'package:dent_is_admin/screens/error.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dent_is_admin/utils/utils.dart';


class ManajerHome extends StatefulWidget {
  @override
  _ManajerHomeState createState() => _ManajerHomeState();
}

class _ManajerHomeState extends State<ManajerHome> {
  double opacity=0;
  String selected ="status";
  double height = 0;
  List<Widget> status=[];
  List<Widget> ohis=[];
  List<Widget> pengunjung=[];
  List<Widget> body;
  List<Widget> rekamMedis=[];

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
    List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://api-dentis.herokuapp.com/manajer-login/")));
    var responseStatus =  await http.get(
      'http://api-dentis.herokuapp.com/statistics/kondisi/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value
      },
    );
    var bodyStatus = json.decode(responseStatus.body);
    var listStatus = json.decode(bodyStatus["result"]);
    print(listStatus[0]);
    var responseOhis =  await http.get(
      'http://api-dentis.herokuapp.com/statistics/ohis/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value
      },
    );
    var bodyOhis = json.decode(responseOhis.body);
    var listOhis = json.decode(bodyOhis["result"]);
    var responsePengunjung =  await http.get(
      'http://api-dentis.herokuapp.com/statistics/pengunjung/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value
      },
    );
    var bodyPengunjung = json.decode(responsePengunjung.body);
    var listPengunjung = json.decode(bodyPengunjung["result"]);
    setState(() {
      pengunjung = [
        Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("http://api-dentis.herokuapp.com${bodyPengunjung["image"]}")
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
                    image: NetworkImage("http://api-dentis.herokuapp.com${bodyStatus["image"]}")
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
          title: Text("Persistance"),
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
    });

    this.rekamMedis=[];
    var responseRekamMedis =  await http.get(
        'http://api-dentis.herokuapp.com/rekam-medis/',
        headers: {
          "Cookie":cookies[1].name+"="+cookies[1].value
        },
      );
      if(responseRekamMedis.statusCode!=200 && responseRekamMedis.statusCode!=201){
        await error();
        setState(() {
          height=0;
        });
        return;
      }
      var listRekamMedis = json.decode(responseRekamMedis.body);
      setState(() {
        this.height=0;
      });
      this.rekamMedis=[];
      for (var a in listRekamMedis){
        this.rekamMedis.addAll(
          [
            InkWell(
              onTap: (){
                pdfRekamMedis(a["id"].toString());
              },
              child: Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(15),
                width: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Colors.white,
                  border: Border.all(
                    color: Theme.of(context).accentColor,
                    width: 2.0
                  )
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.grey,
                        image: DecorationImage(
                          image: NetworkImage(
                            a["fotorontgen_set"].length!=0?"http://api-dentis.herokuapp.com${a["fotorontgen_set"][0]["foto"]}":""
                          ),
                          fit: BoxFit.fitWidth
                        )
                      ),
                    ),
                    Container(
                      width: 15,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text("${a["pasien"]["nama"]}", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                          ),
                          Container(height: 10,),
                          Container(
                            child: Text("${a["dokter"]["nama"]}", style: TextStyle(fontSize: 12),)
                          ),
                          Container(
                            child: Text("${Util.convertToDateString(a["created_at"].split("T")[0])}", style: TextStyle(fontSize: 12),)
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    IconButton(
                      icon: Icon(Icons.file_download),
                      onPressed: (){
                      },
                    )
                  ],
                ),
              )
            ),
          ]
        );
      }

    setState(() {
      body=status;
      this.height=0.0;
    });
    }
    catch(e){
      error();
    }
  }

  pdfManajer()async{
    setState(() {
      opacity=MediaQuery.of(context).size.height;
    });
    print("mulai");
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    
    PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
    List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://api-dentis.herokuapp.com/manajer-login/")));
    var responseStatus =  await http.get(
      'http://api-dentis.herokuapp.com/report/manajer',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value
      },
    );
    print(responseStatus.statusCode);
    if (responseStatus.statusCode==200){
      print("oke");
      await launch(
        "http://api-dentis.herokuapp.com/media/manajer_report.pdf"
      );
    }
    else{
      error();
    }
    setState(() {
      opacity=0;
    });
  }

  pdfRekamMedis(String id)async{
    setState(() {
      opacity=MediaQuery.of(context).size.height;
    });
    print("mulai");
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    
    PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
    List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://api-dentis.herokuapp.com/manajer-login/")));
    var responseStatus =  await http.get(
      'http://api-dentis.herokuapp.com/report/rekam-medis/$id/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value
      },
    );
    print(responseStatus.statusCode);
    if (responseStatus.statusCode==200){
      print("oke");
      await launch(
        "http://api-dentis.herokuapp.com/media/rekam_medis/$id.pdf"
      );
    }
    else{
      error();
    }
    setState(() {
      opacity=0;
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
    return Stack(
      children: <Widget>[
        Scaffold(
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
                  cj.delete(Uri.parse("http://api-dentis.herokuapp.com/manajer-login/"));
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
          body:  Container(
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
                    "Halo,\nManajer!",
                    style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:<Widget>[
                        ButtonGradient(
                        height: 50,
                        width: 250,
                        text: "Download Laporan Statistika",
                        onTap: (){
                          pdfManajer();
                        },
                      )
                    ]
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
                          ),
                          DropdownMenuItem(
                            value: "rekamMedis",
                            child: Text("Rekam Medis",style: TextStyle(color: Colors.grey[700]),),
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
                            else if (a=="status"){
                              body=status;
                            }
                            else{
                              body = rekamMedis;
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
          )
        ),
        new Opacity(
          opacity: 0.5,
          child: new Container(
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            height: this.opacity,
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
          height: this.opacity,
        )
      ],
    );
  }
}