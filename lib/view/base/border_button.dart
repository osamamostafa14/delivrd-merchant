import 'package:flutter/material.dart';

class BorderButton extends StatelessWidget {
  final VoidCallback ? onTap;
  final String? btnTxt;
  final Color? borderColor;
  final Color? textColor;
  final double? height;
  final double? width;
  final double? fontSize;
  BorderButton({this.onTap, @required this.btnTxt, this.borderColor, this.textColor,
    this.height, this.width, this.fontSize});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height==null? 40 : height,
        width: width==null? 80 : width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: borderColor!),
        ),
        child: Center(
          child: Text(btnTxt!,
              style: TextStyle(fontSize:fontSize==null? 15 : fontSize,
                color: textColor,
                //fontWeight: FontWeight.bold
              )),
        ),
      ),
    );
  }
}
