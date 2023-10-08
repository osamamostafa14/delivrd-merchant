import 'dart:convert';
import 'package:delivrd_driver/data/datasource/remote/dio/dio_client.dart';
import 'package:delivrd_driver/data/datasource/remote/exception/api_error_handler.dart';
import 'package:delivrd_driver/data/model/response/base/api_response.dart';
import 'package:delivrd_driver/utill/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ServicesRepo {
  final DioClient? dioClient;

  ServicesRepo({@required this.dioClient});

  Future<ApiResponse> getCategories() async {
    try {
      Response response = await dioClient!.get(
          '${AppConstants.CATEGORIES_URI}'
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDriverCategories(String token) async {
    try {
      Response response = await dioClient!.get(
          '${AppConstants.DRIVER_CATEGORIES_URI}?token=$token'
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> saveServices(List<int> services, String token) async {
    print('tok: ${token} ser: ${services}');
    try {
      final response = await dioClient!.post(AppConstants.SAVE_SERVICES_URI, data: {"services": jsonEncode(services), "token": token},);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}