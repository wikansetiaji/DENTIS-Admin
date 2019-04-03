import 'package:flutter/material.dart';

class Gigi4 extends StatefulWidget {
  final String code;
  bool selected = false;
  final VoidCallback onTap;

  Gigi4({
    @required this.code,
    @required this.selected,
    @required this.onTap
  });

  @override
  _Gigi4State createState() => _Gigi4State();
}

class _Gigi4State extends State<Gigi4> {
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
                    image: AssetImage("assets/odontogram/gigi4kecil.png")
                  )
                ),
              ),
              Container(
                height: widget.selected?40:0,
                width: 40,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/odontogram/gigi4kecilselected.png")
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