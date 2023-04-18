import 'dart:convert';
import 'package:delivrd_driver/data/model/bank_accounts_model.dart';
import 'package:delivrd_driver/data/model/signup_model.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/bank_provider.dart';
import 'package:delivrd_driver/provider/financials_provider.dart';
import 'package:delivrd_driver/provider/profile_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/view/base/border_button.dart';
import 'package:delivrd_driver/view/screens/financials/statistics_screen.dart';
import 'package:delivrd_driver/view/screens/financials/withdrawals_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class EarningsScreen extends StatefulWidget {

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  List<BankAccountsModel> _bankAccounts = [];
  SignUpModel? _user;

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context, _callback);
  }

  void _callback(
      bool isSuccess) async {
    if(isSuccess){
      _user = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
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
  void _withdrawalCallback(
      bool isSuccess, String message) async {
    if(isSuccess){
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(message),
          )
      );
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context, _callback);
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error occured, try again later'),
          )
      );
    }
  }

  void _callback3(
      bool isSuccess) async {
    if(isSuccess){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> WithdrawalsHistoryScreen()));
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error occured, try again later'),
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _bankAccounts = Provider.of<BankProvider>(context, listen: false).accountModel;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Earnings', style: TextStyle(color: Colors.red)),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Theme.of(context).cardColor,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Consumer<FinancialsProvider>(
          builder: (context, financialsProvider, child) {
             _user = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
            return SafeArea(
              child: Scrollbar(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                  physics: BouncingScrollPhysics(),
                  child:
                  financialsProvider.loading?
                  Center(
                      child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.redAccent))
                  ):
                  Center(
                    child: SizedBox(
                      width: 1170,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text('Total earnings',style: TextStyle(fontSize: 19))),
                              Expanded(child: Container(
                                  alignment: Alignment.topRight,
                                  child: Text('\$${_user!.totalEarnings}', style: TextStyle(fontSize: 19)))),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: Text('Current balance',style: TextStyle(fontSize: 19))),
                              Expanded(child: Container(
                                  alignment: Alignment.topRight,
                                  child: Text('\$${_user!.walletBalance}', style: TextStyle(fontSize: 19)))),
                            ],
                          ),
                          SizedBox(height: 30),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> StatisticsScreen()));
                            },
                            child: Container(
                              height:60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(width: 2, color: Colors.red),
                              ),
                              child: Center(
                                child: Text('View earnings activity',
                                    style: TextStyle(fontSize: 16,
                                      color: Colors.red,
                                      //fontWeight: FontWeight.bold
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          GestureDetector(
                            onTap: () {
                              financialsProvider.clearOffset();
                              financialsProvider.getWithdrawals(context, '1', Provider.of<AuthProvider>(context, listen: false).getUserToken(), _callback3);
                            },
                            child: Container(
                              height:60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(width: 2, color: Colors.red),
                              ),
                              child: Center(
                                child: Text('View withdrawals history',
                                    style: TextStyle(fontSize: 16,
                                      color: Colors.red,
                                      //fontWeight: FontWeight.bold
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 20),
                          _user!.walletBalance! > 0?
                          GestureDetector(
                             onTap: () async {
                               showDialog(
                                   context: context,
                                   builder: (BuildContext context) {
                                     return StatefulBuilder(builder: (context, StateSetter setState) {
                                       return AlertDialog(
                                         title: Text('Select Bank Account'),
                                         content: Column(
                                           mainAxisSize: MainAxisSize.min,
                                           children: [
                                             Container(
                                               height: 300.0, // Change as per your requirement
                                               width: 300.0, // Change as per your requirement
                                               child: ListView.builder(
                                                 shrinkWrap: true,
                                                 itemCount: _bankAccounts.length,
                                                 itemBuilder: (BuildContext context, int index) {

                                                   return ListTile(
                                                     title: Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         Text('Routing No', style: TextStyle(fontWeight: FontWeight.bold)),
                                                     Text(' ${_bankAccounts[index].routingNumber.toString().substring(0,4)} ***** ')
                                                       ],
                                                     ),
                                                     leading: Radio(
                                                       value: index,
                                                       groupValue: Provider.of<BankProvider>(context, listen: false).value,
                                                       onChanged: (value) {
                                                         Provider.of<BankProvider>(context, listen: false).setValue(index);

                                                         Provider.of<BankProvider>(context, listen: false).setBankId(_bankAccounts[index].id);
                                                         setState(() {});

                                                       },
                                                       activeColor: Theme.of(context).primaryColor,
                                                     ),
                                                   );
                                                 },
                                               ),
                                             ),
                                             Row(
                                               children: [
                                                 Expanded(
                                                   child: BorderButton(
                                                     btnTxt: 'Confirm',
                                                     textColor: Colors.red,
                                                     borderColor: Colors.red,
                                                     onTap: () async {
                                                       if(Provider.of<BankProvider>(context, listen: false).bankId != null){

                                                         Provider.of<FinancialsProvider>(context, listen: false).withdrawMoney(
                                                             Provider.of<BankProvider>(context, listen: false).bankId.toString(),
                                                             Provider.of<AuthProvider>(context, listen: false).getUserToken(), _withdrawalCallback);

                                                       }else {
                                                         Provider.of<FinancialsProvider>(context, listen: false).withdrawMoney(
                                                             _bankAccounts[0].id.toString(),
                                                             Provider.of<AuthProvider>(context, listen: false).getUserToken(), _withdrawalCallback);
                                                       }

                                                       Navigator.pop(context);

                                                     },
                                                   ),
                                                 ),
                                               ],
                                             )
                                           ],
                                         )
                                       );
                                     });
                                   });
                             },
                            child: Container(
                              height:60,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text('Cash out',
                                    style: TextStyle(fontSize: 16,
                                      color: Colors.white,
                                      //fontWeight: FontWeight.bold
                                    )),
                              ),
                            ),
                          ) :

                          Container(
                            height:60,
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text('Cash out',
                                  style: TextStyle(fontSize: 16,
                                    color: Colors.white,
                                    //fontWeight: FontWeight.bold
                                  )),
                            ),
                          ),
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
}
