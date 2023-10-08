import 'package:delivrd_driver/data/model/bank_accounts_model.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/bank_provider.dart';
import 'package:delivrd_driver/view/base/border_button.dart';
import 'package:delivrd_driver/view/screens/financials/card_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class BankAccountsScreen extends StatefulWidget {

  @override
  _BankAccountsScreenState createState() => _BankAccountsScreenState();
}

class _BankAccountsScreenState extends State<BankAccountsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
  Future<void> _fetchData() async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<BankProvider>(context, listen: false)
          .getAccounts(context, Provider.of<AuthProvider>(context, listen: false).getUserToken());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('My Bank Accounts', style: TextStyle(color: Colors.red)),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Theme.of(context).cardColor,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        body: Consumer<BankProvider>(
          builder: (context, bankProvider, child) {
            List<BankAccountsModel> _accountModel = bankProvider.accountModel;
            return Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(5),
                      child: Center(
                        child: SizedBox(
                          width: 1170,
                          child: bankProvider.isLoadingAccounts?
                          Center(child: CircularProgressIndicator(valueColor:
                          AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))):
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              ListView.builder(
                                padding: EdgeInsets.all(5),
                                itemCount: _accountModel.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {

                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            actions: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 15, bottom: 15),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    BorderButton(
                                                      btnTxt: 'Remove',
                                                      textColor: Colors.red,
                                                      borderColor: Colors.red,
                                                      onTap: ()async{
                                                        bankProvider.deleteBankAccount(
                                                            _accountModel[index].id,
                                                            index,
                                                            Provider.of<AuthProvider>(context, listen: false).getUserToken(),
                                                            _callback);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    SizedBox(width: 10),
                                                    BorderButton(
                                                      btnTxt: 'Update',
                                                      textColor: Theme.of(context).primaryColor,
                                                      borderColor: Theme.of(context).primaryColor,
                                                      onTap: ()async{
                                                        bankProvider.setAccountNumber(_accountModel[index].accountNumber.toString());
                                                        bankProvider.setHolderName(_accountModel[index].holderName);

                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
                                                            CardDetails(updateCard: true, bankAccount: _accountModel[index]))).then((value) => Navigator.pop(context));
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                      );
                                    },
                                    child: Container(
                                        height: 80,
                                        padding: EdgeInsets.all(5),
                                        margin: EdgeInsets.only(bottom: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [BoxShadow(
                                            color: Colors.grey[300]!,
                                            spreadRadius: 1, blurRadius: 5,
                                          )],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(child: Text('Account Name')),
                                                Expanded(child:
                                                Text('${_accountModel[index].holderName}',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold
                                                    )))
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.grey,
                                              height: 16.0,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(child: Text('Account Number')),
                                                Expanded(child:
                                                Text('${_accountModel[index].accountNumber.toString().substring(0,4)} **********',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.red
                                                    ))),
                                              ],
                                            ),
                                          ],
                                        )
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () async {
                    bankProvider.setAccountNumber('1234567890');
                    bankProvider.setHolderName('Account Name');
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> CardDetails(updateCard: false)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 45, right: 45),
                    child: Container(
                      height: 90,
                      child: Card(
                        color: Colors.red,
                        elevation: 8,
                        shadowColor: Colors.white,
                        margin: EdgeInsets.all(15),
                        shape:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.red)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Add new account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
                            SizedBox(width: 5),
                            Icon(Icons.add, color: Colors.white,)
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        )
    );
  }
  void _callback(
      bool isSuccess, String message) async {
    if(isSuccess){
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Account deleted'),
          )
      );

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
