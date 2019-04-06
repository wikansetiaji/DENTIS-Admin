import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class UploadFoto extends StatefulWidget {
  Map<String, dynamic> data;

  UploadFoto({
    @required this.data
  });

  @override
  _UploadFotoState createState() => _UploadFotoState();
}

class _UploadFotoState extends State<UploadFoto> {
  File _image;
  double opacity=0.0;

  submit()async{
    setState(() {
      opacity=MediaQuery.of(context).size.height;
    });
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    
    PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
    List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://10.0.2.2:8000/dokter-login/")));
    
    print(widget.data);

    var responsePasien =  await http.post(
      'http://10.0.2.2:8000/pasien/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
        "X-CSRFToken":cookies[0].value
      },
      body: widget.data["pasien"]
    );
    var bodyPasien = json.decode(responsePasien.body);
    print(bodyPasien);
    
    var responsePA =  await http.post(
      'http://10.0.2.2:8000/pemeriksaanAwal/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
        "X-CSRFToken":cookies[0].value
      },
      body: {
        "idPasien":"$bodyPasien",
        "anamnesa":widget.data["rekamMedis"]["anamnesa"],
        "alergi":widget.data["rekamMedis"]["alergi"],
        "riwayatPenyakit":widget.data["rekamMedis"]["riwayatPenyakit"],
        "tekananDarah":widget.data["rekamMedis"]["tekananDarah"],
        "berat":widget.data["rekamMedis"]["berat"],
        "tinggi":widget.data["rekamMedis"]["tinggi"]
      }
    );
    var bodyPA = json.decode(responsePA.body);
    print(bodyPA);

    List<Map<String,dynamic>> list = [];
    for (var item in widget.data["odontogram"].keys) {
      if(widget.data["odontogram"][item]["o"]==null){
        list.add({
          "kode":item,
          "d":widget.data["odontogram"][item]["d"],
          "l":widget.data["odontogram"][item]["l"],
          "m":widget.data["odontogram"][item]["m"],
          "v":widget.data["odontogram"][item]["v"]
        });
      }
      else{
        list.add({
          "kode":item,
          "d":widget.data["odontogram"][item]["d"],
          "l":widget.data["odontogram"][item]["l"],
          "o":widget.data["odontogram"][item]["o"],
          "m":widget.data["odontogram"][item]["m"],
          "v":widget.data["odontogram"][item]["v"]
        });
      }
    }
    print(list);

    Map<String, dynamic> body = {
      "idRekamMedis":'${bodyPA["id"]}',
      "gigi": list
    };
    var bodyJson = json.encode(body);
    print(bodyJson);
    var responseOdon =  await http.post(
      'http://10.0.2.2:8000/odontogram/',
      headers: {
        "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
        "X-CSRFToken":cookies[0].value,
        "Content-Type":"application/json"
      },
      body: bodyJson
    );
    var bodyOdon = json.decode(responseOdon.body);
    print(bodyOdon);
    setState(() {
      opacity=0;
    });
    Navigator.of(context).popUntil(
      (Route<dynamic> r) => r.isFirst
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
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
          body: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(height: 28,),
                  Text(
                    "Foto",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40
                    ),
                  ),
                  Container(
                    height: 54,
                  ),
                  InkWell(
                    onTap: (){
                      getImage();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 297,
                      height: 297,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                          color: Colors.grey,
                          width: 2.0
                        )
                      ),
                      child: Stack(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.camera_alt,
                                size: 30,
                                color: Colors.grey,
                              ),
                              Container(width:19),
                              Text("Tekan untuk\nmengunggah\ngambar")
                            ],
                          ),
                          _image!=null?Container(
                            width: 297,
                            height: 297,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(_image),
                                fit: BoxFit.contain
                              )
                            ),
                          ):Container()
                        ],
                      ),
                    )
                  ),
                  Container(height:20),
                  ButtonGradient(
                    height: 48,
                    width: 168,
                    text: "Simpan dan Selesai",
                    onTap: ()async{
                      submit();
                    },
                  ),
                ]
              )
            ]
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
          )
      ],
    );
  }
}