import 'package:flutter/material.dart';
import 'dokterHome.dart';
import 'dokterNews.dart';
import 'statistik.dart';

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