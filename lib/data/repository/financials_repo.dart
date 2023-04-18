import 'package:delivrd_driver/data/datasource/remote/dio/dio_client.dart';
import 'package:delivrd_driver/data/datasource/remote/exception/api_error_handler.dart';
import 'package:delivrd_driver/data/model/response/base/api_response.dart';
import 'package:delivrd_driver/utill/app_constants.dart';
import 'package:flutter/material.dart';

class FinancialsRepo {
  final DioClient? dioClient;
  FinancialsRepo({@required this.dioClient});

  Future<ApiResponse> filterDateStats(String offset,String? startDate, String? endDate, String? token) async {
    try {
      final response = await dioClient!.get('${AppConstants.FILTER_DATE_STATS}?offset=$offset&start_date=$startDate&end_date=$endDate&token=$token');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getWithdrawals(String offset, String? token) async {
    try {
      final response = await dioClient!.get('${AppConstants.DRIVER_WITHDRAWALS_URI}?offset=$offset&token=$token');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> withdrawMoney(String bankAccountId, String token) async {
    try {
      final response = await dioClient!.post(AppConstants.WITHDRAW_URI, data: {"bank_account_id": bankAccountId, "token": token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}