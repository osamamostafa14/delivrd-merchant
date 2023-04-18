class BankAccountsModel {
   int? _id;
   int? _companyId;
   int? _accountNumber;
   int? _routingNumber;
   String? _holderName;
   String? _bankName;
   String? _createdAt;
   String? _updatedAt;


  BankAccountsModel(
      {int? id,
        int? companyId,
        int? accountNumber,
        int? routingNumber,
        String? holderName,
        String? bankName,
        String? createdAt,
        String? updatedAt
      }) {
    this._id = id;
    this._companyId = companyId;
    this._accountNumber = accountNumber;
    this._routingNumber = routingNumber;
    this._holderName = holderName;
    this._bankName = bankName;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int? get id => _id;
  int? get companyId => _companyId;
  int? get accountNumber => _accountNumber;
  int? get routingNumber => _routingNumber;
  String? get holderName => _holderName;
  String? get bankName => _bankName;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  BankAccountsModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _companyId = json['company_id'];
    _accountNumber = json['account_number'];
    _routingNumber = json['routing_number'];
    _holderName = json['holder_name'];
    _bankName = json['bank_name'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['company_id'] = this._companyId;
    data['account_number'] = this._accountNumber;
    data['routing_number'] = this._routingNumber;
    data['holder_name'] = this._holderName;
    data['bank_name'] = this._bankName;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}