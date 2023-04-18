class SignUpModel {
  late String fullName;
  late String workshopName;
  late String businessName;
  late String taxId;
  late String phone;
  late String email;
  late String password;
  late String latitude;
  late String longitude;
  late String address;
  late double? walletBalance;
  late double? totalEarnings;
  late int coverage;
  int? status;
  int? online;
   //String? aseCertificate;
   String? bgCheck;
  // String? birthday;
  // String? securityNumber;
  // String? zipCode;

  SignUpModel({
    required this.fullName,
    required this.workshopName,
    required this.businessName,
    required this.taxId,
    required this.phone,
    required this.email,
    required this.password,
    required this.latitude,
    required this.longitude,
    required this.address,
     this.walletBalance,
    this.totalEarnings,
    required this.coverage,
    this.status,
    this.online,
   // this.aseCertificate,
    this.bgCheck,
    // this.birthday,
    // this.securityNumber,
    // this.zipCode,
  });

  SignUpModel.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    workshopName = json['workshop_name'];
    businessName = json['business_name'] ?? '';
    taxId = json['tax_id'].toString();
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    walletBalance = json['wallet_balance'].toDouble();
    totalEarnings = json['total_earnings'].toDouble();
    coverage = json['coverage'];
    status = json['status'];
    online = json['online'];
  //  aseCertificate = json['ase_certificate'];
    bgCheck = json['bg_check'];

    // birthday = json['birthday'];
    // securityNumber = json['security_number'];
    // zipCode = json['zip_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['workshop_name'] = this.workshopName;
    data['business_name'] = this.businessName;
    data['tax_id'] = this.taxId;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['wallet_balance'] = this.walletBalance;
    data['total_earnings'] = this.totalEarnings;
    data['coverage'] = this.coverage;
    data['status'] = this.status;
    data['online'] = this.online;
   // data['ase_certificate'] = this.aseCertificate;
    data['bg_check'] = this.bgCheck;

    // data['birthday'] = this.birthday;
    // data['security_number'] = this.securityNumber;
    // data['zip_code'] = this.zipCode;

    return data;
  }
}
