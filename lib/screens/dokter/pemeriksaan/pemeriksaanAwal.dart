import 'package:flutter/material.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'odontogram.dart';
import 'package:flutter/services.dart';
import 'util.dart';

class PemeriksaanAwal extends StatefulWidget {
  Map<String,dynamic> data;

  PemeriksaanAwal({
    @required this.data
  });

  @override
  _PemeriksaanAwalState createState() => _PemeriksaanAwalState();
}

class _PemeriksaanAwalState extends State<PemeriksaanAwal> {
  TextEditingController anamnesaController = TextEditingController();
  TextEditingController alergiController = TextEditingController();
  TextEditingController riwayatController = TextEditingController();
  TextEditingController tekananDarahController = TextEditingController();
  TextEditingController beratController = TextEditingController();
  TextEditingController tinggiController = TextEditingController();

  String alertAnamnesa="";
  String alertTekananDarah="";
  String alertBerat="";
  String alertTinggi="";

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      if(widget.data["rekamMedis"]!=null){
        anamnesaController.text =widget.data["rekamMedis"]["anamnesis"];
        alergiController.text = widget.data["rekamMedis"]["alergi"];
        riwayatController.text = widget.data["rekamMedis"]["riwayatPenyakit"];
        tekananDarahController.text = widget.data["rekamMedis"]["tekananDarah"];
        beratController.text = widget.data["rekamMedis"]["berat"];
        tinggiController.text = widget.data["rekamMedis"]["tinggi"];
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
      child:Scaffold(
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
        body: 
        ListView(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  Container(height: 28,),
                  Text(
                    "Pemeriksaan Awal",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40
                    ),
                  ),
                  Container(
                    height: 34,
                  ),
                  Container(
                    height: 80,
                    width: 325,
                    child: new TextField(
                      controller: anamnesaController,
                      maxLines: 5,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: new BorderSide(color: Colors.blue)),
                        hintText: 'Isi Anamnesis',
                        labelText: 'Anamnesis*',
                      ),
                    ),
                  ),
                  Container(
                    height: 44,
                  ),
                  Container(
                    height: 30,
                    child: Text(
                      "$alertAnamnesa",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  Container(
                    height: 80,
                    width: 325,
                    child: new TextField(
                      controller: alergiController,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: new BorderSide(color: Colors.blue)),
                        hintText: 'Alergi',
                        labelText: 'Alergi',
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    width: 325,
                    child: new TextField(
                      controller: riwayatController,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: new BorderSide(color: Colors.blue)),
                        hintText: 'Riwayat Penyakit',
                        labelText: 'Riwayat Penyakit',
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 325,
                    child: new TextField(
                      controller: tekananDarahController,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: new BorderSide(color: Colors.blue)),
                        hintText: 'Tekanan Darah',
                        labelText: 'Tekanan Darah',
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    child: Text(
                      "${alertTekananDarah}",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 325,
                    child: new TextField(
                      controller: beratController,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: new BorderSide(color: Colors.blue)),
                        hintText: 'Berat',
                        labelText: 'Berat',
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    child: Text(
                      "$alertBerat",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 325,
                    child: new TextField(
                      controller: tinggiController,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: new BorderSide(color: Colors.blue)),
                        hintText: 'Tinggi',
                        labelText: 'Tinggi',
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    child: Text(
                      "$alertTinggi",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ButtonGradient(
                    height: 48,
                    width: 100,
                    text: "Lanjut",
                    onTap: ()async{
                      bool post=true;
                      setState(() {
                        alertAnamnesa="";
                        alertBerat="";
                        alertTekananDarah="";
                        alertTinggi="";
                      });

                      if (anamnesaController.text==""){
                        setState(() {
                          alertAnamnesa="Field harus diisi";
                        });
                        post=false;
                      }
                      if (double.tryParse(tekananDarahController.text) == null &&tekananDarahController.text!=""){
                        setState(() {
                          alertTekananDarah="Format tekanan darah salah";
                          post=false;
                        });
                      }
                      if (double.tryParse(beratController.text) == null &&beratController.text!=""){
                        setState(() {
                          alertBerat="Format berat salah";
                          post=false;
                        });
                        
                      }
                      if (double.tryParse(tinggiController.text) == null &&tinggiController.text!=""){
                        setState(() {
                          alertTinggi="Format tinggi salah";
                          post=false;
                        });
                      }
                      if (post){
                        widget.data.addAll({
                          "rekamMedis":{
                            "anamnesa":anamnesaController.text,
                            "alergi":alergiController.text,
                            "riwayatPenyakit":riwayatController.text,
                            "tekananDarah":tekananDarahController.text,
                            "berat":beratController.text,
                            "tinggi":tinggiController.text
                          }
                        });
                        if (widget.data["odontogram"]==null){
                          widget.data.addAll({"odontogram":Util.initGigiCondition()});
                        }
                        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                        Navigator.push(
                          context, 
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                              new Odontogram(
                                data: widget.data,
                              )
                            )
                        );
                      }
                    },
                  ),
                  Container(height: 20,)
                ]
              )
            )
          ],
        )
      )
    );
  }
}