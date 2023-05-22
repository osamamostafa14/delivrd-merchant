import 'dart:convert';
import 'package:delivrd_driver/data/model/appointment_model.dart';
import 'package:delivrd_driver/data/model/orders_model.dart';
import 'package:delivrd_driver/data/model/signup_model.dart';
import 'package:delivrd_driver/helper/location_helper.dart';
import 'package:delivrd_driver/provider/appointment_provider.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/home_provider.dart';
import 'package:delivrd_driver/provider/location_provider.dart';
import 'package:delivrd_driver/provider/profile_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/utill/images.dart';
import 'package:delivrd_driver/view/base/border_button.dart';
import 'package:delivrd_driver/view/base/custom_button.dart';
import 'package:delivrd_driver/view/screens/appointment/calendar_screen.dart';
import 'package:delivrd_driver/view/screens/appointment/service_duration_screen.dart';
import 'package:delivrd_driver/view/screens/order/order_details_screen.dart';
import 'package:delivrd_driver/view/screens/widget/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  List<Order>? ordersList = [];
  ScrollController scrollController = new ScrollController();
  double _scroll = 0.0;
  bool _loading = false;
  bool _loadingBottom = false;
  bool start = true;
  int? _statusFix;
  SignUpModel? _driverInfoModel;
  String? token;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String token = Provider.of<AuthProvider>(context, listen: false).getUserToken();

      context.read<ProfileProvider>().getUserInfo(context, _callbackUserInfo);
      Provider.of<HomeProvider>(context, listen: false).getRunningOrderList(
          context,
          '1',
          Provider.of<AuthProvider>(context, listen: false).getUserToken());
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context, _callbackUserInfo);

      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context, _callbackUserInfo);
      _driverInfoModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
      Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();
      Provider.of<HomeProvider>(context, listen: false).getRunningOrderList(context, '1', token);

    });
  }

  Future? _scrollPosition (){
    int offset = 1;
    scrollController.addListener(() {
      _scroll = scrollController.position.pixels;
      // if(_scroll < -25.0){
      //
      //   int pageSize;
      //   pageSize = (Provider.of<HomeProvider>(context, listen: false).pageSize !/ 10).ceil();
      //
      //   print('true 1');
      //   print(start);
      //   if (offset < pageSize && Provider.of<HomeProvider>(context, listen: false).runningOrderList != null
      // && !Provider.of<HomeProvider>(context, listen: false).orderIsLoading && start == true) {
      //     start == false;
      //     setState(() {
      //     });
      //     print('true 2');
      //     print(start);
      //     offset++;
      //     Provider.of<HomeProvider>(context, listen: false).clearOffset();
      //     Provider.of<HomeProvider>(context, listen: false).
      //     getRunningLatest(
      //         context,
      //         Provider.of<AuthProvider>(context, listen: false).getUserToken());
      //   }
      //   // _loading = true;
      //   setState(() {});
      //   // print(_loading);
      //   Future.delayed(Duration(seconds: 3), () async {
      //   //  _loading = false;
      //     start == true;
      //     print('true 3');
      //     print(start);
      //     setState(() {});
      //     print('Scroll false /////////////////');
      //     print(_loading);
      //   });
      // }
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        print('at end /////////////////');
        int pageSize;
        pageSize = (Provider.of<HomeProvider>(context, listen: false).pageSize !/ 10).ceil();

        if (offset < pageSize && Provider.of<HomeProvider>(context, listen: false).runningOrderList != null
            && !Provider.of<HomeProvider>(context, listen: false).orderIsLoading) {
          offset++;
          // Provider.of<HomeProvider>(context, listen: false).clearOffset();
          Provider.of<HomeProvider>(context, listen: false).
          getRunningOrderList(
              context,
              offset.toString(),
              Provider.of<AuthProvider>(context, listen: false).getUserToken());
        }
        _loadingBottom = true;
        setState(() {});

        Future.delayed(Duration(seconds: 2), () async {
          _loadingBottom = false;
          setState(() {});

        });
      }

    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _scrollPosition();

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0.0,
          leadingWidth: 45,
          actions: <Widget>[


            GestureDetector(
                onTap: (){
                  Provider.of<HomeProvider>(context, listen: false).
                  getRunningLatest(
                      context,
                      Provider.of<AuthProvider>(context, listen: false).getUserToken());
                  // _loading = true;
                  setState(() {});
                },
                child: Icon(Icons.refresh, color: Colors.red, size: 30)),
            const SizedBox(width: 20)

          ],
          leading: Padding(padding: const EdgeInsets.only(left: 10),
            child:
            Image.asset('assets/image/logo_home.png'),
          ),
          title: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text('Requests', style: TextStyle(
                    color: Colors.black54,
                    fontSize: 17
                )),
              )
          ),

        ),
        body: Consumer<HomeProvider>(
          builder: (context, homeProvider, child) {
            ordersList = homeProvider.runningOrderList;
            double latitude = Provider.of<LocationProvider>(context, listen: false).currentLatitude;
            double longitude = Provider.of<LocationProvider>(context, listen: false).currentLongitude;
            _driverInfoModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;

            return
              _driverInfoModel!.status == 1?
              ordersList!=null?
              Column(
                children: [
                  SwitchListTile(
                    value: homeProvider.online == 3 ? _driverInfoModel!.online == 1? true : false
                        : homeProvider.online == 1? true: false,
                    onChanged: (bool isActive) async {
                      String _token = Provider.of<AuthProvider>(context, listen: false).getUserToken();
                      Navigator.push(context, MaterialPageRoute(builder:
                          (BuildContext context)=> LoadingScreen(status: isActive,token: _token)));

                    },
                    title: Text(
                        homeProvider.online == 3 ? _driverInfoModel!.online == 1? 'You are active': 'Your are offline'
                            : homeProvider.online == 1? 'You are active': 'Your are offline',
                        style: TextStyle(color:
                        homeProvider.online == 3 ? _driverInfoModel!.online == 1? Colors.green: Colors.black54
                            : homeProvider.online == 1? Colors.green: Colors.black54)),
                    //activeColor: Theme.of(context).primaryColor,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  //if(homeProvider.online == 1 || _driverInfoModel!.online == 1 || _statusFix == 1)

                  homeProvider.online == 3 ? _driverInfoModel!.online == 1?
                  Expanded(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: SizedBox(
                            width: 1170,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [

                                homeProvider.runningIsLoading ?
                                Center(
                                    child: CircularProgressIndicator(
                                        valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.redAccent))
                                ):ordersList!.length > 0 ?
                                ListView.builder(
                                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                  itemCount: ordersList!.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    Map<String,dynamic>? userLocation = jsonDecode(ordersList![index].userLocation);
                                    double _userLat = userLocation!['latitude']!=null? userLocation!['latitude']: 0.0;
                                    double _userLong = userLocation['longitude']!=null? userLocation!['latitude']: 0.0;
                                    double _distance = LocationHelper.calculateDistance(
                                        latitude,
                                        longitude,
                                        _userLat,
                                        _userLong);

                                    return
                                      GestureDetector(
                                        onTap: ()async{
                                          //  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> RiderOrderDetails(orderModel: ordersList[index])));
                                        },
                                        child: Card(
                                          child: Column(

                                            children: [
                                              Padding(padding: EdgeInsets.all(6),
                                                child: Row(

                                                    children: [
                                                      Text('Order Id'),
                                                      Text('#${ordersList![index].id}',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: Colors.black54,
                                                            fontWeight: FontWeight.bold,
                                                          )),
                                                      Flexible(
                                                        flex: 1,
                                                        child: Center(child: Text('${ordersList![index].customer!.fullName}',
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold,
                                                            ))),
                                                      ),
                                                      Flexible(
                                                        child: new Container(
                                                          padding: new EdgeInsets.only(right: 13.0),
                                                          child: new Text('${_distance.toStringAsFixed(2)}  Miles Away',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.black54,
                                                                fontWeight: FontWeight.bold,
                                                              )),
                                                        ),
                                                      ),

                                                    ]),
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                              ),
                                              Padding(padding: EdgeInsets.all(6),
                                                child: Row(

                                                    children: [
                                                      Text('Location: ',style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.normal,
                                                      )),
                                                      Flexible(
                                                        child: new Container(
                                                          padding: new EdgeInsets.only(right: 13.0),
                                                          child: new Text('${userLocation['adminisrative_area']!= null? userLocation['adminisrative_area']:''} ${userLocation['locality']!= null? userLocation['locality']: ''}',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                              )),
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                              ),
                                              /// Service Info

                                              Padding(padding: EdgeInsets.all(6),
                                                child: Row(

                                                    children: [
                                                      Text('Service: ',style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.normal,
                                                      )),
                                                      Flexible(
                                                        child: new Container(
                                                          padding: new EdgeInsets.only(right: 13.0),
                                                          child: new Text('${ordersList![index].serviceName}',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                              )),
                                                        ),
                                                      ),

                                                      Flexible(
                                                        child: new Container(
                                                          padding: new EdgeInsets.only(right: 13.0),
                                                          child: new Text('${ordersList![index].totalPrice} \$',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                              )),
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                              ),
                                              Padding(padding: EdgeInsets.all(6),
                                                child: Row(
                                                    children: [
                                                      Flexible(child: Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () => launch('tel:${ordersList![index].customer!.phone}'),
                                                            child: Container(
                                                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent),
                                                              child: Icon(Icons.call_outlined, color: Colors.white),
                                                            ),
                                                          ),
                                                          SizedBox(width: 8),
                                                          InkWell(
                                                            onTap: () {
                                                              Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((position) {
                                                                MapUtils.openMap(
                                                                    userLocation['latitude'] ?? 23.8103,
                                                                    userLocation['longitude'] ?? 90.4125,
                                                                    position.latitude,
                                                                    position.longitude);
                                                              });
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent),
                                                              child: Icon(Icons.location_on_outlined, color: Colors.white),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                      Container(
                                                        height: 40.0,
                                                        child: BorderButton(
                                                          btnTxt: 'Details',
                                                          textColor: Colors.red,
                                                          borderColor: Colors.red,
                                                          onTap: (){
                                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> OrderDetailsScreen(order: ordersList![index])));
                                                          },
                                                        ),

                                                      ),
                                                      SizedBox(width: 10),
                                                      if(homeProvider.finishedList.contains(ordersList![index].id))
                                                        Padding(padding: EdgeInsets.all(6),
                                                          child: Row(
                                                              children: [

                                                                Container(
                                                                    height: 40.0,
                                                                    child: Row(children: [
                                                                      Text('Finished', style: TextStyle(color: Colors.green)),
                                                                      Icon(Icons.check, color: Colors.green),
                                                                    ])
                                                                )
                                                              ]),
                                                        )
                                                      else if(homeProvider.cancelledList.contains(ordersList![index].id))
                                                        Padding(padding: EdgeInsets.all(6),
                                                          child: Row(
                                                              children: [

                                                                Container(
                                                                    height: 40.0,
                                                                    child: Row(children: [
                                                                      Text('Cancelled', style: TextStyle(color: Colors.redAccent)),
                                                                      //   Icon(Icons.check, color: Colors.green),
                                                                    ])
                                                                )
                                                              ]),
                                                        )

                                                      else if(homeProvider.acceptedList.contains(ordersList![index].id))
                                                          Padding(padding: EdgeInsets.all(6),
                                                            child: Row(
                                                                children: [

                                                                  Container(
                                                                      height: 40.0,
                                                                      child: Row(children: [
                                                                        Text('Accepted', style: TextStyle(color: Colors.green)),
                                                                        Icon(Icons.check, color: Colors.green),
                                                                      ])
                                                                  )
                                                                ]),
                                                          )

                                                        else
                                                          Container(
                                                            height: 40.0,
                                                            child: BorderButton(
                                                              btnTxt: 'Accept',
                                                              textColor: Colors.red,
                                                              borderColor: Colors.red,
                                                              onTap: (){
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (_) => AlertDialog(
                                                                      title: const Text('Accept order?'),

                                                                      actions: [
                                                                        BorderButton(
                                                                          btnTxt: 'No',
                                                                          textColor: Colors.grey,
                                                                          borderColor: Colors.grey,
                                                                          onTap: (){
                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                        BorderButton(
                                                                          btnTxt: 'Yes',
                                                                          textColor: Colors.red,
                                                                          borderColor: Colors.red,
                                                                          onTap: () async {
                                                                            Navigator.pop(context);
                                                                            if(ordersList![index].appointment != null){
                                                                              DateTime _appointmentDate = DateTime.parse(ordersList![index].appointment!.appointmentDate!);
                                                                              Provider.of<AppointmentProvider>(context, listen: false).setDayAndMonth(
                                                                                  _appointmentDate.weekday,
                                                                                  _appointmentDate.day,
                                                                                  _appointmentDate.month,
                                                                                  _appointmentDate.year);

                                                                              String token = Provider.of<AuthProvider>(context, listen: false).getUserToken();
                                                                              Provider.of<AppointmentProvider>(context, listen: false).getDayAppointments(
                                                                                  context,
                                                                                  _appointmentDate,
                                                                                  token
                                                                              );
                                                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> ServiceDurationScreen(
                                                                                appointmentId: ordersList![index].appointment!.id,
                                                                                order: ordersList![index],
                                                                              )));
                                                                            }else{
                                                                              homeProvider.acceptRejectOrder(context,ordersList![index], 'accepted', ordersList![index].id.toString(),'no_date', _callback);
                                                                            }
                                                                          },
                                                                        ),

                                                                      ],
                                                                    )
                                                                );
                                                              },
                                                            ),

                                                          )
                                                    ]),
                                              ),

                                              // Padding(padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
                                              // child: Row(
                                              //   children: [
                                              //     Expanded(child: CustomButton(btnTxt: 'Details')),
                                              //   ],
                                              // )
                                              // ),

                                            ],
                                          ),
                                          elevation: 8,
                                          shadowColor: Colors.white,
                                          margin: EdgeInsets.only(left: 5,right: 5, bottom: 8),
                                          shape:  OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(color: Colors.white)
                                          ),
                                        ),
                                      );
                                  },
                                ) :

                                Padding(padding: EdgeInsets.only(top: 20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(Images.empty,
                                          width: 110,
                                          height: 110,
                                        ),
                                        Text("You have no new orders",
                                            style: TextStyle(fontSize: 13, color: Colors.black54))
                                      ],
                                    )),


                                _loadingBottom == true?
                                Center(
                                    child: CircularProgressIndicator(
                                        valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.redAccent))
                                )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ): const SizedBox()
                      : homeProvider.online == 1?
                  Expanded(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: SizedBox(
                            width: 1170,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [

                                homeProvider.runningIsLoading ?
                                Center(
                                    child: CircularProgressIndicator(
                                        valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.redAccent))
                                ):ordersList!.length > 0 ?
                                ListView.builder(
                                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                  itemCount: ordersList!.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    Map<String,dynamic>? userLocation = jsonDecode(ordersList![index].userLocation);
                                    double _userLat = userLocation!['latitude']!=null? userLocation['latitude']: 0.0;
                                    double _userLong = userLocation['longitude']!=null? userLocation['latitude']: 0.0;
                                    double _distance = LocationHelper.calculateDistance(
                                        latitude,
                                        longitude,
                                        _userLat,
                                        _userLong);

                                    return
                                      GestureDetector(
                                        onTap: ()async{
                                          //  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> RiderOrderDetails(orderModel: ordersList[index])));
                                        },
                                        child: Card(
                                          child: Column(

                                            children: [
                                              Padding(padding: EdgeInsets.all(6),
                                                child: Row(

                                                    children: [
                                                      Text('Order Id'),
                                                      Text('#${ordersList![index].id}',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: Colors.black54,
                                                            fontWeight: FontWeight.bold,
                                                          )),
                                                      Flexible(
                                                        flex: 1,
                                                        child: Center(child: Text('${ordersList![index].customer!.fullName}',
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold,
                                                            ))),
                                                      ),
                                                      Flexible(
                                                        child: new Container(
                                                          padding: new EdgeInsets.only(right: 13.0),
                                                          child: new Text('${_distance.toStringAsFixed(2)}  Miles Away',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.black54,
                                                                fontWeight: FontWeight.bold,
                                                              )),
                                                        ),
                                                      ),

                                                    ]),
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                              ),
                                              Padding(padding: EdgeInsets.all(6),
                                                child: Row(

                                                    children: [
                                                      Text('Location: ',style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.normal,
                                                      )),
                                                      Flexible(
                                                        child: new Container(
                                                          padding: new EdgeInsets.only(right: 13.0),
                                                          child: new Text('${userLocation['adminisrative_area']!= null? userLocation['adminisrative_area']:''} ${userLocation['locality']!= null? userLocation['locality']: ''}',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                              )),
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                              ),
                                              /// Service Info

                                              Padding(padding: EdgeInsets.all(6),
                                                child: Row(

                                                    children: [
                                                      Text('Service: ',style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.normal,
                                                      )),
                                                      Flexible(
                                                        child: new Container(
                                                          padding: new EdgeInsets.only(right: 13.0),
                                                          child: new Text('${ordersList![index].serviceName}',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                              )),
                                                        ),
                                                      ),

                                                      Flexible(
                                                        child: new Container(
                                                          padding: new EdgeInsets.only(right: 13.0),
                                                          child: new Text('${ordersList![index].totalPrice} \$',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                              )),
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                              ),
                                              Padding(padding: EdgeInsets.all(6),
                                                child: Row(
                                                    children: [
                                                      Flexible(child: Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () => launch('tel:${ordersList![index].customer!.phone}'),
                                                            child: Container(
                                                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent),
                                                              child: Icon(Icons.call_outlined, color: Colors.white),
                                                            ),
                                                          ),
                                                          SizedBox(width: 8),
                                                          InkWell(
                                                            onTap: () {
                                                              Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((position) {
                                                                MapUtils.openMap(
                                                                    userLocation['latitude'] ?? 23.8103,
                                                                    userLocation['longitude'] ?? 90.4125,
                                                                    position.latitude,
                                                                    position.longitude);
                                                              });
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent),
                                                              child: Icon(Icons.location_on_outlined, color: Colors.white),
                                                            ),
                                                          ),
                                                        ],
                                                      )),

                                                      if(homeProvider.finishedList.contains(ordersList![index].id))
                                                        Padding(padding: EdgeInsets.all(6),
                                                          child: Row(
                                                              children: [

                                                                Container(
                                                                    height: 40.0,
                                                                    child: Row(children: [
                                                                      Text('Finished', style: TextStyle(color: Colors.green)),
                                                                      Icon(Icons.check, color: Colors.green),
                                                                    ])
                                                                )
                                                              ]),
                                                        )
                                                      else if(homeProvider.cancelledList.contains(ordersList![index].id))
                                                        Padding(padding: EdgeInsets.all(6),
                                                          child: Row(
                                                              children: [

                                                                Container(
                                                                    height: 40.0,
                                                                    child: Row(children: [
                                                                      Text('Cancelled', style: TextStyle(color: Colors.redAccent)),
                                                                      //   Icon(Icons.check, color: Colors.green),
                                                                    ])
                                                                )
                                                              ]),
                                                        )

                                                      else if(homeProvider.acceptedList.contains(ordersList![index].id))
                                                          Padding(padding: EdgeInsets.all(6),
                                                            child: Row(
                                                                children: [

                                                                  Container(
                                                                      height: 40.0,
                                                                      child: Row(children: [
                                                                        Text('Accepted', style: TextStyle(color: Colors.green)),
                                                                        Icon(Icons.check, color: Colors.green),
                                                                      ])
                                                                  )
                                                                ]),
                                                          )

                                                        else
                                                          Container(
                                                            height: 40.0,
                                                            child: BorderButton(
                                                              btnTxt: 'Accept Order?',
                                                              textColor: Colors.red,
                                                              borderColor: Colors.red,
                                                              onTap: (){
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (_) => AlertDialog(
                                                                      title: const Text('Accept order?'),

                                                                      actions: [
                                                                        BorderButton(
                                                                          btnTxt: 'No',
                                                                          textColor: Colors.black,
                                                                          borderColor: Colors.black,
                                                                          onTap: (){
                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                        BorderButton(
                                                                          btnTxt: 'Yes',
                                                                          textColor: Colors.red,
                                                                          borderColor: Colors.red,
                                                                          onTap: (){
                                                                            Navigator.pop(context);
                                                                            if(ordersList![index].appointment != null){
                                                                              DateTime _appointmentDate = DateTime.parse(ordersList![index].appointment!.appointmentDate!);
                                                                              Provider.of<AppointmentProvider>(context, listen: false).setDayAndMonth(
                                                                                  _appointmentDate.weekday,
                                                                                  _appointmentDate.day,
                                                                                  _appointmentDate.month,
                                                                                  _appointmentDate.year);

                                                                              String token = Provider.of<AuthProvider>(context, listen: false).getUserToken();
                                                                              Provider.of<AppointmentProvider>(context, listen: false).getDayAppointments(
                                                                                  context,
                                                                                  _appointmentDate,
                                                                                  token
                                                                              );
                                                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> ServiceDurationScreen(
                                                                                appointmentId: ordersList![index].appointment!.id,
                                                                                order: ordersList![index],
                                                                              )));
                                                                            }else{
                                                                              homeProvider.acceptRejectOrder(context,ordersList![index], 'accepted', ordersList![index].id.toString(),'no_date', _callback);
                                                                            }
                                                                          },
                                                                        ),
                                                                      ],
                                                                    )
                                                                );
                                                              },
                                                            ),

                                                          )
                                                    ]),
                                              ),
                                            ],
                                          ),
                                          elevation: 8,
                                          shadowColor: Colors.white,
                                          margin: EdgeInsets.only(left: 5,right: 5, bottom: 8),
                                          shape:  OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(color: Colors.white)
                                          ),
                                        ),
                                      );
                                  },
                                ) :

                                Padding(padding: EdgeInsets.only(top: 20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(Images.empty,
                                          width: 110,
                                          height: 110,
                                        ),
                                        Text("You have no new orders",
                                            style: TextStyle(fontSize: 13, color: Colors.black54))
                                      ],
                                    )),

                                _loadingBottom == true?
                                Center(
                                    child: CircularProgressIndicator(
                                        valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.redAccent))
                                )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ): const SizedBox()
                ],
              ) :

              SizedBox() :

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Text('Our team reviews your account information and then your account will be activated')),
                    SizedBox(height: 10),
                    Text('Thank you for your patience...',style: TextStyle(
                        fontWeight: FontWeight.bold
                    ))
                  ],
                ),
              );
          },
        )
    );
  }
  void _callback(
      bool isSuccess,Order order, String message, String orderId) async {
    if(isSuccess){
      Provider.of<HomeProvider>(context, listen: false).addAcceptedList(int.parse(orderId));
      // Provider.of<HomeProvider>(context, listen: false).acceptedOrderList!.add(order);
      Provider.of<HomeProvider>(context, listen: false).acceptedOrderList!.insert(0, order);
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(message),
          )
      );
      setState(() {});
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error occured, try again later'),
          )
      );
    }
  }
  void _callbackUserInfo(
      bool isSuccess) async {
    if(isSuccess){

      setState(() {});
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



class MapUtils {
  MapUtils._();

  static Future<void> openMap(double destinationLatitude, double destinationLongitude, double userLatitude, double userLongitude) async {
    String googleUrl = 'https://www.google.com/maps/dir/?api=1&origin=$userLatitude,$userLongitude'
        '&destination=$destinationLatitude,$destinationLongitude&mode=d';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
