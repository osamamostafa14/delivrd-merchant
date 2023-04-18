import 'package:delivrd_driver/data/model/orders_model.dart';
import 'package:delivrd_driver/data/model/response/base/api_response.dart';
import 'package:delivrd_driver/data/model/response/base/error_response.dart';
import 'package:delivrd_driver/data/model/response/response_model.dart';
import 'package:delivrd_driver/data/model/withdrawals_model.dart';
import 'package:delivrd_driver/data/repository/financials_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FinancialsProvider with ChangeNotifier {
  final FinancialsRepo? financialsRepo;

  FinancialsProvider({@required this.financialsRepo});

  bool _loadingStats = false;
  bool get loadingStats => _loadingStats;

  bool _loadingWithdrawals = false;
  bool get loadingWithdrawals => _loadingWithdrawals;

  List<String> _offsetList = [];
  List<String> _offsetStatsList = [];

  List<String> _withdrawalsOffsetList = [];

  List<Order>? _ordersStatsList = [];
  List<Order>? get ordersStatsList => _ordersStatsList;

  List<Withdrawal> _withdrawalsList = [];
  List<Withdrawal> get withdrawalsList => _withdrawalsList;

  bool _isLoadingWithdrawals = false;
  bool get isLoadingWithdrawals => _isLoadingWithdrawals;

  int? _totalStatsPageSize = 0;
  int? get totalStatsPageSize => _totalStatsPageSize;

  int? _totalWithdrawalsSize = 0;
  int? get totalWithdrawalsSize => _totalWithdrawalsSize;

  int? _totalStatsPrice;
  int? get totalStatsPrice => _totalStatsPrice;

  int? _totalPrice;
  int? get totalPrice => _totalPrice;

  int? _totalWithdrawalsAmount;
  int? get totalWithdrawalsAmount => _totalWithdrawalsAmount;

  bool _bottomLoading = false;
  bool get bottomLoading => _bottomLoading;

  bool _bottomLoadingWithdrawals = false;
  bool get bottomLoadingWithdrawals => _bottomLoadingWithdrawals;

  bool _loading = false;
  bool get loading => _loading;

  int? _value = 1;
  int? get value => _value;

  String? _offset;
  String? get offset => _offset;

  String? _offsetWithdrawal;
  String? get offsetWithdrawal => _offsetWithdrawal;

  String? _finalDate;
  String? get finalDate => _finalDate;

  String _startDate = '';
  String get startDate => _startDate;

  String _endDate = '';
  String get endDate => _endDate;

  String? _paymentMethod = 'All';
  String? get paymentMethod => _paymentMethod;

  void filterDateStats(BuildContext context, String offset, String? startDate, String? endDate, String? token) async {
    if(offset == '1'){
      _loadingStats = true;
    }

    if (!_offsetStatsList.contains(offset)) {
      _offsetStatsList.add(offset);
      ApiResponse apiResponse = await financialsRepo!.filterDateStats(offset, startDate, endDate, token);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _bottomLoading = false;

        if (offset == '1') {
          _ordersStatsList = [];
        }
        _totalStatsPageSize = OrdersModel.fromJson(apiResponse.response!.data).totalSize;
        _totalPrice = OrdersModel.fromJson(apiResponse.response!.data).totalPrice;
        _ordersStatsList!.addAll(OrdersModel.fromJson(apiResponse.response!.data).orders);
        _offset = OrdersModel.fromJson(apiResponse.response!.data).offset;
        _loadingStats = false;
      } else {
        _bottomLoading = false;
        _loadingStats = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
      }
    } else {
      if(_loadingStats) {
        _bottomLoading = false;
        _loadingStats = false;
        //notifyListeners();
      }
    }
    notifyListeners();
  }

  void getWithdrawals(BuildContext context, String offset, String? token, Function callback) async {
    if(offset == '1'){
      _loadingWithdrawals = true;
    }

    if (!_withdrawalsOffsetList.contains(offset)) {
      print('test - 1');
      _withdrawalsOffsetList.add(offset);
      ApiResponse apiResponse = await financialsRepo!.getWithdrawals(offset, token);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _bottomLoadingWithdrawals = false;
        if (offset == '1') {
          _withdrawalsList = [];
        }
        _totalWithdrawalsSize = WithdrawalsModel.fromJson(apiResponse.response!.data).totalSize;
        _totalWithdrawalsAmount = WithdrawalsModel.fromJson(apiResponse.response!.data).totalPrice;
        _withdrawalsList!.addAll(WithdrawalsModel.fromJson(apiResponse.response!.data).withdrawals);
        _offsetWithdrawal = WithdrawalsModel.fromJson(apiResponse.response!.data).offset;
        _loadingWithdrawals = false;
        callback(true);
      } else {
        _bottomLoadingWithdrawals = false;
        _loadingWithdrawals = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
        callback(false);
      }
    } else {
      print('test - 2');
      if(_loadingWithdrawals) {
        _bottomLoadingWithdrawals = false;
        _loadingWithdrawals = false;
        //notifyListeners();
      }
      callback(false);
    }
    notifyListeners();
  }


  Future<ResponseModel> withdrawMoney(String bankAccountId, String token, Function callback) async {
    _loading = true;
    notifyListeners();
    ApiResponse apiResponse = await financialsRepo!.withdrawMoney(bankAccountId, token);
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _loading = false;
      responseModel = ResponseModel(true, '');
      int result = apiResponse.response!.data["result"];
      if(result == 0){
        callback(true, apiResponse.response!.data["message"]);
      }else if(result == 1){
        callback(true, apiResponse.response!.data["message"]);
      }
    } else {
      _loading = false;
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
    notifyListeners();
    return responseModel;
  }

  void setDateValue(int value) {
    _value = value;
    notifyListeners();
  }

  void showBottomLoader() {
    _bottomLoading = true;
    notifyListeners();
  }
  void showBottomLoaderWithdrawal() {
    _bottomLoadingWithdrawals = true;
    notifyListeners();
  }
  void setFinalDate() {
    if(value == 1){
      _finalDate = 'Today';
    }else if(value == 2){
      _finalDate = 'Yesterday';
    }else if(value == 3){
      _finalDate = 'Last Month';
    } else if(value == 4){
      _finalDate = '$startDate   $endDate';
    }
    notifyListeners();
  }
  void clearOffset() {
    _offsetList.clear();
    _offsetStatsList.clear();
    _withdrawalsList.clear();
    _withdrawalsOffsetList.clear();
    notifyListeners();
  }
  void setStartDate(String startDate) {
    _startDate = startDate;
    _finalDate = startDate;
    notifyListeners();
  }
  void setEndDate(String endDate) {
    _endDate = endDate;
    _finalDate = endDate;
    notifyListeners();
  }
  void setPaymentMethod(String? method) {
    _paymentMethod = method;
    notifyListeners();
  }
}

