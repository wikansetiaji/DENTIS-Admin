import 'package:flutter/material.dart';
import 'dokterHome.dart';
import 'dokterNews.dart';
import 'statistik.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dent_is_admin/screens/initialScreen.dart';

class DokterTabs extends StatefulWidget {
  @override
  _DokterTabsState createState() => _DokterTabsState();
}

class _DokterTabsState extends State<DokterTabs> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    DokterHome(),
    Statistik(),
    DokterNews()
  ];
  
  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
 }

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
              cj.delete(Uri.parse("http://dent-is.herokuapp.com/dokter-login/"));
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
     body: _children[_currentIndex], // new
     bottomNavigationBar: BottomNavigationBar(
       onTap: onTabTapped,
       currentIndex: _currentIndex, // new
       items: [
         new BottomNavigationBarItem(
           icon: Icon(Icons.home),
           title: Text('Home'),
         ),
         new BottomNavigationBarItem(
           icon: Icon(Icons.trending_up),
           title: Text('Statistik'),
         ),
         new BottomNavigationBarItem(
           icon: Icon(Icons.library_books),
           title: Text('Berita')
         )
       ],
     ),
   );
  }
}