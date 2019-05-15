import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dent_is_admin/screens/error.dart';

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
    try {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      
      PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
      List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://dent-is.herokuapp.com/dokter-login/")));
      
      print(widget.data["pasien"]);

      if (widget.data["isAppointment"]){
        Map<String,dynamic>bodyMap = {
          "idPasien":"${widget.data["pasien"]["id"]}",
          "anamnesa":widget.data["rekamMedis"]["anamnesa"],
          "alergi":widget.data["rekamMedis"]["alergi"],
          "riwayat_penyakit":widget.data["rekamMedis"]["riwayat_penyakit"],
          "tekanan_darah":widget.data["rekamMedis"]["tekanan_darah"],
          "berat":widget.data["rekamMedis"]["berat"],
          "tinggi":widget.data["rekamMedis"]["tinggi"],
          "idAppointment":"${widget.data["idAppointment"]}",
          "penanganan":widget.data["penangananFinal"]
        };

        var bodyJson = json.encode(bodyMap);

        var responsePA =  await http.post(
          'http://dent-is.herokuapp.com/pemeriksaanAwal/',
          headers: {
            "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
            "X-CSRFToken":cookies[0].value,
            "Content-Type":"application/json"
          },
          body: bodyJson
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
              "v":widget.data["odontogram"][item]["v"],
              "di":widget.data["ohis"][item]!=null?widget.data["ohis"][item]["di"]:null,
              "ci":widget.data["ohis"][item]!=null?widget.data["ohis"][item]["ci"]:null,
            });
          }
          else{
            list.add({
              "kode":item,
              "d":widget.data["odontogram"][item]["d"],
              "l":widget.data["odontogram"][item]["l"],
              "o":widget.data["odontogram"][item]["o"],
              "m":widget.data["odontogram"][item]["m"],
              "v":widget.data["odontogram"][item]["v"],
              "di":widget.data["ohis"][item]!=null?widget.data["ohis"][item]["di"]:null,
              "ci":widget.data["ohis"][item]!=null?widget.data["ohis"][item]["ci"]:null,
            });
          }
        }
        print(list);

        Map<String, dynamic> bodyO = {
          "idRekamMedis":'${bodyPA["id"]}',
          "gigi": list
        };
        var bodyOJson = json.encode(bodyO);

        print(bodyOJson);
        var responseOdon =  await http.post(
          'http://dent-is.herokuapp.com/odontogram/',
          headers: {
            "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
            "X-CSRFToken":cookies[0].value,
            "Content-Type":"application/json"
          },
          body: bodyOJson
        );
        var bodyOdon = json.decode(responseOdon.body);
        print("===========");
        print(bodyOdon);
        print("===========");

        
        print(widget.data["ohis"]);
        Map<String, dynamic> bodyOh= {
          "idRekamMedis":'${bodyPA["id"]}',
          "kondisi": widget.data["ohis"].values.toList()
        };
        var bodyOhJson = json.encode(bodyOh);

        var responseOhis =  await http.post(
          'http://dent-is.herokuapp.com/ohis/',
          headers: {
            "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
            "X-CSRFToken":cookies[0].value,
            "Content-Type":"application/json"
          },
          body: bodyOhJson
        );
        print(responseOhis.body);
        

        var bodyOhis = json.decode(responseOhis.body);

        print(bodyOhis);

        if (_image != null){
          var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
          var length = await _image.length();

          var uri = Uri.parse('http://dent-is.herokuapp.com/foto-rontgen/');

          var request = new http.MultipartRequest("POST", uri);
          request.headers["Cookie"]=cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value;
          request.headers["X-CSRFToken"]=cookies[0].value;
          request.fields["idRekamMedis"]='${bodyPA["id"]}';
          var multipartFile = new http.MultipartFile('foto', stream, length,
              filename: path.basename(_image.path));
              //contentType: new MediaType('image', 'png'));

          request.files.add(multipartFile);
          var response = await request.send();
          print(response.statusCode);
          if (response.statusCode!=200 && response.statusCode!=201){
            Navigator.push(
              context, 
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new ErrorScreen()
                )
            );
            return;
          }
        }
      }
      else{
        var responsePasien =  await http.post(
          'http://dent-is.herokuapp.com/pasien/',
          headers: {
            "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
            "X-CSRFToken":cookies[0].value
          },
          body: {
            "nama":widget.data["pasien"]["nama"],
            "jenisKelamin":widget.data["pasien"]["jenisKelamin"]
          }
        );
        print(responsePasien.body);
        var bodyPasien = json.decode(responsePasien.body);
        print("bodyPasien");
        
        var bodyMap={
          "idPasien":"$bodyPasien",
          "anamnesa":widget.data["rekamMedis"]["anamnesa"],
          "alergi":widget.data["rekamMedis"]["alergi"],
          "riwayat_penyakit":widget.data["rekamMedis"]["riwayat_penyakit"],
          "tekanan_darah":widget.data["rekamMedis"]["tekanan_darah"],
          "berat":widget.data["rekamMedis"]["berat"],
          "tinggi":widget.data["rekamMedis"]["tinggi"],
          "penanganan":widget.data["penangananFinal"]
        };

        var bodyJson = json.encode(bodyMap);
        var responsePA =  await http.post(
          'http://dent-is.herokuapp.com/pemeriksaanAwal/',
          headers: {
            "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
            "X-CSRFToken":cookies[0].value,
            "Content-Type":"application/json"
          },
          body: bodyJson
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
              "v":widget.data["odontogram"][item]["v"],
              "di":widget.data["ohis"][item]!=null?widget.data["ohis"][item]["di"]:null,
              "ci":widget.data["ohis"][item]!=null?widget.data["ohis"][item]["ci"]:null,
            });
          }
          else{
            list.add({
              "kode":item,
              "d":widget.data["odontogram"][item]["d"],
              "l":widget.data["odontogram"][item]["l"],
              "o":widget.data["odontogram"][item]["o"],
              "m":widget.data["odontogram"][item]["m"],
              "v":widget.data["odontogram"][item]["v"],
              "di":widget.data["ohis"][item]!=null?widget.data["ohis"][item]["di"]:null,
              "ci":widget.data["ohis"][item]!=null?widget.data["ohis"][item]["ci"]:null,
            });
          }
        }
        print(list);

        Map<String, dynamic> bodyO = {
          "idRekamMedis":'${bodyPA["id"]}',
          "gigi": list
        };
        var bodyOJson = json.encode(bodyO);

        print(bodyOJson);
        var responseOdon =  await http.post(
          'http://dent-is.herokuapp.com/odontogram/',
          headers: {
            "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
            "X-CSRFToken":cookies[0].value,
            "Content-Type":"application/json"
          },
          body: bodyOJson
        );
        var bodyOdon = json.decode(responseOdon.body);
        print("===========");
        print(bodyOdon);
        print("===========");

        
        print(widget.data["ohis"]);
        Map<String, dynamic> bodyOh= {
          "idRekamMedis":'${bodyPA["id"]}',
          "kondisi": widget.data["ohis"].values.toList()
        };
        var bodyOhJson = json.encode(bodyOh);

        var responseOhis =  await http.post(
          'http://dent-is.herokuapp.com/ohis/',
          headers: {
            "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
            "X-CSRFToken":cookies[0].value,
            "Content-Type":"application/json"
          },
          body: bodyOhJson
        );
        print(responseOhis.body);
        

        var bodyOhis = json.decode(responseOhis.body);

        print(bodyOhis);

        var responseJadwal =  await http.get(
          'http://dent-is.herokuapp.com/jadwal-praktek-now/',
          headers: {
            "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
            "X-CSRFToken":cookies[0].value,
            "Content-Type":"application/json"
          },
        ); 
        var bodyJadwal = json.decode(responseJadwal.body);

        print(bodyJadwal);

        var jsonApp=json.encode({
            "is_booked":false,
            "idDokter":"${bodyPA["idDokter"]}", 
            "idRekamMedis":"${bodyPA["id"]}",
            "idJadwal":"${bodyJadwal["id"]}"
          });
        
        var responseAppointment = await http.post(
          'http://dent-is.herokuapp.com/appointment/${bodyPA["data"]["idPasien"]}/',
          headers: {
            "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
            "X-CSRFToken":cookies[0].value,
            "Content-Type":"application/json"
          },
          body: jsonApp
        );
        var bodyAppointment = json.decode(responseAppointment.body);

        print(bodyAppointment);
        


        if (_image != null){
          var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
          var length = await _image.length();

          var uri = Uri.parse('http://dent-is.herokuapp.com/foto-rontgen/');

          var request = new http.MultipartRequest("POST", uri);
          request.headers["Cookie"]=cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value;
          request.headers["X-CSRFToken"]=cookies[0].value;
          request.fields["idRekamMedis"]='${bodyPA["id"]}';
          var multipartFile = new http.MultipartFile('foto', stream, length,
              filename: path.basename(_image.path));
              //contentType: new MediaType('image', 'png'));

          request.files.add(multipartFile);
          var response = await request.send();
          print(response.statusCode);
          if (response.statusCode!=200 && response.statusCode!=201){
            Navigator.push(
              context, 
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new ErrorScreen()
                )
            );
            return;
          }
        }
      }
      
      setState(() {
        opacity=0;
      });
      Navigator.of(context).popUntil(
        (Route<dynamic> r) => r.isFirst
      );
      
      Fluttertoast.showToast(
        msg: "Pemeriksaan selesai! Rekam medis berhasil disimpan",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0
      );
    } catch (e) {
      print(e);
      setState(() {
        opacity=0;
      });
      Navigator.push(
        context, 
        new MaterialPageRoute(
            builder: (BuildContext context) =>
            new ErrorScreen()
          )
      );
    }
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
          body: Container(
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