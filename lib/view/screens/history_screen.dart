import 'dart:convert';
import 'package:delivrd_driver/data/model/orders_model.dart';
import 'package:delivrd_driver/helper/location_helper.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/home_provider.dart';
import 'package:delivrd_driver/provider/location_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/utill/images.dart';
import 'package:delivrd_driver/view/base/border_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  List<Order>? ordersList;
  ScrollController scrollController = new ScrollController();
  double _scroll = 0.0;
  bool _loading = false;
  bool _loadingBottom = false;
  List<int> _finishedOrders = [];

  @override
  void initState() {
    super.initState();
    Provider.of<HomeProvider>(context, listen: false).getHistoryOrderList(context, '1', Provider.of<AuthProvider>(context, listen: false).getUserToken());
  }

  Future? _scrollPosition (){
    int offset = 1;
    scrollController.addListener(() {

      _scroll = scrollController.position.pixels;
      // if(_scroll < -25.0){
      //   int pageSize;
      //   pageSize = (Provider.of<HomeProvider>(context, listen: false).totalHistorySize !/ 10).ceil();
      //
      //   if (offset < pageSize && Provider.of<HomeProvider>(context, listen: false).historyOrderList != null
      //       && !Provider.of<HomeProvider>(context, listen: false).orderIsLoading) {
      //     offset++;
      //     Provider.of<HomeProvider>(context, listen: false).clearOffset();
      //     Provider.of<HomeProvider>(context, listen: false).
      //     getHistoryLatest(
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
      //     setState(() {
      //
      //     });
      //     print('Scroll false /////////////////');
      //     print(_loading);
      //   });
      // }
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        print('at end /////////////////');
        int pageSize;
        pageSize = (Provider.of<HomeProvider>(context, listen: false).totalHistorySize !/ 10).ceil();

        if (offset < pageSize && Provider.of<HomeProvider>(context, listen: false).historyOrderList != null
            && !Provider.of<HomeProvider>(context, listen: false).orderIsLoading) {
          offset++;
          // Provider.of<HomeProvider>(context, listen: false).clearOffset();
          Provider.of<HomeProvider>(context, listen: false).
          getHistoryOrderList(
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
                    getHistoryLatest(
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
                child: Text('History', style: TextStyle(
                    color: Colors.black54,
                    fontSize: 17
                )),
              )
          ),
          ),

        body: Consumer<HomeProvider>(
          builder: (context, homeProvider, child) {
            ordersList = homeProvider.historyOrderList;
            return ordersList!= null?
            Column(
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
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              _loading == true?
                              Center(
                                  child: CircularProgressIndicator(
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.redAccent))
                              )
                                  : SizedBox(),

                              homeProvider.historyIsLoading ?
                              Center(
                                  child: CircularProgressIndicator(
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.redAccent))
                              ):
                              ordersList!.length>0?
                              ListView.builder(
                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                itemCount: ordersList!.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  Map<String,dynamic>? userLocation = jsonDecode(ordersList![index].userLocation);
                                  double lat = userLocation!['latitude'] != null? userLocation['latitude'] : 0.0;
                                  double long = userLocation!['longitude'] != null? userLocation['latitude'] : 0.0;
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
                                                    ordersList![index].orderStatus == 'finished' ||
                                                        homeProvider.finishedList.contains(ordersList![index].id)?
                                                    Container(
                                                        height: 40.0,
                                                        child: Row(children: [
                                                          Text('Finished', style: TextStyle(color: Colors.green)),
                                                          Icon(Icons.check, color: Colors.green),
                                                        ])
                                                    ): Container(
                                                        height: 40.0,
                                                        child: Row(children: [
                                                          Text('Cancelled', style: TextStyle(color: Colors.redAccent)),
                                                         // Icon(Icons.error, color: Colors.green),
                                                        ])
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
                              Padding(padding: EdgeInsets.only(top: 200),
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
