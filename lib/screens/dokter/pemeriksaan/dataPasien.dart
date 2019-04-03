import 'package:flutter/material.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';
import 'pemeriksaanAwal.dart';

class DataPasien extends StatelessWidget {
  Map<String,dynamic> data;

  DataPasien({
    @required this.data
  });

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
        body: Center(
          child: Column(
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
              new Container(
                width: 150,
                height: 150,
                decoration: new BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(150))
                ),
              ),
              Container(height: 31,),
              Text(
                "${data["pasien"]["nama"]}",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20
                ),
              ),
              Container(height: 20,),
              Text("${data["pasien"]["jenisKelamin"]=="l"?"Laki-laki":"Perempuan"}"),
              //Container(height: 20,),
              //Text("24 Tahun"),
              Container(height: 47,),
              ButtonGradient(
                height: 48,
                width: 100,
                text: "Lanjut",
                onTap: ()async{
                  Navigator.push(
                    context, 
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new PemeriksaanAwal(
                          data: data,
                        )
                      )
                  );
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}