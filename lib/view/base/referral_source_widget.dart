import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReferralSourceWidget extends StatelessWidget {
  final String text;

  ReferralSourceWidget({this.text = ''});

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () {
        Provider.of<AuthProvider>(context, listen: false).setReferralSource(text);
        Navigator.pop(context);
        FocusScope.of(context).unfocus();
      },
      child: Row(
        children: [
          Text(text, style: TextStyle(
              color: Colors.black54,
              fontSize: 15
          )),
        ],
      ),
    );
  }
}
