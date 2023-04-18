import 'dart:convert';

import 'package:delivrd_driver/data/model/orders_model.dart';
import 'package:delivrd_driver/data/model/response/base/api_response.dart';
import 'package:delivrd_driver/data/repository/home_repo.dart';
import 'package:flutter/material.dart';


class HomeProvider extends ChangeNotifier {
  final HomeRepo? homeRepo;

  HomeProvider({@required this.homeRepo});

  List<String> _runningOffsetList = [];
  List<String> _acceptedOffsetList = [];
  List<String> _historyOffsetList = [];

  int? _pageSize;
  int? get pageSize => _pageSize;

  bool _orderIsLoading = false;
  bool get orderIsLoading => _orderIsLoading;

  bool _acceptIsLoading = false;
  bool get acceptIsLoading => _acceptIsLoading;

  bool _historyIsLoading = false;
  bool get historyIsLoading => _historyIsLoading;

  bool _runningIsLoading = false;
  bool get runningIsLoading => _runningIsLoading;


  List<Order>? _runningOrderList;
  List<Order>? get runningOrderList => _runningOrderList;

  List<Order>? _acceptedOrderList;
  List<Order>? get acceptedOrderList => _acceptedOrderList;


  List<Order>? _historyOrderList;
  List<Order>? get historyOrderList => _historyOrderList;

  int? _totalRunningSize;
  int? get totalRunningSize => _totalRunningSize;

  int? _totalAcceptedSize;
  int? get totalAcceptedSize => _totalAcceptedSize;

  int? _totalHistorySize;
  int? get totalHistorySize => _totalHistorySize;

  List<int> _finishedList = [];
  List<int> get finishedList => _finishedList;

  List<int> _acceptedList = [];
  List<int> get acceptedList => _acceptedList;

  List<int> _cancelledList = [];
  List<int> get cancelledList => _cancelledList;

  int? _online = 3;
  int? get online => _online;


