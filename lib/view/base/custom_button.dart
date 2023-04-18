import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback?  onTap;
  final String? btnTxt;
  final bool isShowBorder;

  CustomButton({this.onTap, @required this.btnTxt, this.isShowBorder = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: !isShowBorder ? Colors.grey.withOpacity(0.2) : Colors.transparent, spreadRadius: 1, blurRadius: 7, offset: Offset(0, 1))
          ],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isShowBorder ? Colors.black12 : Colors.transparent),
          color: !isShowBorder ? Colors.redAccent : Colors.transparent),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
        child: Text(btnTxt ?? "",
            style: Theme.of(context).textTheme.headline3!.copyWith(
                color: isShowBorder ? Colors.white70 : Colors.white, fontSize: Dimensions.FONT_SIZE_LARGE)),
      ),
    );
  }
}
