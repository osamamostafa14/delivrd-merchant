import 'package:delivrd_driver/data/model/signup_model.dart';
import 'package:delivrd_driver/data/model/user_info_model.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/financials_provider.dart';
import 'package:delivrd_driver/provider/profile_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/view/base/calendar_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatefulWidget {

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  String? _startDate;
  String? _endDate;
  String? _selectedValue;
  SignUpModel? _userInfoModel;
  ScrollController scrollController = new ScrollController();
  String dropdownvalue = 'All';

  @override
  void initState() {
    super.initState();
    Provider.of<FinancialsProvider>(context, listen: false)
        .filterDateStats(context, '1', 'Today', 'no date',  Provider.of<AuthProvider>(context, listen: false).getUserToken());
  }

  Future _userModelInfo () async {
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context, _callback);
    _userInfoModel =
        Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
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
            int ordersLength =financialsProvider.ordersStatsList!.length;
            int totalSize = financialsProvider.totalStatsPageSize ?? 0;
            int totalPrice = financialsProvider.totalPrice ?? 0;
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
                          child: financialsProvider.loadingStats?
                          Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))):
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                      child: Text(financialsProvider.finalDate!= null?
                                      '${financialsProvider.finalDate}': 'Today',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          )),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (con) => CalendarBottomSheetStats(),
                                        );
                                      }
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (con) => CalendarBottomSheetStats(),
                                        );
                                      },
                                      child: Icon(Icons.arrow_drop_down_outlined, color: Colors.black54)),
                                ],
                              ),
                              Divider(),
                              SizedBox(height: 15),

                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 10,bottom: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text('Total Orders'),
                                    ),

                                    SizedBox(width: 33),
                                    Expanded(child: Text('${financialsProvider.totalStatsPageSize}', style: TextStyle(fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 10, bottom: 10),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('Total price')),
                                    SizedBox(width: 20),
                                    Expanded(child: Text('\$${financialsProvider.totalPrice}', style: TextStyle(fontWeight: FontWeight.bold))),
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
                                    Expanded(child: Text('Service', style: TextStyle(color: Colors.red))),
                                    SizedBox(width: 20),
                                    Expanded(child: Text('Price', style: TextStyle(color: Colors.red))),
                                  ],
                                ),
                              ),

                              ListView.builder(
                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                itemCount: financialsProvider.ordersStatsList!.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Container(
                                      height: 60,
                                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1, blurRadius: 5,
                                        )],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child:
                                      Row(
                                        children: [
                                          Text('#${financialsProvider.ordersStatsList![index].id}'),
                                          SizedBox(width: 20),
                                          Expanded(child: Text('${financialsProvider.ordersStatsList![index].serviceName}')),
                                          SizedBox(width: 20),
                                          Expanded(child: Text('\$${financialsProvider.ordersStatsList![index].totalPrice}')),
                                        ],
                                      )
                                  );
                                },
                              ),
                              // Text('$ordersLength $totalSize'),

                              financialsProvider.bottomLoading?
                              Column(
                                children: [
                                  SizedBox(height: 10),
                                  Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                                ],
                              ) :
                              ordersLength < totalSize?
                              Center(child:
                              GestureDetector(
                                  onTap: () {
                                    String offset = financialsProvider.offset ?? '';
                                    int offsetInt = int.parse(offset) + 1;
                                    print('$offset -- $offsetInt');
                                    financialsProvider.showBottomLoader();
                                    financialsProvider.filterDateStats(context, offsetInt.toString(), financialsProvider.startDate, financialsProvider.endDate,  Provider.of<AuthProvider>(context, listen: false).getUserToken());
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
}
