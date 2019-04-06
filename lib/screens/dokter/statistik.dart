import 'package:flutter/material.dart';

class Statistik extends StatefulWidget {
  @override
  _StatistikState createState() => _StatistikState();
}

class _StatistikState extends State<Statistik> {
  String selected ="status";
  List<Widget> status = [
    Center(
      child: Column(
        children: <Widget>[
          Container(
            height: 230,
            width: 230,
            color: Colors.blue,
          )
        ],
      )
    ),
    Container(height: 10,),
    ListTile(
      title: Text("Normal"),
      trailing: Text("77%"),
    ),
    ListTile(
      title: Text("Sound"),
      trailing: Text("77%"),
    ),
    ListTile(
      title: Text("Caries"),
      trailing: Text("77%"),
    ),
    ListTile(
      title: Text("Filled with Caries"),
      trailing: Text("77%"),
    ),
    ListTile(
      title: Text("Filled no Caries"),
      trailing: Text("77%"),
    ),
    ListTile(
      title: Text("Missing due to Caries"),
      trailing: Text("77%"),
    ),
    ListTile(
      title: Text("Missing for Another Reason"),
      trailing: Text("77%"),
    ),
    ListTile(
      title: Text("Fissure Sealant"),
      trailing: Text("77%"),
    ),
    ListTile(
      title: Text("Fix dental prosthesis / crown, abutment, veneer "),
      trailing: Text("77%"),
    ),
    ListTile(
      title: Text("Unerupted"),
      trailing: Text("77%"),
    ),
    ListTile(
      title: Text("Not recorded"),
      trailing: Text("77%"),
    ),
    ListTile(
      title: Text("Whitespot"),
      trailing: Text("77%"),
    ),
  ];

  List<Widget> ohis=[
    Center(
      child: Column(
        children: <Widget>[
          Container(
            height: 230,
            width: 230,
            color: Colors.blue,
          )
        ],
      )
    ),
    Container(height: 10,),
    ListTile(
      title: Text("Baik"),
      trailing: Text("77%"),
    ),
    ListTile(
      title: Text("Sedang"),
      trailing: Text("77%"),
    ),
    ListTile(
      title: Text("Buruk"),
      trailing: Text("77%"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(left:40,right:40),
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(height:73),
            Text(
              "Statistik",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold
              ),
            ),
            Container(height: 40,),
            Row(
              children: <Widget>[
                InkWell(
                  onTap: (){
                    setState(() {
                      selected="status";
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 165,
                        height: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/tabs/status-selected.png")
                          )
                        ),
                      ),
                      Container(
                        width: 165,
                        height: selected=="ohis"?40:0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/tabs/status.png")
                          )
                        ),
                      ),
                    ],
                  )
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      selected="ohis";
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 165,
                        height: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/tabs/ohis.png")
                          )
                        ),
                      ),
                      Container(
                        width: 165,
                        height: selected=="ohis"?40:0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/tabs/ohis-selected.png")
                          )
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
            Container(height: 36,),
            Column(
              children: selected=="status"?status:ohis,
            ),
          ],
        )
      ],
    );
  }
}