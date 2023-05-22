import 'dart:convert';
import 'package:delivrd_driver/data/model/bank_accounts_model.dart';
import 'package:delivrd_driver/data/model/response/base/api_response.dart';
import 'package:delivrd_driver/data/model/response/base/error_response.dart';
import 'package:delivrd_driver/data/model/response/response_model.dart';
import 'package:delivrd_driver/data/model/withdrawals_model.dart';
import 'package:delivrd_driver/data/repository/bank_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BankProvider with ChangeNotifier {
  final BankRepo? bankRepo;
  BankProvider({@required this.bankRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingAccounts = false;
  bool get isLoadingAccounts => _isLoadingAccounts;

  int _accountNumber = 0123456789876;
  int get accountNumber => _accountNumber;

  int _value = 0;
  int get value => _value;

  int? _bankId;
  int? get bankId => _bankId;

  String? _holderName = 'Account Name';
  String? get holderName => _holderName;

  List<BankAccountsModel> _accountModel = [];
  List<BankAccountsModel> get accountModel => _accountModel;


  Future<ResponseModel> addCard(String routingNo, String accountNumber, String holderName,String token, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await bankRepo!.addCard(routingNo: routingNo, accountNumber: accountNumber, holderName: holderName, token:token);
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      callback(true, 'success');
      responseModel = ResponseModel(true, 'successful');
    } else {
      callback(false, 'failed');
      String errorMessage;
      _isLoading = false;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      print(errorMessage);
      responseModel = ResponseModel(false, errorMessage);
    }

    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateCard(String routingNo,String accountNumber, String holderName, int? id,String token, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await bankRepo!.updateCard(routingNo: routingNo, accountNumber: accountNumber, holderName: holderName,id: id, token: token );
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      print('success ----- ');
      _isLoading = false;
      callback(true, 'success');
      responseModel = ResponseModel(true, 'successful');
    } else {
      print('failed ----- ');
      callback(false, 'failed');
      String errorMessage;
      _isLoading = false;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      print(errorMessage);
      responseModel = ResponseModel(false, errorMessage);
    }

    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> getAccounts(BuildContext context, String token) async {
    _isLoadingAccounts = true;
    ApiResponse apiResponse = await bankRepo!.getAccounts(token);
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, 'successful');
      _isLoadingAccounts = false;
      _accountModel = [];
      apiResponse.response!.data.forEach((model) {
        if(_accountModel.contains(model)){}else{
          _accountModel.add(BankAccountsModel.fromJson(model));
        }
      });

      notifyListeners();
    } else {

      _isLoadingAccounts = false;
    //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
      responseModel = ResponseModel(false, apiResponse.error.toString());
    }
    return responseModel;
  }

  void deleteBankAccount(int? accountId, int index,String token, Function callback) async {
    _isLoadingAccounts = true;
    notifyListeners();
    ApiResponse apiResponse = await bankRepo!.removeBankAccount(accountId, token);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoadingAccounts = false;
      _accountModel.removeAt(index);
      callback(true, 'Deleted account successfully');
    } else {
      _isLoadingAccounts = false;
      String? errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message;
      }

      callback(false, errorMessage);
    }
    notifyListeners();
  }



  void setAccountNumber(String text) async {
    _accountNumber = int.parse(text);
    notifyListeners();
  }
  void setHolderName(String? text) async {
    _holderName = text;
    notifyListeners();
  }
  void setValue(int value) async {
    _value = value;
    notifyListeners();
  }
  void setBankId(int? bankId) async {
    _bankId = bankId;
    notifyListeners();
  }
}

