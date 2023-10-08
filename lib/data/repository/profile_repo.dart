import 'dart:convert';
import 'dart:io';
import 'package:delivrd_driver/data/datasource/remote/dio/dio_client.dart';
import 'package:delivrd_driver/data/datasource/remote/exception/api_error_handler.dart';
import 'package:delivrd_driver/data/model/response/base/api_response.dart';
import 'package:delivrd_driver/data/model/signup_model.dart';
import 'package:delivrd_driver/utill/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class ProfileRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  ProfileRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getUserInfo() async {
    try {
      final response = await dioClient!.get('${AppConstants.PROFILE_URI}${sharedPreferences!.getString(AppConstants.TOKEN)}');
      print('succeed ///');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('error here ///');
      print(e);
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<http.StreamedResponse> updateProfile(
      SignUpModel? signUpModel,
      String token,
      ) async {

    print(jsonEncode(signUpModel));
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.UPDATE_PROFILE_URI}'));
    // request.headers.addAll(<String,String>{'Authorization': 'Bearer ${token}'});

    // if(bgCheck != null) {
    //   print('id image /////');
    //   print('----------------${bgCheck!.readAsBytes().asStream()}/${bgCheck.lengthSync()}/${bgCheck.path.split('/').last}');
    //   request.files.add(http.MultipartFile('bg_check_image', new http.ByteStream(DelegatingStream.typed(bgCheck.openRead())), bgCheck.lengthSync(), filename: bgCheck.path.split('/').last));
    // }

    Map<String, String> _fields = Map();
    {
      _fields.addAll(<String, String>{
        '_method': 'post',
        'token': token,
        'full_name': signUpModel!.fullName,
        'workshop_name': signUpModel!.workshopName,
        'phone': signUpModel!.phone,
        'password': signUpModel!.password,
      });
    }
    request.fields.addAll(_fields);

    http.StreamedResponse response = await request.send();
    print("Test responce");
    //
    print(response);
    return response;

  }

}
