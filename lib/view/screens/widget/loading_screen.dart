import 'package:delivrd_driver/provider/home_provider.dart';
import 'package:delivrd_driver/view/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  late final bool status;
  final String? token;
  LoadingScreen({required this.status, @required this.token});



  @override
  Widget build(BuildContext context) {

    void _statusCallback(
        bool isSuccess, String message, int status) async {
      if(isSuccess){
     //   Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen(pageIndex: 0)));
        // showDialog(
        //     context: context,
        //     builder: (_) => AlertDialog(
        //       title: Text(message),
        //     )
        // );

        // Provider.of<HomeProvider>(context, listen: false).setStatus(status);
        // setState(() {
        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen(pageIndex: 0)));
        //   _statusFix = status;
        // });


      } else {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Error occured, try again later'),
            )
        );
      }
      //setState(() async {});
    }

    return Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {

          homeProvider.updateStatus(
              context,
              status? 1 : 0,
              token!,
              _statusCallback);
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.redAccent))
            )
          );

        });
  }
}