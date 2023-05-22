class Tire {
  int? _id;
  double? _price;
  String? _vsa;
  String? _acr;
  String? _createdAt;
  String? _updatedAt;

  Tire(
      {int? id,
        double? price,
        String? vsa,
        String? acr,
        String? createdAt,
        String? updatedAt,
      }) {
    this._id = id;
    this._price = price;
    this._vsa = vsa;
    this._acr = acr;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int? get id => _id;
  double? get price => _price;
  String? get vsa => _vsa;
  String? get acr => _acr;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;


  Tire.fromJson(Map<String?, dynamic> json) {
    _id = json['id'];
    _price = json['price'].toDouble();
    _vsa = json['vsa'];
    _acr = json['acr'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];

  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['id'] = this._id;
    data['price'] = this._price;
    data['vsa'] = this._vsa;
    data['acr'] = this._acr;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;

    return data;
  }
}