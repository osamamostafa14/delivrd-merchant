import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/profile_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/view/screens/auth/login_screen.dart';
import 'package:delivrd_driver/view/screens/splash_screen.dart';
import 'package:delivrd_driver/view/screens/widget/profile_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {
            //profileProvider.getUserInfo(context);
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 60),
                  Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Column(
                      children: [
                        Card(
                          elevation: 8,
                          shadowColor: Colors.white,
                          margin: EdgeInsets.only(left: 5,right: 5, bottom: 8),
                          shape:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          child: Column(

                            children: [
                              Padding(padding: EdgeInsets.all(6),
                                child: Row(

                                    children: [
                                      SizedBox(width: 90,child:  Text('Driver name: ',style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.normal,
                                      ))),
                                      Text('${profileProvider.userInfoModel!.fullName}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          )),

                                    ]),
                              ),

                              Padding(padding: EdgeInsets.all(6),
                                child: Row(

                                    children: [
                                      SizedBox(width: 90,child:  Text('phone: ',style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.normal,
                                      ))),

                                      Text('${profileProvider.userInfoModel!.phone}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          )),

                                    ]),
                              ),

                            ],
                          ),
                        ),

                        /*  ProfileButton(icon: Icons.privacy_tip, title: 'Privacy policy', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HtmlViewerScreen(isPrivacyPolicy: true)));
                      }),
                      SizedBox(height: 10),
                      ProfileButton(icon: Icons.list, title: 'Terms and condition', onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HtmlViewerScreen(isPrivacyPolicy: false)));
                      }),
                      SizedBox(height: 10),*/
                        ProfileButton(icon: Icons.logout, title: 'Logout', onTap: () {
                          Provider.of<AuthProvider>(context, listen: false).clearSharedData().then((condition) {
                            Navigator.pop(context);
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
                          });
                        }),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }

  Widget _userInfoWidget({String? text,required BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 22),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
          color: Theme.of(context).cardColor,
          border: Border.all(color: Colors.grey)),
      child: Text(
        text ?? '',
        style: TextStyle(color: Theme.of(context).focusColor),
      ),
    );
  }
}
