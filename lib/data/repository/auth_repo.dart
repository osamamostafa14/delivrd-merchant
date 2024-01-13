import 'dart:convert';
import 'dart:io';
import 'package:delivrd_driver/data/datasource/remote/dio/dio_client.dart';
import 'package:delivrd_driver/data/datasource/remote/exception/api_error_handler.dart';
import 'package:delivrd_driver/data/model/response/base/api_response.dart';
import 'package:delivrd_driver/data/model/signup_model.dart';
import 'package:delivrd_driver/utill/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class AuthRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  AuthRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> login({String? emailAddress, String? password}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.LOGIN_URI,
        data: {"email": emailAddress, "password": password},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  //
  // Future<ApiResponse> registration(SignUpModel signUpModel, File) async {
  //
  //   try {
  //     Response response = await dioClient!.post(
  //       AppConstants.REGISTER_URI,
  //       data: signUpModel.toJson(),
  //     );
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }

  Future<http.StreamedResponse> registration(SignUpModel? signUpModel) async {
    print('signUpModel ///////////////////');
    print(jsonEncode(signUpModel));

    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.REGISTER_URI}'));
   // request.headers.addAll(<String,String>{'Authorization': 'Bearer ${token}'});



    // if(aseCertificate != null) {
    //   print('----------------${aseCertificate.readAsBytes().asStream()}/${aseCertificate.lengthSync()}/${aseCertificate.path.split('/').last}');
    //   request.files.add(http.MultipartFile('ase_certificate_file', new http.ByteStream(DelegatingStream.typed(aseCertificate.openRead())), aseCertificate.lengthSync(), filename: aseCertificate.path.split('/').last));
    // }


    // if(bgCheck != null) {
    //   print('----------------${bgCheck.readAsBytes().asStream()}/${bgCheck.lengthSync()}/${bgCheck.path.split('/').last}');
    //   request.files.add(http.MultipartFile('bg_check_file', new http.ByteStream(DelegatingStream.typed(bgCheck.openRead())), bgCheck.lengthSync(), filename: bgCheck.path.split('/').last));
    // }

    Map<String, String> _fields = Map();
    {
      _fields.addAll(<String, String>{
        '_method': 'post',
        'full_name': signUpModel!.fullName,
        'workshop_name': signUpModel.workshopName,
        'phone': signUpModel.phone,
        'email': signUpModel.email,
        'password': signUpModel.password,
        'latitude': signUpModel.latitude,
        'longitude': signUpModel.longitude,
        'address': signUpModel.address,
        'referral_source': signUpModel.referralSource!,
      });
    }
    request.fields.addAll(_fields);

    http.StreamedResponse response = await request.send();
    print("Test response");
    print(jsonEncode(response.statusCode));
    return response;

  }

  Future<ApiResponse> checkEmail(String email) async {
    try {
      Response response = await dioClient!.post(AppConstants.CHECK_EMAIL_URI, data: {"email": email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient!.token = token;
    dioClient!.dio!.options.headers = {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'};

    try {
      await sharedPreferences!.setString(AppConstants.TOKEN, token);
    } catch (e) {
      throw e;
    }
  }

  Future<ApiResponse> updateToken() async {
    try {
      String? _deviceToken;
      if (!Platform.isAndroid) {
        NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
          alert: true, announcement: false, badge: true, carPlay: false,
          criticalAlert: false, provisional: false, sound: true,
        );
        if(settings.authorizationStatus == AuthorizationStatus.authorized) {
          _deviceToken = await _saveDeviceToken();
        }
      }else {
        _deviceToken = await _saveDeviceToken();
      }
      print('device token: ${_deviceToken}');
      Response response = await dioClient!.post(
        AppConstants.TOKEN_URI,
        data: {"_method": "put", "fcm_token": _deviceToken, "token": sharedPreferences!.get(AppConstants.TOKEN)},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyEmail(String email, String token) async {
    print('verify code 2 ---- ${token}');
    try {

      Response response = await dioClient!.post(AppConstants.VERIFY_EMAIL_URI, data: {"email": email, "token": token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyToken(String email, String token) async {
    try {
      Response response = await dioClient!.post(AppConstants.VERIFY_TOKEN_URI, data: {"email": email, "reset_token": token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  // for forgot password
  Future<ApiResponse> forgetPassword(String email) async {
    try {
      Response response = await dioClient!.post(AppConstants.FORGET_PASSWORD_URI, data: {"email": email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> resetPassword(String resetToken, String password, String confirmPassword) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.RESET_PASSWORD_URI,
        data: {"_method": "put", "reset_token": resetToken, "password": password, "confirm_password": confirmPassword},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deleteAccount(String token) async {
    try {
      final response = await dioClient!.post('${AppConstants.DELETE_ACCOUNT}?token=$token');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> checkPassword(String token, String password) async {
    try {
      final response = await dioClient!.post('${AppConstants.CHECK_PASSWORD_URI}?token=$token&password=$password');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<String?> _saveDeviceToken() async {
    String? _deviceToken = await FirebaseMessaging.instance.getToken();
    if (_deviceToken != null) {
      print('--------Device Token---------- '+_deviceToken);
    }
    return _deviceToken;
  }

  String getUserToken() {
    return sharedPreferences!.getString(AppConstants.TOKEN) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences!.containsKey(AppConstants.TOKEN);
  }


  Future<bool> clearSharedData() async {
    return sharedPreferences!.remove(AppConstants.TOKEN);
    //return sharedPreferences.clear();
  }

  // for  Remember Email
  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences!.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences!.setString(AppConstants.USER_EMAIL, number);
    } catch (e) {
      throw e;
    }
  }

  String getUserEmail() {
    return sharedPreferences!.getString(AppConstants.USER_EMAIL) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences!.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences!.remove(AppConstants.USER_PASSWORD);
    return await sharedPreferences!.remove(AppConstants.USER_EMAIL);
  }
}