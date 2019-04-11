import 'package:flutter/material.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class AdminTambahDokter extends StatefulWidget {
  @override
  _AdminTambahDokterState createState() => _AdminTambahDokterState();
}

class _AdminTambahDokterState extends State<AdminTambahDokter> {
  double height=0;

  String jenisKelamin="l";
  TextEditingController namaController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nomorKTPController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController noHpController = TextEditingController();
  TextEditingController tanggalLahirController = TextEditingController();
  TextEditingController nomorTeleponController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController strController = TextEditingController();
  String alertNama="";
  String alertUsername="";
  String alertPassword="";
  String alertNomorKtp="";
  String alertEmail="";
  String alertNomorTelepon="";
  String alertTanggalLahir="";
  String alertAlamat="";
  String alertStr="";
  DateTime tanggalLahir;

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  submit()async{
    setState(() {
      alertNama="";
      alertUsername="";
      alertPassword="";
      alertNomorKtp="";
      alertEmail="";
      alertNomorTelepon="";
      alertTanggalLahir="";
      alertAlamat="";
      alertStr="";
    });
    bool pass = true;
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);
    if (tanggalLahirController.text==""){
      pass= false;
      setState(() {
        alertAlamat="Wajib diisi";
      });
    }
    if (alamatController.text==""){
      pass= false;
      setState(() {
        alertAlamat="Wajib diisi";
      });
    }
    if (noHpController.text==""){
      pass= false;
      setState(() {
        alertNomorTelepon="Wajib diisi";
      });
    }
    if (nomorKTPController.text==""){
      pass= false;
      setState(() {
        alertNomorKtp="Wajib diisi";
      });
    }
    if (strController.text==""){
      pass= false;
      setState(() {
        alertStr="Wajib diisi";
      });
    }
    if (namaController.text==""){
      pass= false;
      setState(() {
        alertNama="Wajib diisi";
      });
    }
    if(usernameController.text==""){
      pass= false;
      setState(() {
        alertUsername="Wajib diisi";
      });
    }
    if(passwordController.text.length<6){
      pass= false;
      setState(() {
        alertPassword="Minimal 6 character";
      });
    }
    if(passwordController.text==""){
      pass= false;
      setState(() {
        alertPassword="Wajib diisi";
      });
    }
    if(!regExp.hasMatch(emailController.text)){
      pass= false;
      setState(() {
        alertEmail="Format Salah";
      });
    }
    if(emailController.text==""){
      pass= false;
      setState(() {
        alertEmail="Wajib diisi";
      });
    }
    if (pass){
      setState(() {
        height=MediaQuery.of(context).size.height;
      });
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      
      PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
      List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://10.0.2.2:8000/admin-login/")));
      print(cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value);
      var response =  await http.post(
        'http://10.0.2.2:8000/dokter/',
        headers: {
          "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
          "X-CSRFToken":cookies[0].value
        },
        body: {
          "nama":namaController.text,
          "username":usernameController.text,
          "password":passwordController.text,
          "email":emailController.text,
          "no_hp":noHpController.text,
          "jenisKelamin":jenisKelamin,
          "alamat":alamatController.text,
          "tanggalLahir":tanggalLahirController.text,
          "ktp":nomorKTPController.text,
          "strDokter":strController.text
        }
      );
      var body = json.decode(response.body);
      print(body);
      setState(() {
        height=0;
      });
      Fluttertoast.showToast(
        msg: "Dokter berhasil ditambah",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0
      );
      Navigator.pop(context);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
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
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child:ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Tambah Dokter",
                        style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                      ),
                      Container(height: 40,),
                      new Container(
                        width: 150,
                        height: 150,
                        decoration: new BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(150))
                        ),
                      ),
                      Container(height: 20,),
                      Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(" ${alertNama}",style: TextStyle(color: Colors.red),),
                      ),
                      Container(
                        height: 60,
                        width: 325,
                        child: new TextField(
                          controller: namaController,
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: new BorderSide(color: Colors.blue)),
                            hintText: 'Nama Lengkap*',
                            labelText: 'Nama Lengkap*',
                          ),
                        ),
                      ),
                      Container(height: 10,),
                      Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(" ${alertUsername}",style: TextStyle(color: Colors.red),),
                      ),
                      Container(
                        height: 60,
                        width: 325,
                        child: new TextField(
                          controller: usernameController,
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: new BorderSide(color: Colors.blue)),
                            hintText: 'Username*',
                            labelText: 'Username*',
                          ),
                        ),
                      ),
                      Container(height: 10,),
                      Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(" ${alertPassword}",style: TextStyle(color: Colors.red),),
                      ),
                      Container(
                        height: 60,
                        width: 325,
                        child: new TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: new BorderSide(color: Colors.blue)),
                            hintText: 'Password*',
                            labelText: 'Password*',
                          ),
                        ),
                      ),
                      Container(height: 10,),
                      Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text("$alertNomorKtp",style: TextStyle(color: Colors.red),),
                      ),
                      Container(
                        height: 60,
                        width: 325,
                        child: new TextField(
                          keyboardType: TextInputType.numberWithOptions(),
                          controller: nomorKTPController,
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: new BorderSide(color: Colors.blue)),
                            hintText: 'Nomor KTP*',
                            labelText: 'Nomor KTP*',
                          ),
                        ),
                      ),
                      Container(height: 10,),
                      Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text("$alertStr",style: TextStyle(color: Colors.red),),
                      ),
                      Container(
                        height: 60,
                        width: 325,
                        child: new TextField(
                          keyboardType: TextInputType.numberWithOptions(),
                          controller: strController,
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: new BorderSide(color: Colors.blue)),
                            hintText: 'Nomor STR*',
                            labelText: 'Nomor STR*',
                          ),
                        ),
                      ),
                      Container(height: 10,),
                      Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text("",style: TextStyle(color: Colors.red),),
                      ),
                      Container(
                        padding: EdgeInsets.only(left:10),
                        alignment: Alignment.centerLeft,
                        width: 325,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                            color: Colors.grey[600],

                          )
                        ),
                        child: new DropdownButton(
                          isExpanded: true,
                          value: jenisKelamin,
                          items: <DropdownMenuItem<String>>[
                            DropdownMenuItem(
                              value: "l",
                              child: Text("Laki-laki",style: TextStyle(color: Colors.grey[700]),),
                            ),
                            DropdownMenuItem(
                              value: "p",
                              child: Text("Perempuan",style: TextStyle(color: Colors.grey[700]),),
                            )
                          ],
                          onChanged: (String selected){
                            setState(() {
                                jenisKelamin = selected;
                              });
                          },
                        )
                      ),
                      Container(height: 10,),
                      Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(" ${alertEmail}",style: TextStyle(color: Colors.red),),
                      ),
                      Container(
                        height: 60,
                        width: 325,
                        child: new TextField(
                          controller: emailController,
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: new BorderSide(color: Colors.blue)),
                            hintText: 'Email*',
                            labelText: 'Email*',
                          ),
                        ),
                      ),
                      Container(height: 10,),
                      Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(" ${alertNomorTelepon}",style: TextStyle(color: Colors.red),),
                      ),
                      Container(
                        height: 60,
                        width: 325,
                        child: new TextField(
                          keyboardType: TextInputType.numberWithOptions(),
                          controller: noHpController,
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: new BorderSide(color: Colors.blue)),
                            hintText: 'Nomor Telepon*',
                            labelText: 'Nomor Telepon*',
                          ),
                        ),
                      ),
                      Container(height: 10,),
                      Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(" ${alertTanggalLahir}",style: TextStyle(color: Colors.red),),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            height: 60,
                            width: 275,
                            child: new TextField(
                              controller: tanggalLahirController,
                              enabled: false,
                              decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: new BorderSide(color: Colors.blue)),
                                hintText: 'Tanggal Lahir*',
                                labelText: 'Tanggal Lahir*',
                              ),
                            ),
                          ),
                          Container(width: 5,),
                          IconButton(
                            icon: Icon(
                              Icons.calendar_today
                            ),
                            onPressed: ()async{
                              tanggalLahir=await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2030),
                              );
                              tanggalLahirController.text=tanggalLahir.toString().split(" ")[0];
                            },
                          )
                        ],
                      ),
                      Container(height: 10,),
                      Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.centerLeft,
                        child: Text(" $alertAlamat",style: TextStyle(color: Colors.red),),
                      ),
                      Container(
                        height: 80,
                        width: 325,
                        child: new TextField(
                          controller: alamatController,
                          maxLines: 5,
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: new BorderSide(color: Colors.blue)),
                            hintText: 'Alamat*',
                            labelText: 'Alamat*',
                          ),
                        ),
                      ),
                      Container(height: 50,),
                      ButtonGradient(
                        height: 40,
                        width: 130,
                        text: "Simpan",
                        onTap: (){
                          submit();
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ),
        new Opacity(
          opacity: 0.5,
          child: new Container(
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            height: height,
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
          height: height,
        )
      ],
    );
  }
}