import 'package:delivrd_driver/data/model/signup_model.dart';
import 'package:delivrd_driver/provider/auth_provider.dart';
import 'package:delivrd_driver/provider/location_provider.dart';
import 'package:delivrd_driver/provider/profile_provider.dart';
import 'package:delivrd_driver/provider/services_provider.dart';
import 'package:delivrd_driver/utill/dimensions.dart';
import 'package:delivrd_driver/view/base/custom_button.dart';
import 'package:delivrd_driver/view/base/custom_snack_bar.dart';
import 'package:delivrd_driver/view/screens/category/select_categories_screen.dart';
import 'package:delivrd_driver/view/screens/location/place_search.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SelectLocation extends StatefulWidget {
  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  // static const _initialCameraPosition = CameraPosition(
  //   target: LatLng(widget.lat1, widget.long1),
  //   zoom: 11.5,
  // );

  GoogleMapController? _googleMapController;
  //  Marker _origin = Marker(markerId:  const MarkerId('origin'),);

  //Directions? _info;

  // BitmapDescriptor originIcon;
  // BitmapDescriptor destinationIcon;

  @override
  void initState() {
    super.initState();

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
                        Provider.of<LocationProvider>(context, listen: false).currentLatitude,
                        Provider.of<LocationProvider>(context, listen: false).currentLongitude)
                        : LatLng(
                        Provider.of<LocationProvider>(context, listen: false).latitude,
                        Provider.of<LocationProvider>(context, listen: false).longitude),
                    zoom: 15,
                  ),
                  onLongPress: (LatLng latLng){
                    latLng =

                        LatLng(
                            Provider.of<LocationProvider>(context, listen: false).latitude,
                            Provider.of<LocationProvider>(context, listen: false).longitude);

                    print('lat here: ${Provider.of<LocationProvider>(context, listen: false).longitude}');

                    try {
                      _googleMapController!.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: latLng,
                            zoom: 15,
                          ),
                        ),
                      );
                    } catch (e) {
                      print('error 3 here: ${e}');
                    }
                  },

                  onMapCreated: (controller) {
                    _googleMapController = controller;

                    _googleMapController!.animateCamera(
                      CameraUpdate.newCameraPosition( CameraPosition(
                        target: Provider.of<LocationProvider>(context, listen: false).latitude!=0.0?
                        LatLng(
                            Provider.of<LocationProvider>(context, listen: false).latitude,
                            Provider.of<LocationProvider>(context, listen: false).longitude):
                        LatLng(
                            Provider.of<LocationProvider>(context, listen: false).currentLatitude,
                            Provider.of<LocationProvider>(context, listen: false).currentLongitude),
                        zoom: 15,
                      )),
                    );
                  },
                  markers: {
                    locationProvider.origin,
                  },

                  //  onLongPress: _addMarker1,
                ),
                Column(
                  children: [
                    SizedBox(height: 85),
                    GestureDetector(
                      onTap: () async{
                        Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceSearch()))
                            .then((_){
                          _googleMapController!.animateCamera(
                            CameraUpdate.newCameraPosition( CameraPosition(
                              target: Provider.of<LocationProvider>(context, listen: false).latitude!=0.0?
                              LatLng(
                                  Provider.of<LocationProvider>(context, listen: false).latitude,
                                  Provider.of<LocationProvider>(context, listen: false).longitude):
                              LatLng(
                                  Provider.of<LocationProvider>(context, listen: false).currentLatitude,
                                  Provider.of<LocationProvider>(context, listen: false).currentLongitude),
                              zoom: 15,
                            )),
                          );
                          print('camera animate');

                          if(Provider.of<LocationProvider>(context, listen: false).latitude!=0.0){
                            locationProvider.addMarker(LatLng(
                                Provider.of<LocationProvider>(context, listen: false).latitude,
                                Provider.of<LocationProvider>(context, listen: false).longitude));
                          }
                        });
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

                                                color: locationProvider.latitude != 0.0 ?
                                                Theme.of(context).primaryColor : Colors.grey,
                                              ),
                                            ),
                                            Flexible(
                                              child: new Container(
                                                padding: new EdgeInsets.only(right: 13.0),
                                                child: new Text(
                                                  locationProvider.searchedLocation !=null ?
                                                  '${locationProvider.searchedLocation}': 'Your location',
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

                Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return authProvider.isLoading?
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
                                btnTxt: 'Sign Up',
                                onTap: () async{
                                  if(Provider.of<LocationProvider>(context, listen: false).currentLatitude == 0.0){
                                    showCustomSnackBar(
                                        'Please add your location!',
                                        context);
                                  }else{

                                    SignUpModel signUpModel = SignUpModel(
                                        fullName: Provider.of<AuthProvider>(context, listen: false).signUpModel!.fullName,
                                        workshopName: Provider.of<AuthProvider>(context, listen: false).signUpModel!.workshopName,
                                        phone: Provider.of<AuthProvider>(context, listen: false).signUpModel!.phone,
                                        email: Provider.of<AuthProvider>(context, listen: false).signUpModel!.email,
                                        password: Provider.of<AuthProvider>(context, listen: false).signUpModel!.password,
                                        latitude: locationProvider.latitude.toString(),
                                        longitude: locationProvider.longitude.toString(),
                                        address: locationProvider.addressName.toString());

                                    authProvider
                                        .registration(signUpModel)
                                        .then((status) async {
                                      if (status.isSuccess) {
                                        Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context, _callbackUserInfo);
                                        Provider.of<ServicesProvider>(context, listen: false).getCategories(context);
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
                                            SelectCategoriesScreen(fromMenu: false)));
                                      }

                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),

            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              onPressed: () => _googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition( CameraPosition(
                  target: Provider.of<LocationProvider>(context, listen: false).latitude!=0.0?
                  LatLng(
                      Provider.of<LocationProvider>(context, listen: false).latitude,
                      Provider.of<LocationProvider>(context, listen: false).longitude):
                  LatLng(
                      Provider.of<LocationProvider>(context, listen: false).currentLatitude,
                      Provider.of<LocationProvider>(context, listen: false).currentLongitude),
                  zoom: 15,
                )),
              ),
              child: const Icon(Icons.center_focus_strong),
            ),
          );
        });
  }

  // void _addMarker1(LatLng pos) async {
  //
  //   if (_origin == null || (_origin != null )) {
  //     setState(() async{
  //       _origin = Marker(
  //         markerId: const MarkerId('origin'),
  //         infoWindow: const InfoWindow(title: 'My Location'),
  //         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //         position: pos,
  //       );
  //       // Reset destination
  //       // _destination = null;
  //
  //       // Reset info
  //       _info = null;
  //     });
  //   }
  //
  // }
  void _callbackUserInfo(
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

// void _addMarker(LatLng pos) async {
//   if (_origin == null || (_origin != null && _destination != null)) {
//     //       // Origin is not set OR Origin/Destination are both set
//     // Set origin
//     setState(() {
//       _origin = Marker(
//         markerId: const MarkerId('origin'),
//         infoWindow: const InfoWindow(title: 'Origin'),
//         icon:
//         BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//         position:  LatLng(
//             widget.lat1,
//             widget.long1),
//       );
//       // Reset destination
//       _destination = null;
//
//       // Reset info
//       _info = null;
//     });
//   } else {
//     // Origin is already set
//     // Set destination
//     setState(() {
//       _destination = Marker(
//         markerId: const MarkerId('destination'),
//         infoWindow: const InfoWindow(title: 'Destination'),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         position: LatLng(
//             Provider.of<LocationProvider>(context, listen: false).latitude2,
//             Provider.of<LocationProvider>(context, listen: false).longitude2),
//       );
//     });
//
//     // Get directions
//     final directions = await DirectionsRepository()
//         .getDirections(
//         origin: _origin.position,
//
//         destination: LatLng(
//         Provider.of<LocationProvider>(context, listen: false).latitude2,
//         Provider.of<LocationProvider>(context, listen: false).longitude2));
//     setState(() => _info = directions);
//   }
// }
}
