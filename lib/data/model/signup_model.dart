import 'dart:convert';

class SignUpModel {
  late String fullName;
  late String workshopName;
  late String phone;
  late String email;
  late String password;
  late String latitude;
  late String longitude;
  late String address;
  late double? walletBalance;
  late double? totalEarnings;
  int? status;
  int? online;
   //String? aseCertificate;
  String? workStartTime;
  String? workEndTime;
  List<dynamic>? daysOff;
  // String? birthday;
  // String? securityNumber;
  // String? zipCode;
  String? referralSource;

  SignUpModel({
    required this.fullName,
    required this.workshopName,
    required this.phone,
    required this.email,
    required this.password,
    required this.latitude,
    required this.longitude,
    required this.address,
     this.referralSource,
     this.walletBalance,
    this.totalEarnings,
    this.status,
    this.online,
   // this.aseCertificate,
    // this.birthday,
    // this.securityNumber,
    // this.zipCode,
    String? workStartTime,
    String? workEndTime,
    List<dynamic>? daysOff,
  });

  SignUpModel.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    workshopName = json['workshop_name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    walletBalance = json['wallet_balance'].toDouble();
    totalEarnings = json['total_earnings'].toDouble();
    status = json['status'];
    online = json['online'];
  //  aseCertificate = json['ase_certificate'];

    workStartTime = json['work_start_time'];
    workEndTime = json['work_end_time'];
    if(json['days_off'] != null){
      daysOff = jsonDecode(json['days_off']);
    }

    // birthday = json['birthday'];
    // securityNumber = json['security_number'];
    // zipCode = json['zip_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['workshop_name'] = this.workshopName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['wallet_balance'] = this.walletBalance;
    data['total_earnings'] = this.totalEarnings;
    data['status'] = this.status;
    data['online'] = this.online;
   // data['ase_certificate'] = this.aseCertificate;

    // data['birthday'] = this.birthday;
    // data['security_number'] = this.securityNumber;
    // data['zip_code'] = this.zipCode;

    data['work_start_time'] = this.workStartTime;
    data['work_end_time'] = this.workEndTime;
    data['days_off'] = this.daysOff;
    data['referral_source'] = this.referralSource;
    return data;
  }
}
