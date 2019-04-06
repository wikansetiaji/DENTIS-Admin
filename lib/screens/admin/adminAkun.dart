import 'package:flutter/material.dart';

class AdminAkun extends StatefulWidget {
  @override
  _AdminAkunState createState() => _AdminAkunState();
}

class _AdminAkunState extends State<AdminAkun> {
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
        title: Text("DENT-IS",style: TextStyle(color:Colors.black54),),
      )
    );
  }
}