import 'package:flutter/material.dart';
import 'pemeriksaan/newUser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dent_is_admin/screens/error.dart';
import 'survey/surveyScreen.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:dent_is_admin/utils/utils.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'pemeriksaan/dataPasien.dart';

class DokterHome extends StatefulWidget {
  @override
  _DokterHomeState createState() => _DokterHomeState();
}

class _DokterHomeState extends State<DokterHome> {
  bool loading = true;
  List<Widget> list;

  error()async{
    await Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
          builder: (BuildContext context) =>
          new ErrorScreen()
        )
      );
  }

  load()async{
    setState(() {
      this.list=[];
      loading=true;
    });
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    
    PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
    List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://api-dentis.herokuapp.com/dokter-login/")));
    var response =  await http.get(
      'http://api-dentis.herokuapp.com/appointment-dokter/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value
      }, 
    );
    if(response.statusCode!=200 && response.statusCode!=201){
      print(response.statusCode);
      await error();
      
    }
    var body = json.decode(response.body);
    for (var i in body){
      if (i["is_active"]){
        print(i);
        this.list.addAll([
          Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(15),
            width: 330,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(
                color: Theme.of(context).accentColor,
                width: 2.0
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${Util.convertToDateString(i["jadwal"]["waktu_mulai"].split("T")[0])}",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18),),
                Divider(
                  color: Theme.of(context).accentColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(height: 10,),
                        Text("Nama Pasien"),
                        Container(height: 10,),
                        Text("Waktu Layanan")
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(height: 10,),
                        Text(i["pasien"]["nama"]),
                        Container(height: 10,),
                        Text("${i["jadwal"]["waktu_mulai"].split("T")[1].split("Z")[0]} - ${i["jadwal"]["waktu_selesai"].split("T")[1].split("Z")[0]}")
                      ],
                    )
                  ],
                ),
                Container(height: 20,),
                Container(
                  alignment: Alignment.center,
                  child: ButtonGradient(
                    height: 50,
                    width: 100,
                    text: "Mulai",
                    onTap: (){
                      Navigator.push(
                        context, 
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new DataPasien(
                              data: {"idAppointment":i["id"],"isAppointment":true,"pasien":i["pasien"],},
                            )
                          )
                      );
                    },
                  )
                ),
              ],
            ),
          ),
        ]);
      }
    }
    setState(() {
      loading=false;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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
      ),child:
      ListView(
        padding: EdgeInsets.only(left: 35,right: 35),
        children: <Widget>[
          Container(height: 40.0,),
          Text(
            "Halo\nDokter!",
            style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
          ),
          Container(height: 30,),
          Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(15),
            width: 330,
            height: 123,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 0.3,
                  color: Colors.blueGrey,
                  blurRadius: 10.0,
                  offset: Offset(
                    0.0,
                    2.0,
                  ),
                )
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: ()async{
                    Navigator.push(
                      context, 
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new NewUser()
                        )
                    );

                  },
                  child: Container(
                    height: 108,
                    width: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage("assets/plus-circle.png"))
                          ),
                        ),
                        Container(
                          height: 13,
                        ),
                        Text("Pemeriksaan Baru",textAlign: TextAlign.center,)
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context, 
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new SurveyScreen()
                        )
                    );
                  },
                  child: Container(
                    height: 108,
                    width: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage("assets/kuisioner.png"))
                          ),
                        ),
                        Container(
                          height: 13,
                        ),
                        Text("Kuisioner",textAlign: TextAlign.center,)
                      ],
                    ),
                  )
                ),
              ],
            ),
          ),
          Container(
            height: 33,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "Appointment Terkini",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
              )
            )
          ),
          Container(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            child:Image.asset(
              "assets/line.png",
              width: 268,
            )
          ),
          loading?Column(
            children: <Widget>[
              Container(height: 30,),
              CircularProgressIndicator()
            ],
          )
          :
          Column(
            children:list
          ),
        ],
      )
    );
  }
}