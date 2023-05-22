
import 'package:delivrd_driver/data/model/appointment_model.dart';
import 'package:delivrd_driver/data/model/orders_model.dart';
import 'package:delivrd_driver/data/model/response/base/api_response.dart';
import 'package:delivrd_driver/data/repository/appointment_repo.dart';
import 'package:flutter/material.dart';

class AppointmentProvider extends ChangeNotifier {
  final AppointmentRepo? appointmentRepo;
  AppointmentProvider({@required this.appointmentRepo});

  List<AppointmentModel>? _dayAppointments;
  List<AppointmentModel>? get dayAppointments => _dayAppointments;

  int _selectedDay = DateTime.now().day;
  int get selectedDay => _selectedDay;

  int? _selectedWeekDay;
  int? get selectedWeekDay => _selectedWeekDay;

  int _selectedMonth = DateTime.now().month;
  int get selectedMonth => _selectedMonth;

  int _selectedYear = DateTime.now().year;
  int get selectedYear => _selectedYear;


  bool _appointmentLoading = false;
  bool get appointmentLoading => _appointmentLoading;

  bool _isAm = false;
  bool get isAm => _isAm;

  int? _selectedHour;
  int? get selectedHour => _selectedHour;

  int? _selectedMinute;
  int? get selectedMinute => _selectedMinute;

  void setDayAndMonth(int weekday, int day, int month, int year){
    _selectedWeekDay = weekday;
    _selectedDay = day;
    _selectedMonth = month;
    _selectedYear = year;
    notifyListeners();
  }

  Future<void> getDayAppointments(BuildContext context, DateTime date, String token) async {
    _appointmentLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await appointmentRepo!.getDayAppointments(date, token);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _appointmentLoading = false;
      _dayAppointments = [];
      apiResponse.response!.data.forEach((appointment) {
        AppointmentModel appointmentModel = AppointmentModel.fromJson(appointment);
        _dayAppointments!.add(appointmentModel);
      });
      print('appointments here ${_dayAppointments}');
    } else {
    }
    notifyListeners();
  }


  void pickerIsAm(bool value) {
    _isAm = value;
    notifyListeners();
  }

  void setTime(int hour, int minute) {
    _selectedHour = hour;
    _selectedMinute = minute;
    notifyListeners();
  }

}
