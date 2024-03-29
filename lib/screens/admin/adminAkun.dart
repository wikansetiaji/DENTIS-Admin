import 'package:flutter/material.dart';
import 'adminPasiens.dart';
import 'adminDokters.dart';
import 'adminManajers.dart';
import 'adminEditInstansi.dart';

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
        child: Padding(
          padding: EdgeInsets.only(left: 35,right: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(height: 40.0,),
              Text(
                "Kelola Akun",
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
              ),
              Container(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context, 
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new AdminPasiens()
                          )
                        );
                    },
                    child: Container(
                      height: 122,
                      width: 122,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/button-pasien.png")
                        )
                      ),
                    ),
                  ),
                  Container(width: 28,),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context, 
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new AdminDokters()
                          )
                        );
                    },
                    child: Container(
                      height: 122,
                      width: 122,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/button-dokter.png")
                        )
                      ),
                    ),
                  ),
                ],
              ),
              Container(height: 28,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: (){
                          Navigator.push(
                            context, 
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                new AdminManajers()
                              )
                            );
                        },
                    child: Container(
                      height: 122,
                      width: 122,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/button-manajer.png")
                        )
                      ),
                    ),
                  ),
                  Container(width: 28,),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context, 
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new AdminEditInstansi()
                          )
                        );
                    },
                    child: Container(
                      height: 122,
                      width: 122,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/button-instansi.png")
                        )
                      ),
                    ),
                  ),
                ],
              )
            ]
          )
        )
      )
    );
  }
}