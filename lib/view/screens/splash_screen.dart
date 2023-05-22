import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/bank_provider.dart';
import 'package:delivrd_driver/provider/home_provider.dart';
import 'package:delivrd_driver/provider/location_provider.dart';
import 'package:delivrd_driver/provider/profile_provider.dart';
import 'package:delivrd_driver/provider/splash_provider.dart';
import 'package:delivrd_driver/view/screens/auth/login_screen.dart';
import 'package:delivrd_driver/view/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult>? _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool _firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? SizedBox() : _globalKey.currentState!.hideCurrentSnackBar();
        _globalKey.currentState!.showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'No connection' : 'Connected',
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    _route();
    _checkPermission();
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged!.cancel();
  }

  void _checkPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permission is not Allowed by the user');
      }
    } else {

    }
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false).initConfig(_globalKey).then((bool isSuccess) {
      if (isSuccess) {
        Timer(Duration(seconds: 2), () async {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();
            if(Provider.of<AuthProvider>(context, listen: false).getUserToken()!=''){
              String token = Provider.of<AuthProvider>(context, listen: false).getUserToken();
              print('token -- ${token}');
              print('user token -- ${Provider.of<AuthProvider>(context, listen: false).getUserToken()}');
              if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                Provider.of<HomeProvider>(context, listen: false).getRunningOrderList(context, '1', token);
                Provider.of<HomeProvider>(context, listen: false).getAcceptedOrderList(context, '1', token);
                Provider.of<HomeProvider>(context, listen: false).getHistoryOrderList(context, '1', token);
                Provider.of<BankProvider>(context, listen: false).getAccounts(context, Provider.of<AuthProvider>(context, listen: false).getUserToken());
              }
            }

            Provider.of<AuthProvider>(context, listen: false).updateToken();
            Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context, _callback);

          } else {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> LoginScreen()));
          }
        }
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _globalKey,
      backgroundColor: Colors.red,
      body: Center(
        child: Consumer<SplashProvider>(builder: (context, splash, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/image/main_logo.png', height: 150, color: Colors.white),
              // Padding(
              //   padding: EdgeInsets.only(right: 12),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //
              //     ],
              //   ),
              // ),

            ],
          );
        }),
      ),
    );
  }
  void _callback(
      bool isSuccess) async {
    if(isSuccess){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen(pageIndex: 0)));
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error occured, try again later'),
          )
      );
    }
  }
}
