import 'dart:convert';
import 'package:delivrd_driver/data/model/orders_model.dart';
import 'package:delivrd_driver/helper/location_helper.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/home_provider.dart';
import 'package:delivrd_driver/provider/location_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/utill/images.dart';
import 'package:delivrd_driver/view/base/border_button.dart';
import 'package:delivrd_driver/view/screens/order/order_details_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptedScreen extends StatefulWidget {
  @override
  _AcceptedScreenState createState() => _AcceptedScreenState();
}

class _AcceptedScreenState extends State<AcceptedScreen> {

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  List<Order>? ordersList = [];
  ScrollController scrollController = new ScrollController();
  double _scroll = 0.0;
  bool _loading = false;
  bool _loadingBottom = false;

  @override
  void initState() {
    super.initState();
    Provider.of<HomeProvider>(context, listen: false).getAcceptedOrderList(context, '1',
        Provider.of<AuthProvider>(context, listen: false).getUserToken());
  }

  Future? _scrollPosition (){
    int offset = 1;
    scrollController.addListener(() {

      _scroll = scrollController.position.pixels;
      // if(_scroll < -25.0){
      //   int pageSize;
      //   pageSize = (Provider.of<HomeProvider>(context, listen: false).totalAcceptedSize !/ 10).ceil();
      //
      //   if (offset < pageSize && Provider.of<HomeProvider>(context, listen: false).acceptedOrderList != null
      //       && !Provider.of<HomeProvider>(context, listen: false).orderIsLoading) {
      //     offset++;
      //     Provider.of<HomeProvider>(context, listen: false).clearOffset();
      //     Provider.of<HomeProvider>(context, listen: false).
      //     getAcceptedLatest(
      //         context,
      //         Provider.of<AuthProvider>(context, listen: false).getUserToken());
      //   }
      //   _loading = true;
      //   setState(() {
      //
      //   });
      //   print(_loading);
      //   Future.delayed(Duration(seconds: 2), () async {
      //     _loading = false;
      //     setState(() {});
      //
      //   });
      // }
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        print('at end /////////////////');
        int pageSize;
        pageSize = (Provider.of<HomeProvider>(context, listen: false).pageSize !/ 10).ceil();

        if (offset < pageSize && Provider.of<HomeProvider>(context, listen: false).acceptedOrderList != null
            && !Provider.of<HomeProvider>(context, listen: false).orderIsLoading) {
          offset++;
          // Provider.of<HomeProvider>(context, listen: false).clearOffset();
          Provider.of<HomeProvider>(context, listen: false).
          getAcceptedOrderList(
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
    setState(() {
      //return _scroll;
    });
  }


  @override
  Widget build(BuildContext context) {
    _scrollPosition();
    String token = Provider.of<AuthProvider>(context, listen: false).getUserToken();
    double latitude = Provider.of<LocationProvider>(context, listen: false).position!.latitude;
    double longitude = Provider.of<LocationProvider>(context, listen: false).position!.longitude;


    print('lat lon DRIVER');
    print(Provider.of<LocationProvider>(context, listen: false).position);
    // print(longitude);


    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            backgroundColor: Theme.of(context).cardColor,
            leadingWidth: 45,
            elevation: 0.0,
            actions: <Widget>[
              GestureDetector(
                  onTap: (){
                    Provider.of<HomeProvider>(context, listen: false).
                    getAcceptedLatest(
                        context,
                        Provider.of<AuthProvider>(context, listen: false).getUserToken());
                    // _loading = true;
                    setState(() {});
                  },
                  child: Icon(Icons.refresh, color: Colors.red, size: 30)),
              SizedBox(width: 20)


            ],
          leading: Padding(padding: const EdgeInsets.only(left: 10),
            child:
            Image.asset('assets/image/logo_home.png'),
          ),
          title: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text('Running', style: TextStyle(
                    color: Colors.black54,
                    fontSize: 17
                )),
              )
          ),
        ),
        body: Consumer<HomeProvider>(
          builder: (context, homeProvider, child) {
            ordersList = homeProvider.acceptedOrderList;
            return ordersList != null?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _loading == true?
                              Center(
                                  child: CircularProgressIndicator(
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.redAccent))
                              )
                                  : SizedBox(),

                              homeProvider.orderIsLoading ?
                              Center(
                                  child: CircularProgressIndicator(
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.redAccent))
                              ):ordersList!.length>0?
                              ListView.builder(
                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                itemCount: ordersList!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  Map<String,dynamic>? userLocation = jsonDecode(ordersList![index].userLocation);
                                  double lat = userLocation!['latitude'] != null? userLocation['latitude'] : 0.0;
                                  double long = userLocation['longitude'] != null? userLocation['latitude'] : 0.0;
                                  double _distance = LocationHelper.calculateDistance(
                                      latitude,
                                      longitude,
                                      lat,
                                      long);

                                  return

                                    GestureDetector(
                                      onTap: ()async{
                                        //  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> RiderOrderDetails(orderModel: ordersList[index])));
                                      },
                                      child: Card(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(padding: EdgeInsets.all(6),
                                              child: Row(

                                                  children: [
                                                    Text('Order'),
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
                                                              ) else

                                                        Row(
                                                          children: [

                                                            Container(
                                                              height: 40.0,
                                                              child: BorderButton(
                                                                btnTxt: 'Cancel',
                                                                textColor: Colors.grey,
                                                                borderColor: Colors.grey,
                                                                onTap: (){
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (_) => AlertDialog(
                                                                        title: Text('Are you sure to cancel?'),

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
                                                                            onTap: (){
                                                                              homeProvider.acceptRejectOrder(context,ordersList![index], 'cancelled', ordersList![index].id.toString(),'no_date', _callback);
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),

                                                                        ],
                                                                      )
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Container(
                                                              height: 40.0,
                                                              child: BorderButton(
                                                                btnTxt: 'Finish',
                                                                textColor: Colors.green,
                                                                borderColor: Colors.green,
                                                                onTap: (){
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (_) => AlertDialog(
                                                                        title: Text('did you finish your work?'),

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
                                                                              homeProvider.acceptRejectOrder(context,ordersList![index], 'finished', ordersList![index].id.toString(),'no_date', _callback);
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),

                                                                        ],
                                                                      )
                                                                  );
                                                                },
                                                              ),

                                                              // RaisedButton(
                                                              //   shape: RoundedRectangleBorder(
                                                              //       borderRadius: BorderRadius.circular(18.0),
                                                              //       side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))),
                                                              //   onPressed: () {
                                                              //     showDialog(
                                                              //         context: context,
                                                              //         builder: (_) => AlertDialog(
                                                              //           title: Text('did you finish your work?'),
                                                              //
                                                              //           actions: [
                                                              //             FlatButton(           // FlatButton widget is used to make a text to work like a button
                                                              //               textColor: Colors.black,
                                                              //               onPressed: () {
                                                              //                 Navigator.pop(context);
                                                              //               },        // function used to perform after pressing the button
                                                              //               child: Text('No'),
                                                              //             ),
                                                              //             FlatButton(
                                                              //               textColor: Colors.black,
                                                              //               onPressed: () {
                                                              //                 homeProvider.acceptRejectOrder(context,ordersList![index], 'finished', ordersList![index].id.toString(), _callback);
                                                              //                 Navigator.pop(context);
                                                              //                 // Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen(orderModel: orderModel, fromCheckout: fromCheckout)));
                                                              //               },
                                                              //               child: Text('Yes'),
                                                              //             ),
                                                              //           ],
                                                              //         )
                                                              //     );
                                                              //   },
                                                              //   padding: EdgeInsets.all(10.0),
                                                              //   color: Color.fromRGBO(0, 160, 227, 1),
                                                              //   textColor: Colors.white,
                                                              //   child: Text("Finish",
                                                              //       style: TextStyle(fontSize: 13)),
                                                              // ),
                                                            )
                                                          ],
                                                        ),

                                                  ]),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Container(
                                                    height: 40.0,
                                                    child: BorderButton(
                                                      btnTxt: 'Details',
                                                      textColor: Colors.grey,
                                                      borderColor: Colors.grey,
                                                      onTap: (){
                                                        Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: ordersList![index])));
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                              ],
                                            ),
                                            SizedBox(height: 10),
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
                              ) : Padding(padding: EdgeInsets.only(top: 200),
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
                ),
              ],
            ) :

            SizedBox.expand(
                child:  Column(
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
                ));

          },
        )

    );
  }
  void _callback(
      bool isSuccess,Order order, String message, String orderId) async {
    if(isSuccess){
     // Provider.of<HomeProvider>(context, listen: false).historyOrderList!.add(order);
      Provider.of<HomeProvider>(context, listen: false).historyOrderList!.insert(0, order);
      if(message.toLowerCase().contains('finished')){
        Provider.of<HomeProvider>(context, listen: false).addFinishedList(int.parse(orderId));

      } else {
        Provider.of<HomeProvider>(context, listen: false).addCancelledList(int.parse(orderId));
      }

      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(message),
          )
      );
      setState(() {

      });
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
