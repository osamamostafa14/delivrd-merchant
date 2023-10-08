import 'package:delivrd_driver/provider/appointment_provider.dart';
import 'package:delivrd_driver/provider/bank_provider.dart';
import 'package:delivrd_driver/provider/financials_provider.dart';
import 'package:delivrd_driver/provider/location_provider.dart';
import 'package:delivrd_driver/provider/profile_provider.dart';
import 'package:delivrd_driver/provider/services_provider.dart';
import 'package:delivrd_driver/view/base/custom_snack_bar.dart';
import 'package:delivrd_driver/view/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'di_container.dart' as di;
import 'package:delivrd_driver/provider/splash_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:delivrd_driver/route/route.dart' as route;
import 'package:delivrd_driver/provider/home_provider.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  final applicationDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(applicationDocumentDir.path);
  await Hive.openBox('myBox');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<HomeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BankProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<FinancialsProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AppointmentProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ServicesProvider>()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {

  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  PermissionStatus? _status;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) => print(value));
    _route();
  }
  void _route() {
    Provider.of<SplashProvider>(context, listen: false).initConfig(_globalKey).then((bool isSuccess) {
      if (isSuccess) {
        print('is success');

      }else {
        print('is failed');
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<SplashProvider>(
      builder: (context, splashProvider, child){
        return (splashProvider.configModel == null) ? SizedBox() : MaterialApp(
          onGenerateRoute: route.controller,
          initialRoute: route.splashScreen,

          title: 'Delivrd',
          debugShowCheckedModeBanner: false,
          navigatorKey: MyApp.navigatorKey,
        );
      },
    );
  }
}
