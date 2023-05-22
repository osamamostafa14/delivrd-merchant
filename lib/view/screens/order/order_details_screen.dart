import 'dart:convert';
import 'package:delivrd_driver/data/model/orders_model.dart';
import 'package:delivrd_driver/helper/date_converter.dart';
import 'package:delivrd_driver/provider/appointment_provider.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/home_provider.dart';
import 'package:delivrd_driver/provider/splash_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/utill/images.dart';
import 'package:delivrd_driver/view/base/border_button.dart';
import 'package:delivrd_driver/view/screens/appointment/calendar_screen.dart';
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
            DateTime _appointmentDate = DateTime.parse(widget.order!.appointment!.appointmentDate!);
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final tomorrow = DateTime(now.year, now.month, now.day + 1);
            String _dateText;
            if(_appointmentDate == today) {
             _dateText = 'Today';
            } else if(_appointmentDate == tomorrow) {
              _dateText = 'Tomorrow';
            }else {
              _dateText = DateConverter.isoStringToLocalDateOnly(_appointmentDate);
            }

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
                             const Expanded(child: Text('Appointment date:', style: TextStyle(color: Colors.black54))),
                              Expanded(child: Row(
                                children: [
                                  Text('${DateConverter.convertTimeToTime(_appointmentDate)}',
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13
                                      )),
                                  const SizedBox(width: 10),
                                  Text(_dateText,
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12
                                      )),
                                ],
                              )),
                            ],
                          ),
                          const SizedBox(height: 10),
                          BorderButton(
                            width: 350,
                            btnTxt: 'Check your calendar',
                            textColor: Colors.red,
                            borderColor: Colors.red,
                            onTap: ()async{
                              DateTime _now = DateTime.now();
                              Provider.of<AppointmentProvider>(context, listen: false).setDayAndMonth(_now.weekday,_now.day, _now.month, _now.year);
                              String token = Provider.of<AuthProvider>(context, listen: false).getUserToken();
                              Provider.of<AppointmentProvider>(context, listen: false).getDayAppointments(
                                  context,
                                  DateTime.now(),
                                  token
                              );
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> CalendarScreen()));
                            },
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
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
