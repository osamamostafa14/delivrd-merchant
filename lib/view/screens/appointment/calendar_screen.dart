import 'package:delivrd_driver/data/model/signup_model.dart';
import 'package:delivrd_driver/provider/appointment_provider.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/profile_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/view/screens/appointment/widget/time_intervals.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarScreen extends StatefulWidget {

  // final int serviceId;
  // CalendarScreen({@required this.serviceId});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  final _currentDate = DateTime.now();


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
                              TimeIntervals(intervals: _dates, userModel: _user)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Icon(Icons.watch_later_outlined,
                //         color: Colors.red, size: 25),
                //     const SizedBox(width: 10),
                //     Text('Merchant working hours:',
                //         style: TextStyle(color:Colors.red)),
                //   ],
                // ),

              ],
            );
          },
        )
    );
  }

}
