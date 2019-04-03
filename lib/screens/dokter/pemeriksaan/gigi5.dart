import 'package:flutter/material.dart';

class Gigi5 extends StatefulWidget {
  final String code;
  bool selected = false;
  final VoidCallback onTap;

  Gigi5({
    @required this.code,
    @required this.selected,
    @required this.onTap
  });

  @override
  _Gigi5State createState() => _Gigi5State();
}

class _Gigi5State extends State<Gigi5> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(widget.code),
          Stack(
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/odontogram/gigi5kecil.png")
                  )
                ),
              ),
              Container(
                height: widget.selected?40:0,
                width: 40,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/odontogram/gigi5kecilselected.png")
                  )
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}