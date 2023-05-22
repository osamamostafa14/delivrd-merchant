import 'package:delivrd_driver/data/model/appointment_model.dart';
import 'package:delivrd_driver/data/model/signup_model.dart';
import 'package:delivrd_driver/helper/date_converter.dart';
import 'package:delivrd_driver/provider/appointment_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimeIntervals extends StatelessWidget {
  final List<DateTime>? intervals;
  final SignUpModel? userModel;
  final int? appointmentId; // if from select service duration page
  TimeIntervals({@required this.intervals, @required this.userModel, this.appointmentId});

  @override
  Widget build(BuildContext context) {

    return Scrollbar(
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        child:
        Consumer<AppointmentProvider>(
            builder: (context, appointmentProvider, child) {
              List<AppointmentModel> _appointments = appointmentProvider.dayAppointments!;

              return
                Center(
                  child: SizedBox(
                    width: 1170,
                    child:  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      itemCount: _appointments.length,
                      itemBuilder: (context, index) {
                        DateTime _parseStartingTime = DateTime.parse(_appointments[index].appointmentDate!);
                        DateTime _expectedEndingTime = DateTime.now();
                        bool _hasExpectedEndDate = true;
                        if(_appointments[index].expectedEndDate !=null){
                           _expectedEndingTime = DateTime.parse(_appointments[index].expectedEndDate!);
                          _hasExpectedEndDate = true;
                        }else {
                          _hasExpectedEndDate = false;
                        }
                        Color bgColor;
                        Color borderColor;
                        String _selectedText = '';
                        if(appointmentId !=null){
                          if(appointmentId == _appointments[index].id){
                            bgColor = const Color(0xFFccdfcc);
                            borderColor = Colors.green;
                            _selectedText = 'Selected';
                          }else{
                            bgColor = const Color(0xFFf1d1d1);
                            borderColor = Colors.red;
                          }

                        }else{
                          bgColor = const Color(0xFFf1d1d1);
                          borderColor = Colors.red;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child:
                          GestureDetector(
                            onTap: (){

                            },
                            child: Center(child:
                             Row(
                              children: [
                                 Expanded(
                                   child:
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color:  bgColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [BoxShadow(
                                          color: Colors.grey[100]!,
                                          blurRadius: 5, spreadRadius: 1,
                                        )],
                                      border: Border.all(width: 1, color: borderColor),
                                    ),
                                    child:
                                    Center(child:
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(width: 15),
                                          Icon(Icons.date_range),
                                            const SizedBox(width: 15),
                                            Text('${DateConverter.localDateToHMString(_parseStartingTime)}',
                                                style: TextStyle(color: Colors.black54, fontSize: 14,
                                                    fontWeight: FontWeight.normal)),

                                            _hasExpectedEndDate?
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 5, right: 5),
                                                  child: Icon(Icons.arrow_forward, size: 15),
                                                )
                                            : const SizedBox(),

                                            _hasExpectedEndDate?
                                            Text('${DateConverter.localDateToHMString(_expectedEndingTime)}',
                                                style: TextStyle(color: Colors.black54, fontSize: 14,
                                                    fontWeight: FontWeight.normal)) : const SizedBox(),


                                            Padding(
                                              padding: const EdgeInsets.only(left: 20),
                                              child: Text('${_selectedText}',
                                                  style: TextStyle(color: Colors.black54, fontSize: 12,
                                                      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                                            ),

                                          ],
                                        ),

                                        _appointments[index].service!=null?
                                        Row(
                                          children: [
                                            const SizedBox(width: 55),
                                            Text('Service: ',
                                                style: TextStyle(color: Colors.black54, fontSize: 14,
                                                    fontWeight: FontWeight.normal)),
                                            Text('${_appointments[index].service!.name}',
                                                style: TextStyle(color: Colors.black54, fontSize: 14,
                                                    fontWeight: FontWeight.normal)),
                                          ],
                                        ) :
                                        const SizedBox(),

                                        _appointments[index].tire!=null?
                                        Row(
                                          children: [
                                            const SizedBox(width: 55),
                                            Text('Service: Tire ',
                                                style: TextStyle(color: Colors.black54, fontSize: 14,
                                                    fontWeight: FontWeight.normal)),
                                            const SizedBox(width: 5),
                                            Text('${_appointments[index].tire!.vsa}',
                                                style: TextStyle(color: Colors.black54, fontSize: 14,
                                                    fontWeight: FontWeight.normal)),

                                            const SizedBox(width: 5),

                                            Text('${_appointments[index].tire!.acr}',
                                                style: TextStyle(color: Colors.black54, fontSize: 14,
                                                    fontWeight: FontWeight.normal)),
                                          ],
                                        ): const SizedBox(),
                                      ],
                                    )),
                                  ),
                                ),
                              ],
                            )),
                          ),
                        );
                      },
                    ),
                  ),
                );
            }),
      ),
    );
  }
}
