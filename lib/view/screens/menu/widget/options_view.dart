import 'dart:io';
import 'package:delivrd_driver/helper/responsive_helper.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/location_provider.dart';
import 'package:delivrd_driver/provider/services_provider.dart';
import 'package:delivrd_driver/provider/splash_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/utill/images.dart';
import 'package:delivrd_driver/view/base/border_button.dart';
import 'package:delivrd_driver/view/base/custom_snack_bar.dart';
import 'package:delivrd_driver/view/screens/category/select_categories_screen.dart';
import 'package:delivrd_driver/view/screens/financials/bank_accounts_screen.dart';
import 'package:delivrd_driver/view/screens/financials/earnings_screen.dart';
import 'package:delivrd_driver/view/screens/location/update_location.dart';
import 'package:delivrd_driver/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:delivrd_driver/view/screens/profile/update_profile_screen.dart';
import 'package:delivrd_driver/view/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OptionsView extends StatelessWidget {
  final Function? onTap;
  OptionsView({@required this.onTap});

  @override
  Widget build(BuildContext context) {

    bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    String token = Provider.of<AuthProvider>(context, listen: false).getUserToken();

    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController = TextEditingController();
    bool _loading = false;

    return Scrollbar(
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        child: _isLoggedIn ?
        Center(
          child: SizedBox(
            width: 1170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ResponsiveHelper.isTab(context) ? 50 : 0),
                ListTile(
                  onTap: () =>
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> UpdateProfileScreen())),
                  leading: Image.asset(Images.profile,
                      width: 20,
                      height: 20,
                      color: Colors.black54),
                  title: Text('Profile',
                      style: TextStyle(
                          fontSize: 15
                      )),
                ),

                ListTile(
                  onTap: () {
                    Provider.of<LocationProvider>(context, listen: false).resetLatLong();
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> UpdateLocation()));
                  },

                  leading: Icon(
                    Icons.location_on,
                    size: 23.0,
                    color: Colors.black54,
                  ),
                  title: Text('Location',
                      style: TextStyle(
                          fontSize: 15
                      )),
                ),

                ListTile(
                  onTap: () {
                    Provider.of<LocationProvider>(context, listen: false).resetLatLong();
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> BankAccountsScreen()));
                  },

                  leading: Icon(
                    Icons.credit_card_outlined,
                    size: 23.0,
                    color: Colors.black54,
                  ),
                  title: Text('Bank accounts',
                      style: TextStyle(
                          fontSize: 15
                      )),
                ),

                ListTile(
                  onTap: () {
                    Provider.of<LocationProvider>(context, listen: false).resetLatLong();
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> EarningsScreen()));
                  },
                  leading: Icon(
                    Icons.monetization_on,
                    size: 23.0,
                    color: Colors.black54,
                  ),
                  title: Text('Earnings',
                      style: TextStyle(
                          fontSize: 15
                      )),
                ),

                ListTile(
                  onTap: () {
                    Provider.of<ServicesProvider>(context, listen: false).getCategories(context);
                    Provider.of<ServicesProvider>(context, listen: false).getDriverCategories(context,Provider.of<AuthProvider>(context, listen: false).getUserToken()).then((value) {
                      Provider.of<ServicesProvider>(context, listen: false).driverCategoryList.forEach((category) {
                        Provider.of<ServicesProvider>(context, listen: false).setSelectedValues(
                            category.id!,
                            true,
                            category);
                      });
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> SelectCategoriesScreen()));
                  },

                  leading: Icon(
                    Icons.miscellaneous_services,
                    size: 23.0,
                    color: Colors.black54,
                  ),
                  title: Text('Services',
                      style: TextStyle(
                          fontSize: 15
                      )),
                ),

                ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(Images.customer_team),
                              Text(
                                  'Our team is ready to answer your inquiries, so do not hesitate to contact us',
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          actions: [
                             Padding(
                              padding:  EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                  onTap : () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel', style: TextStyle(color: Colors.black54))),
                            ),

                            BorderButton(
                              btnTxt: 'Call now',
                            borderColor: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).primaryColor,
                              onTap: () async {
                                String _customerPhoneNo = Provider.of<SplashProvider>(context, listen: false).configModel!.appPhone!;
                                String url = "tel:$_customerPhoneNo";
                                if (await canLaunch(url)) {
                                await launch(url);
                                } else {
                                throw 'Could not launch $url';
                                }
                              },
                            ),

                            BorderButton(
                              btnTxt: 'SMS',
                              borderColor: Theme.of(context).primaryColor,
                              textColor: Theme.of(context).primaryColor,
                              onTap: () async {
                                String phoneNumber = Provider.of<SplashProvider>(context, listen: false).configModel!.appPhone!;
                                if (Platform.isAndroid) {
                                  String uri = 'sms:${phoneNumber}';
                                  await launch(uri);
                                } else if (Platform.isIOS) {
                                  // iOS
                                  String uri = 'sms:${phoneNumber}';
                                  // const uri = 'sms:0039-222-060-888&body=hello%20there';
                                  await launch(uri);
                                }
                              },
                            ),

                          ],
                        );
                      },
                    );
                  },

                  leading: Image.asset(Images.customer_support,
                      width: 22,
                      height: 22,
                      color: Colors.black54),
                  title: Text('Customer service',
                      style: TextStyle(
                          fontSize: 15
                      )),
                ),

                // ListTile(
                //   onTap: () =>
                //       Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> ChatScreen())),
                //   leading: Icon(Icons.message,
                //       size: 20,
                //       color: Colors.black54),
                //   title: Text('Contact us',
                //       style: TextStyle(
                //         fontSize: 15
                //       )),
                // ),
                ListTile(
                  onTap: () {
                    void _callback(
                        bool isSuccess) async {
                      if(isSuccess){
                        Provider.of<AuthProvider>(context, listen: false).clearSharedData().then((condition) {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> SplashScreen()));
                        });
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Account deleted'),
                            )
                        );
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Error occured, try again later'),
                            )
                        );
                      }
                    }

                    void _checkPassCallback(
                        bool isSuccess) async {
                      if(isSuccess){
                        _loading = false;
                        Provider.of<AuthProvider>(context, listen: false).deleteAccount(token: token, callback: _callback);
                        Provider.of<AuthProvider>(context, listen: false).clearUserEmailAndPassword();
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Error occured, try again later'),
                            )
                        );
                      }
                    }

                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Your account will be permanently deleted, do you want to continue?'),

                          actions: [
                            BorderButton(
                              btnTxt: 'No',
                              textColor: Colors.grey,
                              borderColor: Colors.grey,
                              onTap: (){
                                Navigator.pop(context);
                              },
                            ),
                            BorderButton(
                              btnTxt: 'Yes',
                              textColor: Colors.red,
                              borderColor: Colors.red,
                              onTap: (){
                                showDialog(
                                    context: context,
                                    builder: (_) => StatefulBuilder(builder: (context, setState)=> AlertDialog(
                                      title: Text('Confirm Password'),
                                      actions: [
                                        Column(
                                          children: [
                                            TextField (
                                              controller: _passwordController,
                                              obscureText: true,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: 'Password',
                                                  hintText: 'Enter Your password'
                                              ),
                                            ),
                                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                            // for confirm password section
                                            TextField (
                                              controller: _confirmPasswordController,
                                              obscureText: true,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: 'Confirm Password',
                                                  hintText: 'Confirm Your password'
                                              ),
                                            ),
                                            Provider.of<AuthProvider>(context, listen: false).passIsLoading == true?
                                            Center(
                                                child: CircularProgressIndicator(
                                                    valueColor:
                                                    AlwaysStoppedAnimation<Color>(Colors.redAccent))
                                            ):
                                            BorderButton(
                                              btnTxt: 'Confirm',
                                              textColor: Colors.red,
                                              borderColor: Colors.red,
                                              onTap: (){
                                                _loading == true;
                                                setState(() {});
                                                String _password = _passwordController.text.trim();
                                                String _confirmPassword = _confirmPasswordController.text.trim();

                                                if (_password.isEmpty) {
                                                  showCustomSnackBar(
                                                      'Password field is empty',
                                                      context);
                                                }
                                                else if ((_password.isNotEmpty &&
                                                    _password.length < 6) ||
                                                    (_confirmPassword.isNotEmpty &&
                                                        _confirmPassword.length < 6)) {
                                                  showCustomSnackBar(
                                                      'Password should be more than 6',
                                                      context);
                                                } else if (_password !=
                                                    _confirmPassword) {
                                                  showCustomSnackBar(
                                                      'Password did not match',
                                                      context);
                                                } else {
                                                  Provider.of<AuthProvider>(context, listen: false).checkPassword(token: token, password: _password, callback: _checkPassCallback);
                                                }
                                              },
                                            ),
                                          ],

                                        )
                                      ],
                                    ))
                                );
                              },
                            ),

                          ],
                        )
                    );
                  },

                  leading: Icon(Icons.account_box_outlined,
                      size: 20,
                      color: Colors.black54),
                  title: Text('Delete account',
                      style: TextStyle(
                          fontSize: 15,
                        color: Colors.red
                      )),
                ),
                ListTile(
                  onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => SignOutConfirmationDialog());
                  },
                  leading: Image.asset(Images.log_out,
                      width: 20,
                      height: 20,
                      color: Colors.black54),
                  title: Text('Logout',
                      style: TextStyle(
                          fontSize: 15
                      ))
                ),

              ],
            ),
          ),
        ) : Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        )),
      ),
    );
  }

}
