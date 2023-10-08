import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/utill/color_resources.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/utill/images.dart';
import 'package:delivrd_driver/view/base/custom_button.dart';
import 'package:delivrd_driver/view/base/custom_snack_bar.dart';
import 'package:delivrd_driver/view/screens/auth/create_account_screen.dart';
import 'package:delivrd_driver/view/screens/auth/create_new_password.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatelessWidget {
  final String emailAddress;
  final bool fromSignUp;
  VerificationScreen({required this.emailAddress, this.fromSignUp = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify your email'),
        backgroundColor: Colors.white,
        elevation: 0.0,

      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 55),
                      Center(
                        child: Icon(Icons.message, color: Colors.black, size: 60),
                      ),

                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Center(
                            child: Text(
                              'Please enter 4 digit_code\n $emailAddress',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 35),
                        child: PinCodeTextField(
                          length: 4,
                          appContext: context,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            fieldHeight: 63,
                            fieldWidth: 55,
                            borderWidth: 1,
                            borderRadius: BorderRadius.circular(10),
                            selectedColor: ColorResources.colorMap[200],
                            selectedFillColor: Colors.white,
                            inactiveFillColor: ColorResources.getSearchBg(context),
                            inactiveColor: ColorResources.colorMap[200],
                            activeColor: ColorResources.colorMap[400],
                            activeFillColor: ColorResources.getSearchBg(context),
                          ),
                          animationDuration: Duration(milliseconds: 300),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          onChanged: authProvider.updateVerificationCode,
                          beforeTextPaste: (text) {
                            return true;
                          },
                        ),
                      ),
                      Center(
                          child: Text(
                            'I didnt receive the code',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15
                            )
                          )),
                      Center(
                        child: InkWell(
                          onTap: () {
                            if(fromSignUp) {
                              Provider.of<AuthProvider>(context, listen: false).checkEmail(emailAddress).then((value) {
                                if (value.isSuccess) {
                                  showCustomSnackBar('Resent code successful', context, isError: false);
                                } else {
                                  showCustomSnackBar(value.message ?? '', context);
                                }
                              });
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Text(
                              'Resend code',
                              style: TextStyle(
                                color: Colors.grey
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 48),
                      authProvider.isEnableVerificationCode ?

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                        child:
                        authProvider.verifyEmailLoading?
                        Center(child: CircularProgressIndicator(valueColor:
                        AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))):
                        CustomButton(
                          btnTxt: 'Verify',
                          onTap: () {

                            if(fromSignUp) {

                              authProvider.verifyEmail(emailAddress).then((value) {
                                if(value.isSuccess) {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> CreateAccountScreen(email: emailAddress)));
                                } else {
                                  showCustomSnackBar(value.message ?? '', context);
                                }
                              });
                            }else {
                              authProvider.verifyToken(emailAddress).then((value) {
                                if(value.isSuccess) {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> CreateNewPasswordScreen(email: emailAddress, resetToken: authProvider.verificationCode)));
                                //  Navigator.pushNamed(context, Routes.getNewPassRoute(emailAddress, authProvider.verificationCode));
                                }else {
                                  showCustomSnackBar(value.message ?? '', context);
                                }
                              });
                            }
                          },
                        ),
                      )
                          : SizedBox.shrink()
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
