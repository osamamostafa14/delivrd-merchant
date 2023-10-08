import 'package:delivrd_driver/data/model/signup_model.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/location_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/view/base/custom_button.dart';
import 'package:delivrd_driver/view/base/custom_snack_bar.dart';
import 'package:delivrd_driver/view/screens/auth/login_screen.dart';
import 'package:delivrd_driver/view/screens/location/select_location.dart';
import 'package:delivrd_driver/view/screens/location/widgets/permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  final String email;
  CreateAccountScreen({required this.email});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _workshopNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  String countryCode = "";
  String? accountPhoneNumber;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => SafeArea(
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

                      SizedBox(height: 22),

                      Center(
                          child: Text(
                              'Create your mechanic account',
                              style: TextStyle(
                                  fontSize: 16,
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
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(height: 20),

                      !authProvider.isLoading
                          ? CustomButton(
                        btnTxt: 'Next',
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
                          // if(pickedAseFile.name == 'Empty'){
                          //   showCustomSnackBar('Please upload ASE Certificate',
                          //       context);
                          // }
                        if (_fullName.isEmpty) {
                            showCustomSnackBar(
                                'Enter your full name',
                                context);
                          } else if (_phone.isEmpty) {
                            showCustomSnackBar(
                                'Enter your phone number',
                                context);
                          }
                          else if (_workshopName.isEmpty) {
                            showCustomSnackBar(
                                'Enter your workshop name',
                                context);
                          }

                          else if (_password.isEmpty) {
                            showCustomSnackBar(
                                'Enter your password',
                                context);
                          } else if (_password.length < 6) {
                            showCustomSnackBar(
                                'Password should be more than 6 numbers',
                                context);
                          } else if (_confirmPassword.isEmpty) {
                            showCustomSnackBar(
                                'Enter confirm password field',
                                context);
                          } else if (_password != _confirmPassword) {
                            showCustomSnackBar(
                                'Password didn\'t match',
                                context);
                          } else {
                            SignUpModel signUpModel = SignUpModel(
                                fullName: _fullName,
                                workshopName: _workshopName,
                                email: widget.email,
                                password: _password,
                                phone: _phone,
                                address: '',
                                longitude: '',
                                latitude: ''
                            );

                            LocationPermission permission = await Geolocator.checkPermission();
                            if(permission == LocationPermission.denied) {
                              showCustomSnackBar('You have to allow location permission to get our services', context);
                            }else if(permission == LocationPermission.deniedForever) {
                              showDialog(context: context, barrierDismissible: false, builder: (context) => PermissionDialog());
                            }else {
                              authProvider.setSignUpModel(signUpModel);
                              Provider.of<LocationProvider>(context, listen: false).getCurrentLocation().then((value) {
                                Provider.of<LocationProvider>(context, listen: false).addMarker(
                                    LatLng(Provider.of<LocationProvider>(context, listen: false).currentLatitude,
                                        Provider.of<LocationProvider>(context, listen: false).currentLongitude)
                                );

                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> SelectLocation()));
                              });
                            }
                            // authProvider
                            //     .registration(signUpModel, aseCertificate, bgCheck)
                            //     .then((status) async {
                            //   if (status.isSuccess) {
                            //     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> DashboardScreen(pageIndex: 0)));
                            //   }
                            // });
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
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));

                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account',
                                style: TextStyle(
                                    fontSize: 14
                                ),
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                              Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
  // _launchURL() async {
  //   const url = 'https://karmacheck.com/pricing/';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}
