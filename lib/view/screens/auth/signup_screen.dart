import 'package:delivrd_driver/helper/email_checker.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/view/base/custom_button.dart';
import 'package:delivrd_driver/view/base/custom_snack_bar.dart';
import 'package:delivrd_driver/view/screens/auth/create_account_screen.dart';
import 'package:delivrd_driver/view/screens/auth/login_screen.dart';
import 'package:delivrd_driver/view/screens/auth/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            physics: BouncingScrollPhysics(),
            child: Center(
              child: Container(
                width: 1170,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 140),

                      Center(
                          child: Text(
                            'Mechanic Sign Up',
                           style: TextStyle(
                             fontSize: 13
                           ),
                          )),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      TextField (
                        controller: _emailController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Enter Email',
                            hintText: 'Enter Your Email'
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      !authProvider.isPhoneNumberVerificationButtonLoading
                          ? CustomButton(
                        btnTxt: 'Continue',
                        onTap: () {
                          String _email = _emailController.text.trim();
                          if (_email.isEmpty) {
                            showCustomSnackBar('Enter email address', context);
                          }else if (EmailChecker.isNotValid(_email)) {
                            showCustomSnackBar('Enter valid email', context);
                          }else {
                            authProvider.checkEmail(_email).then((value) async {
                              if (value.isSuccess) {
                                authProvider.updateEmail(_email);
                                if (value.message == 'active') {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (BuildContext context)=> VerificationScreen(emailAddress: _email, fromSignUp: true)));
                                //  Navigator.pushNamed(context, Routes.getVerifyRoute('sign-up', _email));
                                } else {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (BuildContext context)=> CreateAccountScreen(email: _email)));
                                }
                              }
                            });
                          }
                        },
                      )
                          : Center(
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                          )),
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
                                  fontSize: 10
                                ),
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                              Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.grey
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
}
