import 'dart:convert';
import 'dart:io';
import 'package:delivrd_driver/data/model/response/base/api_response.dart';
import 'package:delivrd_driver/data/model/response/base/error_response.dart';
import 'package:delivrd_driver/data/model/response/response_model.dart';
import 'package:delivrd_driver/data/model/signup_model.dart';
import 'package:delivrd_driver/data/repository/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  final AuthRepo? authRepo;
  AuthProvider({@required this.authRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // for login section
  String? _loginErrorMessage = '';
  String? get loginErrorMessage => _loginErrorMessage;

  bool _isPhoneNumberVerificationButtonLoading = false;
  bool get isPhoneNumberVerificationButtonLoading => _isPhoneNumberVerificationButtonLoading;

  String? _verificationMsg = '';
  String? get verificationMessage => _verificationMsg;

  String? _email = '';
  String? get email => _email;

  String? _registrationErrorMessage = '';
  String? get registrationErrorMessage => _registrationErrorMessage;

  bool _deletionIsLoading = false;
  bool get deletionIsLoading => _deletionIsLoading;

  bool _passIsLoading = false;
  bool get passIsLoading => _passIsLoading;

  // for forgot password
  bool _isForgotPasswordLoading = false;
  bool get isForgotPasswordLoading => _isForgotPasswordLoading;

  Future<ResponseModel> forgetPassword(String email) async {
    _isForgotPasswordLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.forgetPassword(email);
    _isForgotPasswordLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    return responseModel;
  }

  Future<ResponseModel> resetPassword(String resetToken, String password, String confirmPassword) async {
    _isForgotPasswordLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.resetPassword(resetToken, password, confirmPassword);
    _isForgotPasswordLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    return responseModel;
  }

  Future<ResponseModel> checkEmail(String email) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.checkEmail(email);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response!.data["token"]);
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  Future<ResponseModel> login({String? emailAddress, String? password}) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.login(emailAddress: emailAddress, password: password);

    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
     _isLoading = false;
      Map map = apiResponse.response!.data;
      String token = map["token"];
      authRepo!.saveUserToken(token);
      responseModel = ResponseModel(true, '');
      await authRepo!.updateToken();
    } else {
      _isLoading = false;
      String? errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message;
      }
      _loginErrorMessage = errorMessage;
      responseModel = ResponseModel(false,errorMessage);
    }
    notifyListeners();
    return responseModel;
  }



  Future<ResponseModel> registration(SignUpModel? signUpModel, File? bgCheck) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel _responseModel;
    http.StreamedResponse response = await authRepo!.registration(signUpModel,bgCheck);

    if (response.statusCode == 200) {
      _isLoading = false;
      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["message"];
      _responseModel = ResponseModel(true, message);

      String token = map["token"];
      print('token ////');
      print(token);
      authRepo!.saveUserToken(token);

    } else {
      //_isLoading = false;
      _responseModel = ResponseModel(false, '${response.statusCode} ${response.reasonPhrase}');
      print('${response.statusCode} ${response.reasonPhrase}');
    }
    notifyListeners();
    return _responseModel;
  }

  Future<void> updateToken() async {
    ApiResponse apiResponse = await authRepo!.updateToken();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      print(errorMessage);
    }
  }

  Future<void> deleteAccount({required String token,  Function? callback}) async {
    _deletionIsLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.deleteAccount(token);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _deletionIsLoading = false;
      callback!(true);
    } else {
      _deletionIsLoading = false;
      callback!(false);
      //   ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> checkPassword({required String token, required String password, Function? callback}) async {
    _passIsLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.checkPassword(token, password);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _passIsLoading = false;
      callback!(true);
    } else {
      _passIsLoading = false;
      callback!(false);
      //   ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<ResponseModel> verifyEmail(String email) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();

    ApiResponse apiResponse = await authRepo!.verifyEmail(email, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> verifyToken(String email) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.verifyToken(email, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    return responseModel;
  }


  // for verification Code
  String _verificationCode = '';

  String get verificationCode => _verificationCode;
  bool _isEnableVerificationCode = false;

  bool get isEnableVerificationCode => _isEnableVerificationCode;

  updateVerificationCode(String query) {
    if (query.length == 4) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    print('verification code ---- ${_verificationCode}');
    notifyListeners();
  }

  // for Remember Me Section

  bool _isActiveRememberMe = false;

  bool get isActiveRememberMe => _isActiveRememberMe;

  toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }

  bool isLoggedIn() {
    return authRepo!.isLoggedIn();
  }

  Future<bool> clearSharedData() async {
    return await authRepo!.clearSharedData();
  }

  void saveUserNumberAndPassword(String number, String password) {
    authRepo!.saveUserNumberAndPassword(number, password);
  }

  String? getUserEmail() {
    return authRepo!.getUserEmail();
  }

  String? getUserPassword() {
    return authRepo!.getUserPassword();
  }

  Future<bool> clearUserEmailAndPassword() async {
    return authRepo!.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo!.getUserToken();
  }

}