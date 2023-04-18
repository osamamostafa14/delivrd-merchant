import 'package:delivrd_driver/data/model/signup_model.dart';
import 'package:delivrd_driver/provider/profile_provider.dart';
import 'package:delivrd_driver/view/screens/menu/widget/options_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  final Function? onTap;
  MenuScreen({ this.onTap});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
     // appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)) : null,
      body:
        Consumer<ProfileProvider>(
          builder: (context, profile, child) {
            SignUpModel? _userInfoModel;
            _userInfoModel = profile.userInfoModel;

            return _userInfoModel!= null? Column(
              children: [
                Center(
                  child: Container(
                    width: 1170,
                    padding: EdgeInsets.symmetric(vertical: 50),
                    //decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(height: 20),
                      Text('${_userInfoModel.email}', style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ))
                    ]),
                  ),
                ),
                Expanded(child: OptionsView(onTap: onTap)),
              ],
            ): Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));

          },
        ),



    );
  }
}
