import 'package:flutter/material.dart';

class ButtonCard extends StatelessWidget {
  final Widget child;
  final int width;
  final int height;
  final EdgeInsets padding;
  final int borderRadius;
  final VoidCallback onTap;
  ButtonCard(
    {
      @required this.child,
      this.width,
      this.height,
      this.padding,
      this.borderRadius,
      @required this.onTap
    }
  );
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: this.padding!=null ?this.padding: EdgeInsets.only(left: 25.0,),
        width: this.width!=null ? this.width:340,
        height: this.height!=null ? this.width:90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(this.borderRadius!=null ? this.borderRadius:10,),),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 0.3,
              color: Colors.blueGrey,
              blurRadius: 10.0,
              offset: Offset(
                0.0,
                2.0,
              ),
            )
          ],
        ),
        child: this.child
      )
    );
  }
}