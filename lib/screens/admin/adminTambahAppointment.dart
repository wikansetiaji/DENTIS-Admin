import 'package:flutter/material.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'package:dent_is_admin/screens/error.dart';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';


class AdminTambahAppointment extends StatefulWidget {
  final String idPasien;

  AdminTambahAppointment({
    @required this.idPasien
  });

  @override
  _AdminTambahAppointmentState createState() => _AdminTambahAppointmentState();
}

class _AdminTambahAppointmentState extends State<AdminTambahAppointment> {
  String datePicked;
  String timePicked;
  String dokterPicked;
  List<dynamic> listJadwal = [];
  List<dynamic> listDokter = [];
  Set<String> dateSet= new Set<String>();
  Set<String> timeSet= new Set<String>();
  List<DropdownMenuItem<String>> dokterDropdownList = new List<DropdownMenuItem<String>>();
  List<DropdownMenuItem<String>> dateDropdownList = new List<DropdownMenuItem<String>>();
  List<DropdownMenuItem<String>> timeDropdownList = new List<DropdownMenuItem<String>>();
  double height=0;
  double opacity=0;
  String alertTanggal="";
  String alertJam="";
  String alertDokter="";

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
      List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://api-dentis.herokuapp.com/admin-login/")));
      var responseJadwal =  await http.get(
        'http://api-dentis.herokuapp.com/jadwal-available/',
        headers: {
          "Cookie":cookies[1].name+"="+cookies[1].value
        },
      );
      if(responseJadwal.statusCode!=200 && responseJadwal.statusCode!=201){
        await error();
        setState(() {
          height=0;
        });
        return;
      }
      var bodyJadwal = json.decode(responseJadwal.body);
      listJadwal=bodyJadwal;
      print(bodyJadwal);
      dateDropdownList = new List<DropdownMenuItem<String>>();
      for (var i in bodyJadwal){
        var tanggal = i["waktu_mulai"].split("T")[0];
        if (!dateSet.contains(tanggal)){
          dateDropdownList.addAll([
            DropdownMenuItem(
              value: tanggal,
              child: Text("$tanggal"),
            )
          ]);
          dateSet.addAll([
            tanggal
          ]);
        }
      }

      var responseDokter =  await http.get(
        'http://api-dentis.herokuapp.com/dokter/',
        headers: {
          "Cookie":cookies[1].name+"="+cookies[1].value
        },
      );
      if(responseDokter.statusCode!=200 && responseDokter.statusCode!=201){
        await error();
        setState(() {
          height=0;
        });
        return;
      }
      var bodyDokter = json.decode(responseDokter.body);
      listDokter=bodyDokter;
      dokterDropdownList = new List<DropdownMenuItem<String>>();
      for (var i in listDokter){
        dokterDropdownList.addAll([
          DropdownMenuItem(
            value: i["user"]["id"].toString(),
            child: Text(i["nama"]),
          )
        ]);
      }

      setState(() {
        this.height=0;
      });
    } catch (e) {
      print(e);
      error();
    }
  }

  submit()async{
    try {
      setState(() {
        alertDokter="";
        alertJam="";
        alertTanggal="";
      });
      bool passed = true;
      if (datePicked==null){
        passed=false;
        alertTanggal="Tanggal wajib diisi";
      }
      if (timePicked==null){
        passed=false;
        alertJam="Jam wajib diisi";
      }
      if (dokterPicked==null){
        passed=false;
        alertDokter="Dokter wajib diisi";
      }
      if (passed){
        setState(() {
          opacity=MediaQuery.of(context).size.height;
        });
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        
        PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
        List<Cookie> cookies = (cj.loadForRequest(Uri.parse("http://api-dentis.herokuapp.com/admin-login/")));
        print(cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value);
        var response =  await http.post(
          'http://api-dentis.herokuapp.com/appointment/${widget.idPasien}/',
          headers: {
            "Cookie":cookies[1].name+"="+cookies[1].value+";"+cookies[0].name+"="+cookies[0].value,
            "X-CSRFToken":cookies[0].value
          },
          body: {
            "is_booked":"false",
            "idDokter":dokterPicked,
            "idJadwal":timePicked
          }
        );
        if (response.statusCode!=200 && response.statusCode!=201){
          await error();
          setState(() {
            opacity=0;
          });
          return;
        }
        var body = json.decode(response.body);
        print(body);
        setState(() {
          opacity=0;
        });
        Fluttertoast.showToast(
          msg: "Appointment berhasil dibuat",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
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
        title: Text("Appointment",style: TextStyle(color:Colors.black54),),
      ),
      body: 
        Stack(
        children:<Widget>[
          Container(
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
                Container(
                  padding: EdgeInsets.all(43),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Tanggal",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
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
                          hint: Text("Pilih tanggal"),
                          isExpanded: true,
                          value: datePicked,
                          items: dateDropdownList.toList(),
                          onChanged: (String selected){
                            if (timePicked!=null){
                              timePicked=null;
                            }
                            if (timeDropdownList.length!=0){
                              timeDropdownList = new List<DropdownMenuItem<String>>();
                            }
                            timeSet = new Set<String>();
                            for (var i in listJadwal){
                              if (i["waktu_mulai"].split("T")[0]==selected){
                                if (!timeSet.contains("${i["waktu_mulai"].split("T")[1].split("Z")[0]} - ${i["waktu_selesai"].split("T")[1].split("Z")[0]}")){
                                  timeDropdownList.addAll([
                                    DropdownMenuItem(
                                      value: i["id"].toString(),
                                      child: Text("${i["waktu_mulai"].split("T")[1].split("Z")[0]} - ${i["waktu_selesai"].split("T")[1].split("Z")[0]}"),
                                    )
                                  ]);
                                  timeSet.addAll([
                                    "${i["waktu_mulai"].split("T")[1].split("Z")[0]} - ${i["waktu_selesai"].split("T")[1].split("Z")[0]}"
                                  ]);
                                }
                                
                              }
                            }
                            setState(() {
                                datePicked = selected;
                              });
                          },
                        ),
                      ),
                      Text("$alertTanggal",style: TextStyle(color: Colors.red),),
                      Container(height: 15,),
                      Text("Jam",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
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
                          hint: Text("Pilih jam"),
                          disabledHint: Text("Pilih tanggal terlebih dahulu"),
                          isExpanded: true,
                          value: timePicked,
                          items: timeDropdownList.toList(),
                          onChanged: (String selected){
                            setState(() {
                                timePicked = selected;
                              });
                          },
                        ),
                      ),
                      Text("$alertJam",style: TextStyle(color: Colors.red),),
                      Container(height: 15,),
                      Text("Dokter",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
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
                          hint: Text("Pilih dokter"),
                          isExpanded: true,
                          value: dokterPicked,
                          items: dokterDropdownList,
                          onChanged: (String selected){
                            setState(() {
                                dokterPicked = selected;
                              });
                          },
                        ),
                      ),
                      Text("$alertDokter",style: TextStyle(color: Colors.red),),
                      Container(height: 15,),
                      Container(
                        alignment: Alignment.center,
                        child: ButtonGradient(
                          height: 50,
                          width: 150,
                          text: "Simpan",
                          onTap: (){
                            submit();
                          },
                        )
                      ),
                    ]
                  ),
                ),
              ]
            )
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
          ),
          new Opacity(
            opacity: 0.5,
            child: new Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: this.opacity,
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
            height: this.opacity,
          )
        ],
      )
    );
  }
}