  void getRunningOrderList(BuildContext context, String offset, String token) async {

    _runningIsLoading = true;
    if (!_runningOffsetList.contains(offset)) {
      _runningOffsetList.add(offset);
      ApiResponse apiResponse = await homeRepo!.getRunningList(offset,token);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _runningIsLoading = false;
        print('running 1 -- ');
        if (offset == '1') {
          _runningOrderList = [];
        }
        _totalRunningSize = OrdersModel.fromJson(apiResponse.response!.data).totalSize;
     //   _runningOrderList!.addAll(OrdersModel.fromJson(apiResponse.response!.data).orders);

        List<Order> latestOrders = OrdersModel.fromJson(apiResponse.response!.data).orders;
        latestOrders.forEach((order) {
          if(_runningOrderList!.contains(order)){}else
            _runningOrderList!.add(order);
        });

        _pageSize = OrdersModel.fromJson(apiResponse.response!.data).totalSize;
        notifyListeners();
      } else {
        _runningIsLoading = false;
       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
      }
    } else {
      if(_runningIsLoading) {
        _runningIsLoading = false;
        notifyListeners();
      }
    }
    notifyListeners();
  }
  void getAcceptedOrderList(BuildContext context, String offset, String token) async {
    _orderIsLoading = true;
    if (!_acceptedOffsetList.contains(offset)) {
      _acceptedOffsetList.add(offset);
      ApiResponse apiResponse = await homeRepo!.getAcceptedList(offset,token);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _orderIsLoading = false;
        if (offset == '1') {
          _acceptedOrderList = [];

        }

        _totalAcceptedSize = OrdersModel.fromJson(apiResponse.response!.data).totalSize;
        //   _runningOrderList!.addAll(OrdersModel.fromJson(apiResponse.response!.data).orders);


        List<Order> latestOrders = OrdersModel.fromJson(apiResponse.response!.data).orders;
        latestOrders.forEach((order) {
          if(_acceptedOrderList!.contains(order)){}else
            _acceptedOrderList!.add(order);
        });

        notifyListeners();
      } else {
       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
      }
    } else {
      if(_orderIsLoading) {
        _orderIsLoading = false;
        notifyListeners();
      }
    }
    notifyListeners();
  }

  void getHistoryOrderList(BuildContext context, String offset, String token) async {
    _historyIsLoading = true;
    if (!_historyOffsetList.contains(offset)) {
      _historyOffsetList.add(offset);
      ApiResponse apiResponse = await homeRepo!.getHistoryList(offset,token);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _historyIsLoading = false;
        if (offset == '1') {
          _historyOrderList = [];
        }
        _totalHistorySize = OrdersModel.fromJson(apiResponse.response!.data).totalSize;
        //   _runningOrderList!.addAll(OrdersModel.fromJson(apiResponse.response!.data).orders);

        List<Order> latestOrders = OrdersModel.fromJson(apiResponse.response!.data).orders;
        latestOrders.forEach((order) {
          if(_historyOrderList!.contains(order)){}else
            _historyOrderList!.add(order);
        });

        _orderIsLoading = false;
        notifyListeners();
      } else {
        _historyIsLoading = false;
      //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
      }
    } else {
      if(_historyIsLoading) {
        _historyIsLoading = false;
        notifyListeners();
      }
    }
    notifyListeners();
  }


  void getRunningLatest(BuildContext context, String token) async {
    _runningIsLoading = true;
      ApiResponse apiResponse = await homeRepo!.getRunningList('1', token);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _runningIsLoading = false;
        _runningOrderList=[];
       List<Order> latestOrders = OrdersModel.fromJson(apiResponse.response!.data).orders;
       latestOrders.forEach((order) {

         if(_runningOrderList!.contains(order)){}else
         _runningOrderList!.add(order);
       });

        _totalRunningSize = OrdersModel.fromJson(apiResponse.response!.data).totalSize;

        print('running /////');
        print(jsonEncode(_runningOrderList));

        _pageSize = OrdersModel.fromJson(apiResponse.response!.data).totalSize;;
        notifyListeners();
      } else {
        _runningIsLoading = false;
       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
      }

    notifyListeners();
  }

  void getAcceptedLatest(BuildContext context, String token) async {
    _orderIsLoading = true;
    ApiResponse apiResponse = await homeRepo!.getAcceptedList('1', token);
    _orderIsLoading = false;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _acceptedOrderList=[];
      List<Order> latestOrders = OrdersModel.fromJson(apiResponse.response!.data).orders;
      latestOrders.forEach((order) {

        if(_acceptedOrderList!.contains(order)){}else
          _acceptedOrderList!.add(order);
      });

      _totalAcceptedSize = OrdersModel.fromJson(apiResponse.response!.data).totalSize;

      print('accepted /////');
      print(jsonEncode(_acceptedOrderList));

      _orderIsLoading = false;
      notifyListeners();
    } else {
      _orderIsLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }

    notifyListeners();
  }


  void getHistoryLatest(BuildContext context, String token) async {
    _historyIsLoading = true;
    ApiResponse apiResponse = await homeRepo!.getHistoryList('1', token);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _historyIsLoading = false;
      _historyOrderList=[];
      List<Order> latestOrders = OrdersModel.fromJson(apiResponse.response!.data).orders;
      latestOrders.forEach((order) {

        if(_historyOrderList!.contains(order)){}else
          _historyOrderList!.add(order);
      });

      _totalHistorySize = OrdersModel.fromJson(apiResponse.response!.data).totalSize;

      print('history /////');
      print(jsonEncode(_historyOrderList));

      notifyListeners();
    } else {
      _historyIsLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }

    notifyListeners();
  }

  void getRunningOld(BuildContext context, String token) async {


    ApiResponse apiResponse = await homeRepo!.getRunningList('1', token);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _runningOrderList=[];
      List<Order> latestOrders = OrdersModel.fromJson(apiResponse.response!.data).orders;
      latestOrders.forEach((order) {

        if(_runningOrderList!.contains(order)){}else
          _runningOrderList!.add(order);
      });

      _totalRunningSize = OrdersModel.fromJson(apiResponse.response!.data).totalSize;

      print('running /////');
      print(jsonEncode(_runningOrderList));

      _pageSize = OrdersModel.fromJson(apiResponse.response!.data).totalSize;
      _orderIsLoading = false;
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }

    notifyListeners();
  }

  void clearOffset() {

    _runningOffsetList.clear();
    _historyOffsetList.clear();
    _acceptedOffsetList.clear();

    notifyListeners();
  }

  void addFinishedList(int orderId) {
    _finishedList.add(orderId);
    notifyListeners();
  }

  void addAcceptedList(int orderId) {
    _acceptedList.add(orderId);
    notifyListeners();
  }

  void addCancelledList(int orderId) {
    _cancelledList.add(orderId);
    notifyListeners();
  }

  Future<void> acceptRejectOrder(BuildContext context,Order order, String orderStatus, String orderId, Function callback) async {
    _acceptIsLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await homeRepo!.acceptRejectOrder(orderStatus, orderId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _acceptIsLoading = false;
      String? _message;
      if(orderStatus == 'accepted'){
        _message = 'Order accepted';
      }else if(orderStatus == 'rejected'){
        _message = 'Order rejected';
      }else if(orderStatus == 'cancelled'){
        //_cancelledOrders.add(orderId);
        _message = 'Order cancelled';
        notifyListeners();
      }else if(orderStatus == 'on_the_way'){
        _message = 'Order is on the way';
        //  _onTheWayOrders.add(orderId);
        notifyListeners();
      }else if(orderStatus == 'finished'){
        //  _deliveredOrders.add(orderId);
        _message = 'Order finished';
        notifyListeners();
      }
      callback(true,order, _message, '$orderId');
    } else {
      _acceptIsLoading = false;
      callback(true,order, 'failed', '$orderId');
      //   ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> updateStatus(BuildContext context, int status, String token, Function callback) async {

    _online = status;
    notifyListeners();
    ApiResponse apiResponse = await homeRepo!.updateStatus(status, token);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      callback(true,'Status updated', status);
      _online = status;
      notifyListeners();
    } else {
      callback(false,'Failed', status);
      if(status == 1){
        _online = 0;
      }else if(status == 0){
        _online = 1;
      }

      notifyListeners();

      //   ApiChecker.checkApi(context, apiResponse);
    }
    print('_online status');
    print(_online);

    notifyListeners();
  }

  void setStatus(int status) {
    _online = status;
    _online = online;
    notifyListeners();
  }

}