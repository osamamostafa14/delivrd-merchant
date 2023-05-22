import 'package:delivrd_driver/data/model/appointment_model.dart';

class OrdersModel {
  int? _totalSize;
  int? _totalPrice;
  int? _limit;
  String? _offset;
  late List<Order> _orders;

  OrdersModel(
      {int? totalSize,int? totalPrice, int? limit, String? offset,required List<Order> orders}) {
    this._totalSize = totalSize;
    this._totalPrice = totalPrice;
    this._limit = limit;
    this._offset = offset;
    this._orders = orders;
  }

  int? get totalSize => _totalSize;
  int? get totalPrice => _totalPrice;
  int? get limit => _limit;
  String? get offset => _offset;
  List<Order> get orders => _orders;

  OrdersModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _totalPrice = json['total_price'];
    if(json['limit'] is int){
      _limit = json['limit'];
    }else {
      _limit = int.parse(json['limit']);
    }

    _offset = json['offset'];
    if (json['orders'] != null) {
      _orders = [];
      json['orders'].forEach((v) {
        _orders.add(new Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this._totalSize;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._orders != null) {
      data['orders'] = this._orders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
  int? _id;
  int? _userId;
  double? _totalPrice;
  double? _distance;
  int? _serviceId;
  String? _serviceName;
  String? _orderStatus;
  String? _paymentMethod;
  String? _transactionReference;
  late String _userLocation;
  String? _vehicleInfo;
   String? _mechanicLocation;
  String? _createdAt;
  String? _updatedAt;
  int? _mechanicId;
  String? _orderNote;
  String? _fullName;
  String? _phoneNumber;
  CustomerOrderModel? _customer;
  String? _tireImage;
  AppointmentModel? _appointment;

  Order({int? id,
    int? userId,
    double? totalPrice,
    double? distance,
    int? serviceId,
    String? serviceName,
    String? orderStatus,
    String? paymentMethod,
    String? transactionReference,
    required String userLocation,
    String? vehicleInfo,
    String? mechanicLocation,
    String? createdAt,
    String? updatedAt,
    int? mechanicId,
    String? orderNote,
    String? fullName,
    String? phoneNumber,
    CustomerOrderModel? customer,
    String? tireImage,
    AppointmentModel? appointment,

  }) {
    this._id = id;
    this._userId = userId;
    this._totalPrice = totalPrice;
    this._distance = distance;
    this._serviceId = serviceId;
    this._serviceName = serviceName;
    this._orderStatus = orderStatus;
    this._paymentMethod = paymentMethod;
    this._transactionReference = transactionReference;
    this._userLocation = userLocation;
    this._vehicleInfo = vehicleInfo;
    this._mechanicLocation = mechanicLocation;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._mechanicId = mechanicId;
    this._orderNote = orderNote;
    this._fullName = fullName;
    this._phoneNumber = phoneNumber;
    this._customer = customer;
    this._tireImage = tireImage;
    this._appointment = appointment;
  }

  int? get id => _id;

  int? get userId => _userId;

  double? get totalPrice => _totalPrice;

  double? get distance => _distance;

  int? get serviceId => _serviceId;

  String? get serviceName => _serviceName;

  String? get orderStatus => _orderStatus;

  String? get paymentMethod => _paymentMethod;

  String? get transactionReference => _transactionReference;

  String get userLocation => _userLocation;

  String? get vehicleInfo => _vehicleInfo;

  String? get mechanicLocation => _mechanicLocation;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  int? get mechanicId => _mechanicId;

  String? get orderNote => _orderNote;

  String? get fullName => _fullName;

  String? get phoneNumber => _phoneNumber;

  CustomerOrderModel? get customer => _customer;

  String? get tireImage => _tireImage;

  AppointmentModel? get appointment => _appointment;

  Order.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _totalPrice = json['total_price'].toDouble();
    _distance = json['distance']!= null? json['distance'].toDouble() : 0.0;
    _serviceId = json['service_id'];
    _serviceName = json['service_name'];
    _orderStatus = json['order_status'];
    _paymentMethod = json['payment_method'];
    _transactionReference = json['transaction_reference'];
    _userLocation = json['user_location'];
    _vehicleInfo = json['vehicle_info'];
    _mechanicLocation = json['mechanic_location'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _mechanicId = json['mechanic_id'];
    _orderNote = json['order_note'];
    _fullName = json['full_name'];
    _phoneNumber = json['phone_number'];
    _tireImage = json['tire_image'];
    _customer = json['customer'] != null
        ? new CustomerOrderModel.fromJson(json['customer'])
        : null;

    _appointment = json['appointment'] != null
        ? new AppointmentModel.fromJson(json['appointment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['user_id'] = this._userId;
    data['total_price'] = this._totalPrice;
    data['distance'] = this._distance;
    data['service_id'] = this._serviceId;
    data['service_name'] = this._serviceName;
    data['order_status'] = this._orderStatus;
    data['payment_method'] = this._paymentMethod;
    data['transaction_reference'] = this._transactionReference;
    data['user_location'] = this._userLocation;
    data['vehicle_info'] = this._vehicleInfo;
    data['mechanic_location'] = this._mechanicLocation;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['mechanic_id'] = this._mechanicId;
    data['order_note'] = this._orderNote;
    data['full_name'] = this._fullName;
    data['phone_number'] = this._phoneNumber;
    data['tire_image'] = this._tireImage;
    if (this._customer != null) {
      data['customer'] = this._customer!.toJson();
    }
    if (this._appointment != null) {
      data['appointment'] = this._appointment!.toJson();
    }

    return data;
  }
}

class CustomerOrderModel {
  int? _id;
  String? _fullName;
  String? _phone;

  CustomerOrderModel(
      {  int? id,
        String? fullName,
        String? phone,
      }) {
    this._id = id;
    this._fullName = fullName;
    this._phone = phone;
  }

  int? get id => _id;
  String? get fullName => _fullName;
  String? get phone => _phone;

  CustomerOrderModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _fullName = json['full_name'];
    _phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['full_name'] = this._fullName;
    data['phone'] = this._phone;

    return data;
  }
}



