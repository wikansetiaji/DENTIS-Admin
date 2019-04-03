import 'package:flutter/material.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class AdminEditFAQ extends StatefulWidget {
  final String id;
  final String pertanyaan;
  final String jawaban;

  AdminEditFAQ({
    @required this.id,
    @required this.pertanyaan,
    @required this.jawaban
  });

  @override
  _AdminEditFAQState createState() => _AdminEditFAQState();
}

class _AdminEditFAQState extends State<AdminEditFAQ> {
  double height=0.0;
  final pertanyaanController = TextEditingController();
  final jawabanController = TextEditingController();

  submit()async{
    setState(() {
      height=MediaQuery.of(context).size.height;
    });
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    
    PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
    List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://10.0.2.2:8000/admin-login/")));
    print(cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value);
    var response =  await http.patch(
      'http://10.0.2.2:8000/faqs/${widget.id}/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
        "X-CSRFToken":cookies[0].value
      },
      body: {
        "question":pertanyaanController.text,
        "answer":jawabanController.text,
      }
    );
    var body = json.decode(response.body);
    print(body);
    setState(() {
      height=0;
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    pertanyaanController.text=widget.pertanyaan;
    jawabanController.text=widget.jawaban;
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
                      "Ubah FAQ",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900
                      ),
                    ),
                    Container(height: 13,),
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
              height: this.height,
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
            height: this.height,
          )
      ],
    );
  }
}