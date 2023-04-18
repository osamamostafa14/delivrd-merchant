
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/location_provider.dart';
import 'package:delivrd_driver/utill/app_constants.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/view/screens/location/select_location.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class PlaceSearch extends StatefulWidget {

  @override
  _PlaceSearchState createState() => _PlaceSearchState();
}

class _PlaceSearchState extends State<PlaceSearch> {
  var _controller = TextEditingController();

  var uuid = new Uuid();
  String? _sessionToken;
  List<dynamic> _placeList = [];


  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      _onChanged();
    });

  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = AppConstants.API_KEY;

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken&components=country:eg';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
        print('_placeList //////////////////////');
        print(_placeList);
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        child: Container(
          width: 1170,
          child: Consumer<LocationProvider>(
            builder: (context, locationProvider, child){

              return   SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,

                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                      border: Border.all(color: Colors.black12)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child:

                            TextField(
                              autofocus: true,
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'Search',
                                focusColor: Colors.white,
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                prefixIcon: Icon(Icons.map, color: Colors.black54),
                                // suffixIcon: IconButton(
                                //   icon: Icon(Icons.cancel),
                                // ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),

                          Row(
                            children: [
                              SizedBox(width: 10),
                              GestureDetector(
                                  onTap: () {

                                    locationProvider.updateSearchLocation(
                                        latitude: locationProvider.currentLatitude,
                                        longitude: locationProvider.currentLongitude,
                                        location: '',
                                        callback: _callback
                                    );

                                    //Navigator.pop(context);
                                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChooseDispatchLocation(send: widget.send, vehicles: widget.vehicles)));
                                  },
                                  child: Container(
                                      height: 40,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(width: 2, color: Colors.grey),
                                      ),
                                      child: Center(
                                          child: Text('Current Location')
                                      )
                                  )
                              )
                            ],
                          ),

                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: _placeList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_placeList[index]["description"]),
                                onTap:() async{
                                  FocusScope.of(context).unfocus();
                                  locationProvider.updateSearchLocation(
                                      location:_placeList[index]["description"],
                                      latitude: 0.0,
                                      longitude: 0.0,
                                      callback: _callback
                                  );

                                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChooseDispatchLocation(send: widget.send,vehicles: widget.vehicles)));

                                },
                              );
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 30),

                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  void _callback(
      bool isSuccess) async {
    if(isSuccess){
      setState(() {
        Navigator.of(context).pop(true);
       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SelectLocation()));
      });
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