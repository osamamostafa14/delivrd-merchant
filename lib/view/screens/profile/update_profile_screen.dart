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
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _taxIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _coverageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String countryCode = "";
  String? accountPhoneNumber;
  File bgCheck = new File('');
  File aseCertificate = new File('');
  final asePicker = ImagePicker();
  final bgCheckPicker = ImagePicker();
  bool _aseChecked = false;
  bool _bgChecked = false;
  SignUpModel? _driverInfoModel;
  PlatformFile pickedBCFile = PlatformFile(name: 'Empty', size: 1);
  File? fileBC;

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
    _driverInfoModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
    _fullNameController.text = _driverInfoModel!.fullName;
    _workshopNameController.text = _driverInfoModel!.workshopName;
    _phoneController.text = _driverInfoModel!.phone;
    _businessNameController.text = _driverInfoModel!.businessName;
    _taxIdController.text = _driverInfoModel!.taxId;
    _coverageController.text = _driverInfoModel!.coverage.toString();
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
                          controller: _businessNameController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Business Name',
                              hintText: 'Business Name'
                          ),
                        ),

                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        TextField (
                          controller: _taxIdController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'State Tax ID/EIN number',
                              hintText: 'State Tax ID/EIN number'
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
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

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
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
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
                        //
                        // for signup button
                        SizedBox(height: 20),
                        Divider(
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
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

                            String _coverage =
                            _coverageController.text.trim();

                            String _taxId =
                            _taxIdController.text.trim();

                            String _businessName =
                            _businessNameController.text.trim();

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

                            else if (_businessName.isEmpty) {
                              showCustomSnackBar(
                                  'Enter your business name',
                                  context);
                            } else if (_taxId.isEmpty) {
                              showCustomSnackBar(
                                  'Enter your tax id',
                                  context);
                            }

                            else if (_coverage.isEmpty) {
                              showCustomSnackBar(
                                  'Enter the coverage distance that you can reach',
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
                                  businessName: _businessName,
                                  taxId: _taxId,
                                  email: '',
                                  password: _password,
                                  phone: _phone,
                                  coverage: int.parse(_coverage),
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
                                  fileBC,
                                  Provider.of<AuthProvider>(context, listen: false).getUserToken(),
                                _aseChecked,
                                _bgChecked
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
