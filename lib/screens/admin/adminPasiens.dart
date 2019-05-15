import 'package:flutter/material.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'adminTambahPasien.dart';
import 'adminEditPasien.dart';
import 'package:dent_is_admin/screens/error.dart';
import 'adminAppointment.dart';

class AdminPasiens extends StatefulWidget {
  @override
  _AdminPasiensState createState() => _AdminPasiensState();
}

class _AdminPasiensState extends State<AdminPasiens> {
  double height=0;
  List<Widget> isi = [];

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
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      
      PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
      List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://dent-is.herokuapp.com/admin-login/")));
      var response =  await http.get(
        'http://dent-is.herokuapp.com/pasien/?type=user',
        headers: {
          "Cookie":cookies[1].name+"="+cookies[1].value
        },
      );
      if (response.statusCode!=200 && response.statusCode!=201){
        await error();
        setState(() {
          height=0.0;
        });
        return;
      }
      var body = json.decode(response.body);
      int temp =1;
      isi=[];
      for (var i in body){
        setState(() {
          isi.add(
            ListTile(
              title: Text("$temp.   ${i["nama"]}"),
              trailing: Container(
                width: 150,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: (){
                        Navigator.push(
                            context, 
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                new AdminAppointment(idPasien: i["id"],)
                              )
                            );
                      }
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: (){
                        Map<String,dynamic> user =i["user"];
                        Navigator.push(
                            context, 
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                new AdminEditPasien(
                                  id:i["id"],
                                  alamat: i["alamat"]!=null?i["alamat"]:"",
                                  email: user!=null?user["email"]:"",
                                  jenisKelamin: i["jenisKelamin"]!=null?i["jenisKelamin"]:"",
                                  nama: i["nama"],
                                  noHp: i["no_hp"]!=null?i["no_hp"]:"",
                                  tanggalLahir: i["tanggalLahir"]!=null?i["tanggalLahir"]:"",
                                  username: user!=null?user["username"]:"",
                                )
                              )
                            );
                      },
                    ),
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
                                child: Text("Apakah Anda ingin menghapus akun ini?",textAlign: TextAlign.center,),
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
                          List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://dent-is.herokuapp.com/admin-login/")));
                          var response =  await http.delete(
                            'http://dent-is.herokuapp.com/pasien/${i["id"]}/',
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
                          print(response.statusCode);
                          load();
                        }
                      },
                    ),
                  ],
                ),
              )
            )
          );
        });
        temp+=1;
      }
      setState(() {
        this.height=0;
      });
      
    } catch (e) {
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
        title: Text("DENT-IS",style: TextStyle(color:Colors.black54),),
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "Pasien",
                        style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: 70,
                      ),
                      ButtonGradient(
                        height: 40,
                        width: 130,
                        text: "Tambah Pasien",
                        onTap: (){
                          Navigator.push(
                            context, 
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                new AdminTambahPasien()
                              )
                            );
                        },
                      )
                    ],
                  ),
                  Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(height: 30,),
                          Column(
                            children: isi,
                          )
                        ],
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
              ),
            )
          ],
        ),
      )
    );
  }
}