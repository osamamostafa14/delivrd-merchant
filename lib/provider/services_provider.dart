import 'package:delivrd_driver/data/model/category_model.dart';
import 'package:delivrd_driver/data/model/response/base/api_response.dart';
import 'package:delivrd_driver/data/model/response/response_model.dart';
import 'package:delivrd_driver/data/repository/services_repo.dart';
import 'package:flutter/material.dart';

class ServicesProvider extends ChangeNotifier {
  final ServicesRepo? servicesRepo;
  ServicesProvider({@required this.servicesRepo});

  List<CategoryModel> _categoryList = [];
  List<CategoryModel> get categoryList => _categoryList;

  List<CategoryModel> _driverCategoryList = [];
  List<CategoryModel> get driverCategoryList => _driverCategoryList;

  bool _isLoadingCategories = false;
  bool get isLoadingCategories => _isLoadingCategories;

  List<Map<String, dynamic>> _selectedValues = [];
  List<Map<String, dynamic>> get selectedValues => _selectedValues;

  bool _servicesLoading = false;
  bool get servicesLoading => _servicesLoading;

  bool _driverCatesLoading = false;
  bool get driverCatesLoading => _driverCatesLoading;

  Future<ResponseModel> getCategories(BuildContext context) async {
    _isLoadingCategories = true;
    ApiResponse apiResponse = await servicesRepo!.getCategories();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, 'successful');
      _isLoadingCategories = false;
      _categoryList = [];
      apiResponse.response!.data.forEach((model) {
        _categoryList.add(CategoryModel.fromJson(model));
      });

      notifyListeners();
    } else {

      _isLoadingCategories = false;
      //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
      responseModel = ResponseModel(false, apiResponse.error.toString());
    }
    return responseModel;
  }


  void setSelectedValues(int id, bool value, CategoryModel category) {
    bool _inserted = false;
    _selectedValues.forEach((item) {
      if(item['id'] == id){
        _inserted = true;
      }
    });
    if(_inserted == false){
      _selectedValues.add({
        'id': id,
        'value': value,
        'category': category,
      });
    }
    notifyListeners();
  }


  void removeValue(int id) {
    _selectedValues.removeWhere((item) => item['id'] == id);
    notifyListeners();
  }

  Future<void> saveServices(BuildContext context, List<int> services, String token) async {
    _servicesLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await servicesRepo!.saveServices(services, token);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _servicesLoading = false;

    } else {
      _servicesLoading = false;
      //   ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<ResponseModel> getDriverCategories(BuildContext context,  String token) async {
    _driverCatesLoading = true;
    ApiResponse apiResponse = await servicesRepo!.getDriverCategories(token);
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, 'successful');
      _driverCatesLoading = false;
      _driverCategoryList = [];
      apiResponse.response!.data.forEach((model) {
        _driverCategoryList.add(CategoryModel.fromJson(model));
      });
      notifyListeners();
    } else {
      _driverCatesLoading = false;
      //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
      responseModel = ResponseModel(false, apiResponse.error.toString());
    }
    return responseModel;
  }
}