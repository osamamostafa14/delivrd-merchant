// import 'dart:convert';
//
// class MechanicModel {
//   int? _id;
//   String? _fullName;
//   String? _workshopName;
//   String? _phone;
//   String? _email;
//   String _latitude;
//   String? _longitude;
//   String? _address;
//   int? _status;
//   int? _coverage;
//   String? _image;
//   List<Prices>? _prices;
//   double? _distance;
//   String? _workStartTime;
//   String? _workEndTime;
//   List<dynamic>? _daysOff;
//
//   MechanicModel(
//       {int id,
//         String fullName,
//         String workshopName,
//         String phone,
//         String email,
//         String latitude,
//         String longitude,
//         String address,
//         int status,
//         int coverage,
//         String image,
//         List<Prices> prices,
//         double distance,
//         String workStartTime,
//         String workEndTime,
//         List<dynamic> daysOff,
//       }) {
//     this._id = id;
//     this._fullName = fullName;
//     this._workshopName = workshopName;
//     this._phone = phone;
//     this._email = email;
//     this._latitude = latitude;
//     this._longitude = longitude;
//     this._address = address;
//     this._status = status;
//     this._coverage = coverage;
//     this._image = image;
//     this._prices = prices;
//     this._distance = distance;
//     this._workStartTime = workStartTime;
//     this._workEndTime = workEndTime;
//     this._daysOff = daysOff;
//   }
//
//   int get id => _id;
//   String get fullName => _fullName;
//   String get workshopName => _workshopName;
//   String get phone => _phone;
//   String get email => _email;
//   String get latitude => _latitude;
//   String get longitude => _longitude;
//   String get address => _address;
//   int get status => _status;
//   int get coverage => _coverage;
//   String get image => _image;
//   List<Prices> get prices => _prices;
//   double get distance => _distance;
//
//   String get workStartTime => _workStartTime;
//   String get workEndTime => _workEndTime;
//   List<dynamic> get daysOff => _daysOff;
//
//   MechanicModel.fromJson(Map<String, dynamic> json) {
//     _id = json['id'];
//     _fullName = json['full_name'];
//     _phone = json['phone'];
//     _workshopName = json['workshop_name'];
//     _email = json['email'];
//     _latitude = json['latitude'].toString();
//     _longitude = json['longitude'].toString();
//     _address = json['address'];
//     _status = json['status'];
//     _coverage = json['coverage'];
//     _image = json['image'];
//     _distance = json['distance'];
//
//     if (json['mechanic_prices'] != null) {
//       _prices = [];
//       json['mechanic_prices'].forEach((v) {
//         _prices.add(new Prices.fromJson(v));
//       });
//     }
//
//     // if (json['days_off'] != null) {
//     //   _daysOff = [];
//     //   json['days_off'].forEach((v) {
//     //     _daysOff.add(v);
//     //   });
//     // }
//
//     _workStartTime = json['work_start_time'];
//     _workEndTime = json['work_end_time'];
//     if(json['days_off'] != null){
//       _daysOff = jsonDecode(json['days_off']);
//     }
//
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this._id;
//     data['full_name'] = this._fullName;
//     data['phone'] = this._phone;
//     data['workshop_name'] = this._workshopName;
//     data['email'] = this._email;
//     data['latitude'] = this._latitude;
//     data['longitude'] = this._longitude;
//     data['address'] = this._address;
//     data['status'] = this._status;
//     data['coverage'] = this._coverage;
//     data['image'] = this._image;
//     data['distance'] = this._distance;
//
//     if (this._prices != null) {
//       data['details'] = this._prices.map((v) => v.toJson()).toList();
//     }
//
//     data['work_start_time'] = this._workStartTime;
//     data['work_end_time'] = this._workEndTime;
//     data['days_off'] = this._daysOff;
//     return data;
//   }
// }
//
// class Prices {
//   int _id;
//   double _price;
//   int _serviceId;
//   int _tireId;
//   int _mechanicId;
//   Tire _tire;
//   String _createdAt;
//   String _updatedAt;
//
//   Prices(
//       {int id,
//         double price,
//         int serviceId,
//         int tireId,
//         int mechanicId,
//         Tire tire,
//         String createdAt,
//         String updatedAt,
//
//       }) {
//     this._id = id;
//     this._price = price;
//     this._serviceId = serviceId;
//     this._tireId = tireId;
//     this._mechanicId = mechanicId;
//     this._tire = tire;
//     this._createdAt = createdAt;
//     this._updatedAt = updatedAt;
//   }
//
//   int get id => _id;
//   double get price => _price;
//   int get serviceId => _serviceId;
//   int get tireId => _tireId;
//   int get mechanicId => _mechanicId;
//   Tire get tire => _tire;
//   String get createdAt => _createdAt;
//   String get updatedAt => _updatedAt;
//
//
//   Prices.fromJson(Map<String, dynamic> json) {
//     _id = json['id'];
//     _price = json['price'].toDouble();
//     _serviceId = json['service_id'];
//     _tireId = json['tire_id'];
//     _mechanicId = json['mechanic_id'];
//     _tire = json['tire'] != null
//         ? new Tire.fromJson(json['tire'])
//         : null;
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this._id;
//     data['price'] = this._price;
//     data['service_id'] = this._serviceId;
//     data['tire_id'] = this._tireId;
//     data['mechanic_id'] = this._mechanicId;
//
//     if (this._tire != null) {
//       data['tire'] = this._tire.toJson();
//     }
//     data['created_at'] = this._createdAt;
//     data['updated_at'] = this._updatedAt;
//
//     return data;
//   }
// }
