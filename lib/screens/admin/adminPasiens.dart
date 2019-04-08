import 'package:flutter/material.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'adminTambahPasien.dart';
import 'adminEditPasien.dart';

class AdminPasiens extends StatefulWidget {
  @override
  _AdminPasiensState createState() => _AdminPasiensState();
}

class _AdminPasiensState extends State<AdminPasiens> {
  double height=0;
  List<Widget> isi = [];

  load()async{
    isi=[];
    setState(() {
      this.height=MediaQuery.of(context).size.height;
    });
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    
    PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
    List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://10.0.2.2:8000/admin-login/")));
    var response =  await http.get(
      'http://10.0.2.2:8000/pasien/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value
      },
    );
    var body = json.decode(response.body);
    print(body);
    int temp =1;
    for (var i in body){
      setState(() {
        isi.add(
          ListTile(
            title: Text("$temp.   ${i["nama"]}"),
            trailing: Container(
              width: 100,
              child: Row(
                children: <Widget>[
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
                    onPressed: (){},
                  )
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
      body: ListView(
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
    );
  }
}