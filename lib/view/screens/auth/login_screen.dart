import 'package:delivrd_driver/helper/email_checker.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/bank_provider.dart';
import 'package:delivrd_driver/provider/home_provider.dart';
import 'package:delivrd_driver/provider/profile_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/utill/images.dart';
import 'package:delivrd_driver/view/base/custom_button.dart';
import 'package:delivrd_driver/view/base/custom_snack_bar.dart';
import 'package:delivrd_driver/view/screens/auth/signup_screen.dart';
import 'package:delivrd_driver/view/screens/dashboard_screen.dart';
import 'package:delivrd_driver/view/screens/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

   // _emailController!.text = Provider.of<AuthProvider>(context, listen: false).getUserEmail() ?? null;
    String? _email = Provider.of<AuthProvider>(context, listen: false).getUserEmail();
    String? _password = Provider.of<AuthProvider>(context, listen: false).getUserPassword();

    _email!=null? _emailController!.text = _email : _emailController!.text = '';
    _password!=null? _passwordController!.text = _password : _passwordController!.text = '';
    //_passwordController!.text = Provider.of<AuthProvider>(context, listen: false).getUserPassword() ?? null;
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.all(20),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) => Form(
            key: _formKeyLogin,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(height: 50),
                Center(
                    child: Text(
                  'Login',
                  style: TextStyle(fontSize: 24, color: Colors.black54),
                )),
                SizedBox(height: 35),


            TextField (
              controller: _emailController,
              focusNode: _emailFocus,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Enter Email',
                  hintText: 'Enter Your Email'
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

                SizedBox(height: 22),

                // for remember me section
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Consumer<AuthProvider>(
                        builder: (context, authProvider, child) => InkWell(
                              onTap: () {
                                authProvider.toggleRememberMe();
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                        color: authProvider.isActiveRememberMe ? Theme.of(context).primaryColor : Colors.white,
                                        border:
                                            Border.all(color: authProvider.isActiveRememberMe ? Colors.transparent : Theme.of(context).highlightColor),
                                        borderRadius: BorderRadius.circular(3)),
                                    child: authProvider.isActiveRememberMe
                                        ? Icon(Icons.done, color: Colors.white, size: 17)
                                        : SizedBox.shrink(),
                                  ),
                                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                  Text(
                                    'Remember me',
                                    style: TextStyle(fontSize: 10, color: Colors.black54),
                                  )
                                ],
                              ),
                            )),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    authProvider.loginErrorMessage!.length > 0
                        ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                        : SizedBox.shrink(),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        authProvider.loginErrorMessage ?? "",
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    )
                  ],
                ),

                // for login button
                SizedBox(height: 10),
                !authProvider.isLoading
                    ? CustomButton(
                        btnTxt: 'Login',
                        onTap: () async {
                          String _email = _emailController!.text.trim();
                          String _password = _passwordController!.text.trim();
                          if (_email.isEmpty) {
                            showCustomSnackBar('Enter email address', context);
                          }else if (EmailChecker.isNotValid(_email)) {
                            showCustomSnackBar('Enter valid email', context);
                          }else if (_password.isEmpty) {
                            showCustomSnackBar('Enter Password', context);
                          }else if (_password.length < 6) {
                            showCustomSnackBar('Password should be equal or getter than 6 character', context);
                          }else {
                            authProvider.login(emailAddress: _email, password: _password).then((status) async {
                              if (status.isSuccess) {

                                if (authProvider.isActiveRememberMe) {
                                  authProvider.saveUserNumberAndPassword(_email, _password);

                                } else {
                                  authProvider.clearUserEmailAndPassword();
                                }
                                String token = Provider.of<AuthProvider>(context, listen: false).getUserToken();
                                Provider.of<HomeProvider>(context, listen: false).getRunningOrderList(context, '1', token);
                                Provider.of<HomeProvider>(context, listen: false).getAcceptedOrderList(context, '1', token);
                                Provider.of<HomeProvider>(context, listen: false).getHistoryOrderList(context, '1', token);
                                Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context, _callback);
                                Provider.of<BankProvider>(context, listen: false).getAccounts(context, token);
                               // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => DashboardScreen(pageIndex: 0)));
                              }
                            });
                          }
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.redAccent),
                      )),

                SizedBox(height: 9),
                authProvider.isLoading?
                SizedBox():
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SignUpScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Signup',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54

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
    );
  }
  void _callback(
      bool isSuccess) async {
    if(isSuccess){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => DashboardScreen(pageIndex: 0)));
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
