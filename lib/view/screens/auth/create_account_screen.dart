import 'dart:convert';
import 'package:delivrd_driver/data/model/signup_model.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/view/base/border_button.dart';
import 'package:delivrd_driver/view/base/custom_button.dart';
import 'package:delivrd_driver/view/base/custom_snack_bar.dart';
import 'package:delivrd_driver/view/screens/auth/login_screen.dart';
import 'package:delivrd_driver/view/screens/location/select_location.dart';
import 'package:delivrd_driver/view/screens/widget/launch_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final TextEditingController _coverageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _taxIdController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  String countryCode = "";
  String? accountPhoneNumber;
  File bgCheck = new File('');
  File aseCertificate = new File('');
  final asePicker = ImagePicker();
  final bgCheckPicker = ImagePicker();
  bool _aseChecked = false;
  bool _bgChecked = false;

  File? fileAse;
  File? fileBC;

  PlatformFile pickedAseFile = PlatformFile(name: 'Empty', size: 1);
  PlatformFile pickedBCFile = PlatformFile(name: 'Empty', size: 1);

  Future selectASE () async {
    final aseFile = await FilePicker.platform.pickFiles();
    if(aseFile == null) return;

    setState(() {
      pickedAseFile = aseFile.files.first;
      fileAse = File(pickedAseFile.path!);
    });
  }

  Future selectBC () async {
    final bgFile = await FilePicker.platform.pickFiles();
    if(bgFile == null) return;

    setState(() {
      pickedBCFile = bgFile.files.first;
      fileBC = File(pickedBCFile.path!);
    });
  }


  void _chooseAseCertificate() async {
    final pickedFile = await asePicker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        aseCertificate = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  void _chooseBgCheck() async {
    final pickedFile2 = await bgCheckPicker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile2 != null) {
        bgCheck = File(pickedFile2.path);
      } else {
        print('No image selected.');
      }
    });
  }


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

                      Center(
                          child: Text(
                              'Create your mechanic account',
                              style: TextStyle(
                                  fontSize: 13,
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

                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      TextField (
                        controller: _businessNameController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Business Name',
                            hintText: 'Business Name'
                        ),
                      ),

                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      TextField (
                        controller: _taxIdController,
                        keyboardType: TextInputType.number,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'State Tax ID/EIN number',
                            hintText: 'State Tax ID/EIN number'
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

                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      TextField (
                        controller: _coverageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Coverage distance (miles)',
                            hintText: 'Coverage'
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

                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      //
                      //
                      // //ASE
                      // SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       pickedAseFile.name!='Empty'? '${pickedAseFile.name}': 'No selected file',
                      //       style: TextStyle(
                      //           fontSize: 12,
                      //           color: Colors.black54
                      //       ),
                      //     ),
                      //     SizedBox(width: 5),
                      //     pickedAseFile.name!='Empty'?
                      //     Icon(Icons.check_circle, color: Colors.green, size: 16) : SizedBox()
                      //   ],
                      // ),
                      // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      // Center(
                      //   child: BorderButton(
                      //     btnTxt: 'Upload ASE Certificate',
                      //     textColor: Theme.of(context).primaryColor,
                      //     width: 180,
                      //     fontSize: 11,
                      //     borderColor: Theme.of(context).primaryColor,
                      //     onTap: (){
                      //       selectASE();
                      //     },
                      //   ),
                      // ),

                      //ASE
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            pickedBCFile.name!='Empty'? '${pickedBCFile.name}': 'No selected file',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54
                            ),
                          ),
                          SizedBox(width: 5),
                          pickedBCFile.name!='Empty'?
                          Icon(Icons.check_circle, color: Colors.green, size: 16) : SizedBox()
                        ],
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      Center(
                        child: BorderButton(
                          btnTxt: 'Upload background check',
                          textColor: Theme.of(context).primaryColor,
                          width: 180,
                          fontSize: 11,
                          borderColor: Theme.of(context).primaryColor,
                          onTap: (){
                            selectBC();
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'If you don’t have a background check you can create',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> LaunchScreen()));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    ' a new one ',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54
                                    ),
                                  ),
                                  Text(
                                    'here',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
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

                          String _businessName =
                          _businessNameController.text.trim();

                          String _taxId =
                          _taxIdController.text.trim();

                          String _coverage =
                          _coverageController.text.trim();

                          String _password =
                          _passwordController.text.trim();

                          String _confirmPassword =
                          _confirmPasswordController.text.trim();
                          // if(pickedAseFile.name == 'Empty'){
                          //   showCustomSnackBar('Please upload ASE Certificate',
                          //       context);
                          // }
                             if(pickedBCFile.name == 'Empty'){
                            showCustomSnackBar('Please upload Background Check',
                                context);
                          }
                          else if (_fullName.isEmpty) {
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

                          else if (_businessName.isEmpty) {
                            showCustomSnackBar(
                                'Enter your business name',
                                context);
                          }
                          else if (_taxId.isEmpty) {
                            showCustomSnackBar(
                                'Enter your State Tax ID/EIN number',
                                context);
                          }

                          else if (_coverage.isEmpty) {
                            showCustomSnackBar(
                                'Enter the coverage distance that you can reach',
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
                                businessName: _businessName,
                                taxId: _taxId,
                                email: widget.email,
                                password: _password,
                                phone: _phone,
                                coverage: int.parse(_coverage),
                                address: '',
                                longitude: '',
                                latitude: ''
                            );

                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
                                SelectLocation(
                                  signUpModel: signUpModel,
                                  aseCertificate: fileAse,
                                  bgCheck: fileBC,
                                )));
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
                                    fontSize: 12
                                ),
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                              Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12
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
