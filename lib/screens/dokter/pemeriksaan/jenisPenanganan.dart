import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'uploadFoto.dart';

class JenisPenanganan extends StatefulWidget {
  Map<String,dynamic> data;

  JenisPenanganan({
    @required this.data
  });

  @override
  _JenisPenangananState createState(){
    return _JenisPenangananState();
  }
}

class _JenisPenangananState extends State<JenisPenanganan> {
  final lainnyaController = TextEditingController();
  String alert="";
  Map<String,bool> penanganan = {
    "dhe":false,
    "cpp":false,
    "protection":false,
    "fissureseal":false,
    "art":false,
    "ekstraksi":false,
    "lainnya":false
  };

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      if (widget.data["penanganan"]!=null){
        for (var i in widget.data["penanganan"]){
          penanganan[i]=true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child:WillPopScope(
        onWillPop: (){
          SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
          Navigator.of(context).pop();
        },
        child:Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              color: Colors.black,
              icon: Icon(Icons.arrow_back_ios),
              onPressed: (){
                SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                Navigator.of(context).pop();
              },
            ),
            centerTitle: true,
            title: Text("DENT-IS",style: TextStyle(color:Colors.black54),),
          ),
          body: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(height: 28,),
                  Text(
                    "Jenis Penanganan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  new CheckboxListTile(
                    onChanged: (bool value){
                      setState(() {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        penanganan["dhe"]=value;
                      });
                    },
                    value: penanganan["dhe"],
                    title: new Text('DHE'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  new CheckboxListTile(
                    onChanged: (bool value){
                      setState(() {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        penanganan["cpp"]=value;
                      });
                    },
                    value: penanganan["cpp"],
                    title: new Text('Aplikasi CPP ACP'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  new CheckboxListTile(
                    onChanged: (bool value){
                      setState(() {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        penanganan["protection"]=value;
                      });
                    },
                    value: penanganan["protection"],
                    title: new Text('Surface Protection'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  new CheckboxListTile(
                    onChanged: (bool value){
                      setState(() {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        penanganan["fissureseal"]=value;
                      });
                    },
                    value: penanganan["fissureseal"],
                    title: new Text('Fissure Sealant'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  new CheckboxListTile(
                    onChanged: (bool value){
                      setState(() {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        penanganan["art"]=value;
                      });
                    },
                    value: penanganan["art"],
                    title: new Text('Penambahan Art'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  new CheckboxListTile(
                    onChanged: (bool value){
                      setState(() {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        penanganan["ekstraksi"]=value;
                      });
                    },
                    value: penanganan["ekstraksi"],
                    title: new Text('Pencabutan / Ekstraksi'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  new CheckboxListTile(
                    onChanged: (bool value){
                      setState(() {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        penanganan["lainnya"]=value;
                        if (!value){
                          lainnyaController.text="";
                        }
                      });
                    },
                    value: penanganan["lainnya"],
                    title: new Text('Lainnya'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  Container(
                    height: 80,
                    width: 325,
                    child: new TextField(
                      controller: lainnyaController,
                      enabled: penanganan["lainnya"],
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: new BorderSide(color: Colors.blue)),
                        hintText: 'Co: rujukan rumah sakit',
                        labelText: 'Lainnya',
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    child: Text(
                      "$alert",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ButtonGradient(
                    height: 40,
                    width: 130,
                    text: "Lanjut",
                    onTap: (){
                      setState(() {
                        alert="";
                      });
                      bool pass = false;
                      for (var a in penanganan.keys){
                          if (penanganan[a]){
                            pass=true;
                          }
                        }
                      if (pass){
                        widget.data.addAll({"penanganan":<String>[]});
                        for (var a in penanganan.keys){
                          if (penanganan[a]){
                            widget.data["penanganan"].add(a);
                          }
                        }
                        Navigator.of(context).push(
                          new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            UploadFoto(data:widget.data)
                          )
                        );
                      }
                      else{
                        setState(() {
                          alert="Pilih salah satu penanganan";
                        });
                      }
                    },
                  ),
                  Container(height: 20,)
                ],
              )
            ],
          )
        )
      )
    );
  }
}