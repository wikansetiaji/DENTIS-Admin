import 'package:flutter/material.dart';
import 'pemeriksaan/newUser.dart';

class DokterHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(left: 35,right: 35),
      children: <Widget>[
        Container(height: 120.0,),
        Text(
          "Halo\nDokter!",
          style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
        ),
        Container(height: 30,),
        Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(15),
          width: 330,
          height: 123,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                spreadRadius: 0.3,
                color: Colors.blueGrey,
                blurRadius: 10.0,
                offset: Offset(
                  0.0,
                  2.0,
                ),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 108,
                width: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage("assets/appointment.png"))
                      ),
                    ),
                    Container(height: 13,),
                    Text("Appointment")
                  ],
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(
                    context, 
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new NewUser()
                      )
                  );
                },
                child: Container(
                  height: 108,
                  width: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/plus-circle.png"))
                        ),
                      ),
                      Container(
                        height: 13,
                      ),
                      Text("Pemeriksaan Baru",textAlign: TextAlign.center,)
                    ],
                  ),
                ),
              ),
              Container(
                height: 108,
                width: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage("assets/kuisioner.png"))
                      ),
                    ),
                    Container(
                      height: 13,
                    ),
                    Text("Kuisioner",textAlign: TextAlign.center,)
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          height: 33,
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            "Appointment Terkini",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
            ),
          )
        ),
        Container(
          height: 10,
        ),
        Container(
          alignment: Alignment.center,
          child:Image.asset(
            "assets/line.png",
            width: 268,
          )
        )
      ],
    );
  }
}