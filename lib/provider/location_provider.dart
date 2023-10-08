import 'dart:convert';
import 'package:delivrd_driver/data/model/response/response_model.dart';
import 'package:delivrd_driver/data/repository/location_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier {
  final SharedPreferences? sharedPreferences;
  final LocationRepo? locationRepo;

  LocationProvider({@required this.sharedPreferences, this.locationRepo});

  Position? _position = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
  bool _loading = false;
  bool get loading => _loading;

  String? _addressName;
  String? get addressName => _addressName;

  String? _addressStreet;
  String? get addressStreet => _addressStreet;

  double _latitude = 0.0;
  double get latitude => _latitude;

  double _longitude = 0.0;
  double get longitude => _longitude;

  String? _searchedLocation;
  String? get searchedLocation => _searchedLocation;

  Position? get position => _position;
  Placemark? _address = Placemark();

  Placemark? get address => _address;
  List<Marker>? _markers = <Marker>[];

  List<Marker>? get markers => _markers;

  String? _locality;
  String? get locality => _locality;

  String? _administrativeArea;
  String? get administrativeArea => _administrativeArea;

  String? _postalCode;
  String? get postalCode => _postalCode;

  double _currentLatitude = 0.0;
  double get currentLatitude => _currentLatitude;

  double _currentLongitude = 0.0;
  double get currentLongitude => _currentLongitude;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _searchError = false;
  bool get searchError => _searchError;

  Marker _origin = Marker(markerId:  const MarkerId('origin'));
  Marker get origin => _origin;

  updateSearchLocation(BuildContext context, {required String location, required double latitude,required double longitude, Function? callback}) async {

    if(location!= ''){
      _searchedLocation = location;
      _searchError = false;
      try {
        List<Location> locations = await locationFromAddress(location);

        _latitude = locations[0].latitude;
        _longitude = locations[0].longitude;
        notifyListeners();
        print('lat new : $_latitude --- $_longitude');
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _latitude,
          _longitude,
        );
        Placemark place = placemarks[0];
        _locality = place.locality;
        _administrativeArea = place.administrativeArea;
        _postalCode = place.postalCode;
        print('address data ///////////////');
        print('$_postalCode --- $_locality --- $administrativeArea');

        _addressName = '${placemarks[0].name} ${placemarks[0].street}';
        print('address name');
        print(_addressName);

        callback!(true);
      }catch (e) {
        print('error here 22 ${e}');

        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Sorry!'),
              content: Text('Could not find any result for the supplied address or coordinates, try another place'),
            )
        );
      }
    }

    else {
      _latitude = latitude;
      _longitude = longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        _latitude,
        _longitude,
      );

      print(placemarks[0]);
      _addressName = '${placemarks[0].name} ${placemarks[0].street}';
      String _location2 = '${placemarks[0].name}, ${placemarks[0].subLocality}, ${placemarks[0].administrativeArea}, ${placemarks[0].postalCode}, ${placemarks[0].country}';
      _searchedLocation = _location2;

      print('location ////////////');
      print('${_location2}');

      callback!(true);
    }

    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy:LocationAccuracy.high);
    _currentLatitude = position.latitude;
    _currentLongitude = position.longitude;
    List<Placemark> placemarks = await placemarkFromCoordinates(_currentLatitude, _currentLongitude);
    Placemark place = placemarks[0];
    _addressName = place.name;
    _addressStreet = place.street;
    print('_currentLatitude: ${_currentLatitude}');
    notifyListeners();
  }

  void dragableAddress() async {
    try {
      _loading = true;
      notifyListeners();
      List<Placemark> placemarks = await placemarkFromCoordinates(_position!.latitude, _position!.longitude);
      _address = placemarks.first;
      _loading = false;
      notifyListeners();
    }catch(e) {
      _loading = false;
      notifyListeners();
    }
  }
  void updatePosition(CameraPosition position) async {
    _position = Position(
      latitude: position.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
      heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
    );
  }

  void getNewLocation({GoogleMapController? mapController,required double latitude,required double longitude}) async {
    _loading = true;
    notifyListeners();
    try {
      // Position newLocalData = _latitude1;
      if (mapController != null) {
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(latitude, longitude), zoom: 17)));
        //_position = newLocalData;

        List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
        _address = placemarks.first;
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
    _loading = false;
    notifyListeners();
  }

  void resetLatLong() {
    _latitude = 0.0;
    _longitude = 0.0;
    _searchedLocation = null;
    notifyListeners();
  }

  Future<ResponseModel> updateLocation(String latitude, String longitude, String address, String token) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel _responseModel;
    http.StreamedResponse response = await locationRepo!.updateLocation(
      latitude,
      longitude,
      address,
      token,
    );
    if (response.statusCode == 200) {
      _isLoading = false;
      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["message"];
      _responseModel = ResponseModel(true, message);

    } else {
      _isLoading = false;
      _responseModel = ResponseModel(false, '${response.statusCode} ${response.reasonPhrase}');
      print('${response.statusCode} ${response.reasonPhrase}');
    }
    notifyListeners();
    return _responseModel;
  }

  void addMarker(LatLng pos){
    _origin = Marker(
      markerId: const MarkerId('origin'),
      infoWindow: const InfoWindow(title: 'My Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: pos,
    );

    notifyListeners();
  }
}
