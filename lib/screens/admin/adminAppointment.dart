import 'package:flutter/material.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'package:dent_is_admin/screens/error.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:dent_is_admin/utils/utils.dart';
import 'adminTambahAppointment.dart';
import 'adminEditAppointment.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AdminAppointment extends StatefulWidget {
  final String idPasien;

  AdminAppointment({
    @required this.idPasien
  });

  @override
  _AdminAppointmentState createState() => _AdminAppointmentState();
}

class _AdminAppointmentState extends State<AdminAppointment> {
  List<Widget> list=[];
  double height=0;

  error()async{
    await Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
          builder: (BuildContext context) =>
          new ErrorScreen()
        )
      );
  }
  
  load()async{
    try {
      setState(() {
        this.height=MediaQuery.of(context).size.height;
      });
      setState(() {
        list=[];
      });
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      
      PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
      List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://api-dentis.herokuapp.com/admin-login/")));
      var response =  await http.get(
        'http://api-dentis.herokuapp.com/appointment/${widget.idPasien}/',
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
                          Text("Nama Dokter"),
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
                          Text(i["dokter"]["nama"]),
                          Container(height: 10,),
                          Text("${i["jadwal"]["waktu_mulai"].split("T")[1].split("Z")[0]} - ${i["jadwal"]["waktu_selesai"].split("T")[1].split("Z")[0]}")
                        ],
                      )
                    ],
                  ),
                  Container(height: 15,),
                  Row(
                    children: <Widget>[
                      Expanded(child: Container(),),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: (){
                          Navigator.of(context).push(
                            new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                new AdminEditAppointment(
                                  selectedJadwal: i["jadwal"],
                                  idAppointment: i["id"].toString(),
                                  idDokter: i["dokter"]["user"]["id"].toString(),
                                  idJadwal: i["jadwal"]["id"].toString(),
                                  tanggal: i["jadwal"]["waktu_mulai"].split("T")[0].toString(),
                                )
                              )
                          );
                        },
                      ),
                      Container(width: 15,),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: ()async{
                          bool delete = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                content: Container(
                                  alignment: Alignment.center,
                                  height: 37,
                                  child: Text("Apakah Anda ingin menghapus appointment ini?",textAlign: TextAlign.center,),
                                ),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text("Ya"),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                  new FlatButton(
                                    child: new Text("Tidak"),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                ],
                              );
                            }
                          );
                          if(delete){
                            Directory tempDir = await getTemporaryDirectory();
                            String tempPath = tempDir.path;
                            
                            PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
                            List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://api-dentis.herokuapp.com/admin-login/")));
                            var response =  await http.delete(
                              'http://api-dentis.herokuapp.com/appointment-detail/${i["id"]}/',
                              headers: {
                                "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
                                "X-CSRFToken":cookies[0].value
                              },
                            );
                            if (response.statusCode!=200&&response.statusCode!=201){
                              await error();
                              setState(() {
                                height=0.0;
                              });
                              return;
                            }
                            Fluttertoast.showToast(
                              msg: "Appointment berhasil dihapus",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.black45,
                              textColor: Colors.white,
                              fontSize: 16.0
                            );
                            print(response.statusCode);
                            load();
                          }
                        },
                      ),
                      Expanded(child: Container(),),
                    ],
                  )
                ],
              ),
            ),
          ]);
        }
        else{
          this.list.addAll([
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(15),
              width: 330,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(
                  color: Colors.grey,
                  width: 2.0
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${Util.convertToDateString(i["jadwal"]["waktu_mulai"].split("T")[0])}",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18,color: Colors.grey),),
                  Divider(
                    color: Colors.grey,
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
                          Text("Nama Dokter",style:TextStyle(color: Colors.grey)),
                          Container(height: 10,),
                          Text("Waktu Layanan",style:TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(height: 10,),
                          Text(i["dokter"]["nama"],style:TextStyle(color: Colors.grey)),
                          Container(height: 10,),
                          Text("${i["jadwal"]["waktu_mulai"].split("T")[1].split("Z")[0]} - ${i["jadwal"]["waktu_selesai"].split("T")[1].split("Z")[0]}",style:TextStyle(color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                  Container(height: 15,),
                ],
              ),
            ),
          ]);
        }
      }
      setState(() {
        height=0;
      });
    } catch (e) {
      print(e);
      error();
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text("Appointment",style: TextStyle(color:Colors.black54),),
      ),
      body: 
        Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/wallpapers/wallpaper2.png"),
                  fit: BoxFit.cover
                )
              ),
              child: ListView(
                children: <Widget>[
                  Container(height: 48,),
                  Column(
                    children: <Widget>[
                      ButtonGradient(
                        height: 50,
                        width: 150,
                        onTap: (){
                          Navigator.of(context).push(
                            new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                new AdminTambahAppointment(idPasien: widget.idPasien,)
                              )
                          );
                        },
                        text: "Buat Appointment",
                      )
                    ]
                  ),
                  Column(
                    children:this.list
                  )
                ]
              )
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
            ),
          ],
        )
    );
  }
}