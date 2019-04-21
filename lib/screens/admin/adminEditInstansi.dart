import 'package:flutter/material.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dent_is_admin/screens/error.dart';

class AdminEditInstansi extends StatefulWidget {
  @override
  _AdminEditInstansiState createState() => _AdminEditInstansiState();
}

class _AdminEditInstansiState extends State<AdminEditInstansi> {
  bool loaded=false;
  double opacity=0;
  double white=0;
  String id;
  String alertNama="";
  TextEditingController namaController = new TextEditingController();
  String alertAlamat="";
  TextEditingController alamatController = new TextEditingController();
  String alertEmail="";
  TextEditingController emailController = new TextEditingController();
  String alertTelepon="";
  TextEditingController teleponController = new TextEditingController();
  String alertLayanan="";
  TextEditingController layananController = new TextEditingController();
  String alertWaktu="";
  TextEditingController waktuController = new TextEditingController();

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
        this.white=MediaQuery.of(context).size.height;
      });
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      
      PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
      List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://api-dentis.herokuapp.com/admin-login/")));
      var response =  await http.get(
        'http://api-dentis.herokuapp.com/instansi/',
        headers: {
          "Cookie":cookies[1].name+"="+cookies[1].value
        },
      );
      if(response.statusCode!=200 && response.statusCode!=201){
        await error();
        setState(() {
          white=0;
        });
        return;
      }
      var body = json.decode(response.body)[0];
      print(body);
      setState(() {
        id=body["id"];
        namaController.text=body["nama"];
        alamatController.text=body["alamat"];
        emailController.text=body["emailInstansi"];
        teleponController.text=body["noTelepon"];
        layananController.text=body["layanan"];
        waktuController.text=body["waktuLayanan"];
        this.white=0;
      });
    } catch (e) {
      print(e);
      error();
    }
  }

  submit()async{
    try {
      bool pass=true;
      setState(() {
        alertNama="";
        alertAlamat="";
        alertEmail="";
        alertTelepon="";
        alertLayanan="";
        alertWaktu="";
      });
      String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      RegExp regExp = new RegExp(p);
      if (namaController.text==""){
        setState(() {
          alertNama="Wajib diisi";
        });
        pass=false;
      }
      if (alamatController.text==""){
        setState(() {
          alertAlamat="Wajib diisi";
        });
        pass=false;
      }
      if (emailController.text==""){
        setState(() {
          alertEmail="Wajib diisi";
        });
        pass=false;
      }
      if(!regExp.hasMatch(emailController.text)){
        pass= false;
        setState(() {
          alertEmail="Format Salah";
        });
      }
      if (teleponController.text==""){
        setState(() {
          alertTelepon="Wajib diisi";
        });
        pass=false;
      }
      if (layananController.text==""){
        setState(() {
          alertLayanan="Wajib diisi";
        });
        pass=false;
      }
      if (waktuController.text==""){
        setState(() {
          alertWaktu="Wajib diisi";
        });
        pass=false;
      }

      if (pass){
        setState(() {
          opacity=MediaQuery.of(context).size.height;
        });
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        
        PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
        List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://api-dentis.herokuapp.com/admin-login/")));
        print(cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value);
        var response =  await http.patch(
          'http://api-dentis.herokuapp.com/instansi/$id/',
          headers: {
            "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
            "X-CSRFToken":cookies[0].value
          },
          body: {
            "nama":namaController.text,
            "alamat":alamatController.text,
            "noTelepon":teleponController.text,
            "layanan":layananController.text,
            "waktuLayanan":waktuController.text,
            "emailInstansi":emailController.text
          }
        );
        if (response.statusCode!=200 && response.statusCode!=201){
          error();
          return;
        }
        var body = json.decode(response.body);
        print(body);
        setState(() {
          opacity=0;
        });
        Fluttertoast.showToast(
          msg: "Instansi berhasil diubah",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0
        );
        Navigator.pop(context);
      }
    } catch (e) {
      error();
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!loaded){
      load();
    }
    loaded=true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        bool pop = await showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: Text("Apakah anda ingin kembali ke halaman sebelumnya?"),
              content: Container(
                alignment: Alignment.center,
                height: 37,
                child: Text("Perubahan yang sudah Anda buat tidak akan disimpan",textAlign: TextAlign.center,),
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
        if(pop){
          Navigator.of(context).pop();
        }
      },
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                color: Colors.black,
                icon: Icon(Icons.arrow_back_ios),
                onPressed: ()async{
                  bool pop = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      return AlertDialog(
                        title: Text("Apakah anda ingin kembali ke halaman sebelumnya?"),
                        content: Container(
                          alignment: Alignment.center,
                          height: 37,
                          child: Text("Perubahan yang sudah Anda buat tidak akan disimpan",textAlign: TextAlign.center,),
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
                  if(pop){
                    Navigator.of(context).pop();
                  }
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
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Ubah Instansi",
                          style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                        ),
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
                              hintText: 'Nama Instansi*',
                              labelText: 'Nama Instansi*',
                            ),
                          ),
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
                          child: Text(" ${alertTelepon}",style: TextStyle(color: Colors.red),),
                        ),
                        Container(
                          height: 60,
                          width: 325,
                          child: new TextField(
                            controller: teleponController,
                            keyboardType: TextInputType.phone,
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
                          child: Text(" $alertLayanan",style: TextStyle(color: Colors.red),),
                        ),
                        Container(
                          height: 80,
                          width: 325,
                          child: new TextField(
                            controller: layananController,
                            maxLines: 5,
                            decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: new BorderSide(color: Colors.blue)),
                              hintText: 'Layanan*',
                              labelText: 'Layanan*',
                            ),
                          ),
                        ),
                        Container(height: 50,),
                        Container(
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.centerLeft,
                          child: Text(" ${alertWaktu}",style: TextStyle(color: Colors.red),),
                        ),
                        Container(
                          height: 60,
                          width: 325,
                          child: new TextField(
                            controller: waktuController,
                            decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: new BorderSide(color: Colors.blue)),
                              hintText: 'Waktu Layanan*',
                              labelText: 'Waktu Layanan*',
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
                      ]
                    )
                  )
                ],
              )
            )
          ),
          new Opacity(
            opacity: 0.5,
            child: new Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: opacity,
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
            height: opacity,
          ),
          Container(
            height: this.white,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          Container(
            height: this.white,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ]
      )
    );
  }
}