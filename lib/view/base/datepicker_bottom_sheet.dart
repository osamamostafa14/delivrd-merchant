import 'package:delivrd_driver/provider/financials_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DatepickerBottomSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Container(
          width: 550,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Consumer<FinancialsProvider>(
            builder: (context, financialsProvider, child) {
              int val = 1;
              return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Text('Select date')),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Start date'),
                          Row(
                            children: [
                              Icon(Icons.calendar_month),
                              SizedBox(width: 5),
                              Text('${DateTime.now()}')
                            ],
                          ),
                          Text('End date'),
                          Row(
                            children: [
                              Icon(Icons.calendar_month),
                              SizedBox(width: 5),
                              Text('${DateTime.now()}')
                            ],
                          ),
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
