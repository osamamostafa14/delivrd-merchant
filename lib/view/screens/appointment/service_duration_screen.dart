import 'package:delivrd_driver/data/model/orders_model.dart';
import 'package:delivrd_driver/data/model/signup_model.dart';
import 'package:delivrd_driver/provider/appointment_provider.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/home_provider.dart';
import 'package:delivrd_driver/provider/profile_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/view/base/custom_button.dart';
import 'package:delivrd_driver/view/screens/appointment/widget/time_intervals.dart';
import 'package:delivrd_driver/view/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ServiceDurationScreen extends StatefulWidget {

  final int? appointmentId;
  final Order? order;
  ServiceDurationScreen({@required this.appointmentId, @required this.order});

  @override
  _ServiceDurationScreenState createState() => _ServiceDurationScreenState();
}

class _ServiceDurationScreenState extends State<ServiceDurationScreen> {

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  final _currentDate = DateTime.now();
  final TextEditingController _durationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: const Text('Your calendar', style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body:  Consumer<AppointmentProvider>(
          builder: (context, appointmentProvider, child) {

            final _dayFormatter = DateFormat('d');
            final _monthFormatter = DateFormat('MMM');
            List<DateTime> _dates = [];

            for (int i = 0; i < 14; i++) {
              final date = _currentDate.add(Duration(days: i));
              _dates.add(date);
            }
            List<String> days =[
              "sunday",
              "monday",
              "tuesday",
              "wednesday",
              "thursday",
              "friday",
              "saturday",
              "sunday",
            ];
            SignUpModel _user = Provider.of<ProfileProvider>(context, listen: false).userInfoModel!;
            List<dynamic> _mechanicDaysOff = _user.daysOff!;
            String _selectedWeekDay = days[appointmentProvider.selectedWeekDay!];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(
                          Dimensions.PADDING_SIZE_SMALL),
                      child: Center(
                        child: SizedBox(
                          width: 1170,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 80,
                                      width: double.maxFinite,
                                      child: ListView.builder(
                                        itemCount: _dates.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, i) {

                                          return Padding(
                                            padding: const EdgeInsets.only(left: 12, top: 8, right: 12),
                                            child: InkWell(
                                                onTap: () {
                                                  print('selectedDay -- ${appointmentProvider.selectedDay}');
                                                  appointmentProvider.setDayAndMonth(
                                                      _dates[i].weekday,
                                                      _dates[i].day,
                                                      _dates[i].month,
                                                      _dates[i].year);

                                                  DateTime _date = DateTime(
                                                    _dates[i].year,
                                                    _dates[i].month,
                                                    _dates[i].day,
                                                  );

                                                  print('date here--- ${_date}');
                                                  String token = Provider.of<AuthProvider>(context, listen: false).getUserToken();
                                                  appointmentProvider.getDayAppointments(context, _date, token);

                                                },
                                                child: Container(
                                                  //   height: 60,
                                                  //  width: 60,
                                                  // decoration: BoxDecoration(color: Colors.red),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      _dates[i].day == appointmentProvider.selectedDay && _dates[i].month == appointmentProvider.selectedMonth?
                                                      Text('${_dayFormatter.format(_dates[i])}',
                                                          style: TextStyle(fontSize: 19,
                                                              color: Colors.red,
                                                              fontWeight: FontWeight.bold)) :
                                                      Text('${_dayFormatter.format(_dates[i])}',
                                                          style: TextStyle(fontSize: 18,
                                                              color: Colors.black54,
                                                              fontWeight: FontWeight.normal)),

                                                      _dates[i].day == appointmentProvider.selectedDay && _dates[i].month == appointmentProvider.selectedMonth?
                                                      Text('${_monthFormatter.format(_dates[i])}',
                                                          style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold)) :
                                                      Text('${_monthFormatter.format(_dates[i])}',
                                                          style: TextStyle(fontSize: 17, color: Colors.black54, fontWeight: FontWeight.normal)),

                                                    ],
                                                  ),
                                                )
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              appointmentProvider.appointmentLoading?
                              Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor),
                                  )) :

                              _mechanicDaysOff.contains(_selectedWeekDay.toLowerCase())?
                              Padding(
                                padding: const EdgeInsets.only(top: 100),
                                child: Center(
                                  child: Text('You are off this day',
                                    style: TextStyle(
                                        fontSize: 16
                                    ),
                                  ),
                                ),
                              ):
                              TimeIntervals(intervals: _dates, userModel: _user, appointmentId: widget.appointmentId)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
               const Divider(),
               Expanded(child: Column(
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Icon(Icons.watch_later_outlined,
                           color: Colors.black87, size: 25),
                       const SizedBox(width: 10),
                       SizedBox(
                         width: MediaQuery.of(context).size.width * 0.8,
                         child: Text('Approximately how long will this service take to be completed?:',
                             style: TextStyle(color:Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                       ),
                     ],
                   ),
                   Padding(
                     padding: const EdgeInsets.only(left: 50),
                     child: TextField (
                       controller: _durationController,
                       keyboardType: TextInputType.number,
                       decoration: InputDecoration(
                           border: InputBorder.none,
                           labelText: 'Duration (In minutes)',
                           hintText: 'Duration (In minutes)'
                       ),
                     ),
                   ),

                 ],
               )),

                Consumer<HomeProvider>(
                    builder: (context, homeProvider, child) {
                      return
                        homeProvider.acceptIsLoading?
                        Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))) :
                        Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButton(
                          btnTxt: 'Confirm',
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            if(_durationController.text.trim().isNotEmpty){
                              int _serviceDuration = int.parse(_durationController.text);
                              DateTime _appointmentDate = DateTime.parse(widget.order!.appointment!.appointmentDate!);
                              DateTime _expectedEndTime = DateTime(
                                _appointmentDate.year,
                                _appointmentDate.month,
                                _appointmentDate.day,
                                _appointmentDate.hour,
                                _appointmentDate.minute + _serviceDuration,
                              );
                              Provider.of<HomeProvider>(context, listen: false).acceptRejectOrder(
                                  context,
                                  widget.order!,
                                  'accepted',
                                  widget.order!.id.toString(),
                                  _expectedEndTime.toString(),
                                  _callback);
                            }
                            //   Navigator.pop(context);
                          },
                        ),
                      );
                    })
              ],
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> HomeScreen()));
      setState(() {});
    } else {
      if(message == 'time_not_available'){
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('This time is not available, please check your calendar'),
            )
        );
      }else{
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Error occured, try again later'),
            )
        );
      }

    }
  }
}
