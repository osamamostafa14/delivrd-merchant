import 'dart:convert';
import 'package:delivrd_driver/data/model/orders_model.dart';
import 'package:delivrd_driver/provider/home_provider.dart';
import 'package:delivrd_driver/provider/splash_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/utill/images.dart';
import 'package:delivrd_driver/view/screens/widget/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Order? order;
  OrderDetailsScreen({@required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0.0,
        leadingWidth: 45,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text('Order details', style: TextStyle(
            color: Colors.black54,
            fontSize: 17
        )),
        centerTitle: true,
      ),
      body: Consumer<HomeProvider>(
          builder: (context, homeProvider, child) {
            Map<String, dynamic> _location = jsonDecode(widget.order!.userLocation);
            Map<String, dynamic> _vehicleInfo = widget.order!.vehicleInfo !=null? jsonDecode(widget.order!.vehicleInfo!) : {'model_name' : 0};
            return SafeArea(
              child: Scrollbar(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                  physics: BouncingScrollPhysics(),
                  child: Center(
                    child: SizedBox(
                      width: 1170,
                      child: Column(
                        children: [
                         Row(
                           children: [
                             Expanded(child: Text('Service Name:', style: TextStyle(color: Colors.black54))),
                             Expanded(child: Text('${widget.order!.serviceName}', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
                           ],
                         ),

                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(child: Text('Administrative area:', style: TextStyle(color: Colors.black54))),
                              Expanded(child: Text('${_location['adminisrative_area']}', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(child: Text('Locality:', style: TextStyle(color: Colors.black54))),
                              Expanded(child: Text('${_location['locality']}', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                          _vehicleInfo['model_name'] != 0?
                          Row(
                            children: [
                              Expanded(child: Text('Model Name', style: TextStyle(color: Colors.black54))),
                              Expanded(child: Text('${_vehicleInfo['model_name']}', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
                            ],
                          ) : SizedBox(),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                          _vehicleInfo['model_name'] != 0?
                          Row(
                            children: [
                              Expanded(child: Text('Model Year', style: TextStyle(color: Colors.black54))),
                              Expanded(child: Text('${_vehicleInfo['model_year']}', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
                            ],
                          ) : SizedBox(),

                          SizedBox(height: 40),
                          widget.order!.tireImage == null? SizedBox() :
                          Center(
                            child: Text('Tire Image', style: TextStyle(color: Colors.black54)),
                          ),
                          SizedBox(height: 10),
                          widget.order!.tireImage == null? SizedBox() :
                          GestureDetector(onTap: () {
                            String url =
                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.orderImageUrl}/${widget.order!.tireImage}';
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImagePreview(imageURL: url)));
                          }, 
                          child: Stack(children: [
                            FadeInImage.assetNetwork(
                              placeholder: Images.placeholder,
                              image:
                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.orderImageUrl}/${widget.order!.tireImage}',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                                bottom: 10,
                                right: 0,
                            child: Icon(Icons.open_with_rounded, color: Colors.white),
                            )
                          ],)),
                        ],
                      )
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
