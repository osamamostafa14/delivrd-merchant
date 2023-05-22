import 'package:delivrd_driver/data/datasource/remote/dio/dio_client.dart';
import 'package:delivrd_driver/data/datasource/remote/exception/api_error_handler.dart';
import 'package:delivrd_driver/data/model/response/base/api_response.dart';
import 'package:delivrd_driver/utill/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AppointmentRepo {
  final DioClient? dioClient;
  AppointmentRepo({@required this.dioClient});

  Future<ApiResponse> getDayAppointments(DateTime date, String token) async {
    try {
      Response response = await dioClient!.get('${AppConstants.DAY_APPOINTMENTS_URI}?date=$date&token=$token');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
