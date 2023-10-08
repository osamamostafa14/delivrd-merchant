import 'package:delivrd_driver/data/model/category_model.dart';
import 'package:delivrd_driver/provider/services_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/view/base/custom_button.dart';
import 'package:delivrd_driver/view/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesDescriptionScreen extends StatefulWidget {
  final bool? fromMenu;
  CategoriesDescriptionScreen({@required this.fromMenu});

  @override
  State<CategoriesDescriptionScreen> createState() => _CategoriesDescriptionScreenState();
}

class _CategoriesDescriptionScreenState extends State<CategoriesDescriptionScreen> {

  @override
  Widget build(BuildContext? context) {
    return Scaffold(
      backgroundColor: Theme.of(context!).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('', style: TextStyle(color: Colors.red,
            fontWeight: FontWeight.normal, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.red,
          onPressed: () =>  Navigator.pop(context),
        ),
      ),
      body: Consumer<ServicesProvider>(
        builder: (context, servicesProvider, child) => SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: SizedBox(
                  width: 1170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text('As a Delivrd Merchant, you will be notified for',
                          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w500)),

                      ListView.builder(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        itemCount: servicesProvider.selectedValues.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          CategoryModel _category = servicesProvider.selectedValues[index]['category'];

                          return
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Icon(Icons.circle, size: 9),
                                  ),
                                  const SizedBox(width: 7),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      child: Text('${_category.description}', style: TextStyle(fontSize: 16))),
                                ],
                              ),
                            );
                        },
                      ),

                      const SizedBox(height: 20),

                      servicesProvider.servicesLoading?
                      Center(child: CircularProgressIndicator(valueColor:
                      AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))):
                      CustomButton(btnTxt: 'Confirm',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => DashboardScreen(pageIndex: 0)));
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

