import 'dart:convert';
import 'dart:io';
import 'package:delivrd_driver/data/model/response/base/api_response.dart';
import 'package:delivrd_driver/data/model/response/response_model.dart';
import 'package:delivrd_driver/data/model/signup_model.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/view/screens/splash_screen.dart';
import 'package:http/http.dart' as http;
import 'package:delivrd_driver/data/repository/profile_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepo? profileRepo;

  ProfileProvider({@required this.profileRepo});

  SignUpModel? _userInfoModel;
  SignUpModel? get userInfoModel => _userInfoModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future getUserInfo(BuildContext context, [Function? callback]) async {
    ApiResponse apiResponse = await profileRepo!.getUserInfo();
    if(apiResponse.response!.data == 'invalid token'){
      Provider.of<AuthProvider>(context, listen: false).clearSharedData().then((condition) {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> SplashScreen()));
      });
    } else {
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _userInfoModel = SignUpModel.fromJson(apiResponse.response!.data);
        print('info model -- ${jsonEncode(_userInfoModel)}');
        if(callback!=null){
          callback(true);
        }

      } else {

        if (apiResponse.error is String) {
          print(apiResponse.error.toString());
        } else {
          print('error here 401 /// ');
        }
      }
    }
    notifyListeners();
  }


  Future<ResponseModel> updateProfile(
      SignUpModel? signUpModel,
      String token,
      ) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel _responseModel;
    http.StreamedResponse response = await profileRepo!.updateProfile(
        signUpModel,
        token,
    );
    _isLoading = false;
    if (response.statusCode == 200) {

      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["message"];
      _responseModel = ResponseModel(true, message);

    } else {
      _responseModel = ResponseModel(false, '${response.statusCode} ${response.reasonPhrase}');
      print('${response.statusCode} ${response.reasonPhrase}');
    }
    notifyListeners();
    return _responseModel;
  }

}
