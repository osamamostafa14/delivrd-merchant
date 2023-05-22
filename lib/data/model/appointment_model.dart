import 'package:delivrd_driver/data/model/service_model.dart';
import 'package:delivrd_driver/data/model/tire_model.dart';

class AppointmentModel {
  int? _id;
  String? _appointmentDate;
  String? _expectedEndDate;
  int? _acceptedByMerchant;
  ServiceModel? _service;
  Tire? _tire;

  AppointmentModel(
      {  int? id,
        String? appointmentDate,
        String? expectedEndDate,
        int? acceptedByMerchant,
        ServiceModel? service,
        Tire? tire,
      }) {
    this._id = id;
    this._appointmentDate = appointmentDate;
    this._expectedEndDate = expectedEndDate;
    this._acceptedByMerchant = acceptedByMerchant;
    this._service = service;
    this._tire = tire;
  }

  int? get id => _id;
  String? get appointmentDate => _appointmentDate;
  String? get expectedEndDate => _expectedEndDate;
  int? get acceptedByMerchant => _acceptedByMerchant;
  ServiceModel? get service => _service;
  Tire? get tire => _tire;

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _appointmentDate = json['appointment_date'];
    _expectedEndDate = json['expected_end_date'];
    _acceptedByMerchant = json['accepted_by_merchant'];

    _service = json['service'] != null
        ? new ServiceModel.fromJson(json['service'])
        : null;

    _tire = json['tire'] != null
        ? new Tire.fromJson(json['tire'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['appointment_date'] = this._appointmentDate;
    data['expected_end_date'] = this._expectedEndDate;
    data['accepted_by_merchant'] = this._acceptedByMerchant;
    data['service'] = this._service;
    data['tire'] = this._tire;

    return data;
  }
}