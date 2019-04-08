import 'package:flutter/material.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dent_is_admin/screens/initialScreen.dart';

class ManajerHome extends StatefulWidget {
  @override
  _ManajerHomeState createState() => _ManajerHomeState();
}

class _ManajerHomeState extends State<ManajerHome> {
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
              cj.delete(Uri.parse("http://10.0.2.2:8000/manajer-login/"));
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
      body: Padding(
        padding: EdgeInsets.only(left: 35,right: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(height: 40.0,),
            Text(
              "Halo,\nManajer!",
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            Container(height: 30,),
          ]
        )
      )
    );
  }
}