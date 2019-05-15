import 'package:flutter/material.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dent_is_admin/screens/error.dart';


class AdminAddFAQ extends StatefulWidget {
  @override
  _AdminAddFAQState createState() => _AdminAddFAQState();
}

class _AdminAddFAQState extends State<AdminAddFAQ> {
  double height=0;
  final pertanyaanController = TextEditingController();
  final jawabanController = TextEditingController();
  String alertPertanyaan="";
  String alertJawaban="";
  error()async{
    await Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
          builder: (BuildContext context) =>
          new ErrorScreen()
        )
      );
  }

  submit()async{
    try{
    alertJawaban="";
    alertPertanyaan="";
    bool pass=true;
    if (pertanyaanController.text==""){
      pass=false;
      setState(() {
        alertPertanyaan="Field wajib diisi";
      });
    }
    if (jawabanController.text==""){
      pass=false;
      setState(() {
        alertJawaban="Field wajib diisi";
      });
    }
    if (pass){
      setState(() {
        height=MediaQuery.of(context).size.height;
      });
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      
      PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
      List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://dent-is.herokuapp.com/admin-login/")));
      print(cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value);
      var response =  await http.post(
        'http://dent-is.herokuapp.com/faqs/',
        headers: {
          "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
          "X-CSRFToken":cookies[0].value
        },
        body: {
          "question":pertanyaanController.text,
          "answer":jawabanController.text,
        }
      );
      if (response.statusCode!=200 && response.statusCode!=201){
        error();
      }
      var body = json.decode(response.body);
      print(body);
      setState(() {
        height=0;
      });
      Fluttertoast.showToast(
        msg: "FAQ berhasil ditambah",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0
      );
      Navigator.of(context).pop();
    }
    }
    catch(e){
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
            body: 
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(height: 33,),
                      Text(
                        "Tambah FAQ",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                      Container(height: 13,),
                      Container(
                        padding: EdgeInsets.only(left:40),
                        alignment: Alignment.centerLeft,
                        child: Text("${alertPertanyaan}",style: TextStyle(color: Colors.red),),
                      ),
                      Container(
                        height: 80,
                        width: 325,
                        child: new TextField(
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: new BorderSide(color: Colors.blue)),
                            hintText: 'Isi pertanyaan',
                            labelText: 'Pertanyaan',
                          ),
                          controller: pertanyaanController,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left:40),
                        alignment: Alignment.centerLeft,
                        child: Text("${alertJawaban}",style: TextStyle(color: Colors.red),),
                      ),
                      Container(
                        height: 80,
                        width: 325,
                        child: new TextField(
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: new BorderSide(color: Colors.blue)),
                            hintText: 'Isi jawaban',
                            labelText: 'Jawaban',
                          ),
                          controller: jawabanController,
                        ),
                      ),
                      Container(height: 13,),
                      ButtonGradient(
                        height: 40,
                        width: 131,
                        text: "Simpan",
                        onTap: (){
                          print(jawabanController.text);
                          print(pertanyaanController.text);
                          submit();
                        },
                      ),
                    ]
                  )
                ]
              )
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