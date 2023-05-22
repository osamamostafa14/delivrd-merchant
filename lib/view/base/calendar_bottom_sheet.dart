import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/financials_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/view/base/custom_button.dart';
import 'package:delivrd_driver/view/base/datepicker_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CalendarBottomSheetStats extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Container(
          width: 550,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Consumer<FinancialsProvider>(
            builder: (context, financialsProvider, child) {
              return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Text('Select date', style: TextStyle(fontSize: 15))),
                      SizedBox(height: 15),
                      financialsProvider.value != 4 ?
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text("Today"),
                            leading: Radio(
                              value: 1,
                              groupValue: financialsProvider.value,
                              onChanged: (value) {
                                financialsProvider.setDateValue(1);
                              },
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ),

                          ListTile(
                            title: Text("Yesterday"),
                            leading: Radio(
                              value: 2,
                              groupValue: financialsProvider.value,
                              onChanged: (value) {
                                financialsProvider.setDateValue(2);
                              },
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ),

                          ListTile(
                            title: Text("Last Month"),
                            leading: Radio(
                              value: 3,
                              groupValue: financialsProvider.value,
                              onChanged: (value) {
                                financialsProvider.setDateValue(3);
                              },
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          ListTile(
                            title: Text("Date Range"),
                            leading: Radio(
                              value: 4,
                              groupValue: financialsProvider.value,
                              onChanged: (value) {
                                financialsProvider.setDateValue(4);
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (con) => DatepickerBottomSheet(
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          CustomButton(
                            btnTxt: 'Confirm',
                            onTap: () async {
                              financialsProvider.setFinalDate();
                              financialsProvider.clearOffset();

                              financialsProvider.filterDateStats(
                                context,
                                '1',
                                financialsProvider.finalDate,
                                'no date',

                                  Provider.of<AuthProvider>(context, listen: false).getUserToken()
                              );
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ) :
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text("Today"),
                                leading: Radio(
                                  value: 1,
                                  groupValue: financialsProvider.value,
                                  onChanged: (value) {
                                    financialsProvider.setDateValue(1);
                                  },
                                  activeColor: Theme.of(context).primaryColor,
                                ),
                              ),

                              ListTile(
                                title: Text("Yesterday"),
                                leading: Radio(
                                  value: 2,
                                  groupValue: financialsProvider.value,
                                  onChanged: (value) {
                                    financialsProvider.setDateValue(2);
                                  },
                                  activeColor: Theme.of(context).primaryColor,
                                ),
                              ),

                              ListTile(
                                title: Text("Last Month"),
                                leading: Radio(
                                  value: 3,
                                  groupValue: financialsProvider.value,
                                  onChanged: (value) {
                                    financialsProvider.setDateValue(3);
                                  },
                                  activeColor: Theme.of(context).primaryColor,
                                ),
                              ),
                              ListTile(
                                title: Text("Date Range"),
                                leading: Radio(
                                  value: 4,
                                  groupValue: financialsProvider.value,
                                  onChanged: (value) {
                                    financialsProvider.setDateValue(4);
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (con) => DatepickerBottomSheet(

                                      ),
                                    );
                                    Navigator.pop(context);
                                  },
                                  activeColor: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          Text('Start date', style: TextStyle(fontSize: 14)),
                          Row(
                            children: [
                              Icon(Icons.calendar_month, color: Theme.of(context).primaryColor),
                              SizedBox(width: 5),
                              TextButton(
                                  child: Text(financialsProvider.startDate!=''? financialsProvider.startDate : 'Start date',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold
                                      )),
                                  onPressed: () {
                                    DatePicker.showDatePicker(context,
                                        theme: DatePickerTheme(
                                          containerHeight: 210.0,
                                        ),
                                        showTitleActions: true,
                                        minTime: DateTime(2000, 1, 1),
                                        maxTime: DateTime(2022, 12, 31),
                                        onConfirm: (date) {
                                          financialsProvider.setStartDate('${date.year}-${date.month}-${date.day}');
                                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                                  }
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Text('End date', style: TextStyle(fontSize: 14)),
                          Row(
                            children: [
                              Icon(Icons.calendar_month, color: Theme.of(context).primaryColor),
                              SizedBox(width: 5),
                              TextButton(
                                  child: Text(financialsProvider.endDate!=''? financialsProvider.endDate : 'End date',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold
                                      )),
                                  onPressed: () {
                                    DatePicker.showDatePicker(context,
                                        theme: DatePickerTheme(
                                          containerHeight: 210.0,
                                        ),
                                        showTitleActions: true,
                                        minTime: DateTime(2000, 1, 1),
                                        maxTime: DateTime.now(),
                                        onConfirm: (date) {
                                          financialsProvider.setEndDate('${date.year}-${date.month}-${date.day}');
                                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                                  }
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          CustomButton(
                            btnTxt: 'Confirm',
                            onTap: () async {
                              financialsProvider.setFinalDate();
                              financialsProvider.clearOffset();
                              financialsProvider.filterDateStats(
                                context,
                                '1',
                                financialsProvider.startDate,
                                financialsProvider.endDate,

                                  Provider.of<AuthProvider>(context, listen: false).getUserToken()
                              );
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ],
                  )
              );
            },
          ),
        ),
        Positioned(
          right: 10,
          top: 5,
          child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.close)),
        ),
      ],
    );
  }
}
