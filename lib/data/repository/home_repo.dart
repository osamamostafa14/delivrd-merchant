import 'package:delivrd_driver/data/datasource/remote/dio/dio_client.dart';
import 'package:delivrd_driver/data/datasource/remote/exception/api_error_handler.dart';
import 'package:delivrd_driver/data/model/response/base/api_response.dart';
import 'package:delivrd_driver/utill/app_constants.dart';


class HomeRepo {
  final DioClient? dioClient;

  HomeRepo({this.dioClient});

  Future<ApiResponse> getRunningList(String offset, String token) async {
    try {
      final response = await dioClient!.get('${AppConstants.ORDER_LIST_URI}?limit=10&offset=$offset&token=$token');
      print('running true /////////////');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('running false /////////////');
      print(e);
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getAcceptedList(String offset, String token) async {
    try {
      final response = await dioClient!.get('${AppConstants.ACCEPTED_LIST_URI}?limit=10&offset=$offset&token=$token');
      print('running true /////////////');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('running false /////////////');
      print(e);
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getHistoryList(String offset, String token) async {
    try {
      final response = await dioClient!.get('${AppConstants.HISTORY_LIST_URI}?limit=10&offset=$offset&token=$token');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> acceptRejectOrder(String orderStatus, String orderId, String expectedEndTime) async {
    try {
      final response = await dioClient!.post('${AppConstants.ACCEPT_REJECT_URI}?order_status=$orderStatus&order_id=$orderId&expected_end_date=$expectedEndTime');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateStatus(int status, String token) async {
    try {
      final response = await dioClient!.post('${AppConstants.UPDATE_STATUS_URI}?status=$status&token=$token');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}