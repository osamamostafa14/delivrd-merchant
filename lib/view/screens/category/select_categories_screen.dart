import 'package:delivrd_driver/data/model/category_model.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/services_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/view/base/custom_button.dart';
import 'package:delivrd_driver/view/base/custom_snack_bar.dart';
import 'package:delivrd_driver/view/screens/category/categories_description_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectCategoriesScreen extends StatefulWidget {
  final bool? fromMenu;
  SelectCategoriesScreen({@required this.fromMenu});
  @override
  State<SelectCategoriesScreen> createState() => _SelectCategoriesScreenState();
}

class _SelectCategoriesScreenState extends State<SelectCategoriesScreen> {

  @override
  Widget build(BuildContext? context) {
    return Scaffold(
      backgroundColor: Theme.of(context!).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Select services', style: TextStyle(color: Colors.red,
            fontWeight: FontWeight.normal, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.2,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios),
        //   color: Colors.red,
        //   onPressed: () =>  Navigator.pop(context),
        // ),
      ),
      body: Consumer<ServicesProvider>(
        builder: (context, servicesProvider, child) => SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              physics: const BouncingScrollPhysics(),
              child:
              servicesProvider.driverCatesLoading?
              Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))) :
              Center(
                child: SizedBox(
                  width: 1170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text('Which of these services do you provide?',
                          style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w500)),

                      ListView.builder(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        itemCount: servicesProvider.categoryList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          CategoryModel _category = servicesProvider.categoryList[index];
                          Map<String, dynamic>? _selectedValue;
                          bool _value = false;
                          try {
                            _selectedValue = servicesProvider.selectedValues
                                .where((item) => item['id'] == _category.id)
                                .first;
                            _value = _selectedValue['value'];
                          } catch (e) {
                            print("No item found");
                          }
                          return
                            CheckboxListTile(
                              title: Text("${_category.name}",
                                  style: TextStyle(color: Theme.of(context).textTheme.headline2!.color,
                                      fontSize: 16, fontWeight: FontWeight.bold)),
                              value: _value,
                              onChanged: (newValue) {
                                if(_value == false){
                                  servicesProvider.setSelectedValues(_category.id!, newValue!, _category);
                                }else {
                                  servicesProvider.removeValue(_category.id!);
                                }
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              checkColor: Colors.red,
                              activeColor: Colors.white,
                            );
                        },
                      ),

                      const SizedBox(height: 20),

                      servicesProvider.driverCatesLoading?
                      SizedBox():
                      servicesProvider.servicesLoading?
                      Center(child: CircularProgressIndicator(valueColor:
                      AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))):
                      CustomButton(btnTxt: 'Confirm',
                          onTap: () {
                            List<int> selectedValues = [];
                            servicesProvider.selectedValues.forEach((value) {
                              selectedValues.add(value['id']);
                            });
                            if(servicesProvider.selectedValues.isEmpty){
                              showCustomSnackBar(
                                  'Please select at least one service!',
                                  context);
                            }else{
                              servicesProvider.saveServices(context, selectedValues, Provider.of<AuthProvider>(context, listen: false).getUserToken()).then((value){
                                showCustomSnackBar('Updated!', context, isError: false);
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>
                                    CategoriesDescriptionScreen(fromMenu: widget.fromMenu)));
                              });
                            }

                          })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

