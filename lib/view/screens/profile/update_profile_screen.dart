import 'dart:convert';
import 'package:delivrd_driver/data/model/signup_model.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/profile_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/view/base/border_button.dart';
import 'package:delivrd_driver/view/base/custom_button.dart';
import 'package:delivrd_driver/view/base/custom_snack_bar.dart';
import 'package:delivrd_driver/view/screens/widget/launch_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _workshopNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String countryCode = "";
  String? accountPhoneNumber;

  SignUpModel? _driverInfoModel;

  @override
  void initState() {
    super.initState();
    _driverInfoModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
    _fullNameController.text = _driverInfoModel!.fullName;
    _workshopNameController.text = _driverInfoModel!.workshopName;
    _phoneController.text = _driverInfoModel!.phone;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {

          return SafeArea(
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                physics: BouncingScrollPhysics(),
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Center(
                            child: Text(
                                'Update your account',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                )
                            )),
                        SizedBox(height: 20),

                        // for first name section

                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        TextField (
                          controller: _fullNameController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Full Name',
                              hintText: 'Full Name'
                          ),
                        ),

                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        TextField (
                          controller: _workshopNameController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Workshop Name',
                              hintText: 'Workshop Name'
                          ),
                        ),

                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        TextField (
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Phone number',
                              hintText: 'Enter Your phone number'
                          ),
                        ),


                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
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



                        SizedBox(height: 50),

                        !profileProvider.isLoading
                            ? CustomButton(
                             btnTxt: 'Update',
                              onTap: () async {

                            String _fullName =
                            _fullNameController.text.trim();

                            String _phone =
                            _phoneController.text.trim();

                            String _workshopName =
                            _workshopNameController.text.trim();

                            String _password =
                            _passwordController.text.trim();

                            String _confirmPassword =
                            _confirmPasswordController.text.trim();

                            if (_fullName.isEmpty) {
                              showCustomSnackBar(
                                  'Enter your full name',
                                  context);
                            }else if (_workshopName.isEmpty) {
                              showCustomSnackBar(
                                  'Enter your workshop name',
                                  context);
                            } else if (_phone.isEmpty) {
                              showCustomSnackBar(
                                  'Enter your phone number',
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
                              SignUpModel signUpModel = SignUpModel(
                                  fullName: _fullName,
                                  workshopName: _workshopName,
                                  email: '',
                                  password: _password,
                                  phone: _phone,
                                  address: '',
                                  longitude: '',
                                  latitude: '',

                              );
                              print('signup model 2 ///');
                              print(jsonEncode(signUpModel));
                              // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
                              //     SelectLocation(
                              //       signUpModel: signUpModel,
                              //       aseCertificate: aseCertificate,
                              //       bgCheck: bgCheck,
                              //     )));
                              profileProvider
                                  .updateProfile(
                                  signUpModel,
                                  Provider.of<AuthProvider>(context, listen: false).getUserToken(),
                              ).then((status) async {
                                profileProvider.getUserInfo(context, _callbackUserInfo); // to update new user info details, or i will have to restart the app
                                if (status.isSuccess) {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text('Profile updated'),
                                      )
                                  );
                                }
                              });
                            }
                          },
                        )
                            : Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            )),

                        // for already an account
                        SizedBox(height: 11),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
  void _callbackUserInfo(
      bool isSuccess) async {
    if(isSuccess){

      setState(() {});
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error occured, try again later'),
          )
      );
    }
  }
}
