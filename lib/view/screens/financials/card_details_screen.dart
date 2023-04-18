import 'package:delivrd_driver/data/model/bank_accounts_model.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/bank_provider.dart';
import 'package:delivrd_driver/view/base/custom_button.dart';
import 'package:delivrd_driver/view/base/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardDetails extends StatefulWidget {
   late bool updateCard;
  final BankAccountsModel? bankAccount;
   CardDetails({required this.updateCard, @required this.bankAccount});

  @override
  _CardDetailsState createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  TextEditingController? _routingController;
  TextEditingController? _accountNoController;
  TextEditingController? _holderNameController;
  // TextEditingController? _bankNameController;


  final Map<String, String> customCaptions = {
    'Prev' : 'Prev',
    'Next' : 'Next',
    'Done' : 'Done',
    'CARD_NUMBER' : 'Card Number',
    'CARDHOLDER_NAME' : 'Cardholder Name',
    'VALID_THRU' : 'Valid Thru',
    'SECURITY_CODE_CVC' : 'Security Code (CVC)',
    'NAME_SURNAME' : 'Name',
    'MM_YY' : 'MM/YY',
    'RESET' : 'Reset'
  };

  final buttonStyle = BoxDecoration(
      borderRadius: BorderRadius.circular(30.0),
      gradient: LinearGradient(
          colors: [
            const Color(0xFFf83f35),
            const Color(0xFFec827d),
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp
      )
  );
  final cardDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(30.0),
      boxShadow: <BoxShadow> [
        //  BoxShadow(color: Color(0xFF1f9192), blurRadius: 15.0, offset: Offset(0,8))
      ],
      gradient: LinearGradient(
          colors: [
            const Color(0xFFf83f35),
            const Color(0xFFec827d),
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp
      )
  );
  @override
  void initState() {
    super.initState();

    _routingController = TextEditingController();
    _accountNoController = TextEditingController();
    _holderNameController = TextEditingController();
    // _bankNameController = TextEditingController();

    if(widget.updateCard == true){
      _routingController!.text = widget.bankAccount!.routingNumber.toString();
      _accountNoController!.text = widget.bankAccount!.accountNumber.toString();
      _holderNameController!.text = widget.bankAccount!.holderName.toString();
      // _bankNameController!.text = widget.bankAccount!.bankName.toString();
    }

  }

  @override
  Widget build(BuildContext context) {
    //  Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    return Consumer<BankProvider>(
        builder: (context, bankProvider, child){
          return
            Scaffold(
              key: _scaffoldKey,
              // appBar: CustomAppBar(title: 'Payment Method'),
              body:
              bankProvider.isLoading?
              Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))) :
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SafeArea(
                    child: AnimatedContainer(
                      duration: Duration(microseconds: 300),
                      child: Padding(padding: EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          children: [
                            Container(
                                height: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: <BoxShadow> [
                                      //  BoxShadow(color: Color(0xFF1f9192), blurRadius: 15.0, offset: Offset(0,8))
                                    ],
                                    gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFFf83f35),
                                          const Color(0xFFec827d),
                                        ],
                                        begin: const FractionalOffset(0.0, 0.0),
                                        end: const FractionalOffset(1.0, 0.0),
                                        stops: [0.0, 1.0],
                                        tileMode: TileMode.clamp
                                    )
                                ),
                                width: 360,
                                child: Column(
                                  children: [
                                    SizedBox(height: 30),
                                    Row(
                                      children: [
                                        SizedBox(width: 220),
                                        Image.asset("assets/icon/cardeclipse.png",height: 30),
                                      ],
                                    ),
                                    SizedBox(height: 50),

                                    Text('${bankProvider.accountNumber}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        )),

                                    SizedBox(height: 5),

                                    Row(
                                      children: [
                                        SizedBox(width: 200),
                                        Text('',
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white,
                                            )),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        SizedBox(width: 50),
                                        Text('${bankProvider.holderName}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            )),
                                      ],
                                    ),
                                  ],
                                )
                            ),

                            SizedBox(
                                height: 15),
                            Text(
                              'New Routing number',
                              style: TextStyle(color: Colors.black54),
                            ),
                            SizedBox(
                                height: 15),
                            TextField (
                              controller: _routingController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Routing No',
                                  hintText: '1234 5678 90'
                              ),
                              onChanged: (content){
                                // bankProvider.setAccountNumber(_cardNumberController.text.toString());
                                if(_routingController!.text.trim() == "") {
                                  bankProvider.setAccountNumber('012345678976543');
                                } else {
                                  bankProvider.setAccountNumber(_routingController!.text.toString());
                                }
                              },
                            ),
                            SizedBox(
                                height: 15),
                            Text(
                              'New Account number',
                              style: TextStyle(color: Colors.black54),
                            ),
                            SizedBox(
                                height: 15),
                            TextField (
                              controller: _accountNoController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Account No',
                                  hintText: '12345678'
                              ),
                              onChanged: (content){

                              },
                            ),
                            SizedBox(
                                height: 15),
                            Text(
                              'Account Name',
                              style: TextStyle(color: Colors.black54),
                            ),
                            SizedBox(
                                height: 15),

                            TextField (
                              controller: _holderNameController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Account name',
                                  hintText: 'Account name'
                              ),
                              onChanged: (content){
                                if(_holderNameController!.text.trim() == "") {
                                  bankProvider.setHolderName('Account Name');
                                } else {
                                  bankProvider.setHolderName(_holderNameController!.text.toString());
                                }
                              },
                            ),



                            SizedBox(
                                height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 60),

                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 1170,
                          padding: EdgeInsets.all(5),
                          child: CustomButton(
                            btnTxt: widget.updateCard? 'Update Account': 'Add Account',
                            onTap: () async {
                              String _routingNo = _routingController!.text.trim();
                              String _accountNo = _accountNoController!.text.trim();
                              String _holderName = _holderNameController!.text;
                              // String _bankName = _bankNameController!.text.trim();

                              if (_routingNo.isEmpty) {
                                showCustomSnackBar('Enter New Routing Number', context);
                              }else if (_routingNo.length < 6) {
                                showCustomSnackBar('Account valid routing number', context);
                              }

                              if (_accountNo.isEmpty) {
                                showCustomSnackBar('Enter New Account Number', context);
                              } else if (_accountNo.length < 6) {
                                showCustomSnackBar('Enter valid account number', context);
                              }
                              else if (_holderName.isEmpty) {
                                showCustomSnackBar('Enter Account Name', context);
                              }
                              // else if (_bankName.isEmpty) {
                              //   showCustomSnackBar('Enter Bank Name', context);
                              // }
                              else {
                                if(widget.updateCard == true){
                                  bankProvider.updateCard(_routingNo,_accountNo, _holderName, widget.bankAccount!.id, Provider.of<AuthProvider>(context, listen: false).getUserToken(), _callback);
                                }else{
                                  bankProvider.addCard(_routingNo,_accountNo, _holderName, Provider.of<AuthProvider>(context, listen: false).getUserToken(), _callback);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
        });
  }
  void _callback(
      bool isSuccess, String message) async {
    if(isSuccess){
      Provider.of<BankProvider>(context, listen: false).getAccounts(context, Provider.of<AuthProvider>(context, listen: false).getUserToken());
      Navigator.pop(context);
    } else {
      showCustomSnackBar('Error occured', context);
    }
  }
}
