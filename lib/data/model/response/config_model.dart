class ConfigModel {
  String? _appName;
  String? _appLogo;
  String? _appAddress;
  String? _appPhone;
  String? _appEmail;
  BaseUrls? _baseUrls;
  String? _currencySymbol;
  String? _cashOnDelivery;
  String? _digitalPayment;
  String? _termsAndConditions;
  String? _privacyPolicy;
  String? _aboutUs;
  AppLocationCoverage? _appLocationCoverage;

  ConfigModel(
      {String? appName,
        String? appLogo,
        String? appAddress,
        String? appPhone,
        String? appEmail,
        BaseUrls? baseUrls,
        String? currencySymbol,
        String? cashOnDelivery,
        String? digitalPayment,
        String? termsAndConditions,
        String? privacyPolicy,
        String? aboutUs,
        AppLocationCoverage? appLocationCoverage,
       }) {
    this._appName = appName;
    this._appLogo = appLogo;
    this._appAddress = appAddress;
    this._appPhone = appPhone;
    this._appEmail = appEmail;
    this._baseUrls = baseUrls;
    this._currencySymbol = currencySymbol;
    this._cashOnDelivery = cashOnDelivery;
    this._digitalPayment = digitalPayment;
    this._termsAndConditions = termsAndConditions;
    this._aboutUs = aboutUs;
    this._privacyPolicy = privacyPolicy;
    this._appLocationCoverage = appLocationCoverage;

  }

  String? get appName => _appName;
  String? get appLogo => _appLogo;
  String? get appAddress => _appAddress;
  String? get appPhone => _appPhone;
  String? get appEmail => _appEmail;
  BaseUrls? get baseUrls => _baseUrls;
  String? get currencySymbol => _currencySymbol;
  String? get cashOnDelivery => _cashOnDelivery;
  String? get digitalPayment => _digitalPayment;
  String? get termsAndConditions => _termsAndConditions;
  String? get aboutUs=> _aboutUs;
  String? get privacyPolicy=> _privacyPolicy;
  AppLocationCoverage? get appLocationCoverage => _appLocationCoverage;


  ConfigModel.fromJson(Map<String, dynamic> json) {
    _appName = json['store_name'];
    _appLogo = json['store_logo'];
    _appAddress = json['store_address'];
    _appPhone = json['app_phone'];
    _appEmail = json['app_email'];
    _baseUrls = json['base_urls'] != null
        ? new BaseUrls.fromJson(json['base_urls'])
        : null;
    _currencySymbol = json['currency_symbol'];
    _cashOnDelivery = json['cash_on_delivery'];
    _digitalPayment = json['digital_payment'];
    _termsAndConditions = json['terms_and_conditions'];
    _privacyPolicy = json['privacy_policy'];
    _aboutUs = json['about_us'];
    _appLocationCoverage = json['restaurant_location_coverage'] != null
        ? new AppLocationCoverage.fromJson(json['restaurant_location_coverage']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_name'] = this._appName;
    data['restaurant_logo'] = this._appLogo;
    data['restaurant_address'] = this._appAddress;
    data['app_phone'] = this._appPhone;
    data['app_email'] = this._appEmail;
    if (this._baseUrls != null) {
      data['base_urls'] = this._baseUrls!.toJson();
    }
    data['currency_symbol'] = this._currencySymbol;
    data['cash_on_delivery'] = this._cashOnDelivery;
    data['digital_payment'] = this._digitalPayment;
    data['terms_and_conditions'] = this._termsAndConditions;
    data['privacy_policy'] = this.privacyPolicy;
    data['about_us'] = this.aboutUs;
    if (this._appLocationCoverage != null) {
      data['restaurant_location_coverage'] = this._appLocationCoverage!.toJson();
    }

    return data;
  }
}

class BaseUrls {
  String? _customerImageUrl;
  String? _notificationImageUrl;
  String? _appImageUrl;
  String? _deliveryManImageUrl;
  String? _chatImageUrl;
  String? _orderImageUrl;

  BaseUrls(
      {
        String? customerImageUrl,
        String? notificationImageUrl,
        String? appImageUrl,
        String? deliveryManImageUrl,
        String? chatImageUrl,
        String? orderImageUrl,
      }) {
    this._customerImageUrl = customerImageUrl;
    this._notificationImageUrl = notificationImageUrl;
    this._appImageUrl = appImageUrl;
    this._deliveryManImageUrl = deliveryManImageUrl;
    this._chatImageUrl = chatImageUrl;
    this._orderImageUrl = orderImageUrl;
  }

  String? get customerImageUrl => _customerImageUrl;
  String? get notificationImageUrl => _notificationImageUrl;
  String? get appImageUrl => _appImageUrl;
  String? get deliveryManImageUrl => _deliveryManImageUrl;
  String? get chatImageUrl => _chatImageUrl;
  String? get orderImageUrl => _orderImageUrl;

  BaseUrls.fromJson(Map<String, dynamic> json) {
    _customerImageUrl = json['customer_image_url'];
    _notificationImageUrl = json['notification_image_url'];
    _appImageUrl = json['restaurant_image_url'];
    _deliveryManImageUrl = json['delivery_man_image_url'];
    _chatImageUrl = json['chat_image_url'];
    _orderImageUrl = json['order_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_image_url'] = this._customerImageUrl;
    data['notification_image_url'] = this._notificationImageUrl;
    data['restaurant_image_url'] = this._appImageUrl;
    data['delivery_man_image_url'] = this._deliveryManImageUrl;
    data['chat_image_url'] = this._chatImageUrl;
    data['order_image_url'] = this._orderImageUrl;
    return data;
  }
}

class AppLocationCoverage {
  String? _longitude;
  String? _latitude;
  double? _coverage;

  AppLocationCoverage(
      {String? longitude, String? latitude, double? coverage}) {
    this._longitude = longitude!;
    this._latitude = latitude!;
    this._coverage = coverage!;
  }

  String? get longitude => _longitude;
  String? get latitude => _latitude;
  double? get coverage => _coverage;

  AppLocationCoverage.fromJson(Map<String, dynamic> json) {
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _coverage = json['coverage'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['longitude'] = this._longitude;
    data['latitude'] = this._latitude;
    data['coverage'] = this._coverage;
    return data;
  }
}

