class WithdrawalsModel {
  int? _totalSize;
  int? _totalPrice;
  int? _limit;
  String? _offset;
  late List<Withdrawal> _withdrawals;

  WithdrawalsModel(
      {int? totalSize,int? totalPrice, int? limit, String? offset,required List<Withdrawal> withdrawals}) {
    this._totalSize = totalSize;
    this._totalPrice = totalPrice;
    this._limit = limit;
    this._offset = offset;
    this._withdrawals = withdrawals;
  }

  int? get totalSize => _totalSize;
  int? get totalPrice => _totalPrice;
  int? get limit => _limit;
  String? get offset => _offset;
  List<Withdrawal> get withdrawals => _withdrawals;

  WithdrawalsModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _totalPrice = json['total_price'];
    if(json['limit'] is int){
      _limit = json['limit'];
    }else {
      _limit = int.parse(json['limit']);
    }

    _offset = json['offset'];
    if (json['withdrawals'] != null) {
      _withdrawals = [];
      json['withdrawals'].forEach((v) {
        _withdrawals.add(new Withdrawal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this._totalSize;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._withdrawals != null) {
      data['withdrawals'] = this._withdrawals.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Withdrawal {
  int? id;
  double? amount;
  int? status;
  int? bankAccountId;
  String? createdAt;
  String? updatedAt;

  Withdrawal(
      {this.id, this.amount, this.status,this.bankAccountId, this.createdAt, this.updatedAt});

  Withdrawal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'].toDouble();
    status = json['status'];
    if(json['bank_account_id'] is int){
      bankAccountId = json['bank_account_id'];
    }else {
      bankAccountId = int.parse(json['bank_account_id']);
    }

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['bank_account_id'] = this.bankAccountId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}