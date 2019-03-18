import 'package:flutter/material.dart';
import 'package:dent_is_admin/screens/loginScreen.dart';

class ButtonGradient extends StatelessWidget {
  double width;
  double height;
  String text;
  VoidCallback onTap;

  ButtonGradient(
    {
      @required this.width,
      @required this.height,
      @required this.text,
      @required this.onTap
    }
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      splashColor: Colors.grey,
      child: Container(
        width: this.width+8,
        height: this.height+8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: [
            BoxShadow(
              spreadRadius: -14,
              color: Colors.blueGrey,
              blurRadius: 10.0, // has the effect of softening the shadow
              offset: Offset(
                0.0,
                10.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: this.width,
              height: this.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                image: DecorationImage(fit: BoxFit.fill,image: AssetImage("assets/gradient-button.png"))
              ),
              alignment: Alignment.center,
            ),
            Container(
              width: this.width,
              height: this.height,
              alignment: Alignment.center,
              child: Text(this.text,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
      onTap: this.onTap
    );
  }
}