import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/utill/images.dart';
import 'package:delivrd_driver/view/base/custom_button.dart';
import 'package:delivrd_driver/view/base/custom_snack_bar.dart';
import 'package:delivrd_driver/view/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  final String resetToken;
  final String email;
  CreateNewPasswordScreen({required this.resetToken, required this.email});

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new password'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return Scrollbar(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Center(
                child: SizedBox(
                  width: 1170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 55),
                      Image.asset(
                        Images.open_lock,
                        width: 142,
                        height: 142,
                      ),
                      SizedBox(height: 40),
                      Center(
                          child: Text(
                            'Enter new password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black54
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 60),
                            Text(
                              'New password',
                              style: TextStyle(
                                color: Colors.black54
                              ),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            TextField (
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Password',
                                  hintText: 'Password hint'
                              ),
                            ),

                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            // for confirm password section
                            Text(
                              'Confirm password',
                              style: TextStyle(
                                color: Colors.black54
                              ),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            TextField (
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocus,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Password',
                                  hintText: 'Password hint'
                              ),
                            ),

                            SizedBox(height: 24),
                            !auth.isForgotPasswordLoading ? CustomButton(
                              btnTxt: 'Save',
                              onTap: () {
                                if (_passwordController.text.isEmpty) {
                                  showCustomSnackBar('Enter password', context);
                                }else if (_passwordController.text.length < 6) {
                                  showCustomSnackBar('Password should be more than 6 digitd', context);
                                }else if (_confirmPasswordController.text.isEmpty) {
                                  showCustomSnackBar('Enter confirm password field', context);
                                }else if(_passwordController.text != _confirmPasswordController.text) {
                                  showCustomSnackBar('Password did not match', context);
                                }else {
                                  auth.resetPassword(resetToken, _passwordController.text, _confirmPasswordController.text).then((value) {
                                    if(value.isSuccess) {
                                      auth.login(emailAddress: email, password: _passwordController.text).then((value) async {
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SplashScreen()));
                                     //   Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                                      });
                                    }else {
                                      showCustomSnackBar('Failed to reset password', context);
                                    }
                                  });
                                }
                              },
                            ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
