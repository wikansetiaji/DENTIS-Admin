import 'package:flutter/material.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dent_is_admin/screens/error.dart';

class AdminEditManajer extends StatefulWidget {
  final String id;
  final String username;
  final String email;
  final String noHp;
  final String nama;
  final String jenisKelamin;
  final String alamat;
  final String tanggalLahir;
  final String ktp;

  AdminEditManajer({
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.noHp,
    @required this.nama,
    @required this.jenisKelamin,
    @required this.alamat,
    @required this.tanggalLahir,
    @required this.ktp,
  });

  @override
  _AdminEditManajerState createState() => _AdminEditManajerState();
}

class _AdminEditManajerState extends State<AdminEditManajer> {
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
  String alertNama="";
  String alertUsername="";
  String alertPassword="";
  String alertNomorKtp="";
  String alertEmail="";
  String alertNomorTelepon="";
  String alertTanggalLahir="";
  String alertAlamat="";
  DateTime tanggalLahir;

  error()async{
    await Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
          builder: (BuildContext context) =>
          new ErrorScreen()
        )
      );
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    namaController.text=widget.nama;
    usernameController.text=widget.username;
    emailController.text=widget.email;
    noHpController.text=widget.noHp;
    tanggalLahirController.text=widget.tanggalLahir;
    alamatController.text=widget.alamat;
    nomorKTPController.text=widget.ktp;
    jenisKelamin=widget.jenisKelamin;
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  submit()async{
    try {
      setState(() {
        alertNama="";
        alertUsername="";
        alertPassword="";
        alertNomorKtp="";
        alertEmail="";
        alertNomorTelepon="";
        alertTanggalLahir="";
        alertAlamat="";
      });
      bool pass = true;
      String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      RegExp regExp = new RegExp(p);
      if (tanggalLahirController.text==""){
        pass= false;
        setState(() {
          alertTanggalLahir="Wajib diisi";
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
        List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http:// -dentis.herokuapp.com/admin-login/")));
        print(cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value);
        var response =  await http.patch(
          'http://dent-is.herokuapp.com/manajer/${widget.id}/',
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
          }
        );
        if (response.statusCode!=200 && response.statusCode!=201){
          await error();
          setState(() {
            height=0;
          });
          return;
        }
        var body = json.decode(response.body);
        print(body);
        setState(() {
          height=0;
        });
        Fluttertoast.showToast(
          msg: "Manajer berhasil diedit",
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
              child:ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Ubah Manajer",
                          style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                        ),
                        Container(height: 40,),
                        new Container(
                width: 150,
                height: 150,
                decoration: new BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/profile-picture.png"))
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
                              hintText: 'Password (Unchanged)',
                              labelText: 'Password (Unchanged)',
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
      )
    );
  }
}