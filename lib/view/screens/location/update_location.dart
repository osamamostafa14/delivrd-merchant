import 'package:delivrd_driver/data/model/directions_model.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/location_provider.dart';
import 'package:delivrd_driver/provider/profile_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/view/base/custom_button.dart';
import 'package:delivrd_driver/view/screens/location/place_search.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class UpdateLocation extends StatefulWidget {

  @override
  _UpdateLocationState createState() => _UpdateLocationState();
}

class _UpdateLocationState extends State<UpdateLocation> {
  // static const _initialCameraPosition = CameraPosition(
  //   target: LatLng(widget.lat1, widget.long1),
  //   zoom: 11.5,
  // );

  GoogleMapController? _googleMapController;
  Marker _origin = Marker(markerId:  const MarkerId('origin'));
  Directions? _info;

  // BitmapDescriptor originIcon;
  // BitmapDescriptor destinationIcon;

  @override
  void initState() {
    super.initState();
    print(' lat long here ///');
    print('${double.parse(Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.latitude)
    }'  '${double.parse(Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.longitude)}');

    double _savedLatitude = double.parse(Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.latitude);
    double _savedLongitude = double.parse(Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.longitude);


  }

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<LocationProvider>(
        builder: (context, locationProvider, child){
          print('lat ////');
          print(Provider.of<LocationProvider>(context, listen: false).latitude);
          double _savedLatitude = double.parse(Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.latitude);
          double _savedLongitude = double.parse(Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.longitude);


          return Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: Provider.of<LocationProvider>(context, listen: false).latitude==0.0?
                    LatLng(
                        _savedLatitude,
                        _savedLongitude)
                        : LatLng(
                        Provider.of<LocationProvider>(context, listen: false).latitude,
                        Provider.of<LocationProvider>(context, listen: false).longitude),
                    zoom: 15,
                  ),
                  onMapCreated: (controller) {
                    _googleMapController = controller;
                    _addMarker1(LatLng(
                        _savedLatitude,
                        _savedLongitude));
                  } ,
                  markers: {
                    _origin
                  },

                  //  onLongPress: _addMarker1,
                ),
                Column(
                  children: [
                    SizedBox(height: 85),

                    GestureDetector(
                      onTap: () async{
                        Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceSearch()))
                            .then((_) => setState(() {
                          _googleMapController!.animateCamera(
                            _info != null
                                ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
                                : CameraUpdate.newCameraPosition( CameraPosition(
                              target: Provider.of<LocationProvider>(context, listen: false).latitude!=0.0?
                              LatLng(
                                  Provider.of<LocationProvider>(context, listen: false).latitude
                                  , Provider.of<LocationProvider>(context, listen: false).longitude):
                              LatLng(
                                  Provider.of<LocationProvider>(context, listen: false).currentLatitude
                                  , Provider.of<LocationProvider>(context, listen: false).currentLongitude),
                              zoom: 15,
                            )),
                          );

                          if(Provider.of<LocationProvider>(context, listen: false).latitude!=0.0){
                            _addMarker1(LatLng(
                                Provider.of<LocationProvider>(context, listen: false).latitude,
                                Provider.of<LocationProvider>(context, listen: false).longitude));
                          }
                        }));;
                      },
                      child: Center(
                          child: Container(
                            width: 280,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                            ),

                            child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.2), //shadow for button
                                          blurRadius: 5) //blur radius of shadow
                                    ]
                                ),


                                child: Center(
                                  child: Row(
                                    children: [

                                      SizedBox(width:240,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                                              child: Icon(
                                                Icons.location_on_rounded,
                                                size: 27.0,

                                                color: locationProvider.searchedLocation !=null ?
                                                Theme.of(context).primaryColor : Colors.grey,
                                              ),
                                            ),
                                            Flexible(
                                              child: new Container(
                                                padding: new EdgeInsets.only(right: 13.0),
                                                child: new Text(
                                                  locationProvider.searchedLocation !=null ?
                                                  '${locationProvider.searchedLocation}': 'Search location',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: new TextStyle(
                                                    fontSize: 13.0,
                                                    fontFamily: 'Roboto',
                                                    color: new Color(0xFF212121),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      locationProvider.searchedLocation ==null ?
                                      Icon(
                                        Icons.search,
                                        size: 25.0,
                                        color:  Colors.black54,
                                      ) : Icon(
                                        Icons.check_circle,
                                        size: 25.0,
                                        color:  Theme.of(context).primaryColor,
                                      ),

                                    ],

                                  ),
                                )
                            ),
                          )

                      ),
                    ),
                    SizedBox(height: 15),

                  ],
                ),
                locationProvider.isLoading?
                CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.redAccent)) :
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                      Padding(
                        padding: EdgeInsets.only(
                            left: 90,
                            right: 90,
                            top: Dimensions.PADDING_SIZE_LARGE,
                            bottom: Dimensions.PADDING_SIZE_LARGE
                        ),
                        child: CustomButton(
                          btnTxt: 'Update location',
                          onTap: () async{

                            locationProvider
                                .updateLocation(
                                Provider.of<LocationProvider>(context, listen: false).latitude.toString(),
                                Provider.of<LocationProvider>(context, listen: false).longitude.toString(),
                                Provider.of<LocationProvider>(context, listen: false).addressName.toString(),
                              Provider.of<AuthProvider>(context, listen: false).getUserToken()
                            )
                                .then((status) async {
                              if (status.isSuccess) {
                                Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context, _callBackUserInfo);
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text('Location updated'),
                                    )
                                );
                                Future.delayed(Duration(seconds: 2), () async {
                                  Navigator.pop(context);
                                });
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),


            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              onPressed: () => _googleMapController!.animateCamera(
                _info != null
                    ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
                    : CameraUpdate.newCameraPosition( CameraPosition(
                  target: Provider.of<LocationProvider>(context, listen: false).latitude!=0.0?
                  LatLng(
                      Provider.of<LocationProvider>(context, listen: false).latitude
                      , Provider.of<LocationProvider>(context, listen: false).longitude):
                  LatLng(
                      Provider.of<LocationProvider>(context, listen: false).currentLatitude
                      , Provider.of<LocationProvider>(context, listen: false).currentLongitude),
                  zoom: 15,
                )),
              ),
              child: const Icon(Icons.center_focus_strong),
            ),
          );
        });
  }
  void _callBackUserInfo(
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
  void _addMarker1(LatLng pos) async {
    print('marker added ////');
    _origin = Marker(
      markerId: const MarkerId('origin'),
      infoWindow: const InfoWindow(title: 'My Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: pos,
    );
    _info = null;
      setState(() {});
    }

  }
