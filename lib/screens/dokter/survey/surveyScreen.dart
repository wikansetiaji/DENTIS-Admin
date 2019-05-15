import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dent_is_admin/screens/error.dart';


class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  double height=0;
  int page = 1;
  List<bool> tfAlert=[];
  List<int> tfAnswer=[];
  List<bool> rangeAlert=[];
  List<int> rangeAnswer=[];
  Map<String,dynamic> questions;
  ScrollController _controller = ScrollController();

  error()async{
    await Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
          builder: (BuildContext context) =>
          new ErrorScreen()
        )
      );
  }

  post()async{
    try{
      setState(() {
        height=MediaQuery.of(context).size.height;
      });
      List<Map<String,dynamic>> list=[];
      int temp=0;
      for (var item in tfAnswer) {
        temp++;
        list.add({
          "no":temp.toString(),
          "jawaban":item,
          "tipe":"tf"
        });
      }
      temp=0;
      for (var item in rangeAnswer) {
        temp++;
        list.add({
          "no":temp.toString(),
          "jawaban":item,
          "tipe":"range"
        });
      }
      var bodyJson=json.encode({
          "jawaban":list
      });
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      
      PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
      List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://dent-is.herokuapp.com/dokter-login/")));
      print(cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value);
      var response =  await http.post(
        'http://dent-is.herokuapp.com/survey/',
        headers: {
          "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
          "X-CSRFToken":cookies[0].value,
          "Content-Type":"application/json"
        },
        body: bodyJson
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
        msg: "Survey berhasil dibuat",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0
      );
      Navigator.of(context).pop();
    }
    catch(e){
      error();
    }
  }

  load()async{
    if (tfAnswer.length==0){
      for (var i = 0; i < 19; i++) {
        tfAnswer.add(null);
        tfAlert.add(false);
      }
      for (var i = 0; i < 17; i++) {
        rangeAnswer.add(null);
        rangeAlert.add(false);
      }
    }
    String questionString =await rootBundle.loadString('assets/questions.json');
    questions=json.decode(questionString);
    setState(() {
      
    });
  }

  Widget tfQuestion(int no, String soal){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new RichText(
                text: new TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    new TextSpan(text: "$no. $soal"),
                    new TextSpan(text: this.tfAlert[no-1]?"\nWajib diisi*":"*", style: new TextStyle(color:Colors.red)),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  new Radio(
                    value: 1,
                    groupValue: this.tfAnswer[no-1],
                    onChanged: (value){
                      setState(() {
                        this.tfAnswer[no-1] = value;
                      });
                      print(this.tfAnswer);
                    },
                  ),
                  InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      height: 35,
                      child: Text("Benar"),
                    ),
                    onTap: (){
                      setState(() {
                        this.tfAnswer[no-1] = 1;
                      });
                      print(this.tfAnswer);
                    },
                  ),
                  
                  Container(width: 15,),
                  new Radio(
                    value: 0,
                    groupValue: this.tfAnswer[no-1],
                    onChanged: (value){
                      setState(() {
                        this.tfAnswer[no-1] = value;
                      });
                      print(this.tfAnswer);
                    },
                  ),
                  InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      height: 35,
                      child: Text("Salah"),
                    ),
                    onTap: (){
                      setState(() {
                        this.tfAnswer[no-1] = 0;
                      });
                      print(this.tfAnswer);
                    },
                  ),
                ],
              )
            ],
          )
        ),
        Divider(color: Colors.blue,),
      ],
    );
  }

  Widget rangeQuestion(int no, String soal){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new RichText(
                text: new TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    new TextSpan(text: "$no. $soal"),
                    new TextSpan(text: this.rangeAlert[no-1]?"\nWajib diisi*":"*", style: new TextStyle(color:Colors.red)),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 162,
                    child: Row(
                      children: <Widget>[
                        new Radio(
                          value: 0,
                          groupValue: this.rangeAnswer[no-1],
                          onChanged: (value){
                            setState(() {
                              this.rangeAnswer[no-1] = value;
                            });
                            print(this.rangeAnswer);
                          },
                        ),
                        InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            height: 35,
                            child: Text("Tidak Pernah"),
                          ),
                          onTap: (){
                            setState(() {
                              this.rangeAnswer[no-1] = 0;
                            });
                            print(this.rangeAnswer);
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(width: 15,),
                  Container(
                    child: Row(
                      children: <Widget>[
                        new Radio(
                          value: 2,
                          groupValue: this.rangeAnswer[no-1],
                          onChanged: (value){
                            setState(() {
                              this.rangeAnswer[no-1] = value;
                            });
                            print(this.rangeAnswer);
                          },
                        ),
                        InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            height: 35,
                            child: Text("Sering"),
                          ),
                          onTap: (){
                            setState(() {
                              this.rangeAnswer[no-1] = 2;
                            });
                            print(this.rangeAnswer);
                          },
                        ),
                      ]
                    )
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 162,
                    child: Row(
                      children: <Widget>[
                        new Radio(
                          value: 1,
                          groupValue: this.rangeAnswer[no-1],
                          onChanged: (value){
                            setState(() {
                              this.rangeAnswer[no-1] = value;
                            });
                            print(this.rangeAnswer);
                          },
                        ),
                        InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            height: 35,
                            child: Text("Kadang-kadang"),
                          ),
                          onTap: (){
                            setState(() {
                              this.rangeAnswer[no-1] = 1;
                            });
                            print(this.rangeAnswer);
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(width: 15,),
                  Container(
                    child: Row(
                      children: <Widget>[
                        new Radio(
                          value: 3,
                          groupValue: this.rangeAnswer[no-1],
                          onChanged: (value){
                            setState(() {
                              this.rangeAnswer[no-1] = value;
                            });
                            print(this.rangeAnswer);
                          },
                        ),
                        InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            height: 35,
                            child: Text("Selalu"),
                          ),
                          onTap: (){
                            setState(() {
                              this.rangeAnswer[no-1] = 3;
                            });
                            print(this.rangeAnswer);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          )
        ),
        Divider(color: Colors.blue,),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }
  
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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
      child: Scaffold(
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
        body:ListView(
          controller: _controller,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(40,10,40,40),
              child: Column(
                children: <Widget>[
                  this.page==1?Container(
                    alignment: Alignment.center,
                    child: Text("Kuesioner",style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),)
                  )
                  :
                  Container(),
                  Container(height:15),
                  this.page<5?Column(
                    children: <Widget>[
                      this.page==1?Container(
                        alignment: Alignment.center,
                        child: Text("Bagian 1: Pengetahuan Kesehatan Gigi",style: TextStyle(fontWeight: FontWeight.bold),)
                      )
                      :
                      Container(),
                      this.page==1?Container(height:15):Container(),
                      Column(
                        children: this.questions!=null?List<Widget>.from(this.questions["tf"].map((n){
                          return int.parse(n["no"])>=1+(this.page-1)*5 && int.parse(n["no"])<=(this.page)*5?tfQuestion(int.parse(n["no"]), n["pertanyaan"]):Container();
                        })):<Widget>[]
                      ),
                    ],
                  )
                  :
                  Column(
                    children: <Widget>[
                      this.page==5?Container(
                        alignment: Alignment.center,
                        child: Text("Bagian 2: Perilaku Perawatan Gigi",style: TextStyle(fontWeight: FontWeight.bold),)
                      )
                      :
                      Container(),
                      this.page==5?Container(height:15):Container(),
                      Column(
                        children: this.questions!=null?List<Widget>.from(this.questions["range"].map((n){
                          return int.parse(n["no"])>=1+(this.page-4-1)*5 && int.parse(n["no"])<=(this.page-4)*5?rangeQuestion(int.parse(n["no"]), n["pertanyaan"]):Container();
                        })):<Widget>[]
                      ),
                    ],
                  ),
                  Container(height:15),
                  Row(
                    children: <Widget>[
                      this.page!=1?ButtonGradient(
                        height: 35,
                        width: 120,
                        text: "Sebelumnya",
                        onTap: (){
                          _controller.jumpTo(0);
                          setState(() {
                            page-=1;
                          });
                        },
                      ):Container(),
                      Expanded(child: Container(),),
                      this.page!=8?ButtonGradient(
                        height: 35,
                        width: 120,
                        text: "Lanjut",
                        onTap: (){
                          tfAlert=[];
                          rangeAlert=[];
                          for (var i = 0; i < 19; i++) {
                            tfAlert.add(false);
                          }
                          for (var i = 0; i < 17; i++) {
                            rangeAlert.add(false);
                          }
                          bool pass=true;
                          if (page<5){
                            for (var i = ((1+(this.page-1)*5)-1); i < ((this.page)*5); i++) {
                              try {
                                if (tfAnswer[i]==null){
                                  setState(() {
                                    tfAlert[i]=true;
                                    pass=false;
                                  });
                                }
                              } catch (e) {
                              }
                            }
                          }
                          else{
                            for (var i = ((1+(this.page-4-1)*5)-1); i < ((this.page-4)*5); i++) {
                              try {
                                if (rangeAnswer[i]==null){
                                  setState(() {
                                    rangeAlert[i]=true;
                                    pass=false;
                                  });
                                }
                              } catch (e) {
                              }
                            }
                          }
                          if (pass){
                            _controller.jumpTo(0);
                            setState(() {
                              page+=1;
                            });
                          }
                        },
                      ):
                      ButtonGradient(
                        height: 35,
                        width: 120,
                        text: "Submit",
                        onTap: (){
                          post();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        )
      )
    );
  }
}