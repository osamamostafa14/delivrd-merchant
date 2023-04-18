import 'package:delivrd_driver/data/model/signup_model.dart';
import 'package:delivrd_driver/data/model/user_info_model.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/financials_provider.dart';
import 'package:delivrd_driver/provider/profile_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/view/base/calendar_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WithdrawalsHistoryScreen extends StatefulWidget {

  @override
  _WithdrawalsHistoryScreenState createState() => _WithdrawalsHistoryScreenState();
}

class _WithdrawalsHistoryScreenState extends State<WithdrawalsHistoryScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  ScrollController scrollController = new ScrollController();
  String dropdownvalue = 'All';

  @override
  void initState() {
    super.initState();

  }

  Future _userModelInfo () async {
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context, _callback);
  }
  void _callback(
      bool isSuccess) async {
    if(isSuccess){
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
    _userModelInfo();
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('Financials', style: TextStyle(color: Colors.black87)),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
          ),
        ),

        body: Consumer<FinancialsProvider>(
          builder: (context, financialsProvider, child) {
            int withdrawalsLength =financialsProvider.withdrawalsList!.length;
            int totalSize = financialsProvider.totalWithdrawalsSize ?? 0;
            return Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: Center(
                        child: SizedBox(
                          width: 1170,
                          child: financialsProvider.loadingWithdrawals?
                          Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))):
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 10,bottom: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text('Withdrawals'),
                                    ),

                                    SizedBox(width: 33),
                                    Expanded(child: Text('${financialsProvider.totalWithdrawalsSize}', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 10, bottom: 10),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('Total withdrawn')),
                                    SizedBox(width: 20),
                                    Expanded(child: Text('\$${financialsProvider.totalWithdrawalsAmount}', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),

                              Divider(),
                              SizedBox(height: 15),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 10),
                                child: Row(
                                  children: [
                                    Text('#ID', style: TextStyle(color: Colors.red)),
                                    SizedBox(width: 20),
                                    Expanded(child: Text('Amount', style: TextStyle(color: Colors.red))),
                                    SizedBox(width: 20),
                                    Expanded(child: Text('Status', style: TextStyle(color: Colors.red))),
                                  ],
                                ),
                              ),

                              ListView.builder(
                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                itemCount: financialsProvider.withdrawalsList!.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Container(
                                      height: 60,
                                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        boxShadow: [BoxShadow(
                                          color: Colors.grey[300]!,
                                          spreadRadius: 1, blurRadius: 5,
                                        )],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child:
                                      Row(
                                        children: [
                                          Text('#${financialsProvider.withdrawalsList![index].id}'),
                                          SizedBox(width: 20),
                                          Expanded(child: Text('\$${financialsProvider.withdrawalsList![index].amount}')),
                                          SizedBox(width: 20),
                                          Expanded(child: Text('${financialsProvider.withdrawalsList![index].status == 1? 'Released' : 'Pending'}',
                                              style: TextStyle(color: financialsProvider.withdrawalsList![index].status == 1? Colors.green : Colors.orange))),
                                        ],
                                      )
                                  );
                                },
                              ),
                              // Text('$ordersLength $totalSize'),

                              financialsProvider.bottomLoadingWithdrawals?
                              Column(
                                children: [
                                  SizedBox(height: 10),
                                  Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                                ],
                              ) :
                              withdrawalsLength < totalSize?
                              Center(child:
                              GestureDetector(
                                  onTap: () {
                                    String offset = financialsProvider.offsetWithdrawal ?? '';
                                    int offsetInt = int.parse(offset) + 1;
                                    print('$offset -- $offsetInt');
                                    financialsProvider.showBottomLoaderWithdrawal();
                                    financialsProvider.getWithdrawals(context, offsetInt.toString(), Provider.of<AuthProvider>(context, listen: false).getUserToken(), _callback2);
                                  },
                                  child: Text('Load more...',style: TextStyle(color: Colors.red)))) : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            );
          },
        )
    );
  }

  void _callback2(
      bool isSuccess) async {
    if(isSuccess){

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
