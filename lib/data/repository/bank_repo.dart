import 'package:delivrd_driver/data/datasource/remote/dio/dio_client.dart';
import 'package:delivrd_driver/data/datasource/remote/exception/api_error_handler.dart';
import 'package:delivrd_driver/data/model/response/base/api_response.dart';
import 'package:delivrd_driver/utill/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BankRepo {
  final DioClient? dioClient;
  BankRepo({@required this.dioClient});

  Future<ApiResponse> addCard({String? routingNo, String? accountNumber, String? holderName, String? token}) async {
    print('card no: ${accountNumber}');
    try {
      Response response = await dioClient!.post(
        AppConstants.ADD_CARD_URI,
        data: {"routing_number": routingNo,"account_number": accountNumber, "holder_name": holderName, "token": token},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateCard({String? routingNo, String? accountNumber, String? holderName, int? id, String? token}) async {

    try {
      Response response = await dioClient!.post(
        AppConstants.UPDATE_CARD_URI,
        data: {"routing_number": routingNo, "holder_name": holderName, "account_number":accountNumber, "id":id, "token":token},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getAccounts(String token) async {
    print('token here -- ${ '${AppConstants.ACCOUNTS_URI}?token=$token'}');
    try {
      Response response = await dioClient!.get(
        '${AppConstants.ACCOUNTS_URI}?token=$token'
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> removeBankAccount(int? accountId, String token) async {
    try {
      final response = await dioClient!.post('${AppConstants.REMOVE_BANK_ACCOUNT_URI}', data: {'account_id': accountId, 'token': token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> getWithdrawals(String token) async {
    try {
      final response = await dioClient!.post(AppConstants.DRIVER_WITHDRAWALS_URI, data: {'token': token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}