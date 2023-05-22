class ServiceModel {
  int? _id;
  String? _name;
  String? _unitText;
  String? _description;
  String? _descriptionAr;
  String? _image;
  double? _price;
  double? _tax;
  String? _availableTimeStarts;
  String? _availableTimeEnds;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  String? _categoryId;
  double? _discount;
  String? _discountType;
  String? _taxType;


  ServiceModel(
      {int? id,
        String? name,
        String? unitText,
        String? description,
        String? descriptionAr,
        String? image,
        double? price,
        double? tax,
        String? availableTimeStarts,
        String? availableTimeEnds,
        int? status,
        String? createdAt,
        String? updatedAt,
        double? discount,
        String? discountType,
        String? taxType,
        String? categoryId,
      }) {
    this._id = id;
    this._name = name;
    this._unitText = unitText;
    this._description = description;
    this._descriptionAr = descriptionAr;
    this._image = image;
    this._price = price;
    this._tax = tax;
    this._availableTimeStarts = availableTimeStarts;
    this._availableTimeEnds = availableTimeEnds;
    this._status = status;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    //  this._attributes = attributes;
    this._categoryId = categoryId;
    this._discount = discount;
    this._discountType = discountType;
    this._taxType = taxType;
  }

  int? get id => _id;
  String? get name => _name;
  String? get unitText => _unitText;
  String? get description => _description;
  String? get descriptionAr => _descriptionAr;
  String? get image => _image;
  double? get price => _price;

  double? get tax => _tax;
  String? get availableTimeStarts => _availableTimeStarts;
  String? get availableTimeEnds => _availableTimeEnds;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get categoryId => _categoryId;
  double? get discount => _discount;
  String? get discountType => _discountType;
  String? get taxType => _taxType;

  ServiceModel.fromJson(Map<String?, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _unitText = json['unit_text'];
    _description = json['description'];
    _descriptionAr = json['description_ar'];
    _image = json['image'];
    _price = json['price'].toDouble();

    _tax = json['tax'].toDouble();
    _availableTimeStarts = json['available_time_starts'];
    _availableTimeEnds = json['available_time_ends'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _categoryId = json['category_id'].toString();
    _discount = json['discount'].toDouble();
    _discountType = json['discount_type'];
    _taxType = json['tax_type'];

  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['unit_text'] = this._unitText;
    data['description'] = this._description;
    data['image'] = this._image;
    data['price'] = this._price;
    data['tax'] = this._tax;
    data['available_time_starts'] = this._availableTimeStarts;
    data['available_time_ends'] = this._availableTimeEnds;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['category_id'] = this._categoryId;
    data['discount'] = this._discount;
    data['discount_type'] = this._discountType;
    data['tax_type'] = this._taxType;

    return data;
  }
}