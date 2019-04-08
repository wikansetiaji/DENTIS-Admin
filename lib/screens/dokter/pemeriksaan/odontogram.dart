import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gigi5.dart';
import 'gigi4.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'util.dart';
import 'detailGigi5.dart';
import 'detailGigi4.dart';
import 'jenisPenanganan.dart';

class Odontogram extends StatefulWidget {
  Map<String,dynamic> data;

  Odontogram({
    @required this.data
  });

  @override
  _OdontogramState createState() => _OdontogramState();
}

class _OdontogramState extends State<Odontogram> {
  Map<String, Widget>gigi={};
  Map<String,dynamic> ohisData;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.data["odontogram"]);
    ohisData = widget.data["ohis"]==null?{"11":{"kode":"11","ci":0,"di":0},"16":{"kode":"16","ci":0,"di":0},"21":{"kode":"21","ci":0,"di":0},"31":{"kode":"31","ci":0,"di":0},"36":{"kode":"36","ci":0,"di":0},"46":{"kode":"46","ci":0,"di":0}}:widget.data["ohis"];
  }

  openDetail(String code) async{
    List<String> ohis=["11","16","21","31","36","46"];
    if (int.parse(code.substring(1))<4){
      if (ohis.contains(code)){
        Map<String,dynamic> res = await Navigator.push(
          context, 
          new MaterialPageRoute(
              builder: (BuildContext context) =>
                new DetailGigi4(ohisData:ohisData,ohis:true, code:code, conditions: widget.data["odontogram"][code],)
              )
          );
        widget.data["odontogram"][code] = res["condition"];
        ohisData.addAll({code:res["ohis"]});
      }
      else{
        widget.data["odontogram"][code] = await Navigator.push(
          context, 
          new MaterialPageRoute(
              builder: (BuildContext context) =>
                new DetailGigi4(ohis:false, code:code, conditions: widget.data["odontogram"][code],)
              )
          );
      }
    }
    else{
      if (ohis.contains(code)){
        Map<String,dynamic> res = await Navigator.push(
          context, 
          new MaterialPageRoute(
              builder: (BuildContext context) =>
                new DetailGigi5(ohisData:ohisData,ohis:true, code:code, conditions: widget.data["odontogram"][code],)
              )
          );
        widget.data["odontogram"][code] = res["condition"];
        print(widget.data["odontogram"]);
        ohisData.addAll({code:res["ohis"]});        
      }
      else{
        widget.data["odontogram"][code] = await Navigator.push(
          context, 
          new MaterialPageRoute(
              builder: (BuildContext context) =>
                new DetailGigi5(ohis:false, code:code, conditions: widget.data["odontogram"][code],)
              )
          );
      }
    }
    setState(() {
      resetGigiDisplay();
    });
  }

  resetGigiDisplay(){
    gigi={};
    List<String> ohis=["11","16","21","31","36","46"];
    for (var code in widget.data["odontogram"].keys){
      if (int.parse(code.substring(1))<4){
        int sum = 0;
        for(var i in widget.data["odontogram"][code].values){
          sum+=i;
        }
        if (sum==-4){
          if (ohis.contains(code)){
            gigi.addAll({code:Gigi4(ohis:true, code:code, onTap: (){openDetail(code);}, selected: false,)});
          }
          else{
            gigi.addAll({code:Gigi4(ohis:false, code:code, onTap: (){openDetail(code);}, selected: false,)});
          }
        }
        else{
          if (ohis.contains(code)){
            gigi.addAll({code:Gigi4(ohis:true, code:code, onTap: (){openDetail(code);}, selected: true,)});
          }
          else{
            gigi.addAll({code:Gigi4(ohis:false, code:code, onTap: (){openDetail(code);}, selected: true,)});
          }
        }
      }
      else{
        int sum = 0;
        for(var i in widget.data["odontogram"][code].values){
          sum+=i;
        }
        if (sum==-5){
          if (ohis.contains(code)){
            gigi.addAll({code:Gigi5(ohis:true,code:code, onTap:(){openDetail(code);}, selected: false,)});
          }
          else{
            gigi.addAll({code:Gigi5(ohis:false,code:code, onTap:(){openDetail(code);}, selected: false,)});
          }
        }
        else{
          if (ohis.contains(code)){
            gigi.addAll({code:Gigi5(ohis:true,code:code, onTap: (){openDetail(code);}, selected: true,)});
          }
          else{
            gigi.addAll({code:Gigi5(ohis:false,code:code, onTap: (){openDetail(code);}, selected: true,)});
          }
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    resetGigiDisplay();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop(widget.data);
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
              Navigator.of(context).pop(widget.data);
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
                Container(height:12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        gigi["18"],
                        gigi["17"],
                        gigi["16"],
                        gigi["15"],
                        gigi["14"],
                        gigi["13"],
                        gigi["12"],
                        gigi["11"],
                      ]
                    ),
                    Container(width: 12,),
                    Row(
                      children: <Widget>[
                        gigi["21"],
                        gigi["22"],
                        gigi["23"],
                        gigi["24"],
                        gigi["25"],
                        gigi["26"],
                        gigi["27"],
                        gigi["28"],
                      ]
                    ),
                  ],
                ),
                Container(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        gigi["55"],
                        gigi["54"],
                        gigi["53"],
                        gigi["52"],
                        gigi["51"],
                      ]
                    ),
                    Container(width: 12,),
                    Row(
                      children: <Widget>[
                        gigi["61"],
                        gigi["62"],
                        gigi["63"],
                        gigi["64"],
                        gigi["65"],
                      ]
                    ),
                  ],
                ),
                Container(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        gigi["85"],
                        gigi["84"],
                        gigi["83"],
                        gigi["82"],
                        gigi["81"],
                      ]
                    ),
                    Container(width: 12,),
                    Row(
                      children: <Widget>[
                        gigi["71"],
                        gigi["72"],
                        gigi["73"],
                        gigi["74"],
                        gigi["75"],
                      ]
                    ),
                  ],
                ),
                Container(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        gigi["48"],
                        gigi["47"],
                        gigi["46"],
                        gigi["45"],
                        gigi["44"],
                        gigi["43"],
                        gigi["42"],
                        gigi["41"],
                      ]
                    ),
                    Container(width: 12,),
                    Row(
                      children: <Widget>[
                        gigi["31"],
                        gigi["32"],
                        gigi["33"],
                        gigi["34"],
                        gigi["35"],
                        gigi["36"],
                        gigi["37"],
                        gigi["38"],
                      ]
                    ),
                  ],
                ),
                Container(height: 6,),
                ButtonGradient(
                  height: 40,
                  width: 130,
                  text: "Lanjut",
                  onTap: (){
                    widget.data.addAll({"ohis":ohisData});
                    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                    Navigator.of(context).push(
                      new MaterialPageRoute(
                        builder: (BuildContext context) =>
                          new JenisPenanganan(data: widget.data,)
                        )
                    );
                  },
                )
              ],
            )
          ],
        ),
      )
    );
  }
}