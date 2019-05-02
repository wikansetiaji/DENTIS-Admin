import 'package:flutter/material.dart';
import 'package:dent_is_admin/components/buttonCard.dart';
import 'adminFAQ.dart';
import 'adminAkun.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dent_is_admin/screens/initialScreen.dart';

class AdminHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("DENT-IS",style: TextStyle(color:Colors.black54),),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert,color: Colors.black,),
            padding: EdgeInsets.zero,
            onSelected: (String a)async{
              Directory tempDir = await getTemporaryDirectory();
              String tempPath = tempDir.path;
              
              PersistCookieJar cj=new PersistCookieJar(dir:tempPath);
              cj.delete(Uri.parse("http://api-dentis.herokuapp.com/admin-login/"));
              Navigator.pushReplacement(context, new MaterialPageRoute(
                builder: (BuildContext context) =>
                new InitialScreen()
              )
            );
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              PopupMenuItem<String>(
                value: "logout",
                child: const Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/wallpapers/wallpaper1.png"),
            fit: BoxFit.cover
          )
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 35,right: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(height: 40.0,),
              Text(
                "Halo,\nAdmin!",
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
              ),
              Container(height: 30,),
              ButtonCard(
                onTap: (){
                  Navigator.push(
                    context, 
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new AdminAkun()
                      )
                    );
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage("assets/users.png"))
                      ),
                    ),
                    Container(width:10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(height: 10,),
                        Text(
                          "Kelola akun",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                        ),
                        Container(height: 4,),
                        Container(
                          width: 200,
                          height: 30,
                          child: Text(
                            "Buat, ubah, atau hapus akun pasien, instansi, dokter,maupun manajer",
                            style: TextStyle(fontSize: 12),
                          )
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(height: 30,),
              ButtonCard(
                onTap: (){
                  
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage("assets/appointments.png"))
                      ),
                    ),
                    Container(width:10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(height: 10,),
                        Text(
                          "Appointment",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                        ),
                        Container(height: 4,),
                        Container(
                          width: 200,
                          height: 30,
                          child: Text(
                            "Buat appointment baru atau kelola appointment yang sudah ada",
                            style: TextStyle(fontSize: 12),
                          )
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(height: 30,),
              ButtonCard(
                onTap: (){
                  Navigator.push(
                    context, 
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new AdminFAQ()
                      )
                    );
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage("assets/faqs.png"))
                      ),
                    ),
                    Container(width:10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(height: 10,),
                        Text(
                          "FAQ / Bantuan",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                        ),
                        Container(height: 4,),
                        Container(
                          width: 200,
                          height: 30,
                          child: Text(
                            "Kelola daftar pertanyaan bantuan",
                            style: TextStyle(fontSize: 12),
                          )
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}