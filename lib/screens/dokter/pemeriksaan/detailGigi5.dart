import 'package:flutter/material.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';

class DetailGigi5 extends StatefulWidget {
  String code;
  Map<String, int> conditions;

  DetailGigi5({
    @required this.code,
    @required this.conditions
  });

  @override
  _DetailGigi5State createState() => _DetailGigi5State();
}

class _DetailGigi5State extends State<DetailGigi5> {
  bool d = false;
  bool l = false;
  bool m = false;
  bool o = true;
  bool v = false;

  String selected = "o";

  Map<String,int> values;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    values =  widget.conditions.length!=0?widget.conditions:{"d":-1,"l":-1,"m":-1,"o":-1,"v":-1};
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context, widget.conditions);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              Navigator.pop(context, widget.conditions);
            },
          ),
          centerTitle: true,
          title: Text("DENT-IS",style: TextStyle(color:Colors.black54),),
        ),
        body: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(height:6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.code,style: TextStyle(fontSize: 40,fontWeight: FontWeight.w900),),
                        Stack(
                          children: <Widget>[
                            //image
                            Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/detailGigi/gigi5/bg.png")
                                )
                              ),
                            ),
                            Container(
                              height: v?200:0,
                              width: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/detailGigi/gigi5/v.png")
                                )
                              ),
                            ),
                            Container(
                              height: m?200:0,
                              width: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/detailGigi/gigi5/m.png")
                                )
                              ),
                            ),
                            Container(
                              height: o?200:0,
                              width: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/detailGigi/gigi5/o.png")
                                )
                              ),
                            ),
                            Container(
                              height: l?200:0,
                              width: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/detailGigi/gigi5/l.png")
                                )
                              ),
                            ),
                            Container(
                              height: d?200:0,
                              width: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/detailGigi/gigi5/d.png")
                                )
                              ),
                            ),
                            
                            //angka
                            Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: 200,
                                  child: Text(
                                    "${values["v"]!=-1?values["v"]:""}",
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900
                                    ),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      height: 100,
                                      width: 50,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${values["d"]!=-1?values["d"]:""}",
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w900
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 100,
                                      width: 100,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${values["o"]!=-1?values["o"]:""}",
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w900
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 100,
                                      width: 50,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${values["m"]!=-1?values["m"]:""}",
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w900
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: 200,
                                  child: Text(
                                    "${values["l"]!=-1?values["l"]:""}",
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            //tombol
                            Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      v=true;
                                      l=false;
                                      m=false;
                                      o=false;
                                      d=false;
                                      selected="v";
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 200,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          v=false;
                                          l=false;
                                          m=false;
                                          o=false;
                                          d=true;
                                          selected="d";
                                        });
                                      },
                                      child: Container(
                                        height: 100,
                                        width: 50,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          v=false;
                                          l=false;
                                          m=false;
                                          o=true;
                                          d=false;
                                          selected="o";
                                        });
                                      },
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          v=false;
                                          l=false;
                                          m=true;
                                          o=false;
                                          d=false;
                                          selected="m";
                                        });
                                      },
                                      child: Container(
                                        height: 100,
                                        width: 50,
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      v=false;
                                      l=true;
                                      m=false;
                                      o=false;
                                      d=false;
                                      selected="l";
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 200,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(width: 30,),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //Text(
                          //  "Status",
                          //  textAlign: TextAlign.start,
                          //  style: TextStyle(
                          //    fontSize: 20,
                          //    fontWeight: FontWeight.w900
                          //  ),
                          //),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 0,
                                          groupValue: values[selected],
                                          onChanged: (int value){
                                            setState(() {
                                              values[selected]=value;
                                            });
                                          },
                                        ),
                                        InkWell(
                                          child: Text("0 = Sound"),
                                          onTap: (){
                                            setState(() {
                                              values[selected]=0;
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: values[selected],
                                          onChanged: (int value){
                                            setState(() {
                                              values[selected]=value;
                                            });
                                          },
                                        ),
                                        InkWell(
                                          child: Text("1 = Caries"),
                                          onTap: (){
                                            setState(() {
                                              values[selected]=1;
                                            });
                                          },
                                        )
                                        
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 2,
                                          groupValue: values[selected],
                                          onChanged: (int value){
                                            setState(() {
                                              values[selected]=value;
                                            });
                                          },
                                        ),
                                        InkWell(
                                          child: Text("2 = Filled with caries"),
                                          onTap: (){
                                            setState(() {
                                              values[selected]=2;
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 3,
                                          groupValue: values[selected],
                                          onChanged: (int value){
                                            setState(() {
                                              values[selected]=value;
                                            });
                                          },
                                        ),
                                        InkWell(
                                          child: Text("3 = Filled no caries"),
                                          onTap: (){
                                            setState(() {
                                              values[selected]=3;
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 4,
                                          groupValue: values[selected],
                                          onChanged: (int value){
                                            setState(() {
                                              values[selected]=value;
                                            });
                                          },
                                        ),
                                        InkWell(
                                          child: Text("4 = Missing due caries"),
                                          onTap: (){
                                            setState(() {
                                              values[selected]=4;
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 5,
                                          groupValue: values[selected],
                                          onChanged: (int value){
                                            setState(() {
                                              values[selected]=value;
                                            });
                                          },
                                        ),
                                        InkWell(
                                          child: Text("5 = Missing for another\nreason"),
                                          onTap: (){
                                            setState(() {
                                              values[selected]=5;
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 6,
                                          groupValue: values[selected],
                                          onChanged: (int value){
                                            setState(() {
                                              values[selected]=value;
                                            });
                                          },
                                        ),
                                        InkWell(
                                          child: Text("6 = Fissure sealant"),
                                          onTap: (){
                                            setState(() {
                                              values[selected]=6;
                                            });
                                          },
                                        )
                                        
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 7,
                                          groupValue: values[selected],
                                          onChanged: (int value){
                                            setState(() {
                                              values[selected]=value;
                                            });
                                          },
                                        ),
                                        InkWell(
                                          child: Text("7 = Fix dental\nprosthesis / crown,\nabutment, veneer"),
                                          onTap: (){
                                            setState(() {
                                              values[selected]=7;
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 8,
                                          groupValue: values[selected],
                                          onChanged: (int value){
                                            setState(() {
                                              values[selected]=value;
                                            });
                                          },
                                        ),
                                        InkWell(
                                          child: Text("8 = Unerupted"),
                                          onTap: (){
                                            setState(() {
                                              values[selected]=8;
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 9,
                                          groupValue: values[selected],
                                          onChanged: (int value){
                                            setState(() {
                                              values[selected]=value;
                                            });
                                          },
                                        ),
                                        InkWell(
                                          child: Text("9 = Not Recorded"),
                                          onTap: (){
                                            setState(() {
                                              values[selected]=9;
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 10,
                                          groupValue: values[selected],
                                          onChanged: (int value){
                                            setState(() {
                                              values[selected]=value;
                                            });
                                          },
                                        ),
                                        InkWell(
                                          child: Text("10 = Whitespot"),
                                          onTap: (){
                                            setState(() {
                                              values[selected]=10;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(width: 10,),
                                        ButtonGradient(
                                          height: 40,
                                          width: 130,
                                          onTap: (){
                                            Navigator.pop(context, values);
                                          },
                                          text: "Simpan",
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}