import 'package:flutter/material.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'dataPasien.dart';
import 'package:flutter/services.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  Map<String,dynamic> data={};
  String jenisKelamin="l";
  TextEditingController namaController = TextEditingController();
  String alert = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void changedDropDownItem(String selected) {
    setState(() {
      jenisKelamin = selected;
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
        body: ListView(
          children: <Widget>[
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(height: 28,),
                  Text(
                    "Data Pasien",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40
                    ),
                  ),
                  Container(
                    height: 34,
                  ),
                  Container(
                    height: 60,
                    width: 325,
                    child: new TextField(
                      controller: namaController,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: new BorderSide(color: Colors.blue)),
                        hintText: 'Nama',
                        labelText: 'Nama',
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
                  Container(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.only(left:10),
                    alignment: Alignment.centerLeft,
                    width: 325,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: Colors.grey[600],

                      )
                    ),
                    child: new DropdownButton(
                      isExpanded: true,
                      value: jenisKelamin,
                      items: <DropdownMenuItem<String>>[
                        DropdownMenuItem(
                          value: "l",
                          child: Text("Laki-laki",style: TextStyle(color: Colors.grey[700]),),
                        ),
                        DropdownMenuItem(
                          value: "p",
                          child: Text("Perempuan",style: TextStyle(color: Colors.grey[700]),),
                        )
                      ],
                      onChanged: changedDropDownItem,
                    )
                  ),
                  Container(
                    height: 20,
                  ),
                  ButtonGradient(
                    height: 48,
                    width: 100,
                    text: "Lanjut",
                    onTap: ()async{
                      if(namaController.text==""){
                        setState(() {
                          alert = "Field harus terisi";
                        });
                      }
                      else{
                        setState(() {
                          alert = "";
                        });
                        data={"pasien":{"name":namaController.text,"jenisKelamin":jenisKelamin, "no_hp":"081229079453"}};
                        Navigator.push(
                          context, 
                          new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                new DataPasien(
                                  data: data,
                                )
                              )
                          );
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        )
      )
    );
  }
}