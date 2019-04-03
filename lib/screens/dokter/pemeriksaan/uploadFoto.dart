import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dent_is_admin/components/buttonGradient.dart';

class UploadFoto extends StatefulWidget {
  Map<String, dynamic> data;

  UploadFoto({
    @required this.data
  });

  @override
  _UploadFotoState createState() => _UploadFotoState();
}

class _UploadFotoState extends State<UploadFoto> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }
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
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(height: 28,),
              Text(
                "Foto",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40
                ),
              ),
              Container(
                height: 54,
              ),
              InkWell(
                onTap: (){
                  getImage();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 297,
                  height: 297,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2.0
                    )
                  ),
                  child: Stack(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: Colors.grey,
                          ),
                          Container(width:19),
                          Text("Tekan untuk\nmengunggah\ngambar")
                        ],
                      ),
                      _image!=null?Container(
                        width: 297,
                        height: 297,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(_image),
                            fit: BoxFit.contain
                          )
                        ),
                      ):Container()
                    ],
                  ),
                )
              ),
              Container(height:20),
              ButtonGradient(
                height: 48,
                width: 168,
                text: "Simpan dan Selesai",
                onTap: (){
                  print(widget.data);
                },
              ),
            ]
          )
        ]
      )
    );
  }
